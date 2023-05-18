import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_cal_entity.g.dart';
import 'dart:convert';

import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';

@JsonSerializable()
class OrderCalEntity {

	int? usedVoucherCount;
	String? totalMoney;
	String? discountMoney;

  List<OrderConfirmModelConfirmGoodsItems>? confirmGoodsItems;
  OrderConfirmModelFinanceDetail? financeDetail;

  List<VoucherSkuModelEntity>? useVoucherSkus;
  
  OrderCalEntity();

  factory OrderCalEntity.fromJson(Map<String, dynamic> json) => $OrderCalEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderCalEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}