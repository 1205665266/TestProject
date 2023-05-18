import 'dart:io';

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/upgrade/upgrade_model_entity.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cotti_client/pages/upgrade/src/app_upgrade.dart';
import 'package:cotti_client/pages/upgrade/src/flutter_upgrade.dart';

class UpgradeUtil {
  //提频日期 周期每天
  static String kReminderFrequencyDateEveryDay = 'K_REMINDER_FREQUENCY_DATE_EVERY_DAY';

  //每周提醒一次
  static String kReminderFrequencyDateEveryWeek = 'K_REMINDER_FREQUENCY_DATE_EVERY_WEEK';

  //内测提频版本号
  static String kReminderFrequencyVersionBetaTips = 'K_REMINDER_FREQUENCY_VERSION_BETA_TIPS';

  //弱提醒提频版本号
  static String kReminderFrequencyVersionWeak = 'K_REMINDER_FREQUENCY_VERSION_WEAK';

  //强提醒提频版本号
  static String kReminderFrequencyVersionStrong = 'K_REMINDER_FREQUENCY_VERSION_STRONG';

  void checkUpgrade(BuildContext context) {
    AppUpgrade.showUpgradeDialog(context, checkAppInfo());
  }

  //访问后台接口，这里直接返回新版本信息
  static Future<AppUpgradeInfo> checkAppInfo() async {
    //这里一般访问网络接口，将返回的数据解析成如下格式
    // String name = await DeviceHelper.getDeviceName();

    AppInfo appInfo = await FlutterUpgrade.appInfo;
    List<String> contents = [
      // '1、场景：新功能上线、已有功能做了比较大的优化等场景下',
      // '2、方法：APP弹窗',
      // '3、入口：进入APP页面',
      // '4、操作：用户点击升级，可点击取消跳过该版本',
      // '5、提示频次：用户点击取消后直到下个新版出现之前不会弹出更新提示',
      // '6、更新成功：不展示引导页，保留本地数据，用户登录状态不变'
    ];
    /*
    HttpResponse? httpResponse = await HttpClient.post("/dj-api/ota/checkUpdate",
        params: {
          "currentVersion": Constant.currVersionCode, //int.parse(appInfo.versionName)
          "appChannel": Platform.isAndroid ? 402 : 401,
        },
        errorAutoToast: false);
    if (!httpResponse!.ok) {
      return AppUpgradeInfo(
        isShowUpgrade: false,
        force: false,
        title: '更新提醒',
        subTitle: '版本更新描述：',
        contents: contents,
        okButtonTitle: '立即更新',
        cancelButtonTitle: '跳过该版本',
        apkDownloadUrl: '',
      );
    }
     */
    try {
      var jsData = await CottiNetWork().post("/ota/checkUpdate",
          data: {
            "currentVersion": Constant.currVersionCode, //int.parse(appInfo.versionName)
            "appChannel": Platform.isAndroid ? 902 : 903,
          },
          showToast: false);

      logI('checkUpdate s : $jsData');

      // jsData = '{"forceType":0,"focusVersion":"1.2.0","buildVersion":"1.2.0","msg":"msg消息","address":"https://yummy-common-dev.obs.cn-north-4.myhuaweicloud.com:443/productmanager-admin/productcenter/16630361205077540_1640599555.jpg","md5Sign":"md5Sign","upgradeTime":"2022-11-19","appChannel":1}';

      UpgradeModelEntity response = UpgradeModelEntity.fromJson(jsData);
      if (response.msg != null) {
        contents = response.msg!.split('\n');
      }
      String apkDownloadUrl = response.address ?? '';
      int forceType = response.forceType ?? -1;
      bool shouldShow = await _shouldShowUpgradeWithReminderFrequency(forceType);
      switch (forceType) {
        case -1:
          {
            //没有新版本
            return AppUpgradeInfo(
              isShowUpgrade: false,
              force: false,
              title: '更新提醒',
              subTitle: '版本更新描述：',
              contents: contents,
              okButtonTitle: '立即更新',
              cancelButtonTitle: '跳过该版本',
              apkDownloadUrl: apkDownloadUrl,
            );
          }
        case 0:
          {
            ///弱提示更新
            ///提示频次：用户点击取消后直到下个新版出现之前不会弹出更新提示
            if (shouldShow) {
              /// 本次弹窗提示后 保存下一次应该提示的日期
              _setStringValue(kReminderFrequencyVersionWeak, appInfo.versionCode);
            }
            return AppUpgradeInfo(
              isShowUpgrade: shouldShow,
              force: false,
              title: '更新提醒',
              subTitle: '版本更新描述：',
              contents: contents,
              okButtonTitle: '立即更新',
              cancelButtonTitle: '跳过该版本',
              apkDownloadUrl: apkDownloadUrl,
            );
          }
        case 1:
          {
            ///强提示更新
            ///提示频次：用户点击取消后当天不会再提示，每天提示一次
            if (shouldShow) {
              /// 本次弹窗提示后 保存下一次应该提示的日期
              var now = DateTime.now();
              DateTime tomorrow = now.add(const Duration(days: 1));
              // DateTime tomorrow = now.add(Duration(minutes: 5));
              _setStringValue(kReminderFrequencyDateEveryDay, tomorrow.toString());
              _setStringValue(kReminderFrequencyVersionStrong, appInfo.versionCode);
            }
            return AppUpgradeInfo(
              isShowUpgrade: shouldShow,
              force: false,
              title: '更新提醒',
              subTitle: '版本更新描述：',
              contents: contents,
              okButtonTitle: '立即更新',
              cancelButtonTitle: '下次再说',
              apkDownloadUrl: apkDownloadUrl,
            );
          }
        case 2:
          {
            ///强制更新
            return AppUpgradeInfo(
              isShowUpgrade: true,
              force: true,
              title: '更新提醒',
              subTitle: '版本更新描述：',
              contents: contents,
              okButtonTitle: '立即更新',
              cancelButtonTitle: '下次再说',
              apkDownloadUrl: apkDownloadUrl,
            );
          }
        case 3:
          {
            ///自测公测提示
            ///提示频次：用户点击取消后未来一周内不会弹出更新提示
            if (shouldShow) {
              /// 本次弹窗提示后 保存下一次应该提示的日期
              var now = DateTime.now();
              DateTime nextWeek = now.add(const Duration(days: 7));
              _setStringValue(kReminderFrequencyDateEveryWeek, nextWeek.toString());
              _setStringValue(kReminderFrequencyVersionBetaTips, appInfo.versionCode);
            }
            return AppUpgradeInfo(
              isShowUpgrade: shouldShow,
              force: false,
              title: '库迪咖啡邀您参与内测',
              titleFont: 24.sp,
              bgColorWidgetWidth: 242.w,
              subTitle: '内测版本：',
              contents: contents,
              okButtonTitle: '安装',
              cancelButtonTitle: '取消',
              apkDownloadUrl: apkDownloadUrl,
            );
          }
        default:
          return AppUpgradeInfo(
            isShowUpgrade: false,
            force: false,
            title: '更新提醒',
            subTitle: '版本更新描述：',
            contents: contents,
            okButtonTitle: '立即更新',
            cancelButtonTitle: '跳过该版本',
            apkDownloadUrl: '',
          );
      }
    } catch (error) {
      logI('checkUpdate error :$error');
      return AppUpgradeInfo(
        isShowUpgrade: false,
        force: false,
        title: '更新提醒',
        subTitle: '版本更新描述：',
        contents: contents,
        okButtonTitle: '立即更新',
        cancelButtonTitle: '跳过该版本',
        apkDownloadUrl:
            "https://yummy-common-dev.obs.cn-north-4.myhuaweicloud.com:443/productmanager-admin/productcenter/16630361205077540_1640599555.jpg",
      );
    }
  }

  //本地检查时候需要显示升级弹窗
  static Future<bool> _shouldShowUpgradeWithReminderFrequency(int forceType) async {
    var now = DateTime.now();
    AppInfo appInfo = await FlutterUpgrade.appInfo;
    switch (forceType) {
      case -1:
        {
          //没有新版本
          return false;
        }
      case 0:
        {
          String localVersionWeak = await _getStringValue(kReminderFrequencyVersionWeak);

          ///弱提示更新
          ///提示频次：用户点击取消后直到下个新版出现之前不会弹出更新提示

          //更新完版本后，新版本提示一次
          if (localVersionWeak != appInfo.versionCode) {
            return true;
          }
          return false;
        }
      case 1:
        {
          ///强提示更新
          ///提示频次：用户点击取消后当天不会再提示，每天提示一次
          String localTomorrow = await _getStringValue(kReminderFrequencyDateEveryDay);

          String localVersionStrong = await _getStringValue(kReminderFrequencyVersionStrong);
          if (localTomorrow == '') {
            return true;
          }
          //更新完版本后，新版本提示一次
          if (localVersionStrong != appInfo.versionCode) {
            return true;
          }

          DateTime localTomorrowDate = DateTime.parse(localTomorrow);

          if (now.isAfter(localTomorrowDate)) {
            return true;
          }

          return false;
        }
      case 2:
        {
          ///强制更新
          return true;
        }
      case 3:
        {
          ///自测公测提示
          ///提示频次：用户点击取消后未来一周内不会弹出更新提示
          DateTime nextWeek = now.add(const Duration(days: 7));
          String localNextWeek = await _getStringValue(kReminderFrequencyDateEveryWeek);
          String localVersionBetaTips = await _getStringValue(kReminderFrequencyVersionBetaTips);
          if (localNextWeek == '') {
            return true;
          }
          //更新完版本后，新版本提示一次
          if (localVersionBetaTips != appInfo.versionCode) {
            return true;
          }

          DateTime localTomorrowDate = DateTime.parse(localNextWeek);

          if (now.isAfter(localTomorrowDate)) {
            return true;
          }

          return false;
        }
      default:
        return false;
    }
  }

  /// 保存
  ///
  static Future<bool> _setStringValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  /// 获取
  static Future<String> _getStringValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key) ?? "";
    return value;
  }

  static bool haveNewVersion(String newVersion, String old) {
    if (newVersion.isEmpty || old.isEmpty) {
      return false;
    }
    //移除空格
    newVersion = newVersion.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    old = old.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    int newVersionInt, oldVersion;
    var newList = newVersion.split('.');
    var oldList = old.split('.');
    if (newList.isEmpty || oldList.isEmpty) {
      return false;
    }
    for (int i = 0; i < newList.length; i++) {
      newVersionInt = int.parse(newList[i]);
      oldVersion = int.parse(oldList[i]);
      if (newVersionInt > oldVersion) {
        return true;
      } else if (newVersionInt < oldVersion) {
        return false;
      }
    }

    return false;
  }
}
