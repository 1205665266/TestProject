import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// @ClassName: PrivacyMixin
///
/// @Description: 隐私协议
/// @author: hongtao.li@abite.com
/// @date: 2021-08-10
///
class PrivacyUtil {
  ///是否是首次启动
  static Future<bool> isFirstLaunched() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agreeDateString = prefs.getString('KStoreAgreePrivacy');
    return agreeDateString?.isEmpty ?? true;
  }

  static Future<bool> saveFirstLaunched() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("KStoreAgreePrivacy", "false");
  }
}
