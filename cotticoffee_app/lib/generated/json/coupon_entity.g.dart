import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/coupon/coupon_list/entity/coupon_entity.dart';

CouponEntity $CouponEntityFromJson(Map<String, dynamic> json) {
	final CouponEntity couponEntity = CouponEntity();
	final int? tenantCode = jsonConvert.convert<int>(json['tenantCode']);
	if (tenantCode != null) {
		couponEntity.tenantCode = tenantCode;
	}
	final String? couponNo = jsonConvert.convert<String>(json['couponNo']);
	if (couponNo != null) {
		couponEntity.couponNo = couponNo;
	}
	final int? couponType = jsonConvert.convert<int>(json['couponType']);
	if (couponType != null) {
		couponEntity.couponType = couponType;
	}
	final int? condition = jsonConvert.convert<int>(json['condition']);
	if (condition != null) {
		couponEntity.condition = condition;
	}
	final double? value = jsonConvert.convert<double>(json['value']);
	if (value != null) {
		couponEntity.value = value;
	}
	final String? strValue = jsonConvert.convert<String>(json['strValue']);
	if (strValue != null) {
		couponEntity.strValue = strValue;
	}
	final int? limit = jsonConvert.convert<int>(json['limit']);
	if (limit != null) {
		couponEntity.limit = limit;
	}
	final int? productType = jsonConvert.convert<int>(json['productType']);
	if (productType != null) {
		couponEntity.productType = productType;
	}
	final String? terminalScope = jsonConvert.convert<String>(json['terminalScope']);
	if (terminalScope != null) {
		couponEntity.terminalScope = terminalScope;
	}
	final String? takeFoodScope = jsonConvert.convert<String>(json['takeFoodScope']);
	if (takeFoodScope != null) {
		couponEntity.takeFoodScope = takeFoodScope;
	}
	final bool? available = jsonConvert.convert<bool>(json['available']);
	if (available != null) {
		couponEntity.available = available;
	}
	final String? activityNo = jsonConvert.convert<String>(json['activityNo']);
	if (activityNo != null) {
		couponEntity.activityNo = activityNo;
	}
	final String? templateNo = jsonConvert.convert<String>(json['templateNo']);
	if (templateNo != null) {
		couponEntity.templateNo = templateNo;
	}
	final String? couponName = jsonConvert.convert<String>(json['couponName']);
	if (couponName != null) {
		couponEntity.couponName = couponName;
	}
	final String? couponSubTitle = jsonConvert.convert<String>(json['couponSubTitle']);
	if (couponSubTitle != null) {
		couponEntity.couponSubTitle = couponSubTitle;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		couponEntity.title = title;
	}
	final String? threshold = jsonConvert.convert<String>(json['threshold']);
	if (threshold != null) {
		couponEntity.threshold = threshold;
	}
	final String? couponRestrict = jsonConvert.convert<String>(json['couponRestrict']);
	if (couponRestrict != null) {
		couponEntity.couponRestrict = couponRestrict;
	}
	final String? couponDesc = jsonConvert.convert<String>(json['couponDesc']);
	if (couponDesc != null) {
		couponEntity.couponDesc = couponDesc;
	}
	final String? couponImage = jsonConvert.convert<String>(json['couponImage']);
	if (couponImage != null) {
		couponEntity.couponImage = couponImage;
	}
	final String? startTime = jsonConvert.convert<String>(json['startTime']);
	if (startTime != null) {
		couponEntity.startTime = startTime;
	}
	final String? endTime = jsonConvert.convert<String>(json['endTime']);
	if (endTime != null) {
		couponEntity.endTime = endTime;
	}
	final List<String>? timeScopeList = jsonConvert.convertListNotNull<String>(json['timeScopeList']);
	if (timeScopeList != null) {
		couponEntity.timeScopeList = timeScopeList;
	}
	final int? couponTypeTranslate = jsonConvert.convert<int>(json['couponTypeTranslate']);
	if (couponTypeTranslate != null) {
		couponEntity.couponTypeTranslate = couponTypeTranslate;
	}
	return couponEntity;
}

Map<String, dynamic> $CouponEntityToJson(CouponEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['tenantCode'] = entity.tenantCode;
	data['couponNo'] = entity.couponNo;
	data['couponType'] = entity.couponType;
	data['condition'] = entity.condition;
	data['value'] = entity.value;
	data['strValue'] = entity.strValue;
	data['limit'] = entity.limit;
	data['productType'] = entity.productType;
	data['terminalScope'] = entity.terminalScope;
	data['takeFoodScope'] = entity.takeFoodScope;
	data['available'] = entity.available;
	data['activityNo'] = entity.activityNo;
	data['templateNo'] = entity.templateNo;
	data['couponName'] = entity.couponName;
	data['couponSubTitle'] = entity.couponSubTitle;
	data['title'] = entity.title;
	data['threshold'] = entity.threshold;
	data['couponRestrict'] = entity.couponRestrict;
	data['couponDesc'] = entity.couponDesc;
	data['couponImage'] = entity.couponImage;
	data['startTime'] = entity.startTime;
	data['endTime'] = entity.endTime;
	data['timeScopeList'] =  entity.timeScopeList;
	data['couponTypeTranslate'] = entity.couponTypeTranslate;
	return data;
}