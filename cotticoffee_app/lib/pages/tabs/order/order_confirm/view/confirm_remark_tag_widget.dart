
import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// @ClassName: ConfirmRemarkTagWidget
///
/// @Description: 确认订单备注标签
/// @author: zhangxu
/// @date: 2022-11-23
///
class ConfirmRemarkTagWidget extends StatefulWidget {
  final Function(String) callback;
  final List<String> remarkList;

  const ConfirmRemarkTagWidget(this.remarkList, this.callback, {Key? key}) : super(key: key);

  @override
  State<ConfirmRemarkTagWidget> createState() => _ConfirmRemarkTagWidgetState();
}

class _ConfirmRemarkTagWidgetState extends State<ConfirmRemarkTagWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w, top: 16.h),
          child: Text(
            "快捷输入",
            style: TextStyle(
              fontSize: 12.sp,
              color: CottiColor.textBlack
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16.h),
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            children: widget.remarkList.map((item) {
              return tagWidget(item);
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget tagWidget(String item) {
    return GestureDetector(
      onTap: () {
        if (widget.callback != null) {
          widget.callback(item);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1.r)),
            border: Border.all(width: 1.w, color: CottiColor.primeColor),
            color: CottiColor.primeColor.withOpacity(0.05)
        ),
        child: Text(
          item,
          style: TextStyle(
              fontSize: 12.sp, color: CottiColor.primeColor,
              height: 1,
              leadingDistribution: TextLeadingDistribution.even
          ),
        ),
      ),
    );
  }
}
