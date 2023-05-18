import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/sku_entity.g.dart';
import 'package:cotti_client/pages/tabs/menu/entity/special_activity_limit.dart';
import 'package:cotti_client/pages/tabs/menu/entity/special_price_activity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/4/18 10:35 上午
@JsonSerializable()
class SkuEntity {
  SkuEntity();

  factory SkuEntity.fromJson(Map<String, dynamic> json) => $SkuEntityFromJson(json);

  Map<String, dynamic> toJson() => $SkuEntityToJson(this);

  ///sku的商品的数量 临时停售设置为0 0表示售罄 是否售罄判断
  int? quantity;

  ///是否售罄
  bool? saleOut;

  ///是否可售 （1 不可售 0 可售） 1 不可售无效商品 未上架 或者 已下市 已删除 原先isDisplay字段 0 可售
  int? noSale;

  String? noSaleMsg;

  ///sku编码
  late String skuNo;

  ///sku名称
  String? skuName;

  ///sku展示名称
  String? skuShowName;

  ///活动价 可空 单位：分
  int? activityPrice;

  ///售价 不可为空 单位：分
  int? sellPrice;

  ///标准价 不可为空 单位：分
  int? standardPrice;
  List<SkuSpec>? skusSpecs;
  SpecialPriceActivity? specialPriceActivity;

  String? sellPriceStr;
  String? standardPriceStr;
  String? activityPriceStr;
  int? defaultSku;
  int? lowestPrice;
  String? lowestPriceStr;
  String? spuShowName;

  /// 特价活动处理后信息
  @JSONField(name: "specialActivityLimitDTO")
  SpecialActivityLimit? specialActivityLimit;
}

@JsonSerializable()
class SkuSpec {
  SkuSpec();

  factory SkuSpec.fromJson(Map<String, dynamic> json) => $SkuSpecFromJson(json);

  Map<String, dynamic> toJson() => $SkuSpecToJson(this);

  ///规格值value
  String? specItemValue;

  ///规格值名称
  String? specItemValueName;

  ///规格项no
  String? specItemNo;

  ///规格项名称
  String? specItemName;

  @JSONField(deserialize: false, serialize: false)
  String? specItemJoin;
}
