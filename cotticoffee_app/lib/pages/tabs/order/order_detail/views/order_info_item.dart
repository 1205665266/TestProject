import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/20 6:16 PM
class OrderInfoItem extends StatelessWidget {
  String title;
  String? subTitle;
  double? subTitleFontSize;
  Widget? rightIcon;
  Widget? mainIcon;
  Function? clickRight;

  OrderInfoItem(
    this.title,
    this.subTitle, {
    Key? key,
    this.subTitleFontSize,
    this.rightIcon,
    this.clickRight,
    this.mainIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildItem();
  }

  _buildItem() {
    return Container(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: CottiColor.textGray,
                  fontSize: 12.sp,
                ),
              ),
              if (mainIcon != null) mainIcon!,
            ],
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (clickRight != null) {
                  clickRight!();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      subTitle ?? '',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: CottiColor.textBlack,
                        fontSize: subTitleFontSize ?? 13.sp,
                        fontFamily: 'DDP4',
                      ),
                      strutStyle: StrutStyle(
                        forceStrutHeight: true,
                        fontSize: subTitleFontSize ?? 13.sp,
                      ),
                    ),
                  ),
                  if (rightIcon != null)
                    Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: rightIcon,
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
