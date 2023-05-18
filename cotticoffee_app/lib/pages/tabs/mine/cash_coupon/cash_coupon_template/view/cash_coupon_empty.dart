import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/16 14:51
class CashCouponEmpty extends StatefulWidget {
  const CashCouponEmpty({Key? key}) : super(key: key);

  @override
  State<CashCouponEmpty> createState() => _CashCouponEmptyState();
}

class _CashCouponEmptyState extends State<CashCouponEmpty> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 212.h,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Image.asset(
                "assets/images/mine/ic_coupon_none.png",
                width: 141.w,
                height: 121.h,
              ),
              SizedBox(height: 16.h),
              Text(
                "暂无代金券",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: CottiColor.textGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
