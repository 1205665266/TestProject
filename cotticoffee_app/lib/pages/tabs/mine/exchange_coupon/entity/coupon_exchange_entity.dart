import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/coupon_exchange_entity.g.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/2/16 14:00
@JsonSerializable()
class CouponExchangeEntity {
  ///平台券名称
  String? couponName;
  String? couponSubtitle;
  ///数量
  String? num;

  CouponExchangeEntity();

  factory CouponExchangeEntity.fromJson(Map<String, dynamic> json) =>
      $CouponExchangeEntityFromJson(json);

  Map<String, dynamic> toJson() => $CouponExchangeEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
