import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_voucher_count_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class OrderVoucherCountModelEntity {

	int? availableVoucherCount;
	int? unavailableVoucherCount;
  
  OrderVoucherCountModelEntity();

  factory OrderVoucherCountModelEntity.fromJson(Map<String, dynamic> json) => $OrderVoucherCountModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderVoucherCountModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}