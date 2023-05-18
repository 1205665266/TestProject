import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/order_voucher_count_model_entity.dart';

OrderVoucherCountModelEntity $OrderVoucherCountModelEntityFromJson(Map<String, dynamic> json) {
	final OrderVoucherCountModelEntity orderVoucherCountModelEntity = OrderVoucherCountModelEntity();
	final int? availableVoucherCount = jsonConvert.convert<int>(json['availableVoucherCount']);
	if (availableVoucherCount != null) {
		orderVoucherCountModelEntity.availableVoucherCount = availableVoucherCount;
	}
	final int? unavailableVoucherCount = jsonConvert.convert<int>(json['unavailableVoucherCount']);
	if (unavailableVoucherCount != null) {
		orderVoucherCountModelEntity.unavailableVoucherCount = unavailableVoucherCount;
	}
	return orderVoucherCountModelEntity;
}

Map<String, dynamic> $OrderVoucherCountModelEntityToJson(OrderVoucherCountModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['availableVoucherCount'] = entity.availableVoucherCount;
	data['unavailableVoucherCount'] = entity.unavailableVoucherCount;
	return data;
}