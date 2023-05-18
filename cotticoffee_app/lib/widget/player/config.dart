import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Config {
  static bool showWifiToast = true;
  double? radius;
  double? loadingWidth;
  double? loadingHeight;
  double? stopWidth;
  double? stopHeight;
  double? voiceWidth;
  double? voiceHeight;
  double? fullWidth;
  double? fullHeight;
  String? coverUrl;
  String? secondUrl;
  Color? videoColor;
  EdgeInsetsGeometry? uiPadding;
  EdgeInsetsGeometry? uiMargin;

  Config(
    this.radius,
    this.loadingWidth,
    this.loadingHeight,
    this.stopWidth,
    this.stopHeight,
    this.voiceWidth,
    this.voiceHeight,
    this.fullWidth,
    this.fullHeight,
    this.coverUrl,
    this.secondUrl,
    this.videoColor,
    this.uiPadding,
    this.uiMargin,
  );

  Config.defaultConfig() {
    radius = 0.r;
    loadingWidth = 40.w;
    loadingHeight = 40.h;
    stopWidth = 68.w;
    stopHeight = 68.h;
    voiceWidth = 24.w;
    voiceHeight = 24.h;
    fullWidth = 24.w;
    fullHeight = 24.h;
    videoColor = Colors.black;
    uiPadding = EdgeInsets.only(left: 12.w, right: 12.w, bottom: 7.h);
  }

  static Config copy(
      {double? radius,
      double? loadingWidth,
      double? loadingHeight,
      double? stopWidth,
      double? stopHeight,
      double? voiceWidth,
      double? voiceHeight,
      double? fullWidth,
      double? fullHeight,
      String? coverUrl,
      String? secondUrl,
      Color? videoColor,
      EdgeInsetsGeometry? uiPadding,
      EdgeInsetsGeometry? uiMargin}) {
    Config config = Config.defaultConfig();
    return Config(
        radius ?? config.radius,
        loadingWidth ?? config.loadingWidth,
        loadingHeight ?? config.loadingHeight,
        stopWidth ?? config.stopWidth,
        stopHeight ?? config.stopHeight,
        voiceWidth ?? config.voiceWidth,
        voiceHeight ?? config.voiceHeight,
        fullWidth ?? config.fullWidth,
        fullHeight ?? config.fullHeight,
        coverUrl ?? config.coverUrl,
        secondUrl ?? config.secondUrl,
        videoColor ?? config.videoColor,
        uiPadding ?? config.uiPadding,
        uiMargin ?? config.uiMargin);
  }
}
