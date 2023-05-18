import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_voucher_dto_entity.g.dart';
import 'dart:convert';

import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';

@JsonSerializable()
class OrderVoucherDtoEntity {

	int? availableCount;
	int? unAvailableCount;

  @JSONField(name:"confirmOrderCouponDtoList")
  List<CashCouponEntity>? voucherModelList;
  
  OrderVoucherDtoEntity();

  factory OrderVoucherDtoEntity.fromJson(Map<String, dynamic> json) => $OrderVoucherDtoEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderVoucherDtoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}