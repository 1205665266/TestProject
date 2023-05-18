import 'dart:async';
import 'dart:io';

import 'package:abitelogin/abitelogin.dart';
import 'package:bloc/bloc.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_event.dart';
import 'package:cotti_client/pages/shopping_cart/entity/cart_goods_item.dart';
import 'package:cotti_client/pages/shopping_cart/entity/shopping_cart_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/bloc/order_voucher_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_request_model.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_submit_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_submit_request_model.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/api/order_confirm_api.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/mixin/order_exception_dialog.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/order_confirm_page.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/confirm_commodity_dialog.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/routers/order_router.dart';
import 'package:cotti_client/service/location/location_service.dart';
import 'package:cotti_client/service/pay/abite_pay.dart';
import 'package:cotti_client/service/pay/model/pay_type_model.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobias/tobias.dart' as tobias;

import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_confirm_event.dart';

part 'order_confirm_state.dart';

class OrderConfirmBloc extends Bloc<OrderConfirmEvent, OrderConfirmState>
    with OrderExceptionDialog {
  //提频日期 周期每天
  static String kNotConfirmShopTip = 'K_NOT_CONFIRM_SHOP_TIP';

  OrderConfirmBloc() : super(OrderConfirmState()) {
    on<OrderConfirmEvent>((event, emit) {});
    on<OrderConfirmSubmitEvent>(_fetchSubmitEventToState);
    on<OrderConfirmVerifyEvent>(_fetchVerifyEventToState);
    on<OrderConfirmInitVerifyEvent>(_fetchInitVerifyEventToState);
    on<OrderConfirmChangeCouponEvent>(_fetchChangeCouponEventToState);
    on<OrderConfirmNoUseCouponEvent>(_fetchNoUseCouponEventToState);
    on<OrderConfirmChangeBountyEvent>(_fetchChangeBountyEventToState);
    on<OrderConfirmRemarkEvent>(_handleRemarkEventToState);
    on<OrderConfirmPayTypeEvent>(_handlePayTypeEventToState);
    on<OrderConfirmRemarkListEvent>(_handleRemarkListEventToState);
    on<OrderConfirmChangeTakeModeEvent>(_handleChangeTakeModeEventToState);
    on<OrderConfirmInitShowConfirmTipEvent>(_handleInitShowConfirmTipEventToState);
    on<OrderConfirmShowConfirmTipEvent>(_handleShowConfirmTipEventToState);
    on<OrderConfirmInitFirstTakeModeEvent>(_handleFirstTakeModeEventToState);
    on<OrderConfirmGetPayFormListEvent>(_handlePayFormListEventToState);
    on<OrderConfirmChangeAddressEvent>(_fetchChangeAddressEventToState);
  }

  _fetchChangeAddressEventToState(OrderConfirmChangeAddressEvent event, emit) {

    cleanCouponConfig();

    emit(state.copy()..address = event.address);
  }

  _fetchChangeBountyEventToState(OrderConfirmChangeBountyEvent event, emit) {
    OrderConfirmRequestModel requestModel = state.orderConfirmRequestModel.copy()
      ..useBounty = event.useBounty;
    add(OrderConfirmVerifyEvent(context: event.context, requestModel: requestModel));
  }

  _handlePayFormListEventToState(
      OrderConfirmGetPayFormListEvent event, Emitter<OrderConfirmState> emit) async {
    await AbitePay().cottiPayList(
        data: {"shopMdCode": event.shopMdCode, "tookFoodMode": event.takeFoodMode}).then((value) {
      state.payTypeList = value;
      if (value.isNotEmpty) {
        add(OrderConfirmPayTypeEvent(payTypeModel: value[0]));
      }
    }).catchError((e) => {});
  }

  void _handleFirstTakeModeEventToState(
      OrderConfirmInitFirstTakeModeEvent event, Emitter<OrderConfirmState> emit) {
    emit(state.copy()..firstConfirmTakeModeTye = event.firstTakeMode);
  }

  void _handleInitShowConfirmTipEventToState(
      OrderConfirmInitShowConfirmTipEvent event, Emitter<OrderConfirmState> emit) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    state.notConfirmShopTip = sharedPreferences.getBool(kNotConfirmShopTip) ?? false;
    emit(state.copy());
  }

  void _handleShowConfirmTipEventToState(
      OrderConfirmShowConfirmTipEvent event, Emitter<OrderConfirmState> emit) async {
    state.notConfirmShopTip = event.isShowTip;
    var sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool(kNotConfirmShopTip, event.isShowTip);

    emit(state.copy());
  }

  void _handleChangeTakeModeEventToState(
      OrderConfirmChangeTakeModeEvent event, Emitter<OrderConfirmState> emit) {
    // cleanCouponConfig();

    OrderConfirmRequestModel requestModel = state.orderConfirmRequestModel.copy()
      ..tookFoodMode = event.takeMode;

    add(OrderConfirmVerifyEvent(context: event.context, requestModel: requestModel));
    emit(state.copy()
      ..currentTakeTypeMode = event.takeMode
      ..orderConfirmRequestModel = requestModel);
  }

  void _handleRemarkListEventToState(
      OrderConfirmRemarkListEvent event, Emitter<OrderConfirmState> emit) async {
    await OrderConfirmApi.fetchRecommendRemarkList().then((value) {
      logI('备注标签 ==>$value');
      List<String> _listData = [];
      value.forEach((v) => _listData.add(v as String));
      state.remarkList = _listData;
    }).catchError((e) {
      logI('备注标签error ==>$e');
    });
    emit(state.copy());
  }

  void _handlePayTypeEventToState(OrderConfirmPayTypeEvent event, Emitter<OrderConfirmState> emit) {
    emit(state.copy()..currentPayTypeModel = event.payTypeModel);
  }

  void _handleRemarkEventToState(
      OrderConfirmRemarkEvent event, Emitter<OrderConfirmState> emitter) {
    emitter(state.copy()..remark = event.remark);
  }

  /// 提交订单
  void _fetchSubmitEventToState(
      OrderConfirmSubmitEvent event, Emitter<OrderConfirmState> emitter) async {
    emitter(state.copy()..showLoading = true);
    OrderSubmitRequestModel orderSubmitRequestModel =
        await _handleSubmitRequestModel(event.context, state.orderConfirmModelEntity);
    logI('请求入参${orderSubmitRequestModel.toMap()}');
    await OrderConfirmApi.submitOrder(orderSubmitRequestModel.toMap()).then((value) {
      state.orderSubmitModelEntity = value;

      _handleSubmitExceptionCode(event.context, value, orderSubmitRequestModel);
    }).catchError((error) {
      logI("order submit error ==> $error");
    });
    emitter(state.copy()..showLoading = false);
  }

  _handleSubmitExceptionCode(BuildContext context, OrderSubmitModelEntity? orderSubmitModelEntity,
      OrderSubmitRequestModel orderSubmitRequestModel) {
    int? code = orderSubmitModelEntity?.checkCode;
    String? msg = orderSubmitModelEntity?.checkMsg;
    String? orderNo = orderSubmitModelEntity?.orderNo;

    switch (code) {

      /// 提货时间已失效，请重新确认下单时间
      case 17:

      /// 送达时间已失效，请重新确认下单时间
      case 18:
        ToastUtil.show(msg ?? "");
        break;

      /// 当前门店休息中， 不支持下单
      case 1:
        ShopMatchBloc shopMatchBloc = context.read<ShopMatchBloc>();
        // 显示门店休息弹窗
        showShopRest(context, shopMatchBloc.state.curTakeFoodMode, this);

        break;
      case 2: // 【外送】该地址暂不支持外送，请更换收货地址
      case 8: // 【快递】该地址暂不支持外送，请更换收货地址

        showShopNotSupportTakeOut(context, this);

        break;
      case 6: // 当前门店暂不支持自提
        showShopNotSupportSelfTake(context, this);

        break;
      case 4: // 存在不可售商品，请重新选择
      case 5: // 商品数量不足，请重新选择
      case 9: // 部分商品库存不足，请确认商品后重新下单
        // 2022-08-04 商品限量，用户在下单时，如果特价商品数量为0，返回unavailableItemList为空的特殊处理
        if (orderSubmitModelEntity?.unavailableItemList == null) {
          ToastUtil.show("特价商品今日已抢光");

          Future.delayed(const Duration(milliseconds: 1000), () {
            // 刷新购物车，并重新确认订单
            // context.read<ShoppingCartBloc>().add(SyncCartEvent());
            add(OrderConfirmVerifyEvent(
                context: context, requestModel: state.orderConfirmRequestModel));
          });
          SensorsAnalyticsFlutterPlugin.track(
              OrderSensorsConstant.orderConfirmCommodityInvalidToastBrownEvent, {});
          return;
        }
        List<OrderSubmitModelUnavailableItemList> unavailableItemList =
            orderSubmitModelEntity?.unavailableItemList ?? [];
        List<OrderSubmitModelSaleableItemList> saleableItemList =
            orderSubmitModelEntity?.saleableItemList ?? [];

        List<OrderSubmitModelUnavailableItemList> unavailableOfLessList = unavailableItemList
            .where((e) => e.saleable == 1 && e.buyNum > e.quantity && e.quantity > 0)
            .toList();

        List<OrderSubmitModelUnavailableItemList> unavailableOfSaleOutList =
            unavailableItemList.where((e) => e.saleable != 1 || e.quantity == 0).toList();

        showConfirmCommodityDialog(
            context: context,
            callback: (res) {
              // 返回购物车
              if (res == 0) {
                // 通知购物车同步
                // context.read<ShoppingCartBloc>().add(SyncCartEvent());

                SensorsAnalyticsFlutterPlugin.track(
                    OrderSensorsConstant.orderConfirmCommodityInvalidDialogPopEvent, {});
                SensorsAnalyticsFlutterPlugin.track(
                    OrderSensorsConstant.orderConfirmCommodityInvalidDialogCloseEvent, {});
                // 返回购物车
                NavigatorUtils.pop(context);
              }
              if (res == 1) {
                // 将售罄下架等商品移除，并将库存不足商品数量调整为剩余库存数量  重新调用确认订单接口
                List<ConfirmGoodsItem> handleList = unavailableOfLessList
                    .map((e) => ConfirmGoodsItem(e.spuCode, e.skuCode, e.quantity, e.specialPrice))
                    .toList();
                handleList.addAll(saleableItemList
                    .map((e) => ConfirmGoodsItem(e.spuCode, e.skuCode, e.buyNum, e.specialPrice))
                    .toList());
                cleanCouponConfig();
                OrderConfirmRequestModel requestModel = state.orderConfirmRequestModel.copy()
                  ..confirmGoodsItemParams = handleList;
                add(OrderConfirmVerifyEvent(context: context, requestModel: requestModel));

                SensorsAnalyticsFlutterPlugin.track(
                    OrderSensorsConstant.orderConfirmCommodityInvalidDialogConfirmEvent, {});
                SensorsAnalyticsFlutterPlugin.track(
                    OrderSensorsConstant.orderConfirmCommodityInvalidDialogCloseEvent, {});
              }
            },
            unavailableOfLessList: unavailableOfLessList,
            unavailableOfSaleOutList: unavailableOfSaleOutList);

        SensorsAnalyticsFlutterPlugin.track(
            OrderSensorsConstant.orderConfirmCommodityInvalidDialogBrownEvent, {});

        break;

      case 7: // 商品价格发生变化，请确认后下单
      case 12: // 奖励金抵扣金额发生变化
      case 13: // 当前优惠券已失效，请确认下单金额
      case 23: // 当前代金券已失效，请确认下单金额
      case 16:
        ToastUtil.show(msg ?? "");
        // 该场景重置优惠配置；
        cleanCouponConfig();
        // 刷新确认信息
        add(OrderConfirmVerifyEvent(
            context: context, requestModel: state.orderConfirmRequestModel));
        break;

      case 11: // 订单实付满s%起送，还差%s

        ToastUtil.show(msg ?? "");

        break;

      case 14:

      /// 请新建收货地址
      case 15:

        /// 请选择收货地址
        ToastUtil.show(msg ?? "");
        Future.delayed(const Duration(milliseconds: 1500), () {
          NavigatorUtils.push(context, CommonPageRouter.takeAddressListPage,
              params: {"isSelectTakeAddress": true}).then((value) {
            if (value != null) {
              add(OrderConfirmChangeAddressEvent(value));
            }
          });
        });
        break;
      case 0:

        /// 请选择门店
        ToastUtil.show(msg ?? "");
        Future.delayed(const Duration(milliseconds: 1500), () {
          NavigatorUtils.push(
            context,
            CommonPageRouter.storeListPage,
            params: {"isFromConfirm": true},
          );
        });
        break;
      case 10: // 多笔订单未支付
        showShopMultiOrderUnPay(context, msg ?? "");
        break;
      case 19: // 全部商品出现活动结束、售罄或不可售，请确认后重新下单
        ToastUtil.show(msg ?? "");
        Future.delayed(const Duration(milliseconds: 1500), () {
          // 自动跳转到前一个页面  刷新购物车    商品详情刷新商品详情
          if (state.fromDetail) {
            NavigatorUtils.pop(context, result: {"refresh": true});
          } else {
            // 通知购物车同步
            // context.read<ShoppingCartBloc>().add(SyncCartEvent());
          }
          NavigatorUtils.pop(context);
        });
        break;
      case 21: // 不支持当前支付方式
        ToastUtil.show(msg ?? "");

        // 刷新支付列表
        int? shopMdCode = context.read<ShopMatchBloc>().state.shopMdCode;

        int? curTakeFoodMode = context.read<ShopMatchBloc>().state.curTakeFoodMode;
        int takeFoodMode = state.currentTakeTypeMode;
        // 如果当前是外卖
        if (curTakeFoodMode == Constant.takeOutModeCode) {
          takeFoodMode = curTakeFoodMode;
        }
        add(OrderConfirmGetPayFormListEvent(shopMdCode, takeFoodMode));
        break;
      default:

        /// 订单创建成功，调用支付接口
        if (msg == null && code == null && orderNo != null) {
          List<CartGoodsItem> deleteGoodItems = orderSubmitRequestModel.submitItemParamList!
              .map((e) => CartGoodsItem()
                ..itemNo = e.spuNo!
                ..skuCode = e.skuNo!
                ..buyNum = e.buyNum!)
              .toList();
          context.read<ShoppingCartBloc>().add(SubCartListSkuEvent(deleteGoodItems));

          SensorsAnalyticsFlutterPlugin.track(
              OrderSensorsConstant.orderConfirmCreateOrderEvent, {});

          // 支付方式为食堂刷卡 则直接跳转到详情页面
          if (state.currentPayTypeModel?.payFrom == PayForm.canteenCard.index) {
            ///支付订单
            Map<String, dynamic> sensorProperties = {'result': true};

            NavigatorUtils.push(context, OrderRouter.orderDetailPage,
                params: {
                  'orderNo': state.orderSubmitModelEntity?.orderNo,
                },
                replace: true);

            return;
          }

          if (state.currentPayTypeModel == null) {
            ToastUtil.show("请选择支付方式");
            return;
          }

          AbitePay()
              .pay(state.currentPayTypeModel!, orderSubmitModelEntity?.orderId ?? "", orderNo)
              .then((value) async {
            // 处理支付结果
            logI('支付回调,跳转  ${value.state.index}');
            // 如果是Android 直接跳转； 如果是IOS 并且金额为0，直接跳转 ; 如果是IOS 并且支付方式为支付宝，并且未安装支付宝
            bool isAliPayInstalled = await tobias.isAliPayInstalled();
            if ((Platform.isIOS && (state.orderConfirmModelEntity?.totalMoney ?? 0) == 0) ||
                (Platform.isIOS &&
                    state.currentPayTypeModel?.payType == "alipay" &&
                    !isAliPayInstalled)) {
              NavigatorUtils.push(context, OrderRouter.orderDetailPage,
                  params: {'orderNo': state.orderSubmitModelEntity?.orderNo, 'delay': true},
                  replace: true);
              SensorsAnalyticsFlutterPlugin.track(
                  OrderSensorsConstant.orderConfirmPaySuccessEvent, {});
              return;
            }

            if ((Platform.isAndroid && (state.orderConfirmModelEntity?.totalMoney ?? 0) == 0) ||
                (Platform.isAndroid &&
                    state.currentPayTypeModel?.payType == "alipay" &&
                    !isAliPayInstalled)) {
              NavigatorUtils.push(context, OrderRouter.orderDetailPage,
                  params: {'orderNo': state.orderSubmitModelEntity?.orderNo, 'delay': true},
                  replace: true);

              SensorsAnalyticsFlutterPlugin.track(
                  OrderSensorsConstant.orderConfirmPaySuccessEvent, {});
            }
          });
        } else {
          ToastUtil.show(msg ?? "");
        }

        break;
    }
  }

  /// 处理   提交订单入参
  Future<OrderSubmitRequestModel> _handleSubmitRequestModel(
      BuildContext context, OrderConfirmModelEntity? orderConfirmModelEntity) async {
    var shopMatchBloc = context.read<ShopMatchBloc>();
    int? payFrom = state.currentPayTypeModel?.payFrom;
    String canteenCardName = state.currentPayTypeModel?.showName ?? "";
    String deviceId = await DeviceHelper.getDeviceId();
    double totalAmount4ProductDiscount =
        orderConfirmModelEntity?.financeDetail?.totalAmount4ProductDiscount ?? 0;
    int takeFoodMode = shopMatchBloc.state.curTakeFoodMode;
    double orderPayableMoney = orderConfirmModelEntity?.totalMoney ?? 0;
    double? totalDeliveryMoney = orderConfirmModelEntity?.financeDetail?.deliveryMoney;
    List<String> couponNoList = orderConfirmModelEntity?.couponNoList ?? [];
    String remark = state.remark;
    double startDeliveryMoney = orderConfirmModelEntity?.financeDetail?.startDeliveryMoney ?? 0;
    double? bountyDiscountMoney = orderConfirmModelEntity?.useBounty ?? false
        ? orderConfirmModelEntity?.financeDetail?.bountyDiscountMoney
        : null;
    int? bountyDeductionNum = orderConfirmModelEntity?.useBounty ?? false
        ? orderConfirmModelEntity?.financeDetail?.bountyDeductionNum
        : null;
    int? bountyRatio =
        orderConfirmModelEntity?.useBounty ?? false ? orderConfirmModelEntity?.bountyRatio : null;
    int? cityMdCode = orderConfirmModelEntity?.shop?.base?.cityMdCode;
    double? freeThresholdMoney = orderConfirmModelEntity?.financeDetail?.freeThresholdMoney;
    double? totalProductMoney = orderConfirmModelEntity?.financeDetail?.totalProductMoney;
    double? totalPayAmount4Product = orderConfirmModelEntity?.financeDetail?.totalPayAmount4Product;
    List<SubmitGoodsItem>? submitItemParamList = orderConfirmModelEntity?.confirmGoodsItems
        ?.map((e) => SubmitGoodsItem(e.itemNo, e.skuNo, e.buyNum, e.specialPrice, e.skuShowName))
        .toList();

    logI("经纬度 ==${shopMatchBloc.state.address?.lat}");
    logI("经纬度 ==${shopMatchBloc.state.address?.lng}");
    String? latitude = takeFoodMode == Constant.selfTakeModeCode
        ? LocationService().getLastPositionInfo?.latitude?.toString()
        : shopMatchBloc.state.address?.lat;
    String? longitude = takeFoodMode == Constant.selfTakeModeCode
        ? LocationService().getLastPositionInfo?.longitude?.toString()
        : shopMatchBloc.state.address?.lng;
    num? addressId = shopMatchBloc.state.address?.id;
    int? shopMdCode = shopMatchBloc.state.shopMdCode;
    List<OrderConfirmModelFinanceDetailDispatchFeeDiscountList>? dispathcFeeDiscountList =
        orderConfirmModelEntity?.financeDetail?.dispathcFeeDiscountList;
    int? benefitStatus = orderConfirmModelEntity?.benefitStatus;
    int? benefitType = orderConfirmModelEntity?.benefitType;

    logI("经纬度 ==$latitude");
    logI("经纬度 ==$longitude");
    // 如果当前外卖，则请求参数为2， 如果是自提，则请求参数为之前选择的模式：堂食 || 外带
    int tookFoodMode = state.currentTakeTypeMode;
    if (shopMatchBloc.state.curTakeFoodMode == Constant.takeOutModeCode) {
      tookFoodMode = Constant.takeOutModeCode;
    }

    List<VoucherSkuModelEntity> tempList = [];

    for(VoucherSkuModelEntity sku in state.voucherSkusList??[]){
      if(sku.voucherNo?.isNotEmpty ?? false){
        tempList.add(sku.copy());
      }
    }

    return OrderSubmitRequestModel(
        tookFoodMode: tookFoodMode,
        shopMdCode: shopMdCode,
        totalAmount4ProductDiscount: totalAmount4ProductDiscount,
        orderPayableMoney: orderPayableMoney,
        totalDeliveryMoney: totalDeliveryMoney,
        origin: Platform.isAndroid ? 2 : 1,
        // 订单来源 1，"用户端-iOS", 2, "用户端-Android", 3, "微信小程序", 4, "网点收银APP" 5，“电商小程序”
        type: 1,
        // 订单类型（1-立即单；2-预约单）
        deviceId: deviceId,
        payFrom: payFrom,
        // 支付方式（微信2 、支付宝1、银联，来源：配置中心）
        canteenCardName: canteenCardName,
        mapType: 2,
        // 地图类型 1-高德，2-腾讯，3-百度
        couponNoList: couponNoList,
        remark: remark,
        startDeliveryMoney: startDeliveryMoney,
        bountyDiscountMoney: bountyDiscountMoney,
        bountyDeductionNum: bountyDeductionNum,
        bountyRatio: bountyRatio,
        cityMdCode: cityMdCode,
        freeThresholdMoney: freeThresholdMoney,
        totalProductMoney: totalProductMoney,
        totalPayAmount4Product: totalPayAmount4Product,
        shareMemberId: '',
        // app 木有  分享id
        submitItemParamList: submitItemParamList,
        latitude: latitude,
        longitude: longitude,
        addressId: addressId,
        dispathcFeeDiscountList: dispathcFeeDiscountList,
        benefitStatus: benefitStatus,
        benefitType: benefitType,
        useVoucherSkus: tempList
    );
  }

  // 更换优惠券
  void _fetchChangeCouponEventToState(
      OrderConfirmChangeCouponEvent event, Emitter<OrderConfirmState> emitter) {
    OrderConfirmRequestModel requestModel = state.orderConfirmRequestModel.copy()
      ..couponNoList = event.couponList
      ..chooseNotUseCoupon = false;
    add(OrderConfirmVerifyEvent(context: event.context, requestModel: requestModel));
  }

  // 不使用优惠券
  void _fetchNoUseCouponEventToState(
      OrderConfirmNoUseCouponEvent event, Emitter<OrderConfirmState> emitter) {
    OrderConfirmRequestModel requestModel = state.orderConfirmRequestModel.copy()
      ..couponNoList = []
      ..chooseNotUseCoupon = true;
    add(OrderConfirmVerifyEvent(context: event.context, requestModel: requestModel));
  }

  void _fetchInitVerifyEventToState(
      OrderConfirmInitVerifyEvent event, Emitter<OrderConfirmState> emitter) {
    var shopMatchBloc = BlocProvider.of<ShopMatchBloc>(event.context);

    List<ConfirmGoodsItem> list = [];
    OrderConfirmRequestModel requestModel = event.requestModel;
    int takeFoodMode = 0;

    // 如果是来自立即购买
    if (event.fromDetail) {
      logI("请求来自于立即购买${event.productInfo}");

      Map<String, dynamic>? productItem = event.productInfo;
      if (productItem != null) {
        list.add(ConfirmGoodsItem(productItem["spuNo"], productItem["skuNo"], productItem["buyNum"],
            double.tryParse(productItem["specialPrice"] ?? '')));
      }

      // 如果当前取餐方式为自提；判断当前门店支持的方式
      if (shopMatchBloc.state.curTakeFoodMode == Constant.selfTakeModeCode) {
        if (shopMatchBloc.state.getTakeFoodModes.length == 1) {
          takeFoodMode = shopMatchBloc.state.getTakeFoodModes[0];
        } else {
          // 判断当前购物车中的商品是否包含外带的商品，有支持外带的商品，则默认选中的就餐方式为外带，否则 默认显示堂食
          bool containToGoProduct = false;
          List<dynamic> businessTypes =
              productItem?["businessTypes"].map((e) => e['value']).toList();
          if (businessTypes.contains(1)) {
            containToGoProduct = true;
          }
          takeFoodMode = containToGoProduct ? Constant.toGoModeCode : Constant.eatInModeCode;
        }
      } else {
        takeFoodMode = shopMatchBloc.state.curTakeFoodMode;
      }
    } else {
      logI("请求来自于购物车");

      var shoppingCartBloc = BlocProvider.of<ShoppingCartBloc>(event.context);
      List<GoodsItem> selectedSellingProduct = shoppingCartBloc.state.getSelectedSelling;
      logI('购物车中的选中的商品列表 $selectedSellingProduct');

      for (var product in selectedSellingProduct) {
        if (product.processPriceSpecialNum != null) {
          list.add(ConfirmGoodsItem(product.itemNo, product.skuCode, product.processPriceSpecialNum,
              double.tryParse(product.specialPriceActivity?.specialPrice ?? "")));
          list.add(ConfirmGoodsItem(product.itemNo, product.skuCode,
              product.buyNum! - product.processPriceSpecialNum!, null));
        } else {
          list.add(ConfirmGoodsItem(product.itemNo, product.skuCode, product.buyNum, null));
        }
      }

      logI('购物车中的选中的商品列表 ${list[0].toMap()}');
      // 如果当前取餐方式为自提；判断当前门店支持的方式
      if (shopMatchBloc.state.curTakeFoodMode == Constant.selfTakeModeCode) {
        if (shopMatchBloc.state.getTakeFoodModes.length == 1) {
          takeFoodMode = shopMatchBloc.state.getTakeFoodModes[0];
        } else {
          // 判断当前购物车中的商品是否包含外带的商品，有支持外带的商品，则默认选中的就餐方式为外带，否则 默认显示堂食
          bool containToGoProduct = false;
          for (var product in selectedSellingProduct) {
            if (product.businessTypes?.contains(1) ?? false) {
              containToGoProduct = true;
              break;
            }
          }
          takeFoodMode = containToGoProduct ? Constant.toGoModeCode : Constant.eatInModeCode;
        }
      } else {
        takeFoodMode = shopMatchBloc.state.curTakeFoodMode;
      }
    }
    // 如果当前是   堂食 || 外带
    if (takeFoodMode == Constant.toGoModeCode || takeFoodMode == Constant.eatInModeCode) {
      state.currentTakeTypeMode = takeFoodMode;
    }

    requestModel.confirmGoodsItemParams = list;
    requestModel.tookFoodMode = takeFoodMode;

    state.orderConfirmRequestModel = requestModel;
    state.fromDetail = event.fromDetail;
    emitter(state.copy());

    add(OrderConfirmVerifyEvent(context: event.context, requestModel: requestModel));
  }

  /// 确认订单接口
  void _fetchVerifyEventToState(
      OrderConfirmVerifyEvent event, Emitter<OrderConfirmState> emitter) async {
    var shopMatchBloc = event.context.read<ShopMatchBloc>();

    OrderConfirmRequestModel requestModel = event.requestModel;

    int curTakeFoodMode = shopMatchBloc.state.curTakeFoodMode;
    // 如果当前外卖，则请求参数为2， 如果是自提，则请求参数为之前选择的模式：堂食 || 外带
    if (curTakeFoodMode == Constant.takeOutModeCode) {
      requestModel.tookFoodMode = Constant.takeOutModeCode;
      requestModel.addressId = shopMatchBloc.state.address?.id;
      requestModel.addressLatitude = shopMatchBloc.state.address?.lat;
      requestModel.addressLongitude = shopMatchBloc.state.address?.lng;
      requestModel.latitude = LocationService().getLastPositionInfo?.latitude?.toString();
      requestModel.longitude = LocationService().getLastPositionInfo?.longitude?.toString();
    } else {
      requestModel.tookFoodMode = state.currentTakeTypeMode;

      requestModel.addressId = null;
      requestModel.addressLatitude = "";
      requestModel.addressLongitude = "";
      requestModel.latitude = LocationService().getLastPositionInfo?.latitude?.toString();
      requestModel.longitude = LocationService().getLastPositionInfo?.longitude?.toString();
    }

    logI("当前就餐方式为===${shopMatchBloc.state.curTakeFoodMode}");

    requestModel.shopMdCode = shopMatchBloc.state.shopMdCode;

    /// 拼接 使用代金券和不使用代金券列表 ↓↓↓↓↓
    /// 订单是否使用代金券由sku列表中单独设置，订单级别chooseNotUseVoucher永远传false;
    requestModel.chooseNotUseVoucher = state.chooseNotUseCashCoupon ?? false;
    List<VoucherSkuModelEntity> useVoucherList = [];
    List<VoucherSkuModelEntity> noVoucherList = [];
    /// 被标记为不使用代金券的列表
    List<VoucherSkuModelEntity> chooseNotUseCashCouponList = [];

    logI("state.voucherSkusList in confirmOrder 1 === ${state.voucherSkusList}");

    for(VoucherSkuModelEntity item in state.voucherSkusList??[]){

      if(item.voucherNo?.isNotEmpty??false){
        useVoucherList.add(item);
      }else{
        noVoucherList.add(item);
        if(item.chooseNotUseCashCoupon??false){
          chooseNotUseCashCouponList.add(item);
        }
      }



      // if(item.chooseNotUseCashCoupon??false){
      //   noVoucherList.add(item);
      // }else if(item.voucherNo?.isNotEmpty??false){
      //   useVoucherList.add(item);
      //   if(item.chooseNotUseCashCoupon??false){
      //     chooseNotUseCashCouponList.add(item);
      //   }
      // }
    }
    requestModel.useVoucherSkus = useVoucherList.isNotEmpty ? useVoucherList : null;
    requestModel.notUseVoucherSkus = noVoucherList.isNotEmpty ? noVoucherList : null;
    /// 拼接 使用代金券和不使用代金券列表 ↑↑↑↑↑
    state.chooseNotUseCashCouponList = chooseNotUseCashCouponList;

    emitter(state.copy()..showConfirmLoading = true);

    await OrderConfirmApi.confirmOrder(requestModel.toMap()).then((value) {
      logI("order submit success ==> $value");

      _handleConfirmResultExceptionCode(event.context, value);

      // 如果是最优，则记录推荐优惠券列表，用于显示
      // var bestDiscountPlan = value.bestDiscountPlan ?? false;
      // if (bestDiscountPlan) {
      //   state.recommendCouponList = value.couponNoList ?? [];
      // }

      int couponRecommendFlag = value.couponRecommendFlag??2;

      if(couponRecommendFlag == 1){
        state.recommendCouponList = [];
      }else if(couponRecommendFlag == 3){
        state.recommendCouponList = value.couponNoList ?? [];
      }
      state.orderConfirmModelEntity = value;

      /// 合并 can、use的sku列表；
      merge();

      logI("state.voucherSkusList in confirmOrder 2 === ${state.voucherSkusList}");


      /// 判断第一次调用接口保存原始数据
      if(!(requestModel.chooseNotUseVoucher??false)&&(requestModel.useVoucherSkus?.isEmpty??true) && (requestModel.notUseVoucherSkus?.isEmpty??true)){
        state.voucherSkusRawList = state.voucherSkusList;
        logI("state.voucherSkusRawList = ${state.voucherSkusRawList}");
      }

    }).catchError((error) {
      logI("order submit error ==> $error");
    });
    emitter(state.copy()..showConfirmLoading = false);
  }

  _handleConfirmResultExceptionCode(
      BuildContext context, OrderConfirmModelEntity orderConfirmModelEntity) {
    int? code = orderConfirmModelEntity.checkCode;
    String? message = orderConfirmModelEntity.checkMsg ?? "";
    String? speciaPirceChangeMsg = orderConfirmModelEntity.speciaPirceChangeMsg;

    switch (code) {
      // 门店休息中，不支持下单
      case 1:
        ToastUtil.show('当前门店休息中，暂不支持下单');
        // 刷新购物车 返回上一级
        // context.read<ShoppingCartBloc>().add(SyncCartEvent());
        Navigator.of(context).pop({"refresh": state.fromDetail});

        return;
      // 门店休息中，不支持下单
      case 4:
      case 5:
      case 9:
        ToastUtil.show(message);
        try {
          if (code == 9) {
            SensorsAnalyticsFlutterPlugin.track(
                OrderSensorsConstant.orderConfirmCommodityInvalidToastBrownEvent,
                {"toast_show_reason": message});
          }
        } catch (e) {
          logI(e);
        }
        if (state.fromDetail) {
          // 通知购物车同步
          // context.read<ShoppingCartBloc>().add(SyncCartEvent());
          Navigator.of(context).pop({"refresh": true});
        } else {
          // 通知购物车同步
          // context.read<ShoppingCartBloc>().add(SyncCartEvent());
          Navigator.of(context).pop();
        }

        return;
      default:
        break;
    }

    // 如果特价活动变化
    if (speciaPirceChangeMsg?.isNotEmpty ?? false) {
      ToastUtil.show(speciaPirceChangeMsg ?? "");
    }
  }

  merge() {
    logI("in merge action !!");
    List<VoucherSkuModelEntity> canList =
        state.orderConfirmModelEntity?.canUseVoucherProductList ?? [];

    List<VoucherSkuModelEntity> useList = [...(state.orderConfirmModelEntity?.useVoucherSkus ?? [])];

    List<VoucherSkuModelEntity> tempList = [];

    for (VoucherSkuModelEntity sku in canList) {
      for (int i = 0; i < sku.buyNum!; i++) {
        VoucherSkuModelEntity tSku = sku.copy()..buyNum = 1;

        if((tSku.voucherDiscountMoney??0.0) != 0.0) {
          for (VoucherSkuModelEntity uSku in useList) {
            if (uSku.skuNo == tSku.skuNo &&
                (uSku.voucherDiscountMoney == tSku.voucherDiscountMoney)) {
              tSku.voucherNo = uSku.voucherNo;
              tSku.voucherName = uSku.voucherName;
              tSku.voucherDiscountMoney = uSku.voucherDiscountMoney;
              useList.remove(uSku);
              break;
            }
          }
        }
        tempList.add(tSku);
      }
    }

    /// 匹配 不使用代金券的状态
    for(VoucherSkuModelEntity sku in tempList){

      if(sku.voucherNo?.isNotEmpty??false){
        continue;
      }

      VoucherSkuModelEntity? tempNoSku;

      for(VoucherSkuModelEntity noSku in state.chooseNotUseCashCouponList??[]){
        if(sku.skuNo == noSku.skuNo){
          sku.chooseNotUseCashCoupon = noSku.chooseNotUseCashCoupon;
          tempNoSku = noSku;
          break;
        }
      }

      if(tempNoSku != null){
        state.chooseNotUseCashCouponList?.remove(tempNoSku);
      }

    }

    state.chooseNotUseCashCouponList = null;

    state.voucherSkusList = tempList;
  }

  /// 切换取餐方式、门店、用餐方式、外卖地址时需要重新匹配；
  cleanCouponConfig(){
    OrderConfirmRequestModel requestModel = state.orderConfirmRequestModel.copy();
    requestModel.chooseNotUseCoupon = null;
    requestModel.couponNoList = null;
    state.orderConfirmRequestModel = requestModel;
    state.voucherSkusList = [];
    state.chooseNotUseCashCoupon = null;
  }
}
