import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/position_info_entity.g.dart';

@JsonSerializable()
class PositionInfoEntity {
  int? locationType;
  double? latitude;
  double? longitude;
  double? accuracy;
  double? altitude;
  double? bearing;
  double? speed;
  String? country;
  String? province;
  String? city;
  String? district;
  String? street;
  String? streetNumber;
  String? cityCode;
  int? adCode;
  String? address;
  String? description;

  PositionInfoEntity();

  factory PositionInfoEntity.fromJson(Map<String, dynamic> json) =>
      $PositionInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $PositionInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
