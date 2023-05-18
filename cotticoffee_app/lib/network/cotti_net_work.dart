import 'dart:io';

import 'package:cotti_client/config/env.dart';
import 'package:cotti_client/config/env_config.dart';
import 'package:cotti_client/network/cotti_net_work_config.dart';
import 'package:cotti_client/network/interceptor/login_header_interceptor.dart';
import 'package:cotti_client/pages/tabs/mine/setting/virtual_settings.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/network/interface/network_config.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/8/30 5:58 下午
class CottiNetWork extends CottiHttpClient {
  static CottiNetWork? _instance;
  static bool isSetProxy = false;

  CottiNetWork._();

  factory CottiNetWork() {
    _instance ??= CottiNetWork._();
    setProxy();
    return _instance!;
  }

  @override
  List<Interceptor> get interceptors => [LoginHeaderInterceptor()];

  @override
  NetWorkConfig get networkConfig => CottiNetWorkConfig();

  static setProxy() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String ip = sharedPreferences.getString(VirtualSettings.keyIp) ?? '';
    String port = sharedPreferences.getString(VirtualSettings.keyPort) ?? '';
    if (ip.isEmpty ||
        port.isEmpty ||
        Env.currentEnvConfig.envName == EnvConfig.prod ||
        isSetProxy) {
      return;
    }
    isSetProxy = true;
    (_instance?.dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.findProxy = (uri) {
        return 'PROXY $ip:$port';
      };
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    };
  }
}
