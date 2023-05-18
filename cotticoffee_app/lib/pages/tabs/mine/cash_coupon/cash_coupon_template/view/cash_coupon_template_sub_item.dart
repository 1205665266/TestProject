import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';
import 'package:cotti_client/widget/coupon_shape_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'coupon_explain_dialog.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/13 09:38
class CashCouponTemplateSubItem extends StatefulWidget {
  final CashCouponEntity cashCouponEntity;

  const CashCouponTemplateSubItem(
    this.cashCouponEntity, {
    Key? key,
  }) : super(key: key);

  @override
  State<CashCouponTemplateSubItem> createState() => _CashCouponTemplateSubItemState();
}

class _CashCouponTemplateSubItemState extends State<CashCouponTemplateSubItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildSubCouponItem(),
        Positioned(right: 0, top: 0, child: _buildCount()),
      ],
    );
  }

  _buildSubCouponItem() {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: CouponShapeBorder(circleSize: 15.r),
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF8F5),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            SizedBox(height: 6.h),
            _buildSubTitle(),
            SizedBox(height: 6.h),
            _buildTime(),
          ],
        ),
      ),
    );
  }

  _buildTitle() {
    return GestureDetector(
      onTap: () => CouponExplainDialog.show(
        context,
        widget.cashCouponEntity.templateNo ?? '',
        widget.cashCouponEntity.partnerName,
        widget.cashCouponEntity.startTime,
      ),
      behavior: HitTestBehavior.opaque,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: widget.cashCouponEntity.couponName ?? '',
            ),
            WidgetSpan(child: SizedBox(width: 4.w)),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                IconFont.icon_tanhao,
                size: 12.w,
              ),
            ),
          ],
        ),
        style: TextStyle(
          color: CottiColor.textBlack,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _buildSubTitle() {
    return Text(
      widget.cashCouponEntity.couponSubTitle ?? '',
      style: TextStyle(
        color: CottiColor.textGray,
        fontSize: 10.sp,
      ),
    );
  }

  _buildTime() {
    return Row(
      children: [
        if ((widget.cashCouponEntity.recentlyExpiredDate ?? '').isNotEmpty)
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Text(
              "${widget.cashCouponEntity.recentlyExpiredDate}",
              style: TextStyle(
                color: CottiColor.primeColor,
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
              ),
            ),
          ),
        Text(
          "${widget.cashCouponEntity.startTime} 至 ${widget.cashCouponEntity.endTime}",
          style: TextStyle(
            color: CottiColor.textGray,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildCount() {
    if ((widget.cashCouponEntity.count ?? 0) <= 0) {
      return const SizedBox();
    }
    return Container(
      height: 16.h,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFED4E18),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4.r),
          topRight: Radius.circular(4.r),
        ),
      ),
      child: Text(
        "X${widget.cashCouponEntity.count}",
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
