import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_status_str_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class OrderStatusStrEntity {

	String? status;
	String? statusStr;
	int? appTabStatus;
	String? orderDetailCopywriting;
  
  OrderStatusStrEntity();

  factory OrderStatusStrEntity.fromJson(Map<String, dynamic> json) => $OrderStatusStrEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderStatusStrEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}