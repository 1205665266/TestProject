import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/2/16 10:15
class RuleDialog extends StatefulWidget {
  final String title;
  final String content;

  const RuleDialog({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  State<RuleDialog> createState() => _RuleDialogState();

  static Future show(BuildContext context, String title, String content) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return RuleDialog(title: title, content: content);
      },
    );
  }
}

class _RuleDialogState extends State<RuleDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 200.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(context),
            _buildContent(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
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
              widget.title,
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
        widget.content.replaceAll(r'\n', '\n'),
        style: TextStyle(
          color: CottiColor.textBlack,
          fontSize: 14.sp,
        ),
        strutStyle: const StrutStyle(
          height: 1.8,
          forceStrutHeight: true,
        ),
      ),
    );
  }
}
