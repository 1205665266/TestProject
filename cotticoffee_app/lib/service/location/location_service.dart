import 'dart:async';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/config/env.dart';
import 'package:cotti_client/config/env_config.dart';
import 'package:cotti_client/pages/tabs/mine/setting/virtual_settings.dart';
import 'package:cotti_client/service/location/location_result.dart';
import 'package:cotti_client/service/location/position_info_entity.dart';
import 'package:cotti_client/widget/dialog/common_dialog.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();
  StreamSubscription<Map<String, Object>>? _locationListener;
  static LocationService? _instance;
  final String keyFirstLocation = 'keyFirstLocation';

  ///最近一次定位到的数据
  PositionInfoEntity? lastPositionInfo;

  LocationService._();

  factory LocationService() {
    _instance ??= LocationService._();
    return _instance!;
  }

  ///开始定位
  Future<LocationResult> startLocation(BuildContext? context) async {
    Completer<LocationResult> completer = Completer();

    ///如果是android,第一次打开需要先弹窗确认
    if (Platform.isAndroid && SpUtil.getBool(keyFirstLocation, defValue: true)) {
      if (context != null) {
        int result = await CommonDialog.show(
          context,
          isWillPop: true,
          barrierDismissible: false,
          content: '我们想获取您的地址位置权限，以便为您推荐附近门店相关信息，提供配送/自提等服务',
          mainButtonName: '同意',
          subButtonName: '拒绝',
        );
        SpUtil.putBool(keyFirstLocation, false);
        if (result != 1) {
          SpUtil.putBool('location_permission_denied', true);
          completer.complete(LocationResult(12, errMessage: '没有定位权限'));
          return completer.future;
        }
      }
    }
    bool hasLocationPermission = await requestLocationPermission();
    logI('当前定位权限：$hasLocationPermission');
    try {
      if (_locationListener == null) {
        await _startGDLocation();
      } else {
        _locationPlugin.startLocation();
      }
      //监听定位数据回调
      _locationListener?.onData((data) {
        if (!completer.isCompleted) {
          if (data['latitude'] != null && data['longitude'] != null) {
            lastPositionInfo = PositionInfoEntity.fromJson(data);
            if (Env.currentEnvConfig.envName != EnvConfig.prod) {
              String customerLatitude = SpUtil.getString(VirtualSettings.keyCustomerLatitude);
              String customerLongitude = SpUtil.getString(VirtualSettings.keyCustomerLongitude);
              if (customerLatitude.isNotEmpty) {
                double? latitude = double.tryParse(customerLatitude);
                if (latitude != null) {
                  lastPositionInfo?.latitude = latitude;
                }
              }
              if (customerLongitude.isNotEmpty) {
                double? longitude = double.tryParse(customerLongitude);
                if (longitude != null) {
                  lastPositionInfo?.longitude = longitude;
                }
              }
            }
            completer.complete(
              LocationResult(0, positionInfoEntity: lastPositionInfo),
            );
          } else {
            int errorCode = int.tryParse('${data['errorCode']}') ?? -1;
            String errorMessage = "${data['errorInfo']}";
            completer.complete(LocationResult(errorCode, errMessage: errorMessage));
          }
        }
      });
    } catch (e) {
      logE(e);
    }
    return completer.future;
  }

  PositionInfoEntity? get getLastPositionInfo => lastPositionInfo;

  ///停止定位
  void stopLocation() {
    _locationPlugin.stopLocation();
  }

  ///移除定位
  void disposeLocation() {
    ///高德
    stopLocation();

    ///移除定位监听
    if (_locationListener != null) {
      _locationListener!.cancel();
      _locationListener == null;
    }

    ///销毁定位
    _locationPlugin.destroy();
  }

  ///开始高德定位数据
  _startGDLocation() async {
    AMapFlutterLocation.setApiKey(Constant.androidMapKey, Constant.iosMapKey);
    await Future.delayed(const Duration(milliseconds: 200));

    /// 合规协议
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);
    if (Platform.isIOS) {
      requestAccuracyAuthorization();
    }
    _locationListener = _locationPlugin.onLocationChanged().listen(null);
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  ///设置定位参数
  void _setLocationOption() {
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
  void requestAccuracyAuthorization() async {
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
  Future<bool> requestLocationPermission() async {
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
          return false;
        }
      } else {
        return false;
      }
    }
  }
}
