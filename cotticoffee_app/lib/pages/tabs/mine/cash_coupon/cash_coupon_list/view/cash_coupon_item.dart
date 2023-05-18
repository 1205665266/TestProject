import 'dart:math';

import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/widget/coupon_shape_border.dart';
import 'package:cotti_client/widget/horizontail_divider.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'action_enum.dart';
import 'action_view.dart';
import 'employ_label.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/8 11:23
class CashCouponItem extends StatefulWidget {
  ///不可用原因，不传默认显示券使用说明
  final String? unavailableCause;

  ///券不可用描述，不传默认显示 "详细信息"
  final String? unavailableDes;

  ///券不可用描述文案颜色
  final Color? unavailableTextColor;

  ///券是否可用 默认 true
  final bool available;

  ///是否显示占用标识，默认false
  final bool isEmploy;

  ///按钮样式枚举，默认none
  final ActionEnum actionEnum;

  ///自定义显示的时间内容
  final String? customTimeContent;

  ///按钮回调
  final Function? actionCallBack;
  final CashCouponEntity cashCouponEntity;

  const CashCouponItem({
    Key? key,
    this.available = true,
    this.isEmploy = false,
    this.actionEnum = ActionEnum.none,
    this.actionCallBack,
    required this.cashCouponEntity,
    this.customTimeContent,
    this.unavailableDes,
    this.unavailableTextColor,
    this.unavailableCause,
  }) : super(key: key);

  @override
  State<CashCouponItem> createState() => _CashCouponItemState();
}

class _CashCouponItemState extends State<CashCouponItem> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.available ? 1 : 0.5,
      child: Stack(
        children: [
          _buildCouponCard(),
          _buildEmployLabel(),
          _buildDouYinCorner(),
        ],
      ),
    );
  }

  _buildEmployLabel() {
    return Positioned(
      right: 1.w,
      top: 1.h,
      child: Visibility(
        visible: widget.isEmploy,
        child: const EmployLabel(),
      ),
    );
  }

  _buildDouYinCorner() {
    if (widget.cashCouponEntity.sendType != 9) {
      return const SizedBox();
    }
    return Image.asset(
      "assets/images/mine/ic_douyin_corner.png",
      width: 43.w,
      height: 41.h,
    );
  }

  _buildCouponCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF19466A).withOpacity(0.02),
            offset: Offset(0, 4.h),
            blurRadius: 2.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCouponRoot(),
          _buildDes(),
        ],
      ),
    );
  }

  _buildCouponRoot() {
    return GestureDetector(
      onTap: () => setState(() {
        isOpen = !isOpen;

        if(isOpen){

          String eventName = widget.available ? OrderSensorsConstant.confirmOrderVoucherDetailClick:OrderSensorsConstant.confirmOrderVoucherNotUseDetailView;

          var map = {
            "skuNo":"",
            "skuShowName":"",
            "voucherNo":widget.cashCouponEntity.couponNo,
            "voucherName":widget.cashCouponEntity.couponName,
            "value":widget.cashCouponEntity.value,
          };
          logI("var map = $map");
          SensorsAnalyticsFlutterPlugin.track(eventName, map);
        }

      }),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          image: widget.cashCouponEntity.sendType == 9
              ? const DecorationImage(
                  image: AssetImage("assets/images/mine/icon_douyin_cash.png"),
                  alignment: Alignment.centerRight,
                )
              : null,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCouponCash(),
              SizedBox(width: 8.w),
              Expanded(child: _buildCouponInfo()),
              _buildAction(),
            ],
          ),
        ),
      ),
    );
  }

  _buildCouponCash() {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: CouponShapeBorder(circleSize: 6.r),
      ),
      child: Container(
        width: 81.w,
        height: 75.h,
        padding: EdgeInsets.symmetric(horizontal: 3.r),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF79E72), Color(0xFFE04D1B)],
          ),
        ),
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  '¥',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(width: 1.w),
              Flexible(
                child: Text(
                  Decimal.tryParse("${widget.cashCouponEntity.value}")?.toString() ?? '',
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontFamily: 'DDP6',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCouponInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.h),
        Text(
          widget.cashCouponEntity.couponName ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: CottiColor.textBlack,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          strutStyle: const StrutStyle(forceStrutHeight: true),
        ),
        if (widget.cashCouponEntity.couponSubTitle?.isNotEmpty ?? false) SizedBox(height: 5.h),
        Text(
          widget.cashCouponEntity.couponSubTitle ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: CottiColor.textGray,
            fontSize: 10.sp,
          ),
          strutStyle: const StrutStyle(forceStrutHeight: true, height: 1),
        ),
        SizedBox(height: 5.h),
        Wrap(
          spacing: 4.w,
          children: [
            Text(
              widget.customTimeContent ??
                  "${_getTime(widget.cashCouponEntity.startTime ?? '')} 至 ${_getTime(widget.cashCouponEntity.endTime ?? '')}",
              style: TextStyle(
                color: CottiColor.textBlack,
                letterSpacing: -0.5,
                fontSize: 10.sp,
              ),
            ),
            if ((widget.cashCouponEntity.recentlyExpiredDate ?? '').isNotEmpty)
              Text(
                "${widget.cashCouponEntity.recentlyExpiredDate}",
                style: TextStyle(
                  color: CottiColor.primeColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            Text(
              widget.unavailableDes ?? "详细信息",
              style: TextStyle(
                color: widget.unavailableTextColor ?? CottiColor.textGray,
                fontSize: 10.sp,
              ),
            ),
            Transform.rotate(
              angle: isOpen ? 0 : pi,
              child: SvgPicture.asset(
                "assets/images/mine/icon_coupon_drop_down.svg",
                width: 11.w,
                height: 11.h,
                color: widget.unavailableTextColor ?? const Color(0xFF9C9D9D),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildAction() {
    return ActionView(
      actionEnum: widget.actionEnum,
      actionCallBack: () {
        if (widget.actionCallBack != null) {
          widget.actionCallBack!();
        }
      },
    );
  }

  _buildDes() {
    return Visibility(
      visible: isOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HorizontalDivider(
            dividerColor: CottiColor.dividerGray,
            dividerHeight: .5.h,
            dividerMargin: EdgeInsets.symmetric(horizontal: 12.w),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
            child: Text(
              widget.unavailableCause ?? (widget.cashCouponEntity.couponDesc ?? ''),
              style: TextStyle(
                color: const Color(0xFF7A7A7A),
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getTime(String time) {
    List result = time.split(r" ");
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return time;
    }
  }
}
