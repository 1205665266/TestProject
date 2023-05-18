import 'dart:math';

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/bloc/order_voucher_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/widget/radio_widget.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_count_request_model.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_list_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_list_request_model.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_coupon/order_coupon_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/order_coupon_item.dart';
import 'package:cotti_client/widget/cotti_tabbar.dart';
import 'package:cotti_client/widget/custom_smart_footer.dart';
import 'package:cotti_client/widget/custom_smart_header.dart';
import 'package:cotti_client/widget/my_underline_indicator.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class OrderCoupon extends StatefulWidget {
  OrderConfirmModelEntity orderConfirmModelEntity;

  OrderCoupon(this.orderConfirmModelEntity, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderCouponState();
}

class _OrderCouponState extends State<OrderCoupon> with SingleTickerProviderStateMixin {
  final List<String> tabs = ["可用优惠券", "不可用优惠券"];

  late TabController _tabController;
  late PageController _pageController;

  final OrderCouponBloc _bloc = OrderCouponBloc();

  late OrderConfirmBloc _confirmBloc;

  int? shopMdCode;

  int? takeFoodMode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _pageController = PageController();

    _confirmBloc = context.read<OrderConfirmBloc>();

    shopMdCode =
        widget.orderConfirmModelEntity.shopMdCode ?? context.read<ShopMatchBloc>().state.shopMdCode;

    takeFoodMode = context.read<ShopMatchBloc>().state.curTakeFoodMode == Constant.takeOutModeCode
        ? Constant.takeOutModeCode
        : _confirmBloc.state.currentTakeTypeMode;

    _bloc.add(assembleCouponCountEvent(widget.orderConfirmModelEntity, shopMdCode, takeFoodMode));
    _bloc.add(assembleCouponListEvent(
        context, _confirmBloc.state.orderConfirmModelEntity, shopMdCode, 1, takeFoodMode));

    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.confirmOrderCouponCountView, {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _bloc,
        child: Container(
          color: CottiColor.backgroundColor,
          child: SafeArea(
            bottom: false,
            child: _buildContent(),
          ),
        ),
    );
  }

  _buildContent() {
    return BlocBuilder<OrderCouponBloc, OrderCouponState>(
      builder: (context, state) {
        double height = 85.h;

        int itemCount = _bloc.state.couponList.length > 2 ? _bloc.state.couponList.length : 2;

        height = height + itemCount * (12.h + 75.h + 12.h);

        if(_bloc.state.tabIndex == 0){
          height = height + 24.h + 26.h;
        }

        final MediaQueryData data = MediaQuery.of(context);
        double maxHeight = data.size.height - 88.h;
        double bottom = data.padding.bottom;

        height = height + bottom;
        height = height > maxHeight ? maxHeight : height;

        height = height < 482.h ? 482.h:height;
        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 85.h,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildList(),
                ),
                Positioned(
                  top: 48.h,
                  left: 0,
                  right: 0,
                  child: _buildTab(),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildTitle(),
                ),
                if (state.showLoading)
                  Positioned(
                    top: 85.h,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildLoading(),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  _buildLoading() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Flexible(
            child: FractionallySizedBox(
              heightFactor: 0.5,
              child: Center(),
            ),
          ),
          LottieBuilder.asset(
            'assets/images/lotti/loading_data.json',
            width: 48.w,
            height: 48.h,
          ),
        ],
      ),
    );
  }

  _buildTitle() {
    return Container(
      height: 48.h,
      alignment: Alignment.center,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.centerRight,
        textDirection: TextDirection.rtl,
        children: [
          Center(
            child: Text(
              "选择优惠券",
              style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            right: 16.w,
            child: IconButton(
              icon: Icon(IconFont.icon_close, size: 20.sp, color: CottiColor.textGray),
              alignment: Alignment.centerRight,
              onPressed: () {
                logI("_bloc === $_bloc");
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildList() {
    return BlocBuilder<OrderCouponBloc, OrderCouponState>(
      builder: (context, state) {
        return PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: tabs.length,
          itemBuilder: (context, pageIndex) {
            return BlocProvider.value(
              value: context.read<OrderVoucherBloc>(),
              child: CouponListView(pageIndex,),
            );
          },
        );
      },
    );
  }

  _buildTab() {
    return BlocBuilder<OrderCouponBloc, OrderCouponState>(builder: (context, state) {
      return Container(
        width: double.infinity,
        // color: Colors.white,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(25, 70, 106, 0.06),
              offset: Offset(0, 2.h),
              blurRadius: 7.r,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: CottiTabbar(
            (index) => _changeTab(index),
            TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'DDP6',
              color: CottiColor.primeColor,
            ),
            TextStyle(
              fontSize: 14.sp,
              fontFamily: 'DDP4',
              color: const Color(0xFF5E5E5E),
            ),
            MyUnderlineTabIndicator(
              width: 62.w,
              borderSide: BorderSide(
                width: 2.h,
                color: CottiColor.primeColor,
              ),
            ),
            _tabController,
            List.generate(
                tabs.length,
                (index) =>
                    "${tabs[index]}(${index == 0 ? state.orderCouponCountModelEntity?.availableCouponCount ?? 0 : state.orderCouponCountModelEntity?.unavailableCouponCount ?? 0})"),
          ),
        ),
      );
    });
  }

  _changeTab(int index) {
    _bloc.add(assembleCouponListEvent(
        context, _confirmBloc.state.orderConfirmModelEntity, shopMdCode, index + 1, takeFoodMode));

    Future.delayed(const Duration(milliseconds: 200), () {
      // _pageController.jumpToPage(index);
    });

    // _pageController.jumpToPage(index);
  }
}

class CouponListView extends StatefulWidget {
  int type;

  CouponListView(this.type, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CouponListViewState();
}

class _CouponListViewState extends State<CouponListView> {
  late RefreshController _refreshController;
  late OrderCouponBloc _bloc;
  late OrderConfirmBloc _orderConfirmBloc;
  late OrderVoucherBloc _voucherBloc;
  late ShopMatchBloc _shopMatchBloc;

  int? shopMdCode;

  /// 标记 与抵用券不可叠加使用 的index；
  int? firstIndex;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _bloc = BlocProvider.of<OrderCouponBloc>(context);
    _orderConfirmBloc = BlocProvider.of<OrderConfirmBloc>(context);
    _voucherBloc = context.read<OrderVoucherBloc>();

    shopMdCode = _orderConfirmBloc.state.orderConfirmModelEntity?.shopMdCode ??
        context.read<ShopMatchBloc>().state.shopMdCode;

    if (widget.type == 0) {
      SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.confirmOrderCouponCountView, {
        "coupon_usable_number": _bloc.state.orderCouponCountModelEntity?.availableCouponCount ?? 0
      });
    } else {
      SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.confirmOrderCouponNotUseView, {
        "coupon_unusable_number":
            _bloc.state.orderCouponCountModelEntity?.unavailableCouponCount ?? 0
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<OrderCouponBloc, OrderCouponState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.noMore) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
        if (state.refreshStatus == RefreshStatus.completed) {
          _refreshController.refreshCompleted();
        }
      },
      builder: (context, state) {

        return SmartRefresher(
            enablePullUp: true,
            header: const CustomSmartHeader(),
            footer: CustomSmartFooter(),
            controller: _refreshController,
            onLoading: () => _bloc.add(assembleCouponListLoadMoreEvent(context,
                _orderConfirmBloc.state.orderConfirmModelEntity, shopMdCode, state.tabIndex + 1)),
            onRefresh: () => _bloc.add(assembleCouponListRefreshEvent(context,
                _orderConfirmBloc.state.orderConfirmModelEntity, shopMdCode, state.tabIndex + 1)),
            child: Visibility(
              visible: state.couponList.isEmpty && state.loadStatus != LoadStatus.loading,
              child: _buildEmptyView(),
              replacement: _buildListView(),
            ));
      },
    );
  }

  _buildListView() {
    firstIndex = null;
    bool hasCoupon =
        _orderConfirmBloc.state.orderConfirmModelEntity?.usedCouponName?.isNotEmpty ?? false;
    String couponName = _orderConfirmBloc.state.orderConfirmModelEntity?.usedCouponName ?? "";
    String couponVal =
        "${_orderConfirmBloc.state.orderConfirmModelEntity?.financeDetail?.couponDiscountMoney ?? 0}";

    return BlocBuilder<OrderCouponBloc, OrderCouponState>(builder: (context, state) {

      /// 判断是否显示列表顶部信息；
      bool showTopBar = true;

      if(state.tabIndex == 0){
        for(int i=0;i<state.couponList.length;i++){
          OrderCouponListModelConfirmOrderCouponDtoList orderModel = state.couponList[i];
          if((orderModel.canNotBeStackedButtonType == 1 || orderModel.canNotBeStackedButtonType == 2)&&i==0){
            showTopBar = false;
            break;
          }
        }
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.tabIndex == 0 && state.couponList.isNotEmpty && showTopBar)
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Visibility(
                      visible: hasCoupon,
                      child:
                        // /*
                      Wrap(
                        runAlignment: WrapAlignment.center,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "使用",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: CottiColor.textGray,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                            strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            constraints: BoxConstraints(
                              maxWidth: 190.w,
                            ),
                            child: Text(
                              couponName,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: CottiColor.primeColor,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                height: 1,
                              ),
                              strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,),
                            ),
                          ),
                          Text(
                            "优惠",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: CottiColor.textGray,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                            strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.w),
                            child: Text(
                              "￥",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: CottiColor.primeColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "DDP5",
                                letterSpacing: -5,
                                height: 1,
                              ),
                              strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,),
                            ),
                          ),
                          Text(
                            couponVal,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: CottiColor.primeColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: "DDP5",
                              height: 1,
                            ),
                            strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,),
                          ),
                        ],
                      ),
                      // */

                      /*
                      Text.rich(
                        TextSpan(children: [
                          WidgetSpan(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "使用",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: CottiColor.textGray,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                                      constraints: BoxConstraints(
                                        maxWidth: 190.w,
                                      ),
                                      child: Text(
                                        couponName,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: CottiColor.primeColor,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                            ),
                          ),
                          WidgetSpan(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 0.w),
                                      child: Text(
                                        "优惠",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: CottiColor.textGray,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "￥",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: CottiColor.primeColor,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "DDP5",
                                      letterSpacing: -5,
                                    ),
                                  ),
                                  TextSpan(
                                    text: couponVal,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: CottiColor.primeColor,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "DDP5",
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ]),
                      ),
                      */
                      replacement: const SizedBox(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _orderConfirmBloc.add(OrderConfirmNoUseCouponEvent(context));
                      Navigator.of(context).pop();

                      SensorsAnalyticsFlutterPlugin.track(
                          OrderSensorsConstant.confirmOrderCouponNotUseClick, {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "不使用优惠券",
                          style: TextStyle(fontSize: 13.sp, color: CottiColor.textGray),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        RadioWidget(
                          checked:
                              _orderConfirmBloc.state.orderConfirmModelEntity?.chooseNotUseCoupon ??
                                  false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (state.tabIndex == 1)
            SizedBox(
              height: 9.h,
            ),
          ListView.builder(
              shrinkWrap: true,
              controller: scrollController,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                OrderCouponListModelConfirmOrderCouponDtoList orderModel = state.couponList[index];

                bool showTopLine = false;

                if((orderModel.canNotBeStackedButtonType == 1 || orderModel.canNotBeStackedButtonType == 2)&&state.tabIndex == 0){

                  if(firstIndex == null){
                    firstIndex = index;
                  }else {
                    firstIndex = min(firstIndex!, index);
                  }
                  showTopLine = firstIndex == index;
                }
                logI("firstIndex !!!!!= $firstIndex");
                logI("canNotBeStackedButtonType !!!!!= ${orderModel.canNotBeStackedButtonType}");
                logI("showTopLine !!!!!= $showTopLine");
                return BlocProvider.value(
                  value: _voucherBloc,
                  child: OrderCouponItem(
                    orderModel,
                    state.tabIndex == 1
                        ? OrderCouponItemSource.disable
                        : OrderCouponItemSource.order,
                    showTopLine: showTopLine,
                    atLast: (state.couponList.length-1) == index,
                    index: index,
                  ),
                );
              },
              itemCount: state.couponList.length),
        ],
      );
    });
  }

  ScrollController scrollController = ScrollController();

  _buildEmptyView() {
    return Container(
      padding: EdgeInsets.only(top: 73.h),
      child: Column(
        children: [
          Image.asset(
            "assets/images/mine/ic_coupon_none.png",
            width: 141.w,
            height: 121.h,
          ),
          Text(
            "暂无优惠券",
            style: TextStyle(fontSize: 14.sp, color: CottiColor.textGray),
          )
        ],
      ),
    );
  }
}

OrderFetchCouponCountEvent assembleCouponCountEvent(
    OrderConfirmModelEntity? orderConfirmModelEntity, int? shopMdCode, int? takeFoodMode) {
  List<ProductItem>? products = orderConfirmModelEntity?.confirmGoodsItems
      ?.map((e) =>
          ProductItem(e.categoryCode, e.itemNo, e.skuNo, e.facePrice, e.lineThroughPrice, e.buyNum))
      .toList();
  OrderCouponCountRequestModel model = OrderCouponCountRequestModel(
      orderConfirmModelEntity?.financeDetail?.deliveryMoney,
      orderConfirmModelEntity?.shopMdCode,
      takeFoodMode,
      products);
  return OrderFetchCouponCountEvent(model);
}

OrderFetchCouponListEvent assembleCouponListEvent(
    BuildContext context,
    OrderConfirmModelEntity? orderConfirmModelEntity,
    int? shopMdCode,
    int queryType,
    int? takeFoodMode) {
  List<ProductItem>? products = orderConfirmModelEntity?.confirmGoodsItems
      ?.map((e) =>
          ProductItem(e.categoryCode, e.itemNo, e.skuNo, e.facePrice, e.lineThroughPrice, e.buyNum))
      .toList();
  OrderCouponListRequestModel model = OrderCouponListRequestModel(
      queryType,
      orderConfirmModelEntity?.shopMdCode,
      takeFoodMode,
      orderConfirmModelEntity?.financeDetail?.deliveryMoney,
      products);

  OrderVoucherBloc ovBloc = context.read<OrderVoucherBloc>();

  OrderConfirmBloc ocBloc = context.read<OrderConfirmBloc>();

  int num = identityHashCode(ovBloc);
  int num2 = identityHashCode(ocBloc);

  logI("OrderConfirmBloc ocBloc in assembleCouponListEvent = $ocBloc   $num2");

  logI("OrderVoucherBloc ovBloc in assembleCouponListEvent = $ovBloc   $num");
  logI("showItems in assembleCouponListEvent = ${ovBloc.state.showItems ?? []}");

  List<VoucherSkuModelEntity> useList = [];
  List<VoucherSkuModelEntity> nouseList = [];

  for (VoucherSkuModelEntity sku in ocBloc.state.voucherSkusList ?? []) {
    if (sku.voucherNo?.isNotEmpty ?? false) {
      useList.add(sku);
    } else {
      nouseList.add(sku);
    }
  }

  model.useVoucherSkus = useList;
  model.notUseVoucherSkus = nouseList;

  /// 需要将products 参数中不再canuse列表的找出来加到notuse参数
for(OrderConfirmModelConfirmGoodsItems item in orderConfirmModelEntity?.confirmGoodsItems??[]){
    bool inShow = false;
    for(VoucherSkuModelEntity sku in ocBloc.state.orderConfirmModelEntity?.canUseVoucherProductList ?? []){

      if(item.skuNo == sku.skuNo && item.lineThroughPrice == double.tryParse(sku.lineThroughPrice??"0") && item.buyNum == sku.buyNum){
        inShow = true;
        break;
      }
    }

    if(!inShow){
      VoucherSkuModelEntity noinSku = VoucherSkuModelEntity()
        ..itemNo = item.skuNo
        ..buyNum=item.buyNum
        ..categoryCode=item.categoryCode
        ..skuNo=item.skuNo
        ..baseUnitPrice=item.facePrice
        ..lineThroughPrice = "${item.lineThroughPrice}";

      model.notUseVoucherSkus?.add(noinSku);
    }
  }

  model.usedCouponName = ocBloc.state.orderConfirmModelEntity?.usedCouponName ?? "";
  List l = ocBloc.state.orderConfirmModelEntity?.couponNoList ?? [];
  model.usedCouponNo = l.isNotEmpty ? l.first : null;
  model.bestCouponNo = l.isNotEmpty ? l.first : null;
  return OrderFetchCouponListEvent(queryType - 1, model);
}

OrderFetchCouponListRefreshEvent assembleCouponListRefreshEvent(BuildContext context,
    OrderConfirmModelEntity? orderConfirmModelEntity, int? shopMdCode, int? queryType) {
  List<ProductItem>? products = orderConfirmModelEntity?.confirmGoodsItems
      ?.map((e) =>
          ProductItem(e.categoryCode, e.itemNo, e.skuNo, e.facePrice, e.lineThroughPrice, e.buyNum))
      .toList();
  OrderCouponListRequestModel model = OrderCouponListRequestModel(
      queryType, shopMdCode, 1, orderConfirmModelEntity?.financeDetail?.deliveryMoney, products);

  OrderVoucherBloc ovBloc = context.read<OrderVoucherBloc>();
  OrderConfirmBloc ocBloc = context.read<OrderConfirmBloc>();

  List<VoucherSkuModelEntity> useList = [];
  List<VoucherSkuModelEntity> nouseList = [];

  for (VoucherSkuModelEntity sku in ocBloc.state.voucherSkusList ?? []) {
    if (sku.voucherNo?.isNotEmpty ?? false) {
      useList.add(sku);
    } else {
      nouseList.add(sku);
    }
  }

  model.useVoucherSkus = useList;
  model.notUseVoucherSkus = nouseList;

  /// 需要将products 参数中不再canuse列表的找出来加到notuse参数
  for(OrderConfirmModelConfirmGoodsItems item in orderConfirmModelEntity?.confirmGoodsItems??[]){
    bool inShow = false;
    for(VoucherSkuModelEntity sku in ocBloc.state.orderConfirmModelEntity?.canUseVoucherProductList ?? []){

      if(item.skuNo == sku.skuNo && item.lineThroughPrice == double.tryParse(sku.lineThroughPrice??"0") && item.buyNum == sku.buyNum){
        inShow = true;
        break;
      }
    }

    if(!inShow){
      VoucherSkuModelEntity noinSku = VoucherSkuModelEntity()
        ..itemNo = item.skuNo
        ..buyNum=item.buyNum
        ..categoryCode=item.categoryCode
        ..skuNo=item.skuNo
        ..baseUnitPrice=item.facePrice
        ..lineThroughPrice = "${item.lineThroughPrice}";

      model.notUseVoucherSkus?.add(noinSku);
    }
  }

  model.usedCouponName = ocBloc.state.orderConfirmModelEntity?.usedCouponName ?? "";
  List l = ocBloc.state.orderConfirmModelEntity?.couponNoList ?? [];
  model.usedCouponNo = l.isNotEmpty ? l.first : null;
  model.bestCouponNo = l.isNotEmpty ? l.first : null;
  return OrderFetchCouponListRefreshEvent(model);
}

OrderFetchCouponListLoadMoreEvent assembleCouponListLoadMoreEvent(BuildContext context,
    OrderConfirmModelEntity? orderConfirmModelEntity, int? shopMdCode, int? queryType) {
  List<ProductItem>? products = orderConfirmModelEntity?.confirmGoodsItems
      ?.map((e) =>
          ProductItem(e.categoryCode, e.itemNo, e.skuNo, e.facePrice, e.lineThroughPrice, e.buyNum))
      .toList();
  OrderCouponListRequestModel model = OrderCouponListRequestModel(
      queryType, shopMdCode, 1, orderConfirmModelEntity?.financeDetail?.deliveryMoney, products);

  OrderVoucherBloc ovBloc = context.read<OrderVoucherBloc>();
  OrderConfirmBloc ocBloc = context.read<OrderConfirmBloc>();

  List<VoucherSkuModelEntity> useList = [];
  List<VoucherSkuModelEntity> nouseList = [];

  for (VoucherSkuModelEntity sku in ocBloc.state.voucherSkusList ?? []) {
    if (sku.voucherNo?.isNotEmpty ?? false) {
      useList.add(sku);
    } else {
      nouseList.add(sku);
    }
  }

  model.useVoucherSkus = useList;
  model.notUseVoucherSkus = nouseList;

  /// 需要将products 参数中不再canuse列表的找出来加到notuse参数
  for(OrderConfirmModelConfirmGoodsItems item in orderConfirmModelEntity?.confirmGoodsItems??[]){
    bool inShow = false;
    for(VoucherSkuModelEntity sku in ocBloc.state.orderConfirmModelEntity?.canUseVoucherProductList ?? []){

      if(item.skuNo == sku.skuNo && item.lineThroughPrice == double.tryParse(sku.lineThroughPrice??"0") && item.buyNum == sku.buyNum){
        inShow = true;
        break;
      }
    }

    if(!inShow){
      VoucherSkuModelEntity noinSku = VoucherSkuModelEntity()
        ..itemNo = item.skuNo
        ..buyNum=item.buyNum
        ..categoryCode=item.categoryCode
        ..skuNo=item.skuNo
        ..baseUnitPrice=item.facePrice
        ..lineThroughPrice = "${item.lineThroughPrice}";

      model.notUseVoucherSkus?.add(noinSku);
    }
  }

  model.usedCouponName = ocBloc.state.orderConfirmModelEntity?.usedCouponName ?? "";
  List l = ocBloc.state.orderConfirmModelEntity?.couponNoList ?? [];
  model.usedCouponNo = l.isNotEmpty ? l.first : null;
  model.bestCouponNo = l.isNotEmpty ? l.first : null;
  return OrderFetchCouponListLoadMoreEvent(model);
}
