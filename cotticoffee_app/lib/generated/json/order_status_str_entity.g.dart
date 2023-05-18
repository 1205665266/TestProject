import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_status_str_entity.dart';

OrderStatusStrEntity $OrderStatusStrEntityFromJson(Map<String, dynamic> json) {
	final OrderStatusStrEntity orderStatusStrEntity = OrderStatusStrEntity();
	final String? status = jsonConvert.convert<String>(json['status']);
	if (status != null) {
		orderStatusStrEntity.status = status;
	}
	final String? statusStr = jsonConvert.convert<String>(json['statusStr']);
	if (statusStr != null) {
		orderStatusStrEntity.statusStr = statusStr;
	}
	final int? appTabStatus = jsonConvert.convert<int>(json['appTabStatus']);
	if (appTabStatus != null) {
		orderStatusStrEntity.appTabStatus = appTabStatus;
	}
	final String? orderDetailCopywriting = jsonConvert.convert<String>(json['orderDetailCopywriting']);
	if (orderDetailCopywriting != null) {
		orderStatusStrEntity.orderDetailCopywriting = orderDetailCopywriting;
	}
	return orderStatusStrEntity;
}

Map<String, dynamic> $OrderStatusStrEntityToJson(OrderStatusStrEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['status'] = entity.status;
	data['statusStr'] = entity.statusStr;
	data['appTabStatus'] = entity.appTabStatus;
	data['orderDetailCopywriting'] = entity.orderDetailCopywriting;
	return data;
}