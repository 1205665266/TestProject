import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/cash_coupon_template_sub_entity.g.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/15 10:27
@JsonSerializable()
class CashCouponTemplateSubEntity {
  String? tip;
  int? groupNum;
  List<CashCouponEntity>? cashCouponTemplateSubList;

  CashCouponTemplateSubEntity();

  factory CashCouponTemplateSubEntity.fromJson(Map<String, dynamic> json) =>
      $CashCouponTemplateSubEntityFromJson(json);

  Map<String, dynamic> toJson() => $CashCouponTemplateSubEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
