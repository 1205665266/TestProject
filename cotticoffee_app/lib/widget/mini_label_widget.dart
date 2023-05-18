import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/16 9:23 PM
class MiniLabelWidget extends StatelessWidget {
  final EdgeInsets? textPadding;
  final double? textSize;
  final String? label;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isBold;
  final double textHeight;
  final double? radius;
  final EdgeInsets? margin;
  final double? minLength;

  const MiniLabelWidget({
    Key? key,
    this.textPadding,
    this.textSize,
    this.label,
    this.backgroundColor,
    this.textColor,
    this.isBold = true,
    this.textHeight = 1.2,
    this.radius,
    this.margin,
    this.minLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: label?.isEmpty ?? true,
      child: Container(
        padding: textPadding ?? EdgeInsets.all(2.w),
        margin: margin ?? EdgeInsets.all(0.w),
        constraints: BoxConstraints(minWidth: ((minLength !=null ) ? minLength! : 0.w)),
        decoration: BoxDecoration(
          color: backgroundColor ?? CottiColor.primeColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
        ),
        child: Text(
          label ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor ?? CottiColor.primeColor,
            fontSize: textSize ?? 10.sp,
          ),
          strutStyle: StrutStyle(
            forceStrutHeight: true,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            height: textHeight,
          ),
        ),
      ),
    );
  }
}
