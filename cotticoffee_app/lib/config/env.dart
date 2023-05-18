import 'dart:io';
import 'package:cotticommon/cotticommon.dart';
import 'env_config.dart';

/// @Date:2021/11/18
/// @Author: xingguo.lei@abite.com
/// @Description: 环境参数
class Env {
  /// flutter run --dart-define=ENV=debug,test,prod
  /// 多渠道打包
  static const _env = String.fromEnvironment('ENV', defaultValue: EnvConfig.debug);
  static const String keyEnv = "key_env";

  static EnvConfig get currentEnvConfig => _currentEnvConfig();

  static EnvConfig _currentEnvConfig() {
    String cacheEnv = SpUtil.getString(keyEnv);
    String currentEnv = _env;
    if (currentEnv != EnvConfig.prod && cacheEnv.isNotEmpty) {
      currentEnv = cacheEnv;
    }
    switch (currentEnv) {
      case EnvConfig.test:
        return _testConfig;
      case EnvConfig.pre:
        return _preConfig;
      case EnvConfig.prod:
        return _prodConfig;
      default:
        return _devConfig;
    }
  }

  static final EnvConfig _devConfig = EnvConfig(
    envName: EnvConfig.debug,
    baseUrl: "https://gatewaydev.abite.com",
    pushAppKey: "698a5e6a9ec92944b12bd9d9",
    h5: 'https://mdev.cotticoffee.com',
    ak: Platform.isAndroid
        ? 'TwVqNNg89OV22pwiXnHD6NHVHSGXN37Y'
        : 'XC7QWEuBR42qVdfXXg8Xyb7fXsrUJzNa',
    sk: Platform.isAndroid
        ? 'ZrZkRRQIxwFRCCMjChvJZztOIfAm2i96'
        : 'Zca3CZZGScXaGFH3Stg6WOOEQIwB9sj3',
  );

  static final EnvConfig _testConfig = EnvConfig(
    envName: EnvConfig.test,
    baseUrl: "https://gatewaytest1.abite.com",
    pushAppKey: "698a5e6a9ec92944b12bd9d9",
    h5: 'https://mtest1.cotticoffee.com',
    ak: Platform.isAndroid
        ? 'TwVqNNg89OV22pwiXnHD6NHVHSGXN37Y'
        : 'XC7QWEuBR42qVdfXXg8Xyb7fXsrUJzNa',
    sk: Platform.isAndroid
        ? 'ZrZkRRQIxwFRCCMjChvJZztOIfAm2i96'
        : 'Zca3CZZGScXaGFH3Stg6WOOEQIwB9sj3',
  );

  static final EnvConfig _preConfig = EnvConfig(
    envName: EnvConfig.pre,
    baseUrl: "https://gatewaypre.abite.com",
    pushAppKey: "698a5e6a9ec92944b12bd9d9",
    h5: 'https://mpre.cotticoffee.com',
    ak: Platform.isAndroid
        ? 'wpFNVduyNLSCUdABYBxJiXcReYv43TXx'
        : '4rlqsDxzjKBY9lP71L8WPTSierZ0Ji6C',
    sk: Platform.isAndroid
        ? '62NwEDb6D3H55hRgixr6VGalUjEciecb'
        : 'a77prqcthoJvau7v6RyHMqIQYkpgjUXB',
  );

  static final EnvConfig _prodConfig = EnvConfig(
    envName: EnvConfig.prod,
    baseUrl: "https://gateway.abite.com",
    h5: 'https://m.cotticoffee.com',
    isDebug: false,
    ak: Platform.isAndroid
        ? 'Z6LQq2lK66imIKHAcNY9SkZEkk5Hs519'
        : '5KG7TCGwtRFuTJSnnDVswSaUe9lriIvA',
    sk: Platform.isAndroid
        ? 'gqaPpGrN1MCK3fVY4Vfoym65YkwO4vJL'
        : 'hua0UXMDsmkYSGzUDuTTMwkLvUZNzolZ',
  );
}
