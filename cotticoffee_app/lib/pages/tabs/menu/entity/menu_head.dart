import 'package:cotti_client/pages/tabs/menu/entity/menu_classify.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_item_entity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/16 7:45 PM
class MenuHead {
  late int key;

  ///标题
  late MenuClassify headInfo;

  ///二级标题key
  late int? secondHeadKey;

  ///带二级标题的商品
  List<MenuHead> secondHead = [];

  ///不带二级标题的商品
  List<MenuItemEntity> items = [];

  ///售罄的商品
  List<MenuItemEntity> saleOutItems = [];

  MenuHead(this.key, this.headInfo, {this.secondHeadKey});
}
