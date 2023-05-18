import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_delivery_detail_model_entity.dart';

OrderDeliveryDetailModelEntity $OrderDeliveryDetailModelEntityFromJson(Map<String, dynamic> json) {
	final OrderDeliveryDetailModelEntity orderDeliveryDetailModelEntity = OrderDeliveryDetailModelEntity();
	final double? dispatcherLongitude = jsonConvert.convert<double>(json['dispatcherLongitude']);
	if (dispatcherLongitude != null) {
		orderDeliveryDetailModelEntity.dispatcherLongitude = dispatcherLongitude;
	}
	final double? dispatcherLatitude = jsonConvert.convert<double>(json['dispatcherLatitude']);
	if (dispatcherLatitude != null) {
		orderDeliveryDetailModelEntity.dispatcherLatitude = dispatcherLatitude;
	}
	final double? shippingAddressLongitude = jsonConvert.convert<double>(json['shippingAddressLongitude']);
	if (shippingAddressLongitude != null) {
		orderDeliveryDetailModelEntity.shippingAddressLongitude = shippingAddressLongitude;
	}
	final double? shippingAddressLatitude = jsonConvert.convert<double>(json['shippingAddressLatitude']);
	if (shippingAddressLatitude != null) {
		orderDeliveryDetailModelEntity.shippingAddressLatitude = shippingAddressLatitude;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		orderDeliveryDetailModelEntity.status = status;
	}
	return orderDeliveryDetailModelEntity;
}

Map<String, dynamic> $OrderDeliveryDetailModelEntityToJson(OrderDeliveryDetailModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['dispatcherLongitude'] = entity.dispatcherLongitude;
	data['dispatcherLatitude'] = entity.dispatcherLatitude;
	data['shippingAddressLongitude'] = entity.shippingAddressLongitude;
	data['shippingAddressLatitude'] = entity.shippingAddressLatitude;
	data['status'] = entity.status;
	return data;
}