import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'view.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/13 15:12
class ActionView extends StatelessWidget {
  ///按钮样式枚举，默认none
  final ActionEnum actionEnum;

  ///按钮回调
  final Function actionCallBack;

  const ActionView({
    Key? key,
    required this.actionEnum,
    required this.actionCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (actionEnum) {
      case ActionEnum.useNow:
        child = _buildUse("立即使用");
        break;
      case ActionEnum.selected:
        child = _buildSelect(true);
        break;
      case ActionEnum.notSelected:
        child = _buildSelect(false);
        break;
      case ActionEnum.replaceWith:
        child = _buildUse("替换使用");
        break;
      case ActionEnum.none:
        child = const SizedBox();
        break;
    }
    return GestureDetector(
      onTap: () => actionCallBack(),
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }

  _buildUse(String text) {
    return Container(
      height: 75.h,
      margin: EdgeInsets.only(left: 8.w),
      alignment: Alignment.centerLeft,
      child: Container(
        width: 56.w,
        height: 23.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2.r),
          border: Border.all(
            color: const Color(0xFFED4E18),
            width: 1.w,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: const Color(0xFFED4E18),
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  _buildSelect(bool isSelect) {
    return Container(
      height: 75.h,
      alignment: Alignment.centerLeft,
      child: Padding(
        //增加点击区域
        padding: EdgeInsets.only(top: 8.h, left: 8.w, bottom: 8.h),
        child: Icon(
          isSelect ? IconFont.icon_select : IconFont.icon_weixuanzhong2,
          color: isSelect ? CottiColor.primeColor : CottiColor.textHint,
          size: 18.w,
        ),
      ),
    );
  }
}
