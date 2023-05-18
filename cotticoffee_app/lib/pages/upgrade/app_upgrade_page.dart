import 'dart:io';

import 'package:cotti_client/global/style.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cotti_client/pages/upgrade/src/flutter_upgrade.dart';
import 'package:cotti_client/pages/upgrade/src/download_status.dart';
import 'package:cotti_client/pages/upgrade/src/liquid_progress_indicator.dart';
import 'package:cotti_client/pages/upgrade/src/app_upgrade.dart';
import 'package:cotti_client/pages/upgrade/interval_btn_widget.dart';

class AppUpgradePage extends StatefulWidget {
  final String okButtonTitle;
  final String cancelButtonTitle;
  final bool isForce;
  final String title;
  final String? subTitle;
  final List<String> contents;
  final int? forceType;
  final DownloadProgressCallback? downloadProgress;
  final DownloadStatusChangeCallback? downloadStatusChange;
  final String? iosAppId;
  final double? titleFontSize;
  final double? bgColorWidgetWidth;

  ///
  /// app安装包下载url,
  ///
  final String downloadUrl;

  const AppUpgradePage(
      {Key? key,
      required this.title,
      required this.contents,
      this.forceType,
      this.subTitle,
      this.downloadProgress,
      this.downloadStatusChange,
      required this.downloadUrl,
      required this.okButtonTitle,
      required this.cancelButtonTitle,
      required this.isForce,
      this.iosAppId,
      this.titleFontSize,
      this.bgColorWidgetWidth})
      : super(key: key);

  @override
  _AppUpgradePageState createState() => _AppUpgradePageState();
}

class _AppUpgradePageState extends State<AppUpgradePage> {
  ///
  /// 下载进度
  ///
  double _downloadProgress = 0.0;

  DownloadStatus _downloadStatus = DownloadStatus.none;
  static const String _downloadApkName = 'temp.apk';
  Color _okButtonBgColor = CottiColor.primeColor;
  String? _okButtonTitleString;

  @override
  void initState() {
    // TODO: implement initState
    _okButtonTitleString = widget.okButtonTitle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        _buildInfoWidget(context),
        // _downloadProgress > 0
        //     ? Positioned.fill(child: _buildDownloadProgress())
        //     : Container(
        //         height: 10,
        //       )
      ],
    );
  }

  _buildTopImage() {
    return Container(
        transform: Matrix4.translationValues(0, 10.h, 0),
        child: Image.asset(
          'assets/images/upgrade_top_img_1.png',
          // height: 270.h,
        ));
  }

  ///
  /// 信息展示widget
  ///
  Widget _buildInfoWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildTopImage(),
        IndexedStack(
          index: _downloadProgress > 0 ? 0:1,
          children: [
            _downloadProgressWidget(),
            _buildContent()
          ],
        ),
        // _downloadProgress > 0 ? _downloadProgressWidget() : _buildContent(),
      ],
    );
  }

  _buildContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          //标题
          _buildTitle(),
          _buildSubTitle(),
          //更新信息
          _buildAppInfo(),
          //操作按钮
          _buildAction(),
        ],
      ),
    );
  }

  ///
  /// 构建标题
  ///
  _buildTitle() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
              padding: EdgeInsets.only(left: 24.w),
              child: Text(
                widget.title,
                style: TextStyle(
                    fontSize: widget.titleFontSize ?? 28.sp,
                    color: const Color(0xff333333),
                    // background: Paint()..color = Color(0x21CA955E),
                    fontWeight: FontWeight.bold),
              )),
          Positioned(
            child: Container(
              color: const Color(0x21CA955E),
              margin: EdgeInsets.only(left: 24.w, top: 0.h),
              // color: Colors.blue,
              width: widget.bgColorWidgetWidth ?? 113.w,
              height: 19.h,
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// 构建副标题
  ///
  _buildSubTitle() {
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.only(left: 24.w, top: 16.h),
        child: Text(widget.subTitle ?? '版本更新描述:',
            style: TextStyle(
              fontSize: 18.sp,
              color: const Color(0xff333333),
            )));
  }

  ///
  /// 构建版本更新信息
  ///
  _buildAppInfo() {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: double.infinity, //宽度尽可能大
          maxHeight: 110.0.h //最小高度为50像素
          ),
      child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 20.h, top: 8.h),
          // height: 150,
          child: Scrollbar(
            child: ListView(
              shrinkWrap: true,
              addRepaintBoundaries: false,
              // physics: NeverScrollableScrollPhysics(),
              children: widget.contents.map((f) {
                return Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // color: Color(0xffd8d8d8),
                      margin: EdgeInsets.only(
                        top: Platform.isIOS ? 6.5.h : 7.h,
                      ),
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xffd8d8d8),
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: Text(
                        f,
                        style: TextStyle(fontSize: 14.sp, color: const Color(0xff666660)),
                      ),
                    )
                  ],
                );
              }).toList(),
            ),
          )),
    );
  }

  ///
  /// 构建取消或者升级按钮
  ///
  _buildAction() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildOkButton(_okButtonTitleString!),
        !widget.isForce
            ? _buildCancelButton(widget.cancelButtonTitle)
            : SizedBox(
                height: 10.h,
              )
      ],
    );
  }

  _buildOkButton(String title) {
    return IntervalBtn(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      voidCallback: () {
        if (_downloadStatus == DownloadStatus.start ||
            _downloadStatus == DownloadStatus.downloading ||
            _downloadStatus == DownloadStatus.done) {
          return;
        }
        if (Platform.isAndroid) {
          setState(() {
            _okButtonBgColor = const Color(0xffD0D0D0);
            _okButtonTitleString = '正在更新';
          });
        }
        onClickOkButtonAction();
      },
      child: Container(
        margin: EdgeInsets.only(top: 0.h, bottom: 6.h),
        height: 48.h,
        decoration:
            BoxDecoration(color: _okButtonBgColor, borderRadius: BorderRadius.circular(8.r)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: const Color(0xffffffff), fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  _buildCancelButton(String title) {
    return IntervalBtn(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      voidCallback: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: 48.h,
        color: Colors.white,
        child: Center(
            child: Text(
          title,
          style: TextStyle(
              color: const Color(0xFF979797), fontSize: 16.sp, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }

  ///
  /// 下载进度widget
  ///
  Widget _buildDownloadProgress() {
    return LiquidLinearProgressIndicator(
      borderWidth: 1,
      borderColor: Colors.transparent,
      value: _downloadProgress,
      direction: Axis.vertical,
      valueColor: AlwaysStoppedAnimation(CottiColor.primeColor.withOpacity(0.4)),
      borderRadius: 12.0,
    );
  }

  Widget _downloadProgressWidget() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 128,
            height: 128,
            child: Stack(
              children: [
                SizedBox(
                  width: 128,
                  height: 128,
                  child: CircularProgressIndicator(
                    value: _downloadProgress,
                    backgroundColor: const Color(0xffF3F3F3),
                    strokeWidth: 8.r,
                    valueColor: const AlwaysStoppedAnimation(Colors.red),
                    color: CottiColor.primeColor,
                  ),
                ),
                Center(
                  child: Text(
                    '${(_downloadProgress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontFamily: 'Montserrat-Bold, Montserrat',
                      color: const Color(0xff3A3B3C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 18.h,
              bottom: 42.h,
            ),
            child: Text(
              '正在下载，请稍后…',
              style: TextStyle(
                color: const Color(0xff666660),
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 自定义对外方法
  /// 点击立即更新
  onClickOkButtonAction() async {
    if (Platform.isIOS) {
      //ios 需要跳转到app store更新，原生实现
      var iosAppId = widget.downloadUrl.split('/').last;
      FlutterUpgrade.toAppStore(iosAppId);
      return;
    } else if (Platform.isAndroid) {
      String path = await FlutterUpgrade.apkDownloadPath;
      _downloadApk(widget.downloadUrl, '$path/$_downloadApkName');
    }
  }

  ///
  /// 下载apk包
  ///
  _downloadApk(String url, String path) async {
    logI('_downloadApk 11111');
    if (_downloadStatus == DownloadStatus.start ||
        _downloadStatus == DownloadStatus.downloading ||
        _downloadStatus == DownloadStatus.done) {
      return;
    }
    logI('_downloadApk 2222222');
    _updateDownloadStatus(DownloadStatus.start);
    try {
      var dio = Dio();
      await dio.download(url, path, onReceiveProgress: (int count, int total) {
        if (total == -1) {
          _downloadProgress = 0.01;
        } else {
          widget.downloadProgress?.call(count, total);
          _downloadProgress = count / total;
        }
        setState(() {});
        if (_downloadProgress == 1) {
          //下载完成，跳转到程序安装界面
          _updateDownloadStatus(DownloadStatus.done);
          if (!widget.isForce) {
            Navigator.pop(context);
          }
          FlutterUpgrade.installAppForAndroid(path);
        }
      });
    } catch (e) {
      _downloadProgress = 0;
      _updateDownloadStatus(DownloadStatus.error, error: e);
    }
  }

  _updateDownloadStatus(DownloadStatus downloadStatus, {dynamic error}) {
    _downloadStatus = downloadStatus;
    widget.downloadStatusChange?.call(_downloadStatus, error: error);
  }
}
