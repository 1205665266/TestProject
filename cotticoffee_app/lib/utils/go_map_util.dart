import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtil {
  /// 高德地图
  static Future<bool> gotoAMap(longitude, latitude) async {
    var url =
        '${Platform.isAndroid ? 'android' : 'ios'}amap://route/plan/?sourceApplication=amap&dlat=$latitude&dlon=$longitude&dev=0&style=2';

    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      ToastUtil.show('未检测到高德地图');
      return false;
    }
    await launch(url);
    return true;
  }

  /// 腾讯地图
  static Future<bool> gotoTencentMap(longitude, latitude) async {
    var url =
        'qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=$latitude,$longitude&referer=IXHBZ-QIZE4-ZQ6UP-DJYEO-HC2K2-EZBXJ';
    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      ToastUtil.show('未检测到腾讯地图');
      return false;
    }

    await launch(url);

    return canLaunchUrl;
  }

  /// 百度地图
  static Future<bool> gotoBaiduMap(longitude, latitude) async {
    List<double> result = gdConvertBd(longitude, latitude);
    var url =
        'baidumap://map/direction?destination=${result[1]},${result[0]}&coord_type=bd09ll&mode=driving';

    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      ToastUtil.show('未检测到百度地图~');
      return false;
    }

    await launch(url);

    return canLaunchUrl;
  }

  static List<double> gdConvertBd(longitude, latitude) {
    logI("longitude===>$longitude,latitude===>$latitude");

    var p = pi * 3000.0 / 180.0;
    var x = longitude;
    var y = latitude;

    var z = sqrt(x * x + y * y) + 0.00002 * sin(y * p);
    var theta = atan2(y, x) + 0.000003 * cos(x * p);
    var bdLng = z * cos(theta) + 0.0065;
    var bdLat = z * sin(theta) + 0.006;

    logI("longitude===>$bdLng, latitude===>$bdLat");

    return [bdLng, bdLat];
  }

  /// 苹果地图
  static Future<bool> gotoAppleMap(longitude, latitude) async {
    var url = 'http://maps.apple.com/?&daddr=$latitude,$longitude';

    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      ToastUtil.show('打开失败~');
      return false;
    }

    return await launch(url);
  }

  static Future<List<String>> checkInstallMapList(longitude, latitude) async {
    List<String> result = [];
    List<String> urls = [
      '${Platform.isAndroid ? 'android' : 'ios'}amap://navi?sourceApplication=amap&lat=$latitude&lon=$longitude&dev=0&style=2',
      'baidumap://map/direction?destination=$latitude,$longitude&coord_type=bd09ll&mode=driving',
      'qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=$latitude,$longitude&referer=IXHBZ-QIZE4-ZQ6UP-DJYEO-HC2K2-EZBXJ'
    ];
    if (Platform.isIOS) {
      urls.add('http://maps.apple.com/?&daddr=$latitude,$longitude');
    }

    for (var i = 0; i < urls.length; i++) {
      bool canLaunchUrl = await canLaunch(urls[i]);
      if (canLaunchUrl) {
        if (i == 0) {
          result.add("高德");
        } else if (i == 1) {
          result.add("百度");
        } else if (i == 2) {
          result.add("腾讯");
        } else {
          result.add("苹果");
        }
      }
    }
    return result;
  }

  static Future<BitmapDescriptor> widgetToIcon(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }
}
