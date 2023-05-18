import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/22 10:40
class GoodLineCartSpec extends StatelessWidget {
  final String? skuShowName;
  final bool isEatIn;
  final Function onTap;

  const GoodLineCartSpec({Key? key, this.skuShowName, this.isEatIn = false, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (skuShowName?.isNotEmpty ?? false)
          Flexible(
            child: GestureDetector(
              onTap: () => onTap(),
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      skuShowName ?? "",
                      style: TextStyle(
                        color: CottiColor.textGray,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Icon(
                    IconFont.icon_caidan_zhankaishouqingxiajiantou,
                    color: CottiColor.textHint,
                    size: 14.w,
                  ),
                ],
              ),
            ),
          ),
        if (isEatIn)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              border: Border.all(color: CottiColor.textHint, width: 0.5.w),
            ),
            child: Text(
              "仅限堂食",
              style: TextStyle(
                color: CottiColor.textHint,
                fontSize: 10.sp,
              ),
            ),
          ),
        SizedBox(width: 16.w),
      ],
    );
  }
}
