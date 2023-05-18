import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/9 17:06
class AddressEmpty extends StatelessWidget {
  const AddressEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(height: 237.h),
          SvgPicture.asset(
            'assets/images/mine/icon_address_empty.svg',
            width: 140.w,
            height: 120.h,
          ),
          SizedBox(height: 23.h),
          Text(
            "暂无地址",
            style: TextStyle(
              fontSize: 14.sp,
              color: CottiColor.textGray,
            ),
          ),
        ],
      ),
    );
  }
}
