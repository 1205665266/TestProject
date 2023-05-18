import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/12 17:42
class EffectWidget extends StatelessWidget {
  final Widget child;

  const EffectWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: Offset(0, 6.h),
            blurRadius: 12.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
