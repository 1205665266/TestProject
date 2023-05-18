import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/13 14:22
class EmployLabel extends StatelessWidget {
  const EmployLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 14.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFED4E18).withOpacity(0.2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4.r),
          topRight: Radius.circular(4.r),
        ),
      ),
      child: Text(
        '已占用',
        style: TextStyle(
          color: const Color(0xFFED4E18),
          fontWeight: FontWeight.w500,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
