import 'package:cotti_client/global/style.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/6 16:46
class CommonDialogWidget extends StatefulWidget {
  final String? title;
  final String? content;
  final double contentTextHeight;
  final String? mainButtonName;
  final String? subButtonName;
  final Color? subButtonColor;
  final Widget? contentChild;
  final Function(int)? clickButtonCallBack;
  final bool coverBackground;

  const CommonDialogWidget(
      {Key? key,
      this.title,
      this.content,
      this.mainButtonName,
      this.subButtonName,
        this.subButtonColor,
      this.contentChild,
      this.clickButtonCallBack,
      this.coverBackground = false,
      this.contentTextHeight = 1})
      : super(key: key);

  @override
  State<CommonDialogWidget> createState() => _CommonDialogWidgetState();
}

class _CommonDialogWidgetState extends State<CommonDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.coverBackground) Container(color: Colors.white),
        if (widget.coverBackground) Container(color: Colors.black.withOpacity(0.55)),
        Container(
          width: 295.w,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              _buildContent(),
              _buildBottom(),
            ],
          ),
        ),
      ],
    );
  }

  _buildTitle() {
    return Visibility(
      visible: widget.title?.isNotEmpty ?? false,
      child: Padding(
        padding: EdgeInsets.only(top: 16.h),
        child: Text(
          widget.title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: CottiColor.textBlack,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  _buildContent() {
    if (widget.contentChild != null) {
      return widget.contentChild;
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: Text(
        (widget.content ?? '').replaceAll(r"\n", "\n"),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
          height: widget.contentTextHeight,
          color: CottiColor.textBlack,
        ),
      ),
    );
  }

  _buildBottom() {
    return Visibility(
      visible: widget.mainButtonName != null || widget.subButtonName != null,
      child: Container(
        margin: EdgeInsets.only(bottom: 18.h),
        child: Row(
          children: [
            if (widget.subButtonName != null)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (widget.clickButtonCallBack == null) {
                      NavigatorUtils.pop(context, result: 0);
                    } else {
                      widget.clickButtonCallBack!(0);
                    }
                  },
                  child: Container(
                    height: 43.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.r)),
                      border: Border.all(width: 0.5.w, color: widget.subButtonColor ?? CottiColor.textGray),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.subButtonName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.subButtonColor ?? CottiColor.textGray,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            Visibility(
              visible: widget.mainButtonName != null && widget.subButtonName != null,
              child: SizedBox(width: 9.w),
            ),
            if (widget.mainButtonName != null)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (widget.clickButtonCallBack == null) {
                      NavigatorUtils.pop(context, result: 1);
                    } else {
                      widget.clickButtonCallBack!(1);
                    }
                  },
                  child: Container(
                    height: 43.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CottiColor.primeColor,
                      borderRadius: BorderRadius.all(Radius.circular(4.r)),
                    ),
                    child: Text(
                      widget.mainButtonName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
