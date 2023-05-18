import 'dart:async';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';


import 'app_market.dart';
import 'app_upgrade.dart';

class FlutterUpgrade {
  static const MethodChannel _channel =
      MethodChannel('joymo_app_upgrade');

  ///
  /// 获取app信息
  ///
  static Future<AppInfo> get appInfo async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return AppInfo(
        versionName: packageInfo.version,
        versionCode: packageInfo.buildNumber,
        packageName: packageInfo.packageName);
  }


  ///
  /// 获取apk下载路径
  ///
  static Future<String> get apkDownloadPath async {
    return await _channel.invokeMethod('getApkDownloadPath');
  }

  ///
  /// Android 安装app
  ///
  static installAppForAndroid(String path) async {
    var map = {'path': path};
    return await _channel.invokeMethod('install', map);
  }

  ///
  /// 跳转到ios app store
  ///
  static toAppStore(String id) async {
    var map = {'id': id};
    return await _channel.invokeMethod('toAppStore', map);
  }

  ///
  /// 获取android手机上安装的应用商店
  ///
  static getInstallMarket({required List<String> marketPackageNames}) async {
    List<String> packageNameList = AppMarket.buildInPackageNameList;
    if (marketPackageNames.isNotEmpty) {
      packageNameList.addAll(marketPackageNames);
    }
    var map = {'packages': packageNameList};
    var result = await _channel.invokeMethod('getInstallMarket', map);
    List<String> resultList = (result as List).map((f) {
      return '$f';
    }).toList();
    return resultList;
  }

  ///
  /// 跳转到应用商店
  ///
  static toMarket({required AppMarketInfo appMarketInfo}) async {
    var map = {
      'marketPackageName':appMarketInfo.packageName,
      'marketClassName': appMarketInfo.className
    };
    return await _channel.invokeMethod('toMarket', map);
  }
}
