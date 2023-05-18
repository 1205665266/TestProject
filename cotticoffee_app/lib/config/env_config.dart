/// FileName: env_config
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/11/29
class EnvConfig {
  ///开发环境
  static const String debug = "debug";

  ///测试环境
  static const String test = "test";

  ///测试环境
  static const String pre = "pre";

  ///正式环境
  static const String prod = "prod";

  ///默认debug模式，在prod时 置为false
  final bool isDebug;

  final String envName;

  ///在此处添加需要区分环境的参数
  final String baseUrl;
  final String pushAppKey;
  final String? h5;
  final String ak;
  final String sk;

  EnvConfig({
    required this.baseUrl,
    required this.envName,
    required this.h5,
    required this.ak,
    required this.sk,
    this.isDebug = true,
    this.pushAppKey = "e834a319864dcf691ba2ed82",
  });
}
