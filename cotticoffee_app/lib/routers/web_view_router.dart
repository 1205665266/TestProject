import 'package:cotti_client/pages/web_view/cotti_web_view.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:fluro/fluro.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/12 8:35 PM
class WebViewRouter extends ModuleRouteManager {
  static const String webView = '/pages/web_view/cotti_web_view';

  @override
  List<RouteEntry> get routes => [
        RouteEntry(
          webView,
          handler: Handler(handlerFunc: (context, params) {
            final String url = params['url']?.first ?? '';
            final String? isOnlineCustomerServicePage = params['isOnlineCustomerServicePage']?.first;
            logI('isOnlineCustomerServicePage = $isOnlineCustomerServicePage');
            return CottiWebView(url: url,isOnlineCustomerServicePage:isOnlineCustomerServicePage != null);
          }),
        ),
      ];
}
