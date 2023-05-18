import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/23 23:28
class HorizontalDivider extends StatelessWidget {
  final Color? dividerColor;
  final double? dividerHeight;
  final EdgeInsets? dividerPadding;
  final EdgeInsets? dividerMargin;

  const HorizontalDivider(
      {Key? key, this.dividerColor, this.dividerHeight, this.dividerPadding, this.dividerMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dividerColor ?? const Color(0xFFE5E5E5),
      padding: dividerPadding,
      margin: dividerMargin,
      height: dividerHeight ?? 0.5.h,
    );
  }
}
