import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/validate_entity.g.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/2/16 14:03

@JsonSerializable()
class ValidateEntity {
  ///商品名称
  String? productName;

  ///原价
  String? originalAmount;

  ///售价
  String? payAmount;

  ///券名称
  String? couponName;

  String? couponSubtitle;

  ///数量
  String? num;

  ///平台券模板编号
  String? couponTemplateNo;

  /// since20230414 可兑换的总数
  int? total;

  /// since20230414 券模版类型 1-优惠券 2-代金券
  int? templateType;

  /// since20230414 券模版关联的商品类型 1-团购 2-代金券 3-次卡
  int? templateProductType;

  ValidateEntity();

  factory ValidateEntity.fromJson(Map<String, dynamic> json) => $ValidateEntityFromJson(json);

  Map<String, dynamic> toJson() => $ValidateEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
