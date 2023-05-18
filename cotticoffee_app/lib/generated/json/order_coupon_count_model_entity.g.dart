import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_count_model_entity.dart';

OrderCouponCountModelEntity $OrderCouponCountModelEntityFromJson(Map<String, dynamic> json) {
	final OrderCouponCountModelEntity orderCouponCountModelEntity = OrderCouponCountModelEntity();
	final int? availableCouponCount = jsonConvert.convert<int>(json['availableCouponCount']);
	if (availableCouponCount != null) {
		orderCouponCountModelEntity.availableCouponCount = availableCouponCount;
	}
	final int? unavailableCouponCount = jsonConvert.convert<int>(json['unavailableCouponCount']);
	if (unavailableCouponCount != null) {
		orderCouponCountModelEntity.unavailableCouponCount = unavailableCouponCount;
	}
	return orderCouponCountModelEntity;
}

Map<String, dynamic> $OrderCouponCountModelEntityToJson(OrderCouponCountModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['availableCouponCount'] = entity.availableCouponCount;
	data['unavailableCouponCount'] = entity.unavailableCouponCount;
	return data;
}