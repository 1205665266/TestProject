import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:cotti_client/utils/scheme_dispatcher.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// FileName: jpush_wrapper
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/2
class JPushWrapper {
  static JPushWrapper? _instance;
  static const String keyRegistrationID = "JG_RegistrationID";
  final JPush _jPush = JPush();
  bool isLaunchApp = false;

  JPushWrapper._internal() {
    _instance = this;
  }

  factory JPushWrapper() => _instance ?? JPushWrapper._internal();

  void clear() {
    _jPush.clearAllNotifications();
  }

  void initJPush(BuildContext context, String appKey) {
    try {
      _jPush.addEventHandler(onReceiveNotification: (Map<String, dynamic> message) async {
        logD('onReceiveNotification:$message');
      }, onOpenNotification: (Map<String, dynamic> message) async {
        logD('onOpenNotification:$message');
        if (isLaunchApp) {
          goUrl(context, message);
        }
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        logD('onReceiveMessage:$message');
      }, onReceiveNotificationAuthorization: (Map<String, dynamic> message) async {
        logD('onReceiveNotificationAuthorization:$message');
      });
    } on PlatformException {
      logE("Failed to get platform version.");
    }
    _jPush.setup(
      appKey: appKey,
      channel: "developer-default",
      production: false,
      debug: true,
    );
    _jPush.getRegistrationID().then((value) {
      SpUtil.putString(keyRegistrationID, value);
      SensorsAnalyticsFlutterPlugin.profilePushId("jiguang_id", value);
      _jPush.setBadge(0);
    });
    _jPush.applyPushAuthority(const NotificationSettingsIOS(sound: true, alert: true, badge: true));
  }

  void launchAppNotification(BuildContext context) {
    isLaunchApp = true;
    _jPush.getLaunchAppNotification().then((value) => goUrl(context, value));
  }

  void goUrl(BuildContext context, Map<dynamic, dynamic> message) {
    if (Platform.isAndroid) {
      if (message['extras'] != null && message['extras'] is Map) {
        String extras = message['extras']['cn.jpush.android.EXTRA'];
        Map<String, dynamic> result = jsonDecode(extras);
        String goUrl = result['goUrl'];
        SchemeDispatcher.dispatchPath(context, goUrl);
        try {
          var properties = {
            "push_title": message['title'],
            "push_content": message['alert'],
            "push_gourl": goUrl
          };
          SensorsAnalyticsFlutterPlugin.track("pushClick", properties);
        } catch (e) {
          logE(e);
        }
      }
    } else if (Platform.isIOS) {
      if (message['goUrl'] != null) {
        String goUrl = message['goUrl'];
        SchemeDispatcher.dispatchPath(context, goUrl);
        try {
          String title = message['aps']['alert']['title'];
          String content = message['aps']['alert']['body'];
          var properties = {"push_title": title, "push_content": content, "push_gourl": goUrl};
          SensorsAnalyticsFlutterPlugin.track("pushClick", properties);
        } catch (e) {
          logE(e);
        }
      }
    }
  }
}
