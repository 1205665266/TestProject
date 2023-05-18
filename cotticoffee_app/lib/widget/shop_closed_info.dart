import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/widget/box_move_animation.dart';
import 'package:cotti_client/widget/horizontail_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/7 10:13
class ShopClosedInfo extends StatefulWidget {
  final String shopOperateStr;
  final Duration duration;
  final Function clickClose;
  final ValueNotifier<bool> animationChange;

  const ShopClosedInfo(
      {Key? key,
      required this.shopOperateStr,
      required this.duration,
      required this.clickClose,
      required this.animationChange})
      : super(key: key);

  @override
  State<ShopClosedInfo> createState() => _ShopClosedInfoState();
}

class _ShopClosedInfoState extends State<ShopClosedInfo> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.animationChange,
      builder: (BuildContext context, value, Widget? child) {
        return Stack(
          children: [
            if (value)
              GestureDetector(
                onTap: () => widget.clickClose(),
                child: Container(color: Colors.black.withOpacity(0.55)),
              ),
            Align(
              alignment: Alignment.bottomLeft,
              child: _buildOpenWidget(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOpenWidget() {
    return BoxMoveAnimation(
      animationChange: widget.animationChange,
      duration: widget.duration,
      child: Container(
        color: const Color(0xFFF7F6F6),
        padding: EdgeInsets.only(left: 20.w, top: 8.h, bottom: 20.h, right: 14.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            HorizontalDivider(
              dividerColor: const Color(0xFFEEEEEE),
              dividerMargin: EdgeInsets.only(top: 8.h, bottom: 15.h, right: 6.w),
            ),
            _buildCloseInfo(),
          ],
        ),
      ),
    );
  }

  _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '本店休息中',
          style: TextStyle(
            color: CottiColor.textBlack,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'SYHT',
          ),
        ),
        GestureDetector(
          onTap: () => widget.clickClose(),
          behavior: HitTestBehavior.opaque,
          child: SvgPicture.asset(
            'assets/images/menu/icon_shop_closed_open.svg',
            width: 22.w,
            height: 22.w,
          ),
        ),
      ],
    );
  }

  _buildCloseInfo() {
    List<String> shopOperateStrs = widget.shopOperateStr.split("\n");
    List<List<String>> shopOperateNew = shopOperateStrs.map((e) => e.split("#")).toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: widget.shopOperateStr.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '营业时间',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: CottiColor.textBlack,
                        fontWeight: FontWeight.bold,
                      ),
                      strutStyle: const StrutStyle(forceStrutHeight: true),
                    ),
                    SizedBox(height: 6.h),
                    Column(
                      children: List.generate(
                        shopOperateNew.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(top: index == 0 ? 0 : 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(minWidth: 64.w),
                                child: Text(
                                  shopOperateNew[index][0],
                                  style: TextStyle(
                                    color: CottiColor.textBlack,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  strutStyle: const StrutStyle(forceStrutHeight: true),
                                ),
                              ),
                              if (shopOperateNew[index].length > 1)
                                Expanded(
                                  child: Text(
                                    shopOperateNew[index][1].replaceAll(r",", r" "),
                                    style: TextStyle(
                                      color: CottiColor.textBlack,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    strutStyle: const StrutStyle(forceStrutHeight: true),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Text(
                  '今日门店休息',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: CottiColor.textBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 6.w),
          child: SvgPicture.asset(
            'assets/images/menu/icon_closed_tips.svg',
            width: 84.w,
            height: 50.h,
          ),
        ),
      ],
    );
  }
}
