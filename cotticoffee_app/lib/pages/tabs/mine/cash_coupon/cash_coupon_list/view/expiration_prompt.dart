import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/13 09:42
class ExpirationPrompt extends StatelessWidget {
  final String num;

  const ExpirationPrompt({Key? key, required this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 18.h, bottom: 0.h),
      child: Row(
        children: [
          SizedBox(width: 12.w),
          Text(
            "以下",
            style: TextStyle(
              color: CottiColor.textGray,
              fontSize: 14.sp,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 3.w,
              right: 3.w,
            ),
            child: Text(
              num,
              style: TextStyle(
                color: CottiColor.primeColor,
                fontFamily: "DDP5",
                fontSize: 20.sp,
              ),
            ),
          ),
          Text(
            "张代金券即将到期",
            style: TextStyle(
              color: CottiColor.textGray,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
