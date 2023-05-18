import 'dart:io';

import 'package:abitelogin/pages/login/view/one_key_login_helper.dart';
import 'package:cotti_client/app.dart';
import 'package:cotti_client/config/env.dart';
import 'package:cotti_client/config/env_config.dart';
import 'package:cotti_client/service/push/jpush_wrapper.dart';
import 'package:cotti_client/utils/share_util.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
import 'package:yummy_sm/yummy_sm.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/8 4:51 PM
class InitPlatform {
  static Future<void> initPlatform() async {
    _initShanyan();
    _initSM();
    await ShareUtil.init().catchError((error) {});
    JPushWrapper().initJPush(
        CottiCoffeeApp.routeObserver.navigator!.context, Env.currentEnvConfig.pushAppKey);
    await sensorsInit();
    await Future.delayed(const Duration(milliseconds: 150));
  }

  static _initShanyan() {
    late String appId;
    if (Platform.isIOS) {
      appId = "vQnHVrdl";
    } else if (Platform.isAndroid) {
      appId = "KV3ozSCU";
    }
    // 初始化一键登录并预取号
    OneKeyLoginHelper.initAndGetPhoneInfo(appId);
  }

  static void _initSM() async {
    Map<String, String> params = {};
    params['organization'] = 'IH2cjvXHK5XcgcPEGxLF';
    params['appId'] = 'com.cotticoffee.cotticlient';
    if (Platform.isAndroid) {
      params['publicKey'] =
          'MIIDLzCCAhegAwIBAgIBMDANBgkqhkiG9w0BAQUFADAyMQswCQYDVQQGEwJDTjELMAkGA1UECwwCU00xFjAUBgNVB'
          'AMMDWUuaXNodW1laS5jb20wHhcNMjMwMjE2MDMwMDIyWhcNNDMwMjExMDMwMDIyWjAyMQswCQYDVQQGEwJDTj'
          'ELMAkGA1UECwwCU00xFjAUBgNVBAMMDWUuaXNodW1laS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggE'
          'KAoIBAQCCBMvMFfbeygTzhfuBG7ap6qCgh29cvwzD2cLguw+Sbuw8SUXHczxdIvrbuXd/DpiETzwYl6zUoy+K'
          'dHNV4+u1D/w3ZwuK6UHMr2HLlLslBGvWsvo3AoQt57SfZi0AIc1WcGJ3cKaI2WUYOz2ArlpqETrRkhsK39Cqn'
          'PPdASsfe94ubLio/97JqKpBxfYoEt0dUpZ3RppwH6ymuNSPtXzA6So0ZKhxISWfM41WaWYa3IH2f1zaMeiFB0'
          '3ghhEBOwjxqAq/Fv6Kx52ZgsBguBcL2LHlf672oc36dF8wSB0BDBNmL8n4PtImZ1n3/f76yYVlxusQEfmIWll'
          'qQ5qmuSbHAgMBAAGjUDBOMB0GA1UdDgQWBBScal4aMoThGBi6BsIAFGjiiVbyqzAfBgNVHSMEGDAWgBScal4a'
          'MoThGBi6BsIAFGjiiVbyqzAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4IBAQBfqC0qTUDhGK18sYQ8I'
          'VRGJicaPC2rWjPcSX/3vgoW9lxN75NjsrZ38NBy0ti6qj/zpmSGKQfqBRW5RXNWzUrAXgxu5A4E5ewBAEjazj'
          'RhfAk3zOm5XnBJJtjP2rNkJCJIi5fMBqGOLd5sgW5GiGZ7i8O6CH8c1IpGU3Ft0Ze2f3trY10vtFDGWkKYRFE'
          '8XedeCeESD0jovw52H6QzW2V6OpcEocKwEVnZf/iqLG+xkW7kPQrQWC9VBLtp9yoWbrggqQVRJt3MpE2iGIdN'
          'Ce1qfb1s4TzeD3V9vxB0Wj4wW+/Bm/Dg8ueHqPMByGIRU0+eCkBBvkDJRt2xTYU6uCAl';
    } else {
      params['publicKey'] = 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCjiItXqjibnOJ2JMy3S/EjBJ+fFkqy1o'
          'ziZO2SG0oiNgnTNDEdEa1vHLnarLUtX2lTJnmik8EbhQ5eYRL5J1MeIQRcIyTND/cDQC262oNNKNxiG5nUuWWnpE'
          'up4oENGLd11l7N56XtZb+9wiNVXLiuKH/vKSaPERedD5WosQIiSQIDAQAB';
    }
    YummySm.initSM(params);
  }

  static Future<void> sensorsInit() {
    return SensorsAnalyticsFlutterPlugin.init(
      serverUrl: Env.currentEnvConfig.envName == EnvConfig.prod
          ? "https://access.abite.com/sa?project=cotticoffee"
          : "https://access.abite.com/sa?project=cotticoffee_test",
      autoTrackTypes: <SAAutoTrackType>{
        SAAutoTrackType.APP_START,
        SAAutoTrackType.APP_VIEW_SCREEN,
        SAAutoTrackType.APP_CLICK,
        SAAutoTrackType.APP_END
      },
      flushInterval: 30000,
      enableLog: false,
      javaScriptBridge: true,
      visualized: VisualizedConfig(autoTrack: true, properties: true),
      android:
          AndroidConfig(maxCacheSize: 32 * 1024 * 1024, jellybean: true, subProcessFlush: true),
      ios: IOSConfig(maxCacheSize: 10000),
    );
  }
}
