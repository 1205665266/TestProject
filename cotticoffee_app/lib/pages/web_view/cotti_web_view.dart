import 'dart:convert';

import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/routers/order_router.dart';
import 'package:cotti_client/utils/scheme_dispatcher.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as inapp;

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/12 8:30 PM
class CottiWebView extends StatefulWidget {
  String url;
  final bool isOnlineCustomerServicePage;

  CottiWebView({Key? key, required this.url, this.isOnlineCustomerServicePage = false})
      : super(key: key);

  @override
  State<CottiWebView> createState() => _CottiWebViewState();
}

class _CottiWebViewState extends State<CottiWebView> {
  late final WebViewController _webViewController;
  String? title;
  bool isShowLoading = true;

  /// iOS 在跳转订单详情时回多次跳转，
  /// 加锁防止连续跳订单详情页
  bool _jumpBloc = false;

  @override
  void initState() {
    super.initState();
    UserModel? userModel = GlobalBlocs.get<UserBloc>(UserBloc.blocName).state.userModel;
    int? shopMdCode = context.read<ShopMatchBloc?>()?.state.shopMdCode;

    String decodeFull = Uri.decodeFull(widget.url);

    logI('String decodeFull = $decodeFull');

    if (userModel?.memberId != null) {
      if (widget.url.contains("?")) {
        widget.url += '&memberId=${userModel?.memberId}';
      } else {
        widget.url += '?memberId=${userModel?.memberId}';
      }
    }
    if (shopMdCode != null) {
      if (widget.url.contains("?")) {
        widget.url += '&shopMdCode=$shopMdCode';
      } else {
        widget.url += '?shopMdCode=$shopMdCode';
      }
    }
    if (widget.url.contains('abiteol_tylq=1')) {
      /// 通用领券，需要拼接 mmm、linkTerminal、contact_id
      /// https://mdev.cotticoffee.com/#/ticket?comefrom=4&abiteol_tylq=1&auth=1&activityNo=16364254898700288&abiteol_tylq=1
      widget.url +=
          '&mmm=${userModel?.mobile ?? ''}OL&linkTerminal=3&contact_id=${userModel?.memberId ?? ''}';
    }

    /// http://10.132.20.244:8080/#/ticket?comefrom=4&abiteol_tylq=1&auth=1&activityNo=16806607547924480&abiteol_tylq=1&a=3
    /// http://10.132.20.244:8080/
    logW('widget.url === ${widget.url}');
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      title: title,
      pageBackgroundColor: Colors.white,
      showLoading: isShowLoading,
      child: widget.isOnlineCustomerServicePage ? _buildInAppWebView() : _buildWebView(),
    );
  }

  Widget _buildWebView() {
    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: onWebViewCreated,
      onPageFinished: onPageFinished,
      gestureNavigationEnabled: true,
      javascriptChannels: createJavascriptChannels(),
    );
  }

  Widget _buildInAppWebView() {
    return inapp.InAppWebView(
      initialOptions: inapp.InAppWebViewGroupOptions(
        android: inapp.AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),
      ),
      initialUrlRequest: inapp.URLRequest(url: Uri.parse(widget.url)),
      onLoadStart: onLoadStart,
      onLoadResource: (inapp.InAppWebViewController controller, inapp.LoadedResource resource) {
        logI('onLoadResource --- ${resource.url}');
      },
      onTitleChanged: (_, String? t) {
        logI('onTitleChanged === $t');
        setState(() {
          title = t ?? "";
        });
      },
      onLoadStop: (_, Uri? uri) {
        setState(() {
          isShowLoading = false;
        });
      },
    );
  }

  /// inappwebview 每次加载时判断是否需要跳订单详情；
  onLoadStart(inapp.InAppWebViewController controller, Uri? url) async {
    logI('onLoadStart - $url');

    String durl = Uri.decodeFull(url.toString());

    /// 判断反编码后是否包含 订单详情地址；
    if (durl.contains('App/#/orderdetail')) {
      if (_jumpBloc) {
        return;
      }
      _jumpBloc = true;

      durl = durl.replaceAll('App/#/orderdetail', '');

      Uri u = Uri.parse(durl);

      Map<String, String> parameters = u.queryParameters;

      /// 获取连接中的订单号；
      if (parameters.containsKey('orderid')) {
        String orderid = parameters['orderid']!;

        await NavigatorUtils.push(
          context,
          OrderRouter.orderDetailPage,
          params: {'orderNo': orderid},
        );

        _jumpBloc = false;

        /// webView goBack 防止显示错误页或空白页；
        bool can = await controller.canGoBack();
        if (can) {
          controller.goBack();
        }
      }
    }
  }

  void onWebViewCreated(WebViewController webViewController) async {
    _webViewController = webViewController;
  }

  onPageFinished(url) async {
    isShowLoading = false;
    title = await _webViewController.getTitle();
    setState(() {});
  }

  Set<JavascriptChannel> createJavascriptChannels() {
    List<JavascriptChannel> list = <JavascriptChannel>[];
    list.add(_navigationChannel());
    list.add(_receivedTitle());
    return list.toSet();
  }

  /// js 跳转原生页面
  JavascriptChannel _navigationChannel() {
    /** 调用方式
        js 参数：var data = '{"path":"cotti://coffee/pages/tabs/mine/bonus/bonusRulesPage?rules=123124123213123123"}';
        js 调用：CottiNavigation.postMessage(data);
        ※ path:必填，遵循广告位跳转协议:https://i7drsi3tvf.feishu.cn/docx/LfEadBCAloxlGVxhhrFcPO9EnTe
     */
    return JavascriptChannel(
      name: "CottiNavigation",
      onMessageReceived: (JavascriptMessage message) async {
        Map<String, dynamic> msgMap = json.decode(message.message);
        String? path = msgMap['path'];
        String? webBack = msgMap["webBack"];
        if (path == null) {
          logW('CottiNavigation 跳转路径 path 为空');
          return;
        }
        bool canGoBack = await _webViewController.canGoBack();
        logI('webVack == $webBack');
        logI('webVack == $canGoBack');
        if (webBack != null && canGoBack) {
          _webViewController.goBack();
        }
        SchemeDispatcher.dispatchPath(context, path);
      },
    );
  }

  JavascriptChannel _receivedTitle() {
    return JavascriptChannel(
      name: 'TitleChange',
      onMessageReceived: (JavascriptMessage message) {
        Map<String, dynamic> msgMap = json.decode(message.message);
        String? title = msgMap['title'];
        if (title != null) {
          setState(() {
            this.title = title;
          });
        }
      },
    );
  }
}
