import 'dart:ui';

import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/11 2:27 PM

class StringUtil {
  static String mobilePhoneEncode(String? mobilePhone) {
    if (mobilePhone != null && mobilePhone.length >= 11) {
      return mobilePhone.replaceRange(3, 7, '****');
    }
    return mobilePhone ?? '';
  }

  static String removeWrap(String? oldString) {
    return oldString?.replaceAll(r'\n', '').trim() ?? '';
  }

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static Color? colorParse(String? color) {
    try {
      int? value = int.tryParse(color?.replaceAll("#", "0xFF") ?? '');
      if (value == null) {
        return null;
      }
      return Color(value);
    } catch (e) {
      return null;
    }
  }

  static String decimalParse(dynamic source) {
    Decimal? result = Decimal.tryParse("$source");
    if (result == null) {
      return "";
    } else {
      return result.toString();
    }
  }

  static bool checkChinaPhoneNumber(String input) {
    if (input.isEmpty) {
      return false;
    }
    //手机正则验证
    String regexPhoneNumber = "^(1[0-9])\\d{9}\$";
    // "^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$";

    return RegExp(regexPhoneNumber).hasMatch(input);
  }
}
