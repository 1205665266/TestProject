import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// ////////////////////////////////////////////
/// @Author: Jianzhong Cai
/// @Date: 2022/3/1 下午3:16
/// @Email: jianzhong.cai@ucarinc.com
/// @Description:
/// /////////////////////////////////////////////

/// Default choice item widget
class EvaluateC2Chip<T> extends StatelessWidget {
  /// choice item data
  final C2Choice<T> data;

  /// unselected choice style
  final C2ChoiceStyle style;

  /// selected choice style
  final C2ChoiceStyle activeStyle;

  /// label widget
  final Widget? label;

  /// avatar widget
  final Widget? avatar;

  /// default constructor
  const EvaluateC2Chip({
    Key? key,
    required this.data,
    required this.style,
    required this.activeStyle,
    this.label,
    this.avatar,
  }) : super(key: key);

  /// get shape border
  static OutlinedBorder getShapeBorder({
    required Color color,
    double? width,
    BorderRadiusGeometry? radius,
    BorderStyle? style,
  }) {
    final BorderSide side = BorderSide(
        color: color, width: width ?? 1.0, style: style ?? BorderStyle.solid);
    return radius == null
        ? StadiumBorder(side: side)
        : RoundedRectangleBorder(
            borderRadius: radius,
            side: side,
          );
  }

  /// get shape border
  static OutlinedBorder getAvatarShapeBorder({
    required Color color,
    double? width,
    BorderRadiusGeometry? radius,
    BorderStyle? style,
  }) {
    final BorderSide side = BorderSide(
        // color: color != null ? color : const Color(0xFF000000),
        width: width ?? 1.0,
        style: style ?? BorderStyle.none);
    return radius == null
        ? CircleBorder(side: side)
        : RoundedRectangleBorder(
            borderRadius: radius,
            side: side,
          );
  }

  /// default border opacity
  static const double defaultBorderOpacity = .2;

  @override
  Widget build(BuildContext context) {
    final C2ChoiceStyle effectiveStyle = data.selected ? activeStyle : style;

    final bool isDark = effectiveStyle.brightness == Brightness.dark;

    final Color? textColor =
        isDark ? const Color(0xFFFFFFFF) : effectiveStyle.color;

    final Color? checkMarkColor = isDark ? textColor : activeStyle.color;

    final Color? backgroundColor =
        isDark ? const Color(0x00000000) : style.color;

    final Color? selectedBackgroundColor =
        isDark ? const Color(0x00000000) : activeStyle.color;

    return Padding(
      padding: effectiveStyle.margin != null
          ? effectiveStyle.margin!
          : const EdgeInsets.symmetric(vertical: 4),
      child: RawChip(
        padding: effectiveStyle.padding,
        label: label ?? Text(data.label),
        labelStyle:
            TextStyle(color: textColor).merge(effectiveStyle.labelStyle),
        labelPadding: effectiveStyle.labelPadding,
        avatar: avatar,
        avatarBorder: effectiveStyle.avatarBorderShape ??
            getAvatarShapeBorder(
              color: const Color(0xFF000000),
              width: effectiveStyle.avatarBorderWidth,
              radius: effectiveStyle.avatarBorderRadius,
              style: effectiveStyle.avatarBorderStyle,
            ),
        tooltip: data.tooltip,
        shape: effectiveStyle.borderShape,
        clipBehavior: effectiveStyle.clipBehavior ?? Clip.none,
        elevation: effectiveStyle.elevation ?? 0,
        pressElevation: effectiveStyle.pressElevation ?? 0,
        shadowColor: style.color,
        selectedShadowColor: activeStyle.color,
        backgroundColor: backgroundColor,
        selectedColor: selectedBackgroundColor,
        checkmarkColor: checkMarkColor,
        showCheckmark: effectiveStyle.showCheckmark,
        materialTapTargetSize: effectiveStyle.materialTapTargetSize,
        disabledColor:
            effectiveStyle.disabledColor ?? Colors.blueGrey.withOpacity(.1),
        isEnabled: data.disabled != true,
        selected: data.selected,
        onSelected: (_selected) =>
            data.select != null ? data.select!(_selected) : null,
      ),
    );
  }
}
