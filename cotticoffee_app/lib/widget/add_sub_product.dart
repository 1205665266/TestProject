import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/widget/count_red_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/21 17:11
class AddSubProduct extends StatelessWidget {
  ///数量
  final int count;

  ///数量字体大小
  final double? countSize;

  ///按钮大小
  final double btnSize;

  ///加号内间距（为了增大点击区域）
  final EdgeInsetsGeometry? contentPadding;

  ///点击减号回调
  final VoidCallback? onTapSub;

  ///点击加号回调
  final VoidCallback? onTapAdd;

  ///加号是否可用，不可用时置灰
  final bool addBtnClickable;

  ///减号是否可用，不可用时置灰
  final bool subBtnClickable;

  ///是否显示减少按钮，默认显示,如果不显示减少按钮，数量会显示在组件右上角
  final bool showSubBtn;

  final double? redPointMarginBottom;

  const AddSubProduct(
    this.count, {
    Key? key,
    this.countSize,
    this.btnSize = 18,
    this.onTapSub,
    this.onTapAdd,
    this.addBtnClickable = true,
    this.subBtnClickable = true,
    this.contentPadding,
    this.showSubBtn = true,
    this.redPointMarginBottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: contentPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: count > 0 && showSubBtn,
                child: Icon(
                  IconFont.icon_jianhao,
                  color: subBtnClickable ? CottiColor.primeColor : const Color(0xFFDDDDDD),
                  size: btnSize,
                ),
              ),
              Visibility(
                visible: showSubBtn,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: 34.w,
                  ),
                  child: Text(
                    "${count > 0 ? count : ''}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CottiColor.textBlack,
                      fontSize: countSize ?? 18.sp,
                      fontFamily: "DDP5",
                    ),
                  ),
                ),
              ),
              Icon(
                IconFont.icon_jiahao,
                color: addBtnClickable ? CottiColor.primeColor : CottiColor.textHint,
                size: btnSize,
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: redPointMarginBottom ?? btnSize / 1.8,
          child: Visibility(
            visible: !showSubBtn,
            child: CountRedPoint(
              count: count,
              minSize: Size(16.w, 16.w),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          bottom: 0,
          child: Row(
            children: [
              Visibility(
                visible: count > 0 && showSubBtn,
                child: Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (onTapSub != null && subBtnClickable) {
                        onTapSub!();
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (onTapAdd != null && addBtnClickable) {
                      onTapAdd!();
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
