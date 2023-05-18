import 'package:cotti_client/pages/tabs/tab_page.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:fluro/fluro.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/26 11:28
class TabRouter extends ModuleRouteManager {
  static const String tabPage = '/pages/tabPage';

  @override
  List<RouteEntry> get routes => [
        RouteEntry(
          tabPage,
          handler: Handler(handlerFunc: (context, params) {
            return const TabPage();
          }),
        ),
      ];
}
