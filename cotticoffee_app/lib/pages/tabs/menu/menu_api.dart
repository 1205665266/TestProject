import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_classify.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_config_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_root_entity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/15 9:51 AM
class MenuApi {
  static const String _menu = '/item/menu';
  static const String _menuConfig = '/config/getMenuConfig';

  static Future<List<MenuClassify>> getMenu(List<int>? takeFoodModes, int shopMdCode) {
    return CottiNetWork().post(_menu, data: {
      'takeFoodModes': takeFoodModes,
      'shopMdCode': shopMdCode
    }).then((value) => MenuRootEntity.fromJson(value).rootList ?? []);
  }

  static Future<MenuConfigEntity> getMenuConfig() {
    return CottiNetWork()
        .post(_menuConfig, data: {}).then((value) => MenuConfigEntity.fromJson(value));
  }
}
