import 'package:cotti_client/pages/tabs/menu/search/search_page.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:fluro/fluro.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/27 18:30
class MenuRouter extends ModuleRouteManager {
  static const String searchPage = "/pages/tabs/menu/searchpage";

  @override
  List<RouteEntry> get routes => [
        RouteEntry(
          searchPage,
          handler: Handler(handlerFunc: (context, params) {
            return const SearchPage();
          }),
        ),
      ];
}
