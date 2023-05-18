import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/31 14:27
class CottiVerticalDivider extends StatelessWidget {
  final Color? dividerColor;
  final double? dividerWidth;
  final EdgeInsets? dividerPadding;
  final EdgeInsets? dividerMargin;

  const CottiVerticalDivider({
    Key? key,
    this.dividerColor,
    this.dividerWidth,
    this.dividerPadding,
    this.dividerMargin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dividerColor ?? const Color(0xFFE5E5E5),
      padding: dividerPadding,
      margin: dividerMargin,
      width: dividerWidth ?? 0.5.w,
    );
  }
}
