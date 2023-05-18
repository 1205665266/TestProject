import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CouponEmptyWidget extends StatelessWidget {
  const CouponEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 14.sp,
      color: const Color(0xff666666),
      height: 1.1,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 179.h,
        ),
        Image.asset(
          'assets/images/mine/ic_coupon_none.png',
          width: 141.w,
          height: 121.h,
        ),
        Text(
          '暂无优惠券',
          style: textStyle,
        ),
      ],
    );
  }
}
