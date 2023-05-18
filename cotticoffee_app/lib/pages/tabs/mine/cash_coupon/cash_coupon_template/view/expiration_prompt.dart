import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/10 18:35
class ExpirationPrompt extends StatefulWidget {
  final int recentlyExpiredCount;

  const ExpirationPrompt(
    this.recentlyExpiredCount, {
    Key? key,
  }) : super(key: key);

  @override
  State<ExpirationPrompt> createState() => _ExpirationPromptState();
}

class _ExpirationPromptState extends State<ExpirationPrompt> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NavigatorUtils.push(context, MineRouter.cashCouponListPage,
          params: {"recentlyExpiredCount": widget.recentlyExpiredCount}),
      child: Container(
        margin: EdgeInsets.only(top: 12.h),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "${widget.recentlyExpiredCount}",
                  style: TextStyle(
                    color: CottiColor.primeColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "DDP5",
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  "张代金券即将到期",
                  style: TextStyle(
                    color: CottiColor.textGray,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "立即查看",
                  style: TextStyle(
                    color: CottiColor.textGray,
                    fontSize: 14.sp,
                  ),
                ),
                Icon(
                  IconFont.icon_youjiantou,
                  color: CottiColor.textGray,
                  size: 14.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
