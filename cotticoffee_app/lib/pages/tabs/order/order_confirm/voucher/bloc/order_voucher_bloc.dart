import 'package:bloc/bloc.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_request_model.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_list_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/api/order_confirm_api.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/order_cal_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/order_voucher_count_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/order_voucher_dto_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_list_rquest_model.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/page/voucher_goods_page.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/widget/order_voucher.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/widget/dialog/common_dialog.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

part 'order_voucher_event.dart';

part 'order_voucher_state.dart';

class OrderVoucherBloc extends Bloc<OrderVoucherEvent, OrderVoucherState> {

  late OrderConfirmBloc _ocBloc;

  OrderVoucherBloc() : super(OrderVoucherState()) {
    on<OrderVoucherInitEvent>(initEventAction);
    on<OrderVoucherChangeEvent>(changeAction);
    on<OrderVoucherResumeEvent>(resumeEvent);
    on<OrderVoucherNoUseEvent>(noUseEvent);
    on<OrderVoucherSaveEvent>(saveEvent);
    on<VoucherTabChangeEvent>(tabChangeEvent);
    on<VoucherLoadMoreEvent>(voucherLoadMoreEvent);
    on<VoucherRefreshEvent>(voucherRefreshEvent);

    on<ShowVoucherRootPopupEvent>(showVoucherRootPopupEvent);
    on<ShowVoucherSubPopupEvent>(showVoucherSubPopupEvent);
    on<VoucherSkuListCloseEvent>(voucherSkuListCloseEvent);
    on<VoucherAdjustEvent>(voucherAdjustEvent);
  }

  initEventAction(OrderVoucherInitEvent event, emit) {
    List<VoucherSkuModelEntity> goodsItems = event.goodsItems;

    state.goodsItems = event.goodsItems;

    _ocBloc = event.context.read<OrderConfirmBloc>();
    state.financeDetail = _ocBloc.state.orderConfirmModelEntity?.financeDetail;
    state.usedCouponName = _ocBloc.state.orderConfirmModelEntity?.usedCouponName;
    state.chooseNotUseCashCoupon = _ocBloc.state.chooseNotUseCashCoupon;
    logI("List<VoucherSkuModelEntity> goodsItems = =  $goodsItems");

    List<VoucherSkuModelEntity> tempList = [];

    for (VoucherSkuModelEntity sku in goodsItems) {
      if(event.resetShow){
        sku.show = true;
      }
      tempList.add(sku.copy());
    }

    state.showItems = tempList;

    state.edit = hasResume();

    logI("state.showItems in init = ${state.showItems}");
    emit(state.copy());
  }

  reset(List<VoucherSkuModelEntity> list) {}

  changeAction(OrderVoucherChangeEvent event, emit) async {
    logI("in changeAction !");

    if(event.goodsItem.voucherNo == event.voucherModel.couponNo){

      if(state.source == OrderVoucherSource.goodsList){
        Navigator.of(event.context).pop();
        showVoucherRootPopupEvent(
            ShowVoucherRootPopupEvent(
              context: event.context,
            ),
            emit);
      }else{
        add(OrderVoucherSaveEvent(context: event.context));
      }

      return;
    }

    VoucherSkuModelEntity? tempItem;

    for (VoucherSkuModelEntity item in state.showItems ?? []) {
      /// 查找代金券是否被占用；
      if ((item.voucherNo?.isNotEmpty ?? false) && item.voucherNo == event.voucherModel.couponNo) {
        tempItem = item;
        state.renewConpon = true;
        break;
      }
    }

    VoucherSkuModelEntity goodsItemCopy = event.goodsItem.copy();
    VoucherSkuModelEntity? tempItemCopy = tempItem?.copy();

    if(event.goodsItem.voucherNo?.isEmpty??true){
      /// 商品之前未匹配代金券，需要刷新优惠券；
      state.renewConpon = true;
    }

    event.goodsItem
      ..voucherNo = event.voucherModel.couponNo
      ..chooseNotUseCashCoupon = false
      ..voucherName = event.voucherModel.couponName;

    if (tempItem != null) {
      tempItem.voucherNo = null;
      tempItem.voucherName = null;
      tempItem.voucherDiscountMoney = null;
      tempItem.chooseNotUseCashCoupon = true;
    }

    state.chooseNotUseCashCoupon = false;

    state.edit = hasResume();

    if (state.source == OrderVoucherSource.goodsList) {

      Navigator.of(event.context).pop();
      showVoucherRootPopupEvent(
          ShowVoucherRootPopupEvent(
            context: event.context,
          ),
          emit);

      state.showLoading = true;

      emit(state.copy());

      bool? success = await confirmOrderCal(emit);

      logI("bool success = $success");

      if(!(success??false)){
        /// 试算接口失败，将修改恢复；
        event.goodsItem
          ..voucherNo = goodsItemCopy.voucherNo
          ..chooseNotUseCashCoupon = goodsItemCopy.chooseNotUseCashCoupon
          ..voucherName = goodsItemCopy.voucherName;

        if (tempItem != null) {
          tempItem.voucherNo = tempItemCopy?.voucherNo;
          tempItem.voucherName = tempItemCopy?.voucherName;
          tempItem.voucherDiscountMoney = tempItemCopy?.voucherDiscountMoney;
          tempItem.chooseNotUseCashCoupon = tempItemCopy?.chooseNotUseCashCoupon;
        }
      }

      emit(state.copy()..showLoading = false);
    } else {
      add(OrderVoucherSaveEvent(context: event.context));
    }
  }

  resumeEvent(OrderVoucherResumeEvent event, emit) {
    logI("in resumeEvent !");

    List<VoucherSkuModelEntity> goodsItems = _ocBloc.state.voucherSkusRawList ?? [];

    for (int i = 0; i < (state.showItems?.length ?? 0); i++) {
      VoucherSkuModelEntity sItem = (state.showItems ?? [])[i].copy();

      (state.showItems ?? [])[i] = goodsItems[i].copy();

      (state.showItems ?? [])[i].show = sItem.show;
    }

    state.chooseNotUseCashCoupon = false;

    emit(state.copy()..edit = false);
  }

  noUseEvent(OrderVoucherNoUseEvent event, emit) {
    logI("in noUseEvent !");

    state.renewConpon = true;

    if (event.skuModelEntity != null) {
      event.skuModelEntity!.chooseNotUseCashCoupon = true;
      event.skuModelEntity!.voucherNo = null;
      event.skuModelEntity!.voucherDiscountMoney = null;
      event.skuModelEntity!.voucherName = null;
      // emit(state.copy()..edit = hasResume());


      if (state.source == OrderVoucherSource.goodsList) {
        Navigator.of(event.context).pop();
        showVoucherRootPopupEvent(ShowVoucherRootPopupEvent(context: event.context), emit);
      }else {
        add(OrderVoucherSaveEvent(context: event.context));
      }
    } else {
      state.renewConpon = true;
      for (VoucherSkuModelEntity sku in state.showItems ?? []) {
        if (sku.show) {
          sku.chooseNotUseCashCoupon = true;
          sku.voucherNo = null;
          sku.voucherDiscountMoney = null;
          sku.voucherName = null;
        }
      }
      state.chooseNotUseCashCoupon = true;
      add(OrderVoucherSaveEvent(context: event.context));
    }
    emit(state.copy()..edit = hasResume());
  }

  saveEvent(OrderVoucherSaveEvent event, emit) {
    logI("in saveEvent !");


    if(!isEdited()){
      Navigator.pop(event.context, );
      return;
    }

    _ocBloc.state.voucherSkusList = state.showItems;

    _ocBloc.state.chooseNotUseCashCoupon = state.chooseNotUseCashCoupon;

    if(state.renewConpon){
      _ocBloc.state.orderConfirmRequestModel.couponNoList = null;
    }else {
      _ocBloc.state.orderConfirmRequestModel.couponNoList = _ocBloc.state.orderConfirmModelEntity?.couponNoList;
    }

    _ocBloc.add(OrderConfirmVerifyEvent(context: event.context, requestModel: _ocBloc.state.orderConfirmRequestModel));

    state.renewConpon = false;

    bool useVoucher = state.showItems != null;

    Navigator.pop(event.context, );
  }

  tabChangeEvent(VoucherTabChangeEvent event, Emitter<OrderVoucherState> emit) async {
    logI('请求代金券数量');

    state.pageNo = 1;

    String eventName = event.tabIndex == 0 ? OrderSensorsConstant.confirmOrderVoucherCountView : OrderSensorsConstant.confirmOrderVoucherNotUseView;

    var map = {
      "skuNo":event.skuModel.skuNo,
      "skuShowName":event.skuModel.skuShowName,
      "availableCount":state.voucherCountDto?.availableCount,
    };

    SensorsAnalyticsFlutterPlugin.track(eventName, map);

    // state.voucherList = [];

    state.showLoading = true;
    emit(state.copy());
    await getConfirmOrderCouponList(context: event.context, skuModel: event.skuModel,voucherType: event.tabIndex + 1);
    state.tabIndex = event.tabIndex;
    state.showLoading = false;
    emit(state.copy());
  }

  voucherLoadMoreEvent(VoucherLoadMoreEvent event, Emitter<OrderVoucherState> emit) async {
    state.pageNo += 1;
    state.loadStatus = LoadStatus.loading;
    await getConfirmOrderCouponList(context: event.context, skuModel: event.skuModel,voucherType: state.tabIndex + 1);
    emit(state.copy());
  }

  voucherRefreshEvent(VoucherRefreshEvent event, Emitter<OrderVoucherState> emit) async {
    state.pageNo = 1;

    state.voucherList = [];
    state.refreshStatus = RefreshStatus.refreshing;
    await getConfirmOrderCouponList(context: event.context, skuModel: event.skuModel,voucherType: state.tabIndex + 1);
    state.refreshStatus = RefreshStatus.completed;
    emit(state.copy());
  }

  showVoucherRootPopupEvent(ShowVoucherRootPopupEvent event, emit) {
    logI("in showVoucherRootPopupEvent");
    List<VoucherSkuModelEntity> list = state.showItems ?? [];

    logI("List<VoucherSkuModelEntity> list = $list");

    int goodsNum = 0;

    late VoucherSkuModelEntity onleyEntity;

    for (VoucherSkuModelEntity item in list) {
      if (item.show) {
        goodsNum += item.buyNum ?? 0;
        onleyEntity = item;
      }
    }

    state.source = OrderVoucherSource.goodsList;
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      elevation: 900,
      enableDrag: true,
      context: event.context,
      backgroundColor: Colors.transparent,
      builder: (buildContext) {
        return BlocProvider.value(
            value: BlocProvider.of<OrderConfirmBloc>(event.context),
            child: BlocProvider.value(
              value: this,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: Container(
                  color: goodsNum == 0 ? CottiColor.backgroundColor : Colors.white,
                  child: VoucherGoodsPage(
                    goodsItems: list,
                  ),
                ),
              ),
            ));
      },
    );

    /** 需求修改，不再直接弹出代金券选择弹窗；
    if (goodsNum == 1) {
      state.source = OrderVoucherSource.confirmPage;
      showModalBottomSheet(
        context: event.context,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: true,
        builder: (buildContext) {
          return BlocProvider.value(
            value: BlocProvider.of<OrderConfirmBloc>(event.context),
            child: BlocProvider.value(
              value: this,
              child: OrderVoucher(
                skuModelEntity: onleyEntity,
              ),
            ),
          );
        },
      );
    } else {
      state.source = OrderVoucherSource.goodsList;
      showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        elevation: 900,
        enableDrag: true,
        context: event.context,
        backgroundColor: Colors.transparent,
        builder: (buildContext) {
          return BlocProvider.value(
              value: BlocProvider.of<OrderConfirmBloc>(event.context),
              child: BlocProvider.value(
                value: this,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: VoucherGoodsPage(
                      goodsItems: list,
                    ),
                  ),
                ),
              ));
        },
      );
    }
    */
  }

  showVoucherSubPopupEvent(ShowVoucherSubPopupEvent event, emit) {
    logI("in showVoucherSubPopupEvent");

    Navigator.pop(event.context);

    showModalBottomSheet(
      context: event.context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      elevation: 900,
      builder: (buildContext) {
        return BlocProvider.value(
          value: BlocProvider.of<OrderConfirmBloc>(event.context),
          child: BlocProvider.value(
            value: this,
            child: OrderVoucher(
              skuModelEntity: event.goodsItem,
            ),
          ),
        );
      },
    );
  }

  voucherSkuListCloseEvent(VoucherSkuListCloseEvent event, emit){

    Navigator.of(event.context).pop();

  }

  voucherAdjustEvent(VoucherAdjustEvent event, emit){
    logI("in voucherAdjustEvent action !!!");

    Map<String, dynamic> map = {
      "couponNo":event.coupon.couponNo,
      "couponName":event.coupon.couponName,
      "couponType":event.coupon.couponType,
    };

    List<String> skuList = event.coupon.skuCodes??[];

    /// 替换
    if(event.coupon.canNotBeStackedButtonType == 1){

      for(VoucherSkuModelEntity sku in state.showItems??[]){
        if(skuList.contains(sku.skuNo)){
          sku.voucherNo = null;
          sku.voucherName = null;
          sku.voucherDiscountMoney = null;
          sku.chooseNotUseCashCoupon = true;
        }
      }

      state.renewConpon = false;

      _ocBloc.state.orderConfirmModelEntity?.couponNoList =  [event.coupon.couponNo??""];

      SensorsAnalyticsFlutterPlugin.track(
          OrderSensorsConstant.confirmOrderCouponReplaceClick, map);

      add(OrderVoucherSaveEvent(context: event.context));
    }
    /// 调整
    else if(event.coupon.canNotBeStackedButtonType == 2){

      for(VoucherSkuModelEntity sku in _ocBloc.state.voucherSkusList??[]){
        /// 调整代金券时只显示匹配了代金券的sku
        sku.show = skuList.contains(sku.skuNo) && (sku.voucherNo?.isNotEmpty??false);
      }

      Navigator.of(event.context).pop();

      SensorsAnalyticsFlutterPlugin.track(
          OrderSensorsConstant.confirmOrderCouponAdjustVoucherClick, map);

      /// 调整代金券进入时sku列表可能保存有缓存的编辑数据，需要OrderVoucherInitEvent刷新；
      add(OrderVoucherInitEvent(context: event.context, goodsItems: _ocBloc.state.voucherSkusList??[],resetShow: false));

      add(ShowVoucherRootPopupEvent(context: event.context));

    }
  }

  /// 判断是否需要重新请求代金券
  bool needUpdateCoupon() {
    return false;
  }

  bool hasResume() {
    dynamic json1 = state.showItems?.map((v){
      return {"skuNo":v.skuNo,"voucherNo":v.voucherNo};
    }).toList();
    dynamic json2 = (_ocBloc.state.voucherSkusRawList ?? []).map((v){
      return {"skuNo":v.skuNo,"voucherNo":v.voucherNo};
    }).toList();

    String str1 = jsonEncode(json1);
    String str2 = jsonEncode(json2);

    bool inEdit = !(str1 == str2);

    logI("bool inEdit = $inEdit");

    return inEdit;
  }

  bool isEdited() {
    dynamic json1 = state.showItems?.map((v) => v.toJson()).toList();
    dynamic json2 = (state.goodsItems??[]).map((v) => v.toJson()).toList();

    String str1 = jsonEncode(json1);
    String str2 = jsonEncode(json2);

    bool inEdit = !(str1 == str2);

    logI("bool inEdit = $inEdit");

    return inEdit;
  }

  getConfirmOrderCouponList(
      {required BuildContext context, required VoucherSkuModelEntity skuModel,required int voucherType}) async {
    ProductParamModel productParamModel = ProductParamModel()
      ..skuCode = skuModel.skuNo
      ..baseUnitPrice = double.tryParse(skuModel.facePrice ?? "0")
      ..saleUnitPrice = double.tryParse(skuModel.lineThroughPrice ?? "0")
      ..spuCode = skuModel.itemNo
      ..purchaseNums = 1
      ..couponDiscountMoney = skuModel.couponDiscountMoney
      ..cagetoryCode = skuModel.categoryCode
      ..specialPrice = skuModel.specialPrice;

    ShopMatchBloc shopMatchBloc = context.read<ShopMatchBloc>();

    int diningCode = Constant.toGoModeCode;

    switch (shopMatchBloc.state.curTakeFoodMode) {
      case Constant.eatInModeCode:
        diningCode = Constant.eatInModeCode;
        break;
      case Constant.takeOutModeCode:
        diningCode = Constant.takeOutModeCode;
        break;
      default:
        diningCode = Constant.toGoModeCode;
        break;
    }

    int pageSize = 30;

    List<VoucherSkuModelEntity> useVoucherSkus = [];

    for(VoucherSkuModelEntity sku in state.showItems??[]){
      if(sku.voucherNo?.isNotEmpty??false){
        useVoucherSkus.add(sku);
      }
    }

    VoucherListRquestModel requestModel = VoucherListRquestModel()
      ..shopMdCode = shopMatchBloc.state.shopMdCode
      ..diningCode = diningCode
      ..productParam = productParamModel
      // ..voucherType = state.tabIndex + 1
      ..voucherType = voucherType
      ..pageNo = state.pageNo
      ..pageSize = pageSize
      ..userdCouponName = ""
      ..useVoucherSkus = useVoucherSkus
      // ..useVoucherSkus = state.showItems
      ..bestVoucherNo = skuModel.voucherNo;

    await OrderConfirmApi.getConfirmOrderVoucherList(requestModel.toMap()).then((value) {
      logI("in then block !!");
      if(state.pageNo == 1){
        state.voucherList = [];
      }
      state.voucherCountDto = value;
      state.voucherList = [...state.voucherList, ...value.voucherModelList ?? []];

      if ((value.voucherModelList?.length ?? 0) < pageSize) {
        state.loadStatus = LoadStatus.noMore;
      } else {
        state.loadStatus = LoadStatus.idle;
      }
    }).catchError((_) {
      logI("in catchError block !!");
      state.loadStatus = LoadStatus.failed;
    }).whenComplete(() {
      logI("in whenComplete block !!");
    });
  }

  Future<bool>? confirmOrderCal(emit) async {
    OrderConfirmRequestModel requestModel = _ocBloc.state.orderConfirmRequestModel.copy();

    requestModel.chooseNotUseVoucher = state.chooseNotUseCashCoupon;

    /*** 试算接口传入的confirmGoodsItemParams参数需要 specialPrice 字段不为空，不能使用orderConfirmRequestModel.confirmGoodsItemParams列表
     此处用确认订单接口返回的 confirmGoodsItems 列表，该列表包含 lineThroughPrice；
     ***/
    List<OrderConfirmModelConfirmGoodsItems> items = _ocBloc.state.orderConfirmModelEntity?.confirmGoodsItems??[];

    List<Map<String,dynamic>> confirmGoodsItemParams = [];
    
    for(OrderConfirmModelConfirmGoodsItems i in items){

      Map<String,dynamic> map = {
        "cagetoryCode":i.categoryCode,
        "spuNo": i.itemNo,
        "skuNo": i.skuNo,
        "purchaseNums": i.buyNum,
        "baseUnitPrice": i.facePrice,
        "saleUnitPrice": i.lineThroughPrice,
        "specialPrice": i.specialPrice,
        "specialPriceNum": i.specialAvaNum
      };

      confirmGoodsItemParams.add(map);
    }

    List<VoucherSkuModelEntity> useVoucherList = [];
    List<VoucherSkuModelEntity> noVoucherList = [];

    for(VoucherSkuModelEntity item in state.showItems??[]){
      if(item.chooseNotUseCashCoupon??false){
        noVoucherList.add(item);
      }else if(item.voucherNo?.isNotEmpty??false){
        useVoucherList.add(item);
      }
    }
    requestModel.useVoucherSkus = useVoucherList.isNotEmpty ? useVoucherList : null;
    requestModel.notUseVoucherSkus = noVoucherList.isNotEmpty ? noVoucherList : null;

    requestModel.chooseNotUseVoucher ??= false;


    Map<String,dynamic> requestMap = requestModel.toMap();

    requestMap["confirmGoodsItemParams"] = confirmGoodsItemParams;


    return await OrderConfirmApi.confirmOrderCal(requestMap).then((OrderCalEntity value) {
      state.financeDetail = value.financeDetail;

      List<VoucherSkuModelEntity> temp = value.useVoucherSkus ?? [];

      for (VoucherSkuModelEntity sku in state.showItems ?? []) {
        /// 不显示、不使用代金券、无匹配代金券的sku不需要进行匹配
        if (!sku.show ||
            (sku.chooseNotUseCashCoupon ?? false) ||
            (sku.voucherNo?.isEmpty ?? true)) {
          continue;
        }
        bool fond = false;
        for (VoucherSkuModelEntity tSku in temp) {
          if (tSku.skuNo == sku.skuNo && sku.voucherNo == tSku.voucherNo) {
            sku.voucherDiscountMoney = tSku.voucherDiscountMoney;
            sku.voucherName = tSku.voucherName;
            sku.couponDiscountMoney = null;
            fond = true;
            /// 移除，下次循环不需要重新匹配；
            temp.remove(tSku);
            break;
          }
        }

        /// 未匹配到的sku 需要清空代金券(选中的代金券已经失效)
        if(!fond){
          sku.voucherNo = null;
          sku.voucherName = null;
          sku.voucherDiscountMoney = null;
        }
      }
      return true;
    }).catchError((_){
      return false;
    });
  }
}
