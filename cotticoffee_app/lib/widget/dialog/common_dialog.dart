import 'package:cotti_client/widget/dialog/common_dialog_widget.dart';
import 'package:flutter/material.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/26 19:17
class CommonDialog {
  /// 如果点击了mainButtonName按钮Future返回结果1，
  /// 点击了subButtonName按钮Future返回0，
  /// 点击别的区别导致弹窗消失则返回null
  /// eg:    int? result = await CommonDialog.show(
  ///             context,
  ///             title: "test",
  ///             content: '本店营业时间\n周一至周五 10:00-22:00\n周六至周日 11:00-23:00',
  ///             mainButtonName: '主要操作',
  ///             subButtonName: '次要操作',
  ///           );
  ///           print(">>>>>$result");
  /// [title] 弹窗标题
  /// [mainButtonName] 主操作名称(不传不显示按钮)
  /// [content] 显示的内容
  /// [subButtonName] 次要操作名称(不传不显示按钮)
  /// [barrierDismissible] 触摸非弹窗区域弹窗是否可消失(true 消失，false 不消失，默认false)
  /// [isWillPop] 点击返回按钮或侧滑，弹窗是否可消失 (默认不可侧滑)
  /// [contentChild] 自定义内容区域
  /// [clickButtonCallBack]回调函数为空，则直接关闭弹窗
  /// [coverBackground] 是否覆盖背景，默认不覆盖
  static Future show(
    BuildContext context, {
    String? title,
    String? content,
    String? mainButtonName,
    String? subButtonName,
    Color? subButtonColor,
    Widget? contentChild,
    double contentTextHeight = 1.3,
    bool barrierDismissible = false,
    bool isWillPop = true,
    Function(int)? clickButtonCallBack,
    bool coverBackground = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      useSafeArea: false,
      builder: (BuildContext context) {
        Widget widget = CommonDialogWidget(
          title: title,
          content: content,
          contentTextHeight: contentTextHeight,
          mainButtonName: mainButtonName,
          subButtonName: subButtonName,
          subButtonColor: subButtonColor,
          contentChild: contentChild,
          clickButtonCallBack: clickButtonCallBack,
          coverBackground: coverBackground,
        );
        if (isWillPop) {
          widget = WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: widget,
          );
        }
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          child: widget,
        );
      },
    );
  }
}
