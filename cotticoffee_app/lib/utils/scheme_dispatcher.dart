import 'package:abitelogin/abitelogin.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/routers/tab_router.dart';
import 'package:cotti_client/routers/web_view_router.dart';
import 'package:cotti_client/utils/share_util.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// @ClassName: SchemeDispatcher
///
/// @Description: 统一跳转类
/// @author: xingguo.lei
/// @date: 2021-12-01
class SchemeDispatcher {
  static const String _schemeCotti = "cotti";
  static const String _schemeHttp = "http";
  static const String _schemeHttps = "https";
  static const String _schemeCottiTab = "cottitab";
  static const String _schemeCallPhone = "callphone";
  static const String _schemeLogin = "cottilogin";
  static const String _schemeOpenWeChatMiniProgram = "openwechatminiprogram";

  static void dispatchPath(BuildContext context, String uriStr) async {
    String decodeUri = Uri.decodeComponent(uriStr);
    Uri uri = Uri.parse(decodeUri);
    Map<String, Object> arguments = uri.queryParameters;
    if (_equalsIgnoreCase(_schemeCotti, uri.scheme)) {
      ///动态打开各个页面
      _checkLogin(context, decodeUri, () {
        NavigatorUtils.push(context, uri.path, params: arguments);
      });
    } else if (_equalsIgnoreCase(_schemeHttp, uri.scheme) || _equalsIgnoreCase(_schemeHttps, uri.scheme)) {
      _checkLogin(context, decodeUri, () {
        Map<String, String> params = {"url": decodeUri};
        NavigatorUtils.push(context, WebViewRouter.webView, params: params);
      });
    } else if (_equalsIgnoreCase(uri.scheme, _schemeCottiTab)) {
      ///跳转到首页，并tab切换
      Navigator.popUntil(context, ModalRoute.withName(TabRouter.tabPage));
      int? tabIndex = int.tryParse("${arguments['tabIndex']}");
      if (tabIndex != null) {
        GlobalBlocs.get(GlobalBloc.blocName).add(SwitchTabEvent(tabIndex, arguments: arguments));
      }
    } else if (_equalsIgnoreCase(_schemeCallPhone, uri.scheme)) {
      ///拨打电话
      Object? phoneNumber = arguments['phoneNumber'];
      var url = "tel:$phoneNumber";
      if (await canLaunch(url)) {
        launch(url);
      }
    } else if (_equalsIgnoreCase(_schemeOpenWeChatMiniProgram, uri.scheme)) {
      List<String> paths = decodeUri.split("openwechatminiprogram://coffee");
      if (paths.length > 1) {
        ShareUtil.openWeChatMiniProgram(path: NavigatorUtils.getParamsPath(paths[1], arguments));
      }
    } else if (_equalsIgnoreCase(_schemeLogin, uri.scheme)) {
      if (!Constant.hasLogin) {
        LoginUtils.login(context);
      }
    } else {
      logI("未知的跳转类型：$uriStr 跳转失败");
    }
  }

  static void _checkLogin(BuildContext context, String sourceStr, Function callBack) {
    if (sourceStr.contains("auth=1")) {
      if (Constant.hasLogin) {
        callBack();
      } else {
        LoginUtils.login(context).then((value) {
          if (Constant.hasLogin) {
            callBack();
          }
        });
      }
    } else {
      callBack();
    }
  }

  static bool _equalsIgnoreCase(String? string1, String? string2) {
    if ((string1?.isEmpty ?? true) || (string2?.isEmpty ?? true)) {
      return false;
    }
    return string1!.toLowerCase() == string2!.toLowerCase();
  }
}
