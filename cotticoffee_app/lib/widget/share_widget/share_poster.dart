import 'dart:io';
import 'dart:typed_data';

import 'package:cotti_client/pages/product/entity/product_detail_entity.dart';
import 'package:cotti_client/utils/share_util.dart';
import 'package:cotti_client/widget/widget_to_image.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/utils/log_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluwx/fluwx.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

/// FileName: share
///
/// Description: 分享
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/21
class SharePoster extends StatelessWidget {
  SharePoster(
      {Key? key,
      this.shareContent,
      this.litimgUrl,
      this.shareUrl,
      this.shareWebTitle,
      this.productId,
      this.productName,
      this.shareChannels = const [1, 2],
      this.path,
      required this.globalKey,
      this.itemDetail,
      required this.fromPageType,
      this.adImageUrl,
      this.viewPage,
      this.hidePoster,
      this.recordShareGetCoupon})
      : super(key: key) {
    shareChannels = [1, 2];
  }

  final String? shareContent;
  final String? litimgUrl;
  final String? shareUrl;
  final String? shareWebTitle;
  final String? productId;
  final String? productName;
  List shareChannels;
  final GlobalKey globalKey;

  final String? path;

  final String? adImageUrl;

  //商品详情商品信息
  final ProductDetailEntity? itemDetail;

  final int fromPageType;
  final String? viewPage;
  final Function? hidePoster;
  final Function? recordShareGetCoupon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 96.5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // children: _buildBtns(context),

        children: [
          shareChannels.contains(2)
              ? _buildShareBtn(
                  "保存到相册",
                  "assets/images/product_detail/ic_share_poster_to_album.svg",
                  () => saveToAlbum(context),
                )
              : const SizedBox(),
          shareChannels.length == 1 ? const SizedBox() : Expanded(child: Container()),
          shareChannels.contains(1)
              ? _buildShareBtn(
                  "朋友圈",
                  "assets/images/product_detail/ic_share_to_timeline.svg",
                  () => shareTimeLine(context),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildShareBtn(String title, String assetName, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(height: 38.h),
          SvgPicture.asset(
            assetName,
            width: 44.w,
            height: 44.w,
          ),
          SizedBox(height: 6.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF979797),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void saveToAlbum(context) async {
    // SensorsAnalyticsFlutterPlugin.track(SensorsConstant.sharePyqSave, {
    //   "product_spu_id": productId ?? '',
    //   "viewPage": viewPage,
    // });

    /// 获取当前的权限
    // var status = await Permission.storage.status;
    var status =
        Platform.isIOS ? await Permission.photosAddOnly.status : await Permission.storage.status;
    logE('进入value+${status.toString()}');

    if (status == PermissionStatus.granted) {
      //已经授权
      toSavePhoto(context);
    } else {
      if (!SpUtil.getBool('photos_storage_permission_dialog_show')) {
        //未授权则发起一次申请
        status = Platform.isIOS
            ? await Permission.photosAddOnly.request()
            : await Permission.storage.request();
        if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied) {
          SpUtil.putBool('photos_storage_permission_dialog_show', true);
        }
        if (status == PermissionStatus.granted) {
          toSavePhoto(context);
        } else {
          // _showCameraPermissionDialog(context);
          ToastUtil.show('保存失败, 请打开相册授权!');
          hidePosterWidget();
        }
      } else {
        // _showCameraPermissionDialog(context);
        ToastUtil.show('保存失败, 请打开相册授权！');
        hidePosterWidget();
      }
    }
  }

  void hidePosterWidget() {
    if (hidePoster != null) {
      hidePoster!();
    }
  }

  void recordShareGetCouponEvent() {
    if (recordShareGetCoupon != null) {
      recordShareGetCoupon!();
    }
  }

  /// 展示拍照授权弹窗
  void _showCameraPermissionDialog(context) {
    _showPermissionDialog(
        '相机权限未开启',
        Platform.isIOS
            ? '请在设置->库迪咖啡->照片服务中打开开关，并允许库迪咖啡使用照片服务'
            : '请在系统设置->隐私->相册服务中打开开关，并允许库迪咖啡使用照片服务',
        context);
  }

  /// 选择弹窗视图
  void _showPermissionDialog(String title, String content, context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('取消'),
              onPressed: () {
                NavigatorUtils.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text('去开启'),
              onPressed: () async {
                openAppSettings();
                NavigatorUtils.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void toSavePhoto(context) async {
    BuildContext? buildContext = globalKey.currentContext;
    if (null != buildContext) {
      // RenderRepaintBoundary boundary = buildContext.findRenderObject();
      // ui.Image image = await boundary.toImage();
      // ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      String bytes = await GetWidgetToImage.getByte64(globalKey);

      String path = await GetWidgetToImage.createFileFromString(bytes);

      final result = await ImageGallerySaver.saveFile(path);
      if (result['isSuccess']) {
        ToastUtil.show("保存成功");
        recordShareGetCouponEvent();

        Navigator.of(context).pop();
      } else {
        ToastUtil.show('保存失败!');
        hidePosterWidget();
      }
    }
  }

  void shareTimeLine(context) async {
    recordShareGetCouponEvent();
    // SensorsAnalyticsFlutterPlugin.track(SensorsConstant.sharePyqPyqClick, {
    //   "product_spu_id": productId ?? '',
    //   "viewPage": viewPage,
    // });

    Uint8List bytes = await GetWidgetToImage.getUint8List(globalKey);

    logW('-图片数据开始输出-');
    logW(bytes);
    logW('-图片数据输出结束-');

    ShareUtil.shareWxImage(WeChatImage.binary(bytes), scene: WeChatScene.TIMELINE);

    Navigator.of(context).pop();
  }
}
