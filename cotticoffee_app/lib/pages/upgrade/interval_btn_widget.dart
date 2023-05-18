import 'package:flutter/material.dart';

///
/// @description:
/// @author :zhangmeng
/// @create :2021-08-10 17:17:00
///

/// 示例 注意：实现该方法需要屏蔽掉你组件的交互事件
// IntervalBtn(
//     child:RoundedTextButton(text: "重复点击",bgColor: Color(0xFFE53222),textColor: Colors.white),
//     padding: EdgeInsets.all(0),
//     disabledColor: Colors.transparent,
//     highlightColor: Colors.transparent,
//     hoverColor: Colors.transparent,
//     focusColor: Colors.transparent,
//     splashColor: Colors.transparent,
//     voidCallback: (){
//     }
//     ),

//定义枚举类型点击类型
// enum ClickType {
//   Level1,//延时操作可点击
//   Level2,//自己控制
//
// }

/// 按钮 500 毫秒内 不能 多次点击
class IntervalBtn extends StatefulWidget {
  const IntervalBtn({
    Key? key,
    required this.child,
    required this.voidCallback,
    this.onHighlightChanged,
    this.textTheme,
    this.textColor,
    this.disabledTextColor,
    this.color,
    this.disabledColor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.colorBrightness,
    this.padding,
    this.visualDensity,
    this.shape,
    this.focusNode,
    this.materialTapTargetSize,
    this.milliseconds = 500,
  }) : super(key: key);

  final Widget? child;

  // final ClickType clickType;
  final VoidCallback voidCallback;
  final ValueChanged<bool>? onHighlightChanged;
  final ButtonTextTheme? textTheme;
  final Color? textColor;
  final Color? disabledTextColor;
  final Color? color;
  final Color? disabledColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor; //高亮颜色
  final Color? splashColor; //点击颜色
  final Brightness? colorBrightness; //暗黑模式颜色
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;
  final ShapeBorder? shape;
  final Clip clipBehavior = Clip.none;
  final FocusNode? focusNode;
  final bool autofocus = false;
  final MaterialTapTargetSize? materialTapTargetSize;
  final int milliseconds;

  @override
  _IntervalBtnState createState() => _IntervalBtnState();
}

class _IntervalBtnState extends State<IntervalBtn> {
  bool _isCan = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isCan = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: () => _buttonClick(),
        child: widget.child!,
        textTheme: widget.textTheme,
        textColor: widget.textColor,
        disabledTextColor: widget.disabledTextColor,
        color: widget.color,
        disabledColor: widget.disabledColor,
        focusColor: widget.focusColor,
        hoverColor: widget.hoverColor,
        highlightColor: widget.highlightColor,
        splashColor: widget.splashColor ?? Colors.transparent,
        colorBrightness: widget.colorBrightness,
        padding: widget.padding,
        visualDensity: widget.visualDensity,
        shape: widget.shape,
        clipBehavior: widget.clipBehavior,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        materialTapTargetSize: widget.materialTapTargetSize,
      ),
    );
  }

  /// 按钮点击事件
  _buttonClick() {
    if (_isCan) {
      widget.voidCallback();
      _isCan = false;

      // 500 毫秒内 不能多次点击
      Future.delayed(Duration(milliseconds: widget.milliseconds), () {
        _isCan = true;
      });
    }
  }
}
