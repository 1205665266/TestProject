import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/shop_license_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class ShopLicenseList {
  int? total;
  List<ShopLicenseEntity>? list;

  ShopLicenseList();

  factory ShopLicenseList.fromJson(Map<String, dynamic> json) => $ShopLicenseListFromJson(json);

  Map<String, dynamic> toJson() => $ShopLicenseListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ShopLicenseEntity {
  int? shopMdCode;
  String? shopName;
  dynamic cityMdCode;
  dynamic cityMdName;
  dynamic address;
  List<String>? images;

  ShopLicenseEntity();

  factory ShopLicenseEntity.fromJson(Map<String, dynamic> json) => $ShopLicenseEntityFromJson(json);

  Map<String, dynamic> toJson() => $ShopLicenseEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
