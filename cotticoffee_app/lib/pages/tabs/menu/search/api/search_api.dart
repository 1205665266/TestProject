import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_item_entity.dart';
import 'package:cotti_client/pages/tabs/menu/search/entity/item_label_model.dart';
import 'package:cotti_client/pages/tabs/menu/search/entity/search_label.dart';
import 'package:cotti_client/pages/tabs/menu/search/entity/search_param.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:cotti_client/pages/tabs/menu/search/entity/menu_root_entity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/15 9:51 AM
class SearchApi {

  static const String _keyHistory = "keyHistory";
  static const String _searchPageContent = "/itemPageSearch/getSearchPageContent";
  static const String _itemPageSearch = "/itemPageSearch/page";

  static Future<ItemLabelModel> getSearchPageContent(int? shopMdCode, int? takeFoodMode) {
    return CottiNetWork().post(_searchPageContent, data: {
      "shopMdCode": shopMdCode,
      "takeFoodMode": takeFoodMode
    }).then((value) => ItemLabelModel.fromJson(value));
  }

  static Future<List<MenuItemEntity>> getItemPageSearch(SearchParam searchParam) {

    logI("getItemPageSearch ===>");
    return CottiNetWork()
        .post(_itemPageSearch, data: searchParam.toJson()).then((value) {
      logI("result ===>$value");
      List list = value ?? [];
      return list.map((e) => MenuItemEntity.fromJson(e)).toList();
    });
  }

  static Future<List<SearchLabel>> getHistory() async {
    return await SharedPreferences.getInstance().then((sp) {
      String? json = sp.getString(_keyHistory);
      if (json?.isEmpty ?? true) {
        json = "[]";
      }
      String history = json!;
      List list = jsonDecode(history);
      return list.map((e) => SearchLabel.fromJson(e)).toList();
    });
  }

  static Future<bool> saveHistory(List<SearchLabel> list) async {
    return await SharedPreferences.getInstance()
        .then((value) => value.setString(_keyHistory, jsonEncode(list)));
  }

  static Future<bool> clearHistory() async {
    return await SharedPreferences.getInstance().then((value) => value.setString(_keyHistory, ''));
  }

}
