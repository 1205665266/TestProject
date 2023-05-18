import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/menu_item_entity.g.dart';
import 'package:cotti_client/pages/tabs/menu/entity/custom_marketing_label_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/marketing_label_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';

@JsonSerializable()
class MenuItemEntity {
  int? key;
  String? title;
  String? itemNo;
  List<SkuEntity>? skuCombinList;
  String? litimgUrl;
  String? itemNetWeight;
  String? capacity;
  int? itemSpicyValue;
  String? itemLabel;
  String? placeOfOrigin;
  String? workmanship;
  String? flavor;
  List<MarketingLabelEntity>? marketingLabel;
  CustomMarketingLabelEntity? customMarketingLabel;
  int? isDisplay;
  int? skuAllSaleOut;
  int? skuNum;
  int? skuNumNew;
  int? quantity;
  String? sellingPoints;
  String? essentials;
  int? quantityCount;
  int? sales;
  List<SkuEntity>? skuList;
  SkuEntity? firstSku;

  MenuItemEntity();

  factory MenuItemEntity.fromJson(Map<String, dynamic> json) => $MenuItemEntityFromJson(json);

  Map<String, dynamic> toJson() => $MenuItemEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
