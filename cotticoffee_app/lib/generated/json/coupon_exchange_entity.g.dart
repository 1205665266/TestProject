import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/entity/coupon_exchange_entity.dart';

CouponExchangeEntity $CouponExchangeEntityFromJson(Map<String, dynamic> json) {
	final CouponExchangeEntity couponExchangeEntity = CouponExchangeEntity();
	final String? couponName = jsonConvert.convert<String>(json['couponName']);
	if (couponName != null) {
		couponExchangeEntity.couponName = couponName;
	}
	final String? couponSubtitle = jsonConvert.convert<String>(json['couponSubtitle']);
	if (couponSubtitle != null) {
		couponExchangeEntity.couponSubtitle = couponSubtitle;
	}
	final String? num = jsonConvert.convert<String>(json['num']);
	if (num != null) {
		couponExchangeEntity.num = num;
	}
	return couponExchangeEntity;
}

Map<String, dynamic> $CouponExchangeEntityToJson(CouponExchangeEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['couponName'] = entity.couponName;
	data['couponSubtitle'] = entity.couponSubtitle;
	data['num'] = entity.num;
	return data;
}