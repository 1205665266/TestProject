

import 'dart:io';
import 'dart:typed_data';

import 'package:card_swiper/card_swiper.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/utils/share_util.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/widget_to_image.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ShareImagePage extends StatefulWidget {

  List<String> imageList = [];
  String qrCodeImageUrl = '';

  BoxFit? fit;



  ShareImagePage(this.imageList, this.qrCodeImageUrl, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_ShareImagePageState();

}

class _ShareImagePageState extends State<ShareImagePage> {

  final GlobalKey _globalKey = GlobalKey();
  double? width;
  double? height;
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return CustomPageWidget(
      title: "生成美图",
      child: SafeArea(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: _buildImageSwiper()
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w),
              color: Colors.white,
              child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          saveToAlbum(context);
                        },
                        child: Container(
                          height: 40.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.w,
                                  color: CottiColor.primeColor
                              )
                          ),
                          child: Text(
                            "保存到相册",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: CottiColor.primeColor
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7.w,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          shareFriend();
                        },
                        child: Container(
                          height: 40.h,
                          alignment: Alignment.center,
                          color: CottiColor.primeColor,
                          child: Text(
                              "发送给好友",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    )
                  ]

              ),
            )
          ],
        ),
      )
    );
  }

  _buildImageSwiper() {
    return RepaintBoundary(
      key: _globalKey,
      child: Swiper(
        itemCount: widget.imageList.length,
        pagination: _buildSwiperPagination(),
        autoplay: false,
        itemBuilder: (context, index) => _swiperItem(context, widget.imageList[index], index),
        autoplayDelay: 4000,
        duration: 550,
        onIndexChanged: (index) {
          currentIndex = index;
        },
      ),
    );

  }

  _swiperItem(BuildContext ctx, String imageUrl, int index, {onTapCallback}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CottiImageWidget(
          imageUrl,
          imgH: height,
          imgW: width,
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: PrettyQr(
                data: widget.qrCodeImageUrl,
                size: 74.w,
                elementColor: Colors.black,
              ),
              padding: EdgeInsets.all(5.w),
              color: Colors.white,
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              "扫码立即享",
              style: TextStyle(
                fontSize: 14.sp,
                color: CottiColor.textBlack
              ),
            ),
            SizedBox(
              height: 80.h,
            )
          ],
        )
      ],
    );
  }


  SwiperPlugin _buildSwiperPagination() {
    return SwiperPagination(
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.only(bottom: 10.h, right: 10.w),
      builder: RectSwiperPaginationBuilder(
        size: Size(7.w, 3.h),
        activeSize: Size(21.w, 3.5.h),
        space: 0,
        activeColor: Colors.white,
        color: Colors.white.withOpacity(0.6),
      ),
    );
  }

  void shareFriend() async {

    Uint8List uint8list = await GetWidgetToImage.getUint8List(_globalKey);
    ShareUtil.shareWxImage(WeChatImage.binary(uint8list), scene: WeChatScene.SESSION);
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
        }
      } else {
        // _showCameraPermissionDialog(context);
        ToastUtil.show('保存失败, 请打开相册授权！');
      }
    }
  }

  void toSavePhoto(context) async {
    BuildContext? buildContext = _globalKey.currentContext;
    if (null != buildContext) {

      String bytes = await GetWidgetToImage.getByte64(_globalKey);

      String path = await GetWidgetToImage.createFileFromString(bytes);

      final result = await ImageGallerySaver.saveFile(path);
      if (result['isSuccess']) {
        ToastUtil.show("保存成功");
        // recordShareGetCouponEvent();

        Navigator.of(context).pop();
      } else {
        ToastUtil.show('保存失败!');
        // hidePosterWidget();
      }
    }
  }

}