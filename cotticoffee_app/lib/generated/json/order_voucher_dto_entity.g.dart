import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/order_voucher_dto_entity.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';


OrderVoucherDtoEntity $OrderVoucherDtoEntityFromJson(Map<String, dynamic> json) {
	final OrderVoucherDtoEntity orderVoucherDtoEntity = OrderVoucherDtoEntity();
	final int? availableCount = jsonConvert.convert<int>(json['availableCount']);
	if (availableCount != null) {
		orderVoucherDtoEntity.availableCount = availableCount;
	}
	final int? unAvailableCount = jsonConvert.convert<int>(json['unAvailableCount']);
	if (unAvailableCount != null) {
		orderVoucherDtoEntity.unAvailableCount = unAvailableCount;
	}
	final List<CashCouponEntity>? voucherModelList = jsonConvert.convertListNotNull<CashCouponEntity>(json['confirmOrderCouponDtoList']);
	if (voucherModelList != null) {
		orderVoucherDtoEntity.voucherModelList = voucherModelList;
	}
	return orderVoucherDtoEntity;
}

Map<String, dynamic> $OrderVoucherDtoEntityToJson(OrderVoucherDtoEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['availableCount'] = entity.availableCount;
	data['unAvailableCount'] = entity.unAvailableCount;
	data['confirmOrderCouponDtoList'] =  entity.voucherModelList?.map((v) => v.toJson()).toList();
	return data;
}