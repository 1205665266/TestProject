import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/routers/menu_router.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/routers/order_router.dart';
import 'package:cotti_client/routers/tab_router.dart';
import 'package:cotti_client/routers/web_view_router.dart';
import 'package:cotticommon/global/global_route_manager.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/8/31 9:32 上午
class MainRouter {
  static init() {
    GlobalRouterManager.registerRoutes(TabRouter().routes);
    GlobalRouterManager.registerRoutes(OrderRouter().routes);
    GlobalRouterManager.registerRoutes(MineRouter().routes);
    GlobalRouterManager.registerRoutes(WebViewRouter().routes);
    GlobalRouterManager.registerRoutes(MenuRouter().routes);
    GlobalRouterManager.registerRoutes(CommonPageRouter().routes);
  }
}
