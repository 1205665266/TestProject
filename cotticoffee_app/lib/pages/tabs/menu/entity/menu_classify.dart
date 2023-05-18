import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/menu_classify.g.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_item_entity.dart';

@JsonSerializable()
class MenuClassify {
  int? key;
  String? id;
  String? code;
  String? name;
  int? sort;
  String? iconUrl;
  String? adPicUrl;
  String? tagUrl;
  String? classifyDesc;
  int? adType;
  String? adInfo;
  List<MenuItemEntity>? items;
  List<MenuItemEntity>? saleOutItems;
  List<MenuClassify>? subList;
  List<MenuClassify>? triList;
  int? tag;

  MenuClassify();

  factory MenuClassify.fromJson(Map<String, dynamic> json) => $MenuClassifyFromJson(json);

  Map<String, dynamic> toJson() => $MenuClassifyToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
