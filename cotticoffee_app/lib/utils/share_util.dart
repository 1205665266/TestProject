import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/config/env.dart';
import 'package:cotti_client/config/env_config.dart';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluwx/fluwx.dart';

class ShareUtil {
  static String defaultFissionActivity = '';

  static Future<bool> init() {
    getDefaultFissionActivity();
    return registerWxApi(
      appId: Constant.wxAppID,
      universalLink: "https://m.cotticoffee.com/app/",
    );
  }

  /// @description 微信分享图片 <br>
  static void shareWxImage(
    WeChatImage source, {
    WeChatImage? thumbnail,
    String? title,
    String? description,
    String? messageExt,
    String? messageAction,
    String? mediaTagName,
    WeChatScene scene = WeChatScene.SESSION,
    bool compressThumbnail = true,
  }) async {
    if (await checkWeChatInstalled()) {
      shareToWeChat(WeChatShareImageModel(
        source,
        thumbnail: thumbnail,
        title: title,
        scene: scene,
        mediaTagName: mediaTagName,
        messageAction: messageAction,
        messageExt: messageExt,
        description: description,
        compressThumbnail: compressThumbnail,
      ));
    }
  }

  /// @description 微信分享网页 <br>
  static void shareWxWebPage(
    String webPage, {
    String? thumbnail,
    String title = "",
    String? description,
    String? messageExt,
    String? messageAction,
    String? mediaTagName,
    WeChatScene scene = WeChatScene.SESSION,
    bool compressThumbnail = true,
  }) async {
    if (await checkWeChatInstalled()) {
      shareToWeChat(WeChatShareWebPageModel(
        webPage,
        thumbnail: WeChatImage.network(thumbnail!),
        title: title,
        scene: scene,
        mediaTagName: mediaTagName,
        messageAction: messageAction,
        messageExt: messageExt,
        description: description,
        compressThumbnail: compressThumbnail,
      ));
    }
  }

  /// @description 微信分享小程序 <br>
  static void shareWxMiniProgram(
    String webPage,
    String path, {
    String? thumbnail,
    String? hdImagePath,
    String title = "",
    String? description,
    String? messageExt,
    String? messageAction,
    String? mediaTagName,
    bool compressThumbnail = true,
  }) async {
    String defaultUrl = "https://yummy-product-prod.obs.cn-north-4.myhuaweicloud"
        ".com/wechat/cotti/images/icon_share_mini_program_thumbnail.png";
    if (thumbnail?.endsWith("gif") ?? false) {
      thumbnail = defaultUrl;
    }
    thumbnail = Uri.encodeFull(thumbnail ?? defaultUrl);
    if (await checkWeChatInstalled()) {
      shareToWeChat(WeChatShareMiniProgramModel(
        webPageUrl: webPage,
        miniProgramType: Env.currentEnvConfig.envName == EnvConfig.prod
            ? WXMiniProgramType.RELEASE
            : WXMiniProgramType.PREVIEW,
        userName: Constant.miniProgramUserName,
        path: path,
        thumbnail: WeChatImage.network(
            "$thumbnail?x-image-process=image/resize,w_600,limit_0/quality,q_90/format,wbep"),
        title: title,
        description: description,
        messageAction: messageAction,
        messageExt: messageExt,
        withShareTicket: false,
      ));
    }
  }

  /// @description 微信分享文本内容 <br>
  /// @author Yihua LI
  static void shareWxText(
    String source, {
    String? title,
    String? description,
    String? messageExt,
    String? messageAction,
    String? mediaTagName,
    WeChatScene scene = WeChatScene.SESSION,
  }) async {
    if (await checkWeChatInstalled()) {
      shareToWeChat(WeChatShareTextModel(
        source,
        title: title,
        scene: scene,
        mediaTagName: mediaTagName,
        messageAction: messageAction,
        messageExt: messageExt,
        description: description,
      ));
    }
  }

  static void openWeChatMiniProgram({
    String? path,
  }) async {
    if (await checkWeChatInstalled()) {
      launchWeChatMiniProgram(
        username: Constant.miniProgramUserName,
        path: path,
        miniProgramType: Env.currentEnvConfig.envName == EnvConfig.prod
            ? WXMiniProgramType.RELEASE
            : WXMiniProgramType.PREVIEW,
      );
    }
  }

  static Future<bool> checkWeChatInstalled() async {
    var result = await isWeChatInstalled;
    if (!result) {
      ToastUtil.show('请先安装微信应用！');
    }
    return result;
  }

  static getDefaultFissionActivity() {
    const url = '/fission/getDefaultFissionActivity';
    CottiNetWork().post(url, showToast: false).then((value) {
      debugPrint('defaultFissionActivity  === $value');
      defaultFissionActivity = value['activityNo'] ?? '';
      debugPrint('defaultFissionActivity  === $defaultFissionActivity');
    }).catchError((error) {});
  }
}
