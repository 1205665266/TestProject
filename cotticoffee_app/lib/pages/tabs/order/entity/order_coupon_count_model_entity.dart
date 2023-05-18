import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_coupon_count_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class OrderCouponCountModelEntity {

	int? availableCouponCount;
	int? unavailableCouponCount;
  
  OrderCouponCountModelEntity();

  factory OrderCouponCountModelEntity.fromJson(Map<String, dynamic> json) => $OrderCouponCountModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderCouponCountModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}