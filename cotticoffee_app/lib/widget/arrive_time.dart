import 'package:cotti_client/global/entity/config_entity.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/widget/horizontail_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/20 11:33 PM
/// 慢必赔
class ArriveTime extends StatefulWidget {
  final ConfigEntity? configEntity;
  final Color? iconColor;
  final double? tipsTextSize;
  final double? leftIconSize;
  final FontWeight? fontWeight;
  final Size? rightIconSize;

  const ArriveTime({
    Key? key,
    this.configEntity,
    this.iconColor,
    this.tipsTextSize,
    this.leftIconSize,
    this.fontWeight,
    this.rightIconSize,
  }) : super(key: key);

  @override
  State<ArriveTime> createState() => _ArriveTimeState();
}

class _ArriveTimeState extends State<ArriveTime> {
  @override
  Widget build(BuildContext context) {
    if (widget.configEntity?.arriveOnTime?.isEmpty ?? true) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: _showSheetDialog,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(1.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/icon_allotment.svg',
              width: widget.leftIconSize ?? 13.w,
              height: widget.leftIconSize ?? 13.w,
            ),
            Container(
              margin: EdgeInsets.only(left: 2.w),
              child: Text(
                widget.configEntity?.arriveOnTime ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: widget.tipsTextSize ?? 10.sp,
                    color: CottiColor.primeColor,
                    fontFamily: 'DDP4',
                    fontWeight: widget.fontWeight ?? FontWeight.normal),
                strutStyle: StrutStyle(
                  forceStrutHeight: true,
                  fontSize: widget.tipsTextSize ?? 10.sp,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/images/icon_manbipei_more.svg',
              width: widget.rightIconSize?.width ?? 9.w,
              height: widget.rightIconSize?.height ?? 9.w,
            ),
          ],
        ),
      ),
    );
  }

  _showSheetDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.r),
              topRight: Radius.circular(8.r),
            ),
          ),
          constraints: BoxConstraints(minHeight: 200.h),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitle(context),
                HorizontalDivider(dividerMargin: EdgeInsets.symmetric(horizontal: 16.w)),
                _buildContent(),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildTitle(BuildContext context) {
    return Container(
      height: 52.h,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: 16.w),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              '慢必赔',
              style: TextStyle(
                fontSize: 16.sp,
                color: CottiColor.textBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                IconFont.icon_close,
                size: 24.w,
                color: CottiColor.textBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      alignment: Alignment.topLeft,
      child: Text(
        (widget.configEntity?.arriveOnTimeTips ?? '').replaceAll(r'\n', '\n'),
        style: TextStyle(
          color: CottiColor.textBlack,
          fontSize: 14.sp,
        ),
        strutStyle: const StrutStyle(
          height: 1.5,
          forceStrutHeight: true,
        ),
      ),
    );
  }
}
