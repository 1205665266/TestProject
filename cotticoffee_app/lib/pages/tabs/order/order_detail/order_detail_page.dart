import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/activity/red_envelope_widget.dart';
import 'package:cotti_client/pages/tabs/mine/help/help_widget.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_delivery_detail_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/delivery_map.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/refund_record_dialog.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_event.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/order_confirm_page.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_event.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_state.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/bottom_action_bar.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/cancel_count_dwon.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/canteen_pickup_code.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/delivery_info.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/other_widget.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/pay_detail.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/self_take.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/simple_item.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/take_out_food.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_bloc.dart';
import 'package:cotti_client/routers/order_router.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/banner/widget/float_banner.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/custom_smart_header.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/19 8:59 PM
class OrderDetailPage extends StatefulWidget {
  final String orderNo;
  bool? isEvaluatePush;

  /// 是否是来自订单评价推送点击
  bool isDelay;
  bool fromList; // 是否是从订单列表页跳转

  OrderDetailPage(
      {Key? key,
      required this.orderNo,
      this.isEvaluatePush,
      this.isDelay = false,
      this.fromList = false})
      : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> with WidgetsBindingObserver {
  final OrderDetailBloc _bloc = OrderDetailBloc();
  late OrderBloc _orderBloc;
  final ValueNotifier<bool> animationNotifier = ValueNotifier(false);
  final ValueNotifier<double> _notifier = ValueNotifier(0);
  double titleBackgroundOpacity = 0;

  final ScrollPhysics _physics = const AlwaysScrollableScrollPhysics();
  final ScrollPhysics _physics2 = const NeverScrollableScrollPhysics();
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();
  bool canScroll = true;
  double mapHeight = 284.h;

  // 是否在订单详情操作了取消操作
  bool orderCanceled = false;

  // 是否在订单详情操作了支付
  bool orderPayed = false;

  // 是否在订单详情操作了评价操作
  bool orderEvaluated = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      logI('app进入前台 订单详情');
      // 获取系统通知是否允许， 用户设置完回到应用需要刷新展示
      _bloc.add(GrantSystemNotificationEvent());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    Future.delayed(Duration(milliseconds: widget.isDelay ? 500 : 0), () {
      // 获取系统通知是否允许
      _bloc.add(GrantSystemNotificationEvent());
      _bloc.add(InitOrderInfoEvent(widget.orderNo));
    });

    logI('获取通知');

    if (widget.fromList) {
      _orderBloc = BlocProvider.of<OrderBloc>(context);
    } else {
      _orderBloc = OrderBloc();
    }
  }

  Widget _rightAction() {
    return GestureDetector(
      onTap: () {
        logI('_rightAction in detail');
        String? shopPhone = _bloc.state.orderDetail?.orderQueryExtend?.shopPhone;
        logI("shopPhone === $shopPhone");
        HelpSheet.show(context, shopPhone: shopPhone, orderDetailModel: _bloc.state.orderDetail);
        SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.servantOrderDetailClick,
            {"order_state": _bloc.state.orderDetail?.orderStatusStr?.statusStr});
      },
      child: Container(
        margin: EdgeInsets.only(right: 16.w),
        child: Icon(
          IconFont.icon_help_color,
          size: 20.w,
          color: CottiColor.textBlack,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fromList) {
      return BlocProvider(create: (_) => _bloc, child: _buildContent());
    } else {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => _bloc),
          BlocProvider(create: (_) => _orderBloc),
        ],
        child: _buildContent(),
      );
    }
  }

  // 地图相关信息
  _buildDeliveryMap() {
    return BlocBuilder<OrderDetailBloc, OrderDetailState>(builder: (context, state) {
      OrderDeliveryDetailModelEntity? orderDeliveryDetailModelEntity =
          state.orderDeliveryDetailModelEntity;
      LatLng destination = LatLng(
          orderDeliveryDetailModelEntity?.shippingAddressLatitude ?? 39.909187,
          orderDeliveryDetailModelEntity?.shippingAddressLongitude ?? 116.397451);
      LatLng rider = LatLng(orderDeliveryDetailModelEntity?.dispatcherLatitude ?? 39.909187,
          orderDeliveryDetailModelEntity?.dispatcherLongitude ?? 116.397451);
      return SizedBox(
          width: double.infinity,
          height: 342.h,
          child: state.orderDeliveryDetailModelEntity != null
              ? DeliveryMap(destinationPosition: destination, riderPosition: rider)
              : Container());
    });
  }

  Widget _buildContent() {
    return CustomPageWidget(
      showAppBar: false,
      child: Stack(
        children: [
          NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollStartNotification) {
                  animationNotifier.value = true;
                } else if (notification is ScrollUpdateNotification) {
                  double opacity = _computeTitleOpacity();
                  if (opacity <= 1 && opacity >= 0) {
                    _notifier.value = opacity;
                  }
                } else if (notification is ScrollEndNotification) {
                  animationNotifier.value = false;
                }
                return true;
              },
              child: _buildScrollContent()),
          _buildTitleContent(),
          _buildBottomContent(),
          RedEnvelopeWidget(
            animationNotifier: animationNotifier,
            orderId: widget.orderNo,
            bannerCode: "cotti-order-detail-float",
            viewPage: 'cotti-app-orderdetail',
          ),
          ABiteBanner(
            bannerParam: BannerParam(
              'cotti-window-common',
              isNoCache: true,
              memberId: Constant.memberId,
              viewPage: 'cotti-app-orderdetail',
            ),
          ),
          FloatBanner(
            controller: _scrollController,
            paddingBottom: 84.h + MediaQuery.of(context).padding.bottom,
            child: ABiteBanner(
              width: 60.w,
              resize: true,
              bannerParam: BannerParam(
                'cotti-float-common',
                memberId: Constant.memberId,
                viewPage: "cotti-app-orderdetail",
              ),
            ),
          ),
          _buildLoadingWidget()
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return BlocBuilder<OrderDetailBloc, OrderDetailState>(builder: (context, state) {
      if (!state.showLoading) {
        return Container();
      }
      return Container(
        color: Colors.transparent,
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
    });
  }

  _buildScrollContent() {
    return BlocConsumer<OrderDetailBloc, OrderDetailState>(
      listener: (context, state) {
        // 如果是评价推送的点击跳转，并且当前订单还未评价，则跳转到订单评价页面
        if ((widget.isEvaluatePush ?? false) && state.orderDetail?.isEvaluate == 0) {
          NavigatorUtils.push(context, OrderRouter.orderEvaluatePage,
              params: {"orderNo": widget.orderNo}, replace: true);
        }
        if (state.refreshStatus == RefreshStatus.completed) {
          _refreshController.refreshCompleted();
        }
      },
      builder: (context, state) {
        List<Widget> listView = _listView(state.orderDetail);
        return Listener(
            onPointerDown: (event) {
              if (_bloc.state.isShowMap &&
                  (event.position.dy <= mapHeight - (_refreshController.position?.pixels ?? 0))) {
                setState(() {
                  canScroll = false;
                });
              }
            },
            onPointerUp: (event) {
              setState(() {
                canScroll = true;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(top: _paddingTop()),
              child: SmartRefresher(
                  controller: _refreshController,
                  header: const CustomSmartHeader(),
                  onRefresh: () => _bloc.add(OnRefreshDetailEvent()),
                  physics: canScroll ? _physics : _physics2,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      state.isShowMap
                          ? SliverPersistentHeader(
                              pinned: false,
                              floating: false,
                              delegate:
                                  MySliverPersistentHeaderDelegate(child: _buildDeliveryMap()))
                          : SliverToBoxAdapter(
                              child: Container(),
                            ),
                      SliverToBoxAdapter(
                        child: Container(
                          child: Column(
                            children: listView,
                          ),
                        ),
                      ),
                      SliverPadding(
                          padding: EdgeInsets.only(
                              bottom: (72.h + MediaQuery.of(context).padding.bottom)))
                    ],
                  )),
            ));
      },
    );
  }

  _buildTitleContent() {
    return BlocBuilder<OrderDetailBloc, OrderDetailState>(
      builder: (context, state) {
        return ValueListenableBuilder<double>(
          valueListenable: _notifier,
          builder: (context, value, child) {
            return Container(
                color: Colors.white.withOpacity(value),
                height: MediaQuery.of(context).padding.top + 44.h,
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        (!state.isShowMap || value > 0.5)
                            ? state.orderDetail?.orderStatusStr?.statusStr ?? ''
                            : "",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: CottiColor.textBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [_buildBack(), _rightAction()],
                      ),
                    ),
                  ],
                ));
          },
        );
      },
    );
  }

  _buildBack() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => NavigatorUtils.pop(context),
      child: UnconstrainedBox(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: SvgPicture.asset(
            'assets/images/ic_back.svg',
            width: 20.h,
            height: 20.h,
            color: const Color(0xFF111111),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  _buildBottomContent() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: BottomActionBar(
        payResult: (result) {
          if (result) {
            orderPayed = true;
          }
        },
        cancelResult: (result) {
          if (result) {
            orderCanceled = true;
          }
        },
        evaluatedResult: (result) {
          if (result) {
            orderEvaluated = true;
          }
        },
      ),
    );
  }

  _computeTitleOpacity() {
    return (_refreshController.position?.pixels ?? 0) / 100.h;
  }

  List<Widget> _listView(OrderDetailModel? orderDetail) {
    List<Widget> list = [];
    if (orderDetail == null) {
      return list;
    }
    // 支付倒计时
    if (orderDetail.status == 10 && (orderDetail.deadLineSeconds ?? 0) > 0) {
      if (orderDetail.orderQueryPay?.payFrom == PayForm.canteenCard.index) {
        list.add(CanteenPickupCode(orderModel: orderDetail));
      } else {
        list.add(CancelCountDown(orderDetail: orderDetail));
      }
    }
    if (_bloc.state.isSelfTake) {
      list.add(SelfTake(orderModel: orderDetail));
    }
    if (_bloc.state.isTakeOut) {
      list.add(TakeOutFood(orderModel: orderDetail));
    }
    list.add(_topBannerView());
    list.add(PayDetail(orderDetail: orderDetail));
    if (_bloc.state.isTakeOut) {
      list.add(const DeliveryInfo());
    }
    if (orderDetail.isEvaluate == 1) {
      list.add(buildOrderEvaluate(orderDetail.orderNo, orderDetail.orderStatusStr?.statusStr));
    }
    if (orderDetail.refundStatus == 3 || orderDetail.refundStatus == 2) {
      list.add(_buildRefundRecordView());
    }
    list.add(const OtherWidget());
    return list;
  }

  _buildRefundRecordView() {
    return BlocListener<OrderDetailBloc, OrderDetailState>(
        listenWhen: (previous, current) {
          logE('退款');
          logE('退款${previous.getRefundRecordListTimeStamp}');
          logE('退款${current.getRefundRecordListTimeStamp}');
          return previous.getRefundRecordListTimeStamp != current.getRefundRecordListTimeStamp;
        },
        listener: (context, state) {
          logE('显示退款');
          RefundRecordDialog.show(context, state.refundRecordList);
        },
        child: SimpleItem(
            title: '退款记录',
            click: () {
              _bloc.add(OnRequestRefundRecordEvent());
            }));
  }

  _topBannerView() {
    return ABiteBanner(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
      bannerParam: BannerParam("cotti-order-detail-banner"),
      width: ScreenUtil().screenWidth - 32.w,
      borderRadius: BorderRadius.circular(4.r),
      fit: BoxFit.fitWidth,
      resize: true,
    );
  }

  _paddingTop() {
    if (_bloc.state.isShowMap) {
      return 0.h;
    } else {
      return 42.h + MediaQuery.of(context).padding.top;
    }
  }

  buildOrderEvaluate(String? orderNo, String? statusStr) {
    return SimpleItem(
        title: '查看评价',
        click: () {
          NavigatorUtils.push(
            context,
            OrderRouter.orderEvaluateDetailPage,
            params: {"orderNo": orderNo},
          );

          SensorsAnalyticsFlutterPlugin.track(
              OrderSensorsConstant.checkCommentOrderDetailClick, {"order_state": statusStr});
        });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    // 如果不是从列表跳转过来，直接return
    if (!widget.fromList) {
      return;
    }
    if (orderCanceled || orderPayed || orderEvaluated) {
      _orderBloc.add(OnRefreshEvent(0));
    }
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  MySliverPersistentHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 342.h;

  @override
  double get minExtent => 342.h;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false; // 如果内容需要更新，设置为true
}
