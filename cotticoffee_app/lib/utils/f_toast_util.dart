import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/2/20 10:45
class FToastUtil {
  static void showToast(String msgStr, {bool isError = false}) {
    FToast().showToast(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10.0,
            sigmaY: 10.0,
          ),
          child: Container(
            width: 140.w,
            constraints: BoxConstraints(minHeight: 120.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.all(Radius.circular(6.r)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.h),
                  if (isError)
                    SvgPicture.asset("assets/images/mine/ic_exchange_success.svg")
                  else
                    SvgPicture.asset("assets/images/mine/ic_gantanhao.svg"),
                  SizedBox(height: 20.h),
                  Text(
                    msgStr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
        ),
      ),
      gravity: ToastGravity.CENTER,
    );
  }
}
