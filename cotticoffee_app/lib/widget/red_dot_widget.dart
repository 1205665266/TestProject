import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/18 17:58
class RedDotWidget extends StatefulWidget {
  final int count;

  const RedDotWidget({Key? key, required this.count}) : super(key: key);

  @override
  State<RedDotWidget> createState() => _RedDotWidgetState();
}

class _RedDotWidgetState extends State<RedDotWidget> {
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: widget.count < 1,
      child: Container(
        height: 18.w,
        width: widget.count > 99 ? 26.w : 18.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFF9A8F),
          borderRadius: BorderRadius.all(
            Radius.circular(9.r),
          ),
        ),
        child: Text(
          "${widget.count}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
          ),
          strutStyle: const StrutStyle(forceStrutHeight: true),
        ),
      ),
    );
  }
}
