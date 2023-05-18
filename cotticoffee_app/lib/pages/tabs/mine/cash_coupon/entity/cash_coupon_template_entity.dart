import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/cash_coupon_template_entity.g.dart';

@JsonSerializable()
class CashCouponTemplateEntity {
  int? recentlyExpiredCount;
  List<VoucherTemplateInfo>? voucherTemplateInfoList;

  CashCouponTemplateEntity();

  factory CashCouponTemplateEntity.fromJson(Map<String, dynamic> json) =>
      $CashCouponTemplateEntityFromJson(json);

  Map<String, dynamic> toJson() => $CashCouponTemplateEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VoucherTemplateInfo {
  String? templateTypeNo;
  String? templateTypeName;
  double? value;
  String? strValue;
  int? nums;
  String? pictureUrl;
  String? recentlyExpiredDateDesc;
  String? recentlyExpiredDate;
  bool? specialDisplay;

  VoucherTemplateInfo();

  factory VoucherTemplateInfo.fromJson(Map<String, dynamic> json) =>
      $VoucherTemplateInfoFromJson(json);

  Map<String, dynamic> toJson() => $VoucherTemplateInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
