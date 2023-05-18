import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/my/entity/coupon_exchange_statement_entity.dart';

CouponExchangeStatementEntity $CouponExchangeStatementEntityFromJson(Map<String, dynamic> json) {
	final CouponExchangeStatementEntity couponExchangeStatementEntity = CouponExchangeStatementEntity();
	final int? appKeyBoardType = jsonConvert.convert<int>(json['appKeyBoardType']);
	if (appKeyBoardType != null) {
		couponExchangeStatementEntity.appKeyBoardType = appKeyBoardType;
	}
	final CouponExchangeStatement? couponExchangeStatement = jsonConvert.convert<CouponExchangeStatement>(json['couponExchangeStatement']);
	if (couponExchangeStatement != null) {
		couponExchangeStatementEntity.couponExchangeStatement = couponExchangeStatement;
	}
	return couponExchangeStatementEntity;
}

Map<String, dynamic> $CouponExchangeStatementEntityToJson(CouponExchangeStatementEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['appKeyBoardType'] = entity.appKeyBoardType;
	data['couponExchangeStatement'] = entity.couponExchangeStatement?.toJson();
	return data;
}

CouponExchangeStatement $CouponExchangeStatementFromJson(Map<String, dynamic> json) {
	final CouponExchangeStatement couponExchangeStatement = CouponExchangeStatement();
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		couponExchangeStatement.title = title;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		couponExchangeStatement.content = content;
	}
	return couponExchangeStatement;
}

Map<String, dynamic> $CouponExchangeStatementToJson(CouponExchangeStatement entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['title'] = entity.title;
	data['content'] = entity.content;
	return data;
}