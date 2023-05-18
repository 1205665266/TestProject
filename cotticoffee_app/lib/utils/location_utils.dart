import 'dart:async';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationUtils {
  static StreamSubscription<Map<String, Object>>? _locationListener;
  static final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();

  ///开始高德定位数据
  static _startGDLocation() {
    /// 合规协议
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);
    AMapFlutterLocation.setApiKey(Constant.androidMapKey, Constant.iosMapKey);
    if (Platform.isIOS) {
      requestAccuracyAuthorization();
    }
    _locationListener = _locationPlugin.onLocationChanged().listen(null);
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  ///开始定位
  static Future startLocation() async {
    Completer completer = Completer();
    bool hasLocationPermission = await requestLocationPermission();
    logI('当前定位权限：$hasLocationPermission');
    try {
      if (_locationListener == null) {
        _startGDLocation();
      } else {
        _setLocationOption();
        _locationPlugin.startLocation();
      }
      _locationListener?.onData((data) {
        completer.complete(data);
      });
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  ///停止定位
  static void _stopLocation() {
    _locationPlugin.stopLocation();
  }

  ///移除定位
  static void disposeLocation() {
    ///高德
    _stopLocation();

    ///移除定位监听
    if (_locationListener != null) {
      _locationListener!.cancel();
      _locationListener == null;
    }

    ///销毁定位
    _locationPlugin.destroy();
  }

  ///设置定位参数
  static void _setLocationOption() {
    AMapLocationOption locationOption = AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = true;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 500;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.HundredMeters;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  ///获取iOS native的accuracyAuthorization类型
  static void requestAccuracyAuthorization() async {
    AMapAccuracyAuthorization currentAccuracyAuthorization =
        await _locationPlugin.getSystemAccuracyAuthorization();
    if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
      logI("精确定位类型");
    } else if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
      logI("模糊定位类型");
    } else {
      logI("未知定位类型");
    }
  }

  /// 申请定位权限 授予定位权限返回true， 否则返回false
  static Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //如果用户拒绝了授权 不去请求权限
      if (!SpUtil.getBool('location_permission_denied')) {
        //用户没用拒接，发起一次申请
        status = await Permission.location.request();

        if (status == PermissionStatus.granted) {
          return true;
        } else {
          SpUtil.putBool('location_permission_denied', true);
          SpUtil.putBool('android_location_denied', true);
          return false;
        }
      } else {
        return false;
      }
    }
  }
}
