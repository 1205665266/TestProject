import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_delivery_detail_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class OrderDeliveryDetailModelEntity {

	double? dispatcherLongitude;
	double? dispatcherLatitude;
	double? shippingAddressLongitude;
	double? shippingAddressLatitude;
	int? status;
  
  OrderDeliveryDetailModelEntity();

  factory OrderDeliveryDetailModelEntity.fromJson(Map<String, dynamic> json) => $OrderDeliveryDetailModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderDeliveryDetailModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}