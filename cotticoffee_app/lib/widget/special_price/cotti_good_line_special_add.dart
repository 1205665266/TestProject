import 'dart:math';

import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/menu/entity/special_activity_limit.dart';
import 'package:cotti_client/widget/count_red_point.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/28 14:02
class CottiGoodLineSpecialAdd extends StatefulWidget {
  final int quantity;
  final int surplus;
  final SpecialActivityLimit special;
  final VoidCallback callback;

  const CottiGoodLineSpecialAdd({
    Key? key,
    required this.quantity,
    required this.surplus,
    required this.special,
    required this.callback,
  }) : super(key: key);

  @override
  State<CottiGoodLineSpecialAdd> createState() => _CottiGoodLineSpecialAddState();
}

class _CottiGoodLineSpecialAddState extends State<CottiGoodLineSpecialAdd> {
  @override
  Widget build(BuildContext context) {
    bool isNotAdd = disabledIn(widget.special.activityShowType);
    Color color = isNotAdd ? CottiColor.textHint : CottiColor.primeColor;
    return GestureDetector(
      onTap: () {
        if (!isNotAdd) {
          widget.callback();
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              height: 17.8.w,
              margin: EdgeInsets.only(right: 17.5.w, top: 0.2.w),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border.all(width: 1.w, color: color),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(1.r),
                  bottomLeft: Radius.circular(1.r),
                ),
              ),
              child: Text(
                _specialText(),
                style: TextStyle(
                  color: color,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
                strutStyle: const StrutStyle(
                  forceStrutHeight: true,
                  height: 1.1,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: SvgPicture.asset(
                "assets/images/menu/icon_add_btn.svg",
                width: 18.w,
                height: 18.w,
                color: color,
              ),
            ),
            Positioned(
              right: -8,
              top: -9,
              child: CountRedPoint(
                count: widget.quantity,
                minSize: Size(16.w, 16.w),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _specialText() {
    String specialText = '';
    switch (widget.special.activityShowType) {
      case 0:
        specialText = context.read<ConfigBloc>().state.buyNow;
        break;
      case 1:
      case 2:
        specialText = "限购${widget.special.memberLimitAmount}件";
        break;
      case 3:
        specialText = "仅剩${min<int>(widget.special.shopPlusNum ?? 0, widget.surplus)}件";
        break;
      case 5:
        specialText =
            "已抢${Decimal.parse("${widget.special.limitProgressBar ?? 0}") * Decimal.parse("100")}%";
        break;
    }
    return specialText;
  }

  bool disabledIn(int? activityShowType) {
    if (activityShowType == 3) {
      return widget.quantity >= min<int>(widget.special.shopPlusNum ?? 0, widget.surplus);
    } else {
      return widget.quantity >= widget.surplus;
    }
  }
}
