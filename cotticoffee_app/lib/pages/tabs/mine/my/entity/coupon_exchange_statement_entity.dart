import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/coupon_exchange_statement_entity.g.dart';

@JsonSerializable()
class CouponExchangeStatementEntity {
  int? appKeyBoardType;
  CouponExchangeStatement? couponExchangeStatement;

  CouponExchangeStatementEntity();

  factory CouponExchangeStatementEntity.fromJson(Map<String, dynamic> json) =>
      $CouponExchangeStatementEntityFromJson(json);

  Map<String, dynamic> toJson() => $CouponExchangeStatementEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CouponExchangeStatement {
  String? title;
  String? content;

  CouponExchangeStatement();

  factory CouponExchangeStatement.fromJson(Map<String, dynamic> json) =>
      $CouponExchangeStatementFromJson(json);

  Map<String, dynamic> toJson() => $CouponExchangeStatementToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
