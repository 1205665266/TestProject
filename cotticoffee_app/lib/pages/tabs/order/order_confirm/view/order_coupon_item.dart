import 'dart:math';

import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/bloc/order_voucher_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/widget/radio_widget.dart';
import 'package:cotti_client/sensors/coupon_sensors_constant.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_list_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/divider_line.dart';
import 'package:cotti_client/utils/scheme_dispatcher.dart';
import 'package:cotti_client/widget/cotti_tooltip.dart';
import 'package:cotti_client/widget/simple_tooltip/src/types.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

enum OrderCouponItemSource {
  /// 不可用
  disable,

  /// 历史
  history,

  /// 列表，包含 立即使用 和 通知 兩種
  list,

  /// 訂單，包含選中圖標
  order,
}

class OrderCouponItem extends StatefulWidget {
  OrderCouponListModelConfirmOrderCouponDtoList coupon;

  final bool showTopLine;
  OrderCouponItemSource source;
  final bool atLast;
  int? index;

  OrderCouponItem(this.coupon, this.source,
      {Key? key, this.showTopLine = false, this.atLast = false, this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderCouponItemState();
}

class _OrderCouponItemState extends State<OrderCouponItem> {
  bool showDetail = false;
  late List<String> couponNoList = [];
  late OrderConfirmBloc _orderConfirmBloc;
  bool isSelect = false;
  bool isRecommend = false;

  /// 优惠券，优惠金额
  String? couponVal;

  /// 标识是否与代金券冲突；
  bool clash = false;

  String? clashTitle;
  String clashMsg = "可用优惠券但已使用代金券商品：\n1.美式咖啡\n2.经典咖啡\n当前优惠券可用于上述任一商品";

  final ValueNotifier<bool> showControl = ValueNotifier(false);

  initData() {
    couponNoList = _orderConfirmBloc.state.orderConfirmModelEntity?.couponNoList ?? [];

    isSelect = couponNoList.contains(widget.coupon.couponNo);
    // 是否是推荐
    var recommendCouponList = _orderConfirmBloc.state.recommendCouponList;
    isRecommend = recommendCouponList.contains(widget.coupon.couponNo);
    couponVal = "${widget.coupon.discountPrice ?? ""}";
    clash = (widget.coupon.canNotBeStackedTip?.isNotEmpty ?? false) &&
        widget.source == OrderCouponItemSource.order;

    clashMsg = widget.coupon.canNotBeStackedTip ?? "";
    clashTitle = widget.coupon.canNotBeStackedContext;
  }

  @override
  void initState() {
    super.initState();

    if (widget.source == OrderCouponItemSource.order || widget.source == OrderCouponItemSource.disable) {
      _orderConfirmBloc = BlocProvider.of<OrderConfirmBloc>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.source == OrderCouponItemSource.order ||
        widget.source == OrderCouponItemSource.disable) {
      initData();
    }
    return Column(
      children: [
        _buildTopWidget(),
        Container(
          margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: widget.atLast ? 0.h : 12.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(CottiColor.circular),
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildTopWidget() {
    return widget.showTopLine
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: 24.w,
                    bottom: 12.h,
                    top: (widget.index != null && widget.index == 0) ? 12.h : 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "与代金券不可叠加使用",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: CottiColor.textGray,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Visibility(
                visible: widget.index != null && widget.index == 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 24.w),
                  child: GestureDetector(
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
                ),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget _buildContent() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              showDetail = !showDetail;
              if (showDetail) {
                Map<String, dynamic> map = {};
                try {
                  map = widget.coupon.toJson();
                } catch (_) {}
                SensorsAnalyticsFlutterPlugin.track(CouponSensorsConstant.coupondetailClick, map);
              }
            });
            if (widget.source == OrderCouponItemSource.disable) {
              SensorsAnalyticsFlutterPlugin.track(
                  OrderSensorsConstant.confirmOrderCouponNotUseDetailView, {});
            } else {
              SensorsAnalyticsFlutterPlugin.track(
                  OrderSensorsConstant.confirmOrderCouponDetailClick, {});
            }
          },
          child: Container(
            foregroundDecoration:
                _showMask() ? BoxDecoration(color: Colors.white.withOpacity(0.5)) : null,
            padding: EdgeInsets.only(top: 8.h, bottom: 8.h, left: 8.w, right: 8.w),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: const Color(0xFF19466A).withOpacity(0.02),
                offset: Offset(0, 2.h),
                blurRadius: 4.r,
                spreadRadius: 0,
              ),
            ]),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildDouYinLogo(),
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCouponLeft(),
                        SizedBox(width: 12.w),
                        _buildCouponRight(),

                        /// 确认订单页面选中图标
                        _buildSelectIcon(),

                        /// 立即使用按钮
                        _buildTouseBtn(),

                        /// 调整代金券
                        _buildAdjustBtn(),
                      ],
                    ),

                    /// 优惠券描述
                    _buildDetailLine(),
                  ],
                ),
                _buildDouYinCorner(),
              ],
            ),
          ),
        ),

        /// 确认订单页面 推荐 标签
        // _buildRecommendLabel(),
        _buildCouponVal(),
      ],
    );
  }

  _buildCouponLeft() {
    return Container(
      width: 81.w,
      height: 75.h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          // fit: BoxFit.fitWidth,
          image: AssetImage('assets/images/order/order_confirm/icon_coupon_bg.png'),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: _buildCouponLeftShow(),
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.coupon.threshold ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white,
                  fontFamily: 'DDP6',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildCouponLeftShow() {
    // 立减券
    if (widget.coupon.couponType == 10) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "￥",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "${widget.coupon.strValue}",
                    style: TextStyle(
                        fontSize: _autoSize(widget.coupon.strValue ?? ''),
                        color: Colors.white,
                        fontFamily: 'DDP6',
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
    // 折扣券
    if (widget.coupon.couponType == 20) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: "${widget.coupon.strValue}",
                      style: TextStyle(
                          fontSize: _autoSize(widget.coupon.strValue ?? ''),
                          color: Colors.white,
                          fontFamily: 'DDP6',
                          fontWeight: FontWeight.w600)),
                  TextSpan(
                      text: "折",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                      )),
                ],
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
    // 一口价券
    if (widget.coupon.couponType == 62) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "￥",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                      text: "${widget.coupon.strValue}",
                      style: TextStyle(
                          fontSize: _autoSize(widget.coupon.strValue ?? ''),
                          color: Colors.white,
                          fontFamily: 'DDP6',
                          fontWeight: FontWeight.w600)),
                ],
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "换",
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "购",
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ],
      );
    }

    return Container();
  }

  _buildCouponRight() {
    return Expanded(
      child: SizedBox(
        // height: 75.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                "${widget.coupon.title}",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: CottiColor.textBlack,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ),
            if (widget.coupon.couponSubTitle?.isNotEmpty ?? false) SizedBox(height: 6.h),
            Text(
              widget.coupon.couponSubTitle ?? '',
              // "${widget.coupon.couponRestrict}",
              style: TextStyle(
                fontSize: 10.sp,
                color: CottiColor.textGray,
                height: 1,
              ),
            ),
            SizedBox(height: 6.h),
            Text.rich(
              TextSpan(
                children: [_getExpire()],
              ),
            ),
            Offstage(
              offstage: !clash,
              child: Container(
                // color: Colors.red,
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        showControl.value = !showControl.value;
                      },
                      child: Text(
                        clashTitle ?? "",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffC67F06),
                          height: 1.1,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showControl.value = !showControl.value;
                      },
                      child: Container(
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        height: 10.w,
                        width: 10.w,
                        child: CottiTooltip(
                          child: SvgPicture.asset(
                            "assets/images/order/order_confirm/ic_remind.svg",
                            width: 10.w,
                            height: 10.w,
                          ),
                          tip: clashMsg,
                          maxWidth: 180.w,
                          tooltipDirection: TooltipDirection.up,
                          showControl: showControl,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    _showRestrict() ? "${widget.coupon.couponRestrict}" : "详细信息",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: _showRestrict() ? CottiColor.primeColor : CottiColor.textGray,
                      height: 1,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Visibility(
                    visible: showDetail,
                    child: Icon(
                      IconFont.icon_shangjiantou,
                      size: 12.w,
                      color: const Color(0xFF9C9D9D),
                    ),
                    replacement: Icon(
                      IconFont.icon_xiajiantou_copy,
                      size: 12.w,
                      color: const Color(0xFF9C9D9D),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getExpire() {
    if (_getExpireHint().isNotEmpty) {
      return TextSpan(
        text: _getExpireHint(),
        style: TextStyle(
          color: CottiColor.primeColor,
          fontSize: 10.sp,
          height: 1,
        ),
      );
    } else {
      return TextSpan(
        text: _getExpireInterval(),
        style: TextStyle(
          color: CottiColor.textGray,
          fontSize: 10.sp,
          height: 1,
        ),
      );
    }
  }

  String _getExpireHint() {
    var dateMsByTimeStr = DateUtil.getDateMsByTimeStr(widget.coupon.endTime ?? "");
    var dateTime = DateUtil.getDateTime(widget.coupon.endTime ?? "");
    if (DateUtil.isToday(dateMsByTimeStr)) {
      return "今日到期 ";
    } else if (DateUtil.isYesterday(DateTime.now(), dateTime ?? DateTime.now())) {
      return "明日到期 ";
    }
    return "";
  }

  _getExpireInterval() {
    return "${widget.coupon.startTime?.substring(0, 10)} 至 ${widget.coupon.endTime?.substring(0, 10)}";
  }

  /// 优惠金额
  Widget _buildCouponVal() {
    bool show = (couponVal?.isNotEmpty ?? false) &&
        widget.coupon.canNotBeStackedButtonType == null &&
        widget.source == OrderCouponItemSource.order;

    return Visibility(
      visible: show,
      child: Positioned(
        // bottom: 12.h,
        right: 10.w,
        top: 65.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "可优惠",
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: CottiColor.textGray,
              ),
            ),
            SizedBox(
              width: 2.w,
            ),
            Text(
              "￥${couponVal ?? ""}",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: CottiColor.primeColor,
                fontFamily: "DDP5",
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 确认订单页面 推荐 标签
  Widget _buildNewRecommendLabel({bool show = false}) {
    double size = 4.h;

    Color bgColor = show ? CottiColor.primeColor : Colors.transparent;
    Color textColor = show ? Colors.white : Colors.transparent;

    return Visibility(
      visible: isRecommend && widget.coupon.canNotBeStackedButtonType == null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: Text(
              "推荐",
              style: TextStyle(
                fontSize: 9.sp,
                color: textColor,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, 0 - (size / 2)),
            child: Transform.rotate(
              angle: pi / 4,
              child: Container(
                width: size,
                height: size,
                color: bgColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 确认订单页面 推荐 标签
  Widget _buildRecommendLabel() {
    return Visibility(
      visible: isRecommend,
      child: Positioned(
        right: 0,
        child: SvgPicture.asset(
          "assets/images/order/order_confirm/ic_order_recommend.svg",
          width: 38.w,
          height: 15.h,
        ),
      ),
    );
  }

  /// 优惠券描述
  Widget _buildDetailLine() {
    return Visibility(
      visible: showDetail,
      child: Column(
        children: [
          SizedBox(
            height: 6.h,
          ),
          const DividerLine(),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10.h),
            child: Text(
              "${widget.coupon.couponDesc}",
              style: TextStyle(
                fontSize: 11.sp,
                color: CottiColor.textGray,
                height: 1,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 确认订单页的选中按钮
  Widget _buildSelectIcon() {
    return Visibility(
      visible: widget.source == OrderCouponItemSource.order &&
          widget.coupon.canNotBeStackedButtonType == null,
      child: SizedBox(
        height: 75.h,
        child: GestureDetector(
          onTap: () {
            if (widget.source != OrderCouponItemSource.order) {
              return;
            }
            List<String> list = [];
            list.add(widget.coupon.couponNo ?? "");

            if (!isRecommend) {
              SensorsAnalyticsFlutterPlugin.track(
                  OrderSensorsConstant.confirmOrderCouponNotBestClick, {});
            }

            _orderConfirmBloc.add(OrderConfirmChangeCouponEvent(context, list));
            Navigator.of(context).pop();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNewRecommendLabel(show: true),
              RadioWidget(
                checked: couponNoList.contains(widget.coupon.couponNo),
              ),

              /// 用一个透明widget保证选中按钮居中
              _buildNewRecommendLabel(show: false),
            ],
          ),
        ),
      ),
    );
  }

  /// 立即使用按钮
  Widget _buildTouseBtn() {
    return Offstage(
      offstage: _showMask() || widget.source == OrderCouponItemSource.order,
      child: Container(
        height: 75.h,
        width: 56.w,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            _toUse();
          },
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://cdn-product-prod.yummy.tech/wechat/cotti/images/mine/bg_coupon_touse2.png'),
              ),
            ),
            width: 56.w,
            height: 23.h,
            alignment: Alignment.center,
            child: Text(
              '立即使用',
              strutStyle: StrutStyle(
                fontSize: 11.sp,
                height: 1.2,
                leading: 0,
                forceStrutHeight: true,
                leadingDistribution: TextLeadingDistribution.proportional,
                fontWeight: FontWeight.w500,
                // leading: 1,
              ),
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 调整代金券按钮
  Widget _buildAdjustBtn() {
    String btnTitle = widget.coupon.canNotBeStackedButtonType == 1 ? "替换使用" : "调整代金券";

    return Offstage(
      offstage: widget.coupon.canNotBeStackedButtonType == null,
      child: InkWell(
        onTap: () {
          OrderVoucherBloc ovBloc = context.read<OrderVoucherBloc>();

          ovBloc.add(VoucherAdjustEvent(context: context, coupon: widget.coupon));

          logI("OrderVoucherBloc ovBloc = $ovBloc");

          logI("in _buildAdjustBtn action !!");
        },
        child: Container(
          height: 75.h,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: CottiColor.primeColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: Text(
              btnTitle,
              // "调整代金券""替换使用",
              style: TextStyle(
                color: CottiColor.primeColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
              strutStyle: const StrutStyle(
                forceStrutHeight: true,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 生效通知 按钮
  Widget _buildRemindBtn() {
    return Visibility(
      visible: _isFuture(),
      child: Positioned(
        right: 28.w,
        top: 20.h,
        child: Container(
          color: Colors.white,
          height: 75.h,
          width: 56.w,
          padding: EdgeInsets.only(top: 18.h),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              _remindAction();
            },
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn-product-prod.yummy.tech/wechat/cotti/images/mine/bg_coupon_list_remind.png'),
                ),
              ),
              width: 56.w,
              height: 23.h,
              alignment: Alignment.center,
              child: Text(
                '生效通知',
                strutStyle: StrutStyle(
                  fontSize: 11.sp,
                  height: 1.1,
                  leading: 0,
                  forceStrutHeight: true,
                  leadingDistribution: TextLeadingDistribution.proportional,
                  // leading: 1,
                ),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTooltip() {
    return Visibility(
      visible: _isFuture(),
      child: Positioned(
        right: 28.w,
        top: 82.h,
        child: Container(
          width: 56.w,
          alignment: Alignment.center,
          child: Tooltip(
            verticalOffset: 10.h,
            padding: EdgeInsets.symmetric(
              vertical: 3.h,
              horizontal: 6.w,
            ),
            richMessage: WidgetSpan(
              child: SizedBox(
                width: 134.w,
                child: Text(
                  '1. 您享有生效通知订阅权，可随时开启或取消\n2. 避免打扰您，一次订阅动作只推送一次微信服务通知，如您需要多次接收通知，可重复订阅动作。',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            triggerMode: TooltipTriggerMode.tap,
            preferBelow: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info,
                  size: 10.w,
                  color: const Color(0xffAEAEAE),
                ),
                Text(
                  '通知说明',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: const Color(0xffAEAEAE),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 生效通知点击事件
  _remindAction() {
    logW('_remindAction');
  }

  ///  跳转 菜单页
  _toUse() {
    Map<String, dynamic> map = {};

    try {
      map = widget.coupon.toJson();
    } catch (_) {}

    SensorsAnalyticsFlutterPlugin.track(CouponSensorsConstant.couponListUseItClick, map);

    SchemeDispatcher.dispatchPath(context, 'cottitab://coffee?tabIndex=1&takeFoodMode=100');
  }

  /// 是否显示 生效通知 按钮
  bool _isShowRemindBtn() {
    return _isFuture();
  }

  /// 判断 是否未生效
  bool _isFuture() {
    // /// 非优惠券 列表 不做判断直接返回 false
    // if (widget.source != OrderCouponItemSource.list) {
    //   return false;
    // }
    DateTime startTime = DateTime.parse(widget.coupon.startTime ?? '');

    DateTime now = DateTime.now();

    bool isAfter = now.isAfter(startTime);

    return !isAfter;
  }

  /// 是否显示不可用蒙层
  bool _showMask() {
    return _showRestrict() || widget.source == OrderCouponItemSource.history;
  }

  /// 详细信息是否显示为使用限制
  bool _showRestrict() {
    /// 不可用列表、未生效、优惠券列表(list)中available为false
    return (widget.source == OrderCouponItemSource.disable ||
        _isFuture() ||
        (widget.source == OrderCouponItemSource.list && !(widget.coupon.available ?? true)));
  }

  double _autoSize(String str) {
    int length = str.length;

    switch (length) {
      case 6:
      case 5:
        return 22.5.sp;
      case 4:
        return 25.sp;
      case 3:
      case 2:
      case 1:
        return 30.sp;
    }
    return 22.5.sp;
  }

  _buildDouYinCorner() {
    if (widget.coupon.sendType != 9) {
      return const SizedBox();
    }
    return Positioned(
      left: -9.w,
      top: -9.h,
      child: Image.asset(
        "assets/images/mine/ic_douyin_corner.png",
        width: 43.w,
        height: 41.h,
      ),
    );
  }

  _buildDouYinLogo() {
    if (widget.coupon.sendType != 9) {
      return const SizedBox();
    }
    return Positioned(
      right: 40.w,
      top: -8.h,
      child: SvgPicture.asset(
        "assets/images/mine/ic_douyin_logo.svg",
        height: 90.h,
      ),
    );
  }
}
