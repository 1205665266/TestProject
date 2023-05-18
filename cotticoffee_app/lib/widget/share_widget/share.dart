import 'dart:convert';

import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/utils/share_util.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluwx/fluwx.dart';

/// FileName: share
///
/// Description: 分享
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/21
class Share extends StatelessWidget {
  Share(
      {Key? key,
      this.shareContent,
      this.litimgUrl,
      this.shareUrl,
      this.shareWebTitle,
      this.productId,
      this.productName,
      this.shareChannels = const [1, 2],
      this.path,
      this.generatePoster,
      this.viewPage,
      this.posterBaseImgList,
      this.qrCodeUrl,
      this.shareWeChat})
      : super(key: key);

  final String? shareContent;
  final String? litimgUrl;
  final String? shareUrl;
  final String? shareWebTitle;
  final String? productId;
  final String? productName;
  List shareChannels;

  final String? path;

  final Function? generatePoster;
  final Function? shareWeChat;

  final String? viewPage;

  final List<String>? posterBaseImgList;
  final String? qrCodeUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 96.5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildShareBtn(
            "微信好友",
            "assets/images/icon_share_wechat.svg",
            () => share(context, WeChatScene.SESSION),
          ),
          Expanded(child: Container()),
          _buildShareBtn(
            "生成海报",
            "assets/images/icon_share_poster.svg",
            () => share(context, WeChatScene.TIMELINE),
          )
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
            width: 34.w,
            height: 34.w,
          ),
          SizedBox(height: 6.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: CottiColor.textBlack,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void share(context, WeChatScene scene) {
    // if ((shareUrl?.isEmpty ?? true)) {
    //   ToastUtil.show("分享链接不能为空");
    //   return;
    // }
    if (litimgUrl?.isEmpty ?? true) {
      ToastUtil.show("缩略图不能为空");
      return;
    }

    if(scene == WeChatScene.TIMELINE) {

      NavigatorUtils.push(context, CommonPageRouter.shareImagePage, params: {
        "imageList": jsonEncode(posterBaseImgList),
        "qrImageUrl": qrCodeUrl
      });
      return;
    }

    if (scene == WeChatScene.SESSION) {
      if (shareWeChat != null) {
        shareWeChat!();
      }
    }

    ShareUtil.shareWxMiniProgram(
      shareUrl ?? "https://m.cotticoffee.com/#/download",
      path ?? "",
      title: shareWebTitle ?? "",
      description: shareContent ?? "",
      thumbnail: Uri.encodeFull(litimgUrl!),
    );

    Navigator.of(context).pop();
  }
}
