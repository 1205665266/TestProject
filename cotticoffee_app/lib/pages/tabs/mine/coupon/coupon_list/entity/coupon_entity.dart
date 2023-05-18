import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/coupon_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class CouponEntity {
  int? tenantCode;
  String? couponNo;
  int? couponType;
  int? condition;
  double? value;
  String? strValue;
  int? limit;
  int? productType;
  String? terminalScope;
  String? takeFoodScope;
  bool? available;
  String? activityNo;
  String? templateNo;
  String? couponName;
  String? couponSubTitle;
  String? title;
  String? threshold;
  String? couponRestrict;
  String? couponDesc;
  String? couponImage;
  String? startTime;
  String? endTime;
  List<String>? timeScopeList;
  int? couponTypeTranslate;

  CouponEntity();

  static List<CouponEntity> listFromJson(List<Map<String, dynamic>>? jsons) {
    return List.generate(
      jsons?.length ?? 0,
      (index) => CouponEntity.fromJson(jsons![index]),
    );
  }

  factory CouponEntity.fromJson(Map<String, dynamic> json) => $CouponEntityFromJson(json);

  Map<String, dynamic> toJson() => $CouponEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
