import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/5 16:12

class CountRedPoint extends StatelessWidget {
  final int count;
  final Size minSize;

  const CountRedPoint({Key? key, required this.count, required this.minSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: count < 1,
      child: Container(
        constraints: BoxConstraints(minWidth: minSize.width, minHeight: minSize.height),
        decoration: BoxDecoration(
          color: const Color(0xFFFF9A8F),
          border: Border.all(color: Colors.white, width: .5.w),
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        child: Text(
          "$count",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.sp,
          ),
          strutStyle: const StrutStyle(
            forceStrutHeight: true,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}
