import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';

CashCouponEntity $CashCouponEntityFromJson(Map<String, dynamic> json) {
	final CashCouponEntity cashCouponEntity = CashCouponEntity();
	final String? partnerName = jsonConvert.convert<String>(json['partnerName']);
	if (partnerName != null) {
		cashCouponEntity.partnerName = partnerName;
	}
	final String? useTime = jsonConvert.convert<String>(json['useTime']);
	if (useTime != null) {
		cashCouponEntity.useTime = useTime;
	}
	final String? invalidTime = jsonConvert.convert<String>(json['invalidTime']);
	if (invalidTime != null) {
		cashCouponEntity.invalidTime = invalidTime;
	}
	final int? count = jsonConvert.convert<int>(json['count']);
	if (count != null) {
		cashCouponEntity.count = count;
	}
	final int? groupNum = jsonConvert.convert<int>(json['groupNum']);
	if (groupNum != null) {
		cashCouponEntity.groupNum = groupNum;
	}
	final int? tenantCode = jsonConvert.convert<int>(json['tenantCode']);
	if (tenantCode != null) {
		cashCouponEntity.tenantCode = tenantCode;
	}
	final String? couponNo = jsonConvert.convert<String>(json['couponNo']);
	if (couponNo != null) {
		cashCouponEntity.couponNo = couponNo;
	}
	final int? couponType = jsonConvert.convert<int>(json['couponType']);
	if (couponType != null) {
		cashCouponEntity.couponType = couponType;
	}
	final int? condition = jsonConvert.convert<int>(json['condition']);
	if (condition != null) {
		cashCouponEntity.condition = condition;
	}
	final double? value = jsonConvert.convert<double>(json['value']);
	if (value != null) {
		cashCouponEntity.value = value;
	}
	final String? strValue = jsonConvert.convert<String>(json['strValue']);
	if (strValue != null) {
		cashCouponEntity.strValue = strValue;
	}
	final int? limit = jsonConvert.convert<int>(json['limit']);
	if (limit != null) {
		cashCouponEntity.limit = limit;
	}
	final int? productType = jsonConvert.convert<int>(json['productType']);
	if (productType != null) {
		cashCouponEntity.productType = productType;
	}
	final String? terminalScope = jsonConvert.convert<String>(json['terminalScope']);
	if (terminalScope != null) {
		cashCouponEntity.terminalScope = terminalScope;
	}
	final String? takeFoodScope = jsonConvert.convert<String>(json['takeFoodScope']);
	if (takeFoodScope != null) {
		cashCouponEntity.takeFoodScope = takeFoodScope;
	}
	final bool? available = jsonConvert.convert<bool>(json['available']);
	if (available != null) {
		cashCouponEntity.available = available;
	}
	final String? activityNo = jsonConvert.convert<String>(json['activityNo']);
	if (activityNo != null) {
		cashCouponEntity.activityNo = activityNo;
	}
	final String? templateNo = jsonConvert.convert<String>(json['templateNo']);
	if (templateNo != null) {
		cashCouponEntity.templateNo = templateNo;
	}
	final String? couponName = jsonConvert.convert<String>(json['couponName']);
	if (couponName != null) {
		cashCouponEntity.couponName = couponName;
	}
	final String? couponSubTitle = jsonConvert.convert<String>(json['couponSubTitle']);
	if (couponSubTitle != null) {
		cashCouponEntity.couponSubTitle = couponSubTitle;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		cashCouponEntity.title = title;
	}
	final String? threshold = jsonConvert.convert<String>(json['threshold']);
	if (threshold != null) {
		cashCouponEntity.threshold = threshold;
	}
	final String? couponRestrict = jsonConvert.convert<String>(json['couponRestrict']);
	if (couponRestrict != null) {
		cashCouponEntity.couponRestrict = couponRestrict;
	}
	final String? couponDesc = jsonConvert.convert<String>(json['couponDesc']);
	if (couponDesc != null) {
		cashCouponEntity.couponDesc = couponDesc;
	}
	final String? couponImage = jsonConvert.convert<String>(json['couponImage']);
	if (couponImage != null) {
		cashCouponEntity.couponImage = couponImage;
	}
	final String? startTime = jsonConvert.convert<String>(json['startTime']);
	if (startTime != null) {
		cashCouponEntity.startTime = startTime;
	}
	final String? endTime = jsonConvert.convert<String>(json['endTime']);
	if (endTime != null) {
		cashCouponEntity.endTime = endTime;
	}
	final List<String>? timeScopeList = jsonConvert.convertListNotNull<String>(json['timeScopeList']);
	if (timeScopeList != null) {
		cashCouponEntity.timeScopeList = timeScopeList;
	}
	final int? couponTypeTranslate = jsonConvert.convert<int>(json['couponTypeTranslate']);
	if (couponTypeTranslate != null) {
		cashCouponEntity.couponTypeTranslate = couponTypeTranslate;
	}
	final String? recentlyExpiredDate = jsonConvert.convert<String>(json['recentlyExpiredDate']);
	if (recentlyExpiredDate != null) {
		cashCouponEntity.recentlyExpiredDate = recentlyExpiredDate;
	}
	final int? invalidType = jsonConvert.convert<int>(json['invalidType']);
	if (invalidType != null) {
		cashCouponEntity.invalidType = invalidType;
	}
	final int? sendType = jsonConvert.convert<int>(json['sendType']);
	if (sendType != null) {
		cashCouponEntity.sendType = sendType;
	}
	final int? occupied = jsonConvert.convert<int>(json['occupied']);
	if (occupied != null) {
		cashCouponEntity.occupied = occupied;
	}
	final String? canNotBeStackedTip = jsonConvert.convert<String>(json['canNotBeStackedTip']);
	if (canNotBeStackedTip != null) {
		cashCouponEntity.canNotBeStackedTip = canNotBeStackedTip;
	}
	final int? canNotBeStackedButtonType = jsonConvert.convert<int>(json['canNotBeStackedButtonType']);
	if (canNotBeStackedButtonType != null) {
		cashCouponEntity.canNotBeStackedButtonType = canNotBeStackedButtonType;
	}
	final List<String>? skuCodes = jsonConvert.convertListNotNull<String>(json['skuCodes']);
	if (skuCodes != null) {
		cashCouponEntity.skuCodes = skuCodes;
	}
	return cashCouponEntity;
}

Map<String, dynamic> $CashCouponEntityToJson(CashCouponEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['partnerName'] = entity.partnerName;
	data['useTime'] = entity.useTime;
	data['invalidTime'] = entity.invalidTime;
	data['count'] = entity.count;
	data['groupNum'] = entity.groupNum;
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
	data['recentlyExpiredDate'] = entity.recentlyExpiredDate;
	data['invalidType'] = entity.invalidType;
	data['sendType'] = entity.sendType;
	data['occupied'] = entity.occupied;
	data['canNotBeStackedTip'] = entity.canNotBeStackedTip;
	data['canNotBeStackedButtonType'] = entity.canNotBeStackedButtonType;
	data['skuCodes'] =  entity.skuCodes;
	return data;
}