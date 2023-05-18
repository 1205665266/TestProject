import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_head.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/17 10:40
class FirstHead extends StatefulWidget {
  final MenuHead? menuHead;

  const FirstHead({Key? key, required this.menuHead}) : super(key: key);

  @override
  State<FirstHead> createState() => _FirstHeadState();
}

class _FirstHeadState extends State<FirstHead> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringUtil.removeWrap(widget.menuHead?.headInfo.name),
            style: TextStyle(
              color: CottiColor.textBlack,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          if (widget.menuHead?.headInfo.classifyDesc?.isNotEmpty ?? false)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                widget.menuHead!.headInfo.classifyDesc!.replaceAll(r"\n", "\n").trim(),
                style: TextStyle(
                  color: const Color(0xFF5E6164),
                  fontSize: 12.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
