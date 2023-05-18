import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/spec_entity.g.dart';
import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';

@JsonSerializable()
class SpecEntity {
  SpecEntity();

  factory SpecEntity.fromJson(Map<String, dynamic> json) => $SpecEntityFromJson(json);

  Map<String, dynamic> toJson() => $SpecEntityToJson(this);

  ///商品名称
  String? title;

  ///总库存数
  int? quantityCount;

  ///最低价 不可为空 单位：分
  int? lowestPrice;

  ///sku数量
  int? skuNum;

  ///是否sku全部售罄 (方便排序) 0：是 >0：否
  int? skuAllSaleOut;
  String? itemNo;
  String? litimgUrl;

  ///商品净含量,单位：克
  String? itemNetWeight;

  ///商品最低价（此价格供APP展示使用），单位: 元
  String? minPrice;

  ///商品划线价（此价格供APP展示使用），单位: 元
  String? lineThroughPrice;

  ///整个spu不可售 该商品当前门店是否可售: 1-可售,0-不可售 不可售：1. 产品中台未上市 2.spu
  ///暂不支持快递、自提、外送 3.spu所有sku 商品当前门店未上架
  int? isDisplay;

  ///当前服务器时间
  int? nowTime;

  List<SpecItem>? specItems;
  List<SkuEntity>? skuCombinList;
  SkuEntity? firstSku;
}

///规格项 对应的 基础信息
@JsonSerializable()
class SpecItem {
  SpecItem();

  factory SpecItem.fromJson(Map<String, dynamic> json) => $SpecItemFromJson(json);

  Map<String, dynamic> toJson() => $SpecItemToJson(this);

  /// 规格项编码
  String? specItemNo;

  ///规格项中文名称
  String? specItemName;
  List<SpecValue>? specValueList;
}

@JsonSerializable()
class SpecValue {
  SpecValue();

  factory SpecValue.fromJson(Map<String, dynamic> json) => $SpecValueFromJson(json);

  Map<String, dynamic> toJson() => $SpecValueToJson(this);

  String? name;
  String? value;
  @JSONField(deserialize: false, serialize: false)
  String? specItemJoin;
}
