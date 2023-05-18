import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/menu_config_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class MenuConfigEntity {
  String? recentOrderMenuCode;
  String? discountMenuCode;

  MenuConfigEntity();

  factory MenuConfigEntity.fromJson(Map<String, dynamic> json) => $MenuConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => $MenuConfigEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
