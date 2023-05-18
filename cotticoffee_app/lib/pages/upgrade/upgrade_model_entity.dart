import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/upgrade_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class UpgradeModelEntity {

	int? forceType;
	String? focusVersion;
	String? buildVersion;
	String? msg;
	String? address;
	String? md5Sign;
	String? upgradeTime;
	int? appChannel;
  
  UpgradeModelEntity();

  factory UpgradeModelEntity.fromJson(Map<String, dynamic> json) => $UpgradeModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $UpgradeModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}