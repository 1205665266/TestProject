import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class CottiColor {
  static const Color primeColor = Color(0xFFCD4444);
  static const Color textBlack = Color(0xFF3A3B3C);
  static const Color textGray = Color(0xFF5E5E5E);
  static const Color textHint = Color(0xFF979797);
  static const Color dividerGray = Color(0xFFEEEEEE);
  static const Color backgroundColor = Color(0xFFF5F6F7);

  static double circular = 4.r;
}

TextStyle titleTextStyle = TextStyle(
  fontSize: 16.sp,
  color: CottiColor.textBlack,
  fontWeight: FontWeight.bold,
);
