import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/last_order_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class LastOrderEntity {

	int? id;
	String? orderNo;
	int? memberId;
	int? productQuantity;
	double? totalPayableMoney;
	int? status;
	String? statusStr;
	int? createTime;
	String? memberNickName;
	List<String>? productNames;
  
  LastOrderEntity();

  factory LastOrderEntity.fromJson(Map<String, dynamic> json) => $LastOrderEntityFromJson(json);

  Map<String, dynamic> toJson() => $LastOrderEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}