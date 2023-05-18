import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/order_cal_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';

import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';


OrderCalEntity $OrderCalEntityFromJson(Map<String, dynamic> json) {
	final OrderCalEntity orderCalEntity = OrderCalEntity();
	final int? usedVoucherCount = jsonConvert.convert<int>(json['usedVoucherCount']);
	if (usedVoucherCount != null) {
		orderCalEntity.usedVoucherCount = usedVoucherCount;
	}
	final String? totalMoney = jsonConvert.convert<String>(json['totalMoney']);
	if (totalMoney != null) {
		orderCalEntity.totalMoney = totalMoney;
	}
	final String? discountMoney = jsonConvert.convert<String>(json['discountMoney']);
	if (discountMoney != null) {
		orderCalEntity.discountMoney = discountMoney;
	}
	final List<OrderConfirmModelConfirmGoodsItems>? confirmGoodsItems = jsonConvert.convertListNotNull<OrderConfirmModelConfirmGoodsItems>(json['confirmGoodsItems']);
	if (confirmGoodsItems != null) {
		orderCalEntity.confirmGoodsItems = confirmGoodsItems;
	}
	final OrderConfirmModelFinanceDetail? financeDetail = jsonConvert.convert<OrderConfirmModelFinanceDetail>(json['financeDetail']);
	if (financeDetail != null) {
		orderCalEntity.financeDetail = financeDetail;
	}
	final List<VoucherSkuModelEntity>? useVoucherSkus = jsonConvert.convertListNotNull<VoucherSkuModelEntity>(json['useVoucherSkus']);
	if (useVoucherSkus != null) {
		orderCalEntity.useVoucherSkus = useVoucherSkus;
	}
	return orderCalEntity;
}

Map<String, dynamic> $OrderCalEntityToJson(OrderCalEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['usedVoucherCount'] = entity.usedVoucherCount;
	data['totalMoney'] = entity.totalMoney;
	data['discountMoney'] = entity.discountMoney;
	data['confirmGoodsItems'] =  entity.confirmGoodsItems?.map((v) => v.toJson()).toList();
	data['financeDetail'] = entity.financeDetail?.toJson();
	data['useVoucherSkus'] =  entity.useVoucherSkus?.map((v) => v.toJson()).toList();
	return data;
}