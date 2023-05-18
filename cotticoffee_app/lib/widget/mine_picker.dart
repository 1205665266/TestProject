import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MinePicker extends Picker {
  /// Index of currently selected items
  @override
  late List<int> selecteds;

  /// Picker adapter, Used to provide data and generate widgets
  @override
  late PickerAdapter adapter;

  /// insert separator before picker columns
  @override
  final List<PickerDelimiter>? delimiter;

  @override
  final VoidCallback? onCancel;
  @override
  final PickerSelectedCallback? onSelect;
  @override
  final PickerConfirmCallback? onConfirm;
  @override
  final PickerConfirmBeforeCallback? onConfirmBefore;

  /// When the previous level selection changes, scroll the child to the first item.
  @override
  final changeToFirst;

  /// Specify flex for each column
  @override
  final List<int>? columnFlex;

  @override
  final Widget? title;
  @override
  final Widget? cancel;
  @override
  final Widget? confirm;
  @override
  final String? cancelText;
  @override
  final String? confirmText;

  @override
  final double height;

  /// Height of list item
  @override
  final double itemExtent;

  @override
  final TextStyle? textStyle, cancelTextStyle, confirmTextStyle, selectedTextStyle;
  @override
  final TextAlign textAlign;
  @override
  final IconThemeData? selectedIconTheme;

  /// Text scaling factor
  @override
  final double? textScaleFactor;

  @override
  final EdgeInsetsGeometry? columnPadding;
  @override
  final Color? backgroundColor, headerColor, containerColor;

  /// Hide head
  @override
  final bool hideHeader;

  /// Show pickers in reversed order
  @override
  final bool reversedOrder;

  /// Generate a custom header， [hideHeader] = true
  @override
  final WidgetBuilder? builderHeader;

  /// List item loop
  @override
  final bool looping;

  /// Delay generation for smoother animation, This is the number of milliseconds to wait. It is recommended to > = 200
  @override
  final int smooth;

  @override
  final Widget? footer;

  /// A widget overlaid on the picker to highlight the currently selected entry.
  @override
  final Widget selectionOverlay;

  @override
  final Decoration? headerDecoration;

  @override
  final double magnification;
  @override
  final double diameterRatio;
  @override
  final double squeeze;

  MinePicker(
      {required this.adapter,
      this.delimiter,
      List<int>? selecteds,
      this.height = 150.0,
      this.itemExtent = 28.0,
      this.columnPadding,
      this.textStyle,
      this.cancelTextStyle,
      this.confirmTextStyle,
      this.selectedTextStyle,
      this.selectedIconTheme,
      this.textAlign = TextAlign.start,
      this.textScaleFactor,
      this.title,
      this.cancel,
      this.confirm,
      this.cancelText,
      this.confirmText,
      this.backgroundColor = Colors.white,
      this.containerColor,
      this.headerColor,
      this.builderHeader,
      this.changeToFirst = false,
      this.hideHeader = false,
      this.looping = false,
      this.reversedOrder = false,
      this.headerDecoration,
      this.columnFlex,
      this.footer,
      this.smooth = 0,
      this.magnification = 1.0,
      this.diameterRatio = 1.1,
      this.squeeze = 1.45,
      this.selectionOverlay = const CupertinoPickerDefaultSelectionOverlay(),
      this.onCancel,
      this.onSelect,
      this.onConfirmBefore,
      this.onConfirm})
      : super(
            adapter: adapter,
            delimiter: delimiter,
            selecteds: selecteds,
            height: height,
            itemExtent: itemExtent,
            columnPadding: columnPadding,
            textStyle: textStyle,
            cancelTextStyle: cancelTextStyle,
            confirmTextStyle: confirmTextStyle,
            selectedTextStyle: selectedTextStyle,
            selectedIconTheme: selectedIconTheme,
            textAlign: textAlign,
            textScaleFactor: textScaleFactor,
            title: title,
            cancel: cancel,
            confirm: confirm,
            cancelText: cancelText,
            confirmText: confirmText,
            backgroundColor: backgroundColor,
            containerColor: containerColor,
            headerColor: headerColor,
            builderHeader: builderHeader,
            changeToFirst: changeToFirst,
            hideHeader: hideHeader,
            looping: looping,
            reversedOrder: reversedOrder,
            headerDecoration: headerDecoration,
            columnFlex: columnFlex,
            footer: footer,
            smooth: smooth,
            magnification: magnification,
            diameterRatio: diameterRatio,
            squeeze: squeeze,
            selectionOverlay: selectionOverlay,
            onCancel: onCancel,
            onSelect: onSelect,
            onConfirmBefore: onConfirmBefore,
            onConfirm: onConfirm);

  @override
  Future<T?> showModal<T>(BuildContext context,
      [ThemeData? themeData, bool isScrollControlled = false]) async {
    return await showModalBottomSheet<T>(
        context: context, //state.context,
        isScrollControlled: isScrollControlled,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(5.r),
            color: Colors.white,
            child: makePicker(themeData, true),
          );
        });
  }
}
