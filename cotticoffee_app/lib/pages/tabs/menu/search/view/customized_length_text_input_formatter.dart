import 'package:flutter/services.dart';

/// FileName: customized_length_text_input_formatter
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/29
class CustomizedTextInputFormatter extends TextInputFormatter {
  final Pattern filterPattern;

  CustomizedTextInputFormatter({required this.filterPattern});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.isComposingRangeValid) return newValue;
    return FilteringTextInputFormatter.allow(filterPattern).formatEditUpdate(oldValue, newValue);
  }
}

/// 自定义兼容中文拼音输入法长度限制输入框
class CustomizedLengthTextInputFormatter extends TextInputFormatter {
  final int maxLength;

  CustomizedLengthTextInputFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.isComposingRangeValid) return newValue;
    return LengthLimitingTextInputFormatter(maxLength).formatEditUpdate(oldValue, newValue);
  }
}
