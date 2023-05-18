library joymo_app_upgrade;

export 'src/app_upgrade.dart';
export 'src/flutter_upgrade.dart';
export 'src/app_market.dart';
export 'src/download_status.dart';

import 'dart:async';

import 'package:flutter/services.dart';

class JoymoAppUpgrade {
  static const MethodChannel _channel =
      const MethodChannel('joymo_app_upgrade');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
