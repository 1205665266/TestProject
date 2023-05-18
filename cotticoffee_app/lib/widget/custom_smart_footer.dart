import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/3/21 4:00 下午
class CustomSmartFooter extends StatelessWidget {
  String? footerText;
  Color? footerColor;
  double height;

  CustomSmartFooter({Key? key, this.footerText, this.footerColor, this.height = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      height: height + 60,
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = const Text("上滑加载更多");
        } else if (mode == LoadStatus.loading) {
          body = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/@.svg',
                width: 12.w,
                height: 12.w,
              ),
              SizedBox(width: 4.w),
              Text(
                '努力加载中...',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: CottiColor.textGray,
                ),
              ),
            ],
          );
        } else if (mode == LoadStatus.failed) {
          body = const Text("加载错误");
        } else if (mode == LoadStatus.noMore) {
          body = Text(
            footerText ?? "— 美味无上限，页面有底线哦 —",
            style: TextStyle(color: footerColor ?? CottiColor.textGray, fontSize: 12.sp),
          );
        } else {
          body = const Text("");
        }
        return Container(
          alignment: Alignment.center,
          height: 60.h,
          child: body,
        );
      },
    );
  }
}
