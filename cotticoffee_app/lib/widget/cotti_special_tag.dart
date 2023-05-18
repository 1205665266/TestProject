import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 特价标签
class CottiSpecialTag extends StatelessWidget {

  final String title;
  final String content;
  final int countDown;

  const CottiSpecialTag({
    Key? key,
    this.title = '',
    this.content = '',
    this.countDown = 0,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFBE7E5),
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      height: 14.h,
      child: Row(
        children: [
          Container(
            height: 14.h,
            padding: EdgeInsets.only(left: 3.w, right: 2.w),
            child: Text(
              title,
              style: TextStyle(fontSize: 10.sp, color: CottiColor.primeColor),
            ),
          ),
          if(content!='')Container(
            width: 1.w,
            height: 8.h,
            color:CottiColor.primeColor
          ),
          if(content!='')Container(
            height: 14.h,
            padding: EdgeInsets.only(left: 3.w, right: 2.w),
            child: Text(
              content,
              style: TextStyle(fontSize: 10.sp, color: CottiColor.primeColor),
            ),
          ),
        ],
      ),
    );
  }
}
