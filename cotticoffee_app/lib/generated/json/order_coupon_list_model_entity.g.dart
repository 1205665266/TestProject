import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_list_model_entity.dart';

OrderCouponListModelEntity $OrderCouponListModelEntityFromJson(Map<String, dynamic> json) {
	final OrderCouponListModelEntity orderCouponListModelEntity = OrderCouponListModelEntity();
	final List<OrderCouponListModelConfirmOrderCouponDtoList>? confirmOrderCouponDtoList = jsonConvert.convertListNotNull<OrderCouponListModelConfirmOrderCouponDtoList>(json['confirmOrderCouponDtoList']);
	if (confirmOrderCouponDtoList != null) {
		orderCouponListModelEntity.confirmOrderCouponDtoList = confirmOrderCouponDtoList;
	}
	return orderCouponListModelEntity;
}

Map<String, dynamic> $OrderCouponListModelEntityToJson(OrderCouponListModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['confirmOrderCouponDtoList'] =  entity.confirmOrderCouponDtoList?.map((v) => v.toJson()).toList();
	return data;
}

OrderCouponListModelConfirmOrderCouponDtoList $OrderCouponListModelConfirmOrderCouponDtoListFromJson(Map<String, dynamic> json) {
	final OrderCouponListModelConfirmOrderCouponDtoList orderCouponListModelConfirmOrderCouponDtoList = OrderCouponListModelConfirmOrderCouponDtoList();
	final int? tenantCode = jsonConvert.convert<int>(json['tenantCode']);
	if (tenantCode != null) {
		orderCouponListModelConfirmOrderCouponDtoList.tenantCode = tenantCode;
	}
	final String? couponNo = jsonConvert.convert<String>(json['couponNo']);
	if (couponNo != null) {
		orderCouponListModelConfirmOrderCouponDtoList.couponNo = couponNo;
	}
	final int? couponType = jsonConvert.convert<int>(json['couponType']);
	if (couponType != null) {
		orderCouponListModelConfirmOrderCouponDtoList.couponType = couponType;
	}
	final double? condition = jsonConvert.convert<double>(json['condition']);
	if (condition != null) {
		orderCouponListModelConfirmOrderCouponDtoList.condition = condition;
	}
	final double? value = jsonConvert.convert<double>(json['value']);
	if (value != null) {
		orderCouponListModelConfirmOrderCouponDtoList.value = value;
	}
	final String? strValue = jsonConvert.convert<String>(json['strValue']);
	if (strValue != null) {
		orderCouponListModelConfirmOrderCouponDtoList.strValue = strValue;
	}
	final double? limit = jsonConvert.convert<double>(json['limit']);
	if (limit != null) {
		orderCouponListModelConfirmOrderCouponDtoList.limit = limit;
	}
	final int? productType = jsonConvert.convert<int>(json['productType']);
	if (productType != null) {
		orderCouponListModelConfirmOrderCouponDtoList.productType = productType;
	}
	final String? terminalScope = jsonConvert.convert<String>(json['terminalScope']);
	if (terminalScope != null) {
		orderCouponListModelConfirmOrderCouponDtoList.terminalScope = terminalScope;
	}
	final String? takeFoodScope = jsonConvert.convert<String>(json['takeFoodScope']);
	if (takeFoodScope != null) {
		orderCouponListModelConfirmOrderCouponDtoList.takeFoodScope = takeFoodScope;
	}
	final bool? available = jsonConvert.convert<bool>(json['available']);
	if (available != null) {
		orderCouponListModelConfirmOrderCouponDtoList.available = available;
	}
	final String? activityNo = jsonConvert.convert<String>(json['activityNo']);
	if (activityNo != null) {
		orderCouponListModelConfirmOrderCouponDtoList.activityNo = activityNo;
	}
	final String? templateNo = jsonConvert.convert<String>(json['templateNo']);
	if (templateNo != null) {
		orderCouponListModelConfirmOrderCouponDtoList.templateNo = templateNo;
	}
	final String? couponName = jsonConvert.convert<String>(json['couponName']);
	if (couponName != null) {
		orderCouponListModelConfirmOrderCouponDtoList.couponName = couponName;
	}
	final String? couponSubTitle = jsonConvert.convert<String>(json['couponSubTitle']);
	if (couponSubTitle != null) {
		orderCouponListModelConfirmOrderCouponDtoList.couponSubTitle = couponSubTitle;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		orderCouponListModelConfirmOrderCouponDtoList.title = title;
	}
	final String? threshold = jsonConvert.convert<String>(json['threshold']);
	if (threshold != null) {
		orderCouponListModelConfirmOrderCouponDtoList.threshold = threshold;
	}
	final String? couponRestrict = jsonConvert.convert<String>(json['couponRestrict']);
	if (couponRestrict != null) {
		orderCouponListModelConfirmOrderCouponDtoList.couponRestrict = couponRestrict;
	}
	final String? couponDesc = jsonConvert.convert<String>(json['couponDesc']);
	if (couponDesc != null) {
		orderCouponListModelConfirmOrderCouponDtoList.couponDesc = couponDesc;
	}
	final dynamic couponImage = jsonConvert.convert<dynamic>(json['couponImage']);
	if (couponImage != null) {
		orderCouponListModelConfirmOrderCouponDtoList.couponImage = couponImage;
	}
	final String? startTime = jsonConvert.convert<String>(json['startTime']);
	if (startTime != null) {
		orderCouponListModelConfirmOrderCouponDtoList.startTime = startTime;
	}
	final String? endTime = jsonConvert.convert<String>(json['endTime']);
	if (endTime != null) {
		orderCouponListModelConfirmOrderCouponDtoList.endTime = endTime;
	}
	final dynamic realDiscount = jsonConvert.convert<dynamic>(json['realDiscount']);
	if (realDiscount != null) {
		orderCouponListModelConfirmOrderCouponDtoList.realDiscount = realDiscount;
	}
	final dynamic timeScopeList = jsonConvert.convert<dynamic>(json['timeScopeList']);
	if (timeScopeList != null) {
		orderCouponListModelConfirmOrderCouponDtoList.timeScopeList = timeScopeList;
	}
	final int? couponTypeTranslate = jsonConvert.convert<int>(json['couponTypeTranslate']);
	if (couponTypeTranslate != null) {
		orderCouponListModelConfirmOrderCouponDtoList.couponTypeTranslate = couponTypeTranslate;
	}
	final int? sendType = jsonConvert.convert<int>(json['sendType']);
	if (sendType != null) {
		orderCouponListModelConfirmOrderCouponDtoList.sendType = sendType;
	}
	final int? invalidType = jsonConvert.convert<int>(json['invalidType']);
	if (invalidType != null) {
		orderCouponListModelConfirmOrderCouponDtoList.invalidType = invalidType;
	}
	final double? discountPrice = jsonConvert.convert<double>(json['discountPrice']);
	if (discountPrice != null) {
		orderCouponListModelConfirmOrderCouponDtoList.discountPrice = discountPrice;
	}
	final String? canNotBeStackedTip = jsonConvert.convert<String>(json['canNotBeStackedTip']);
	if (canNotBeStackedTip != null) {
		orderCouponListModelConfirmOrderCouponDtoList.canNotBeStackedTip = canNotBeStackedTip;
	}
	final int? canNotBeStackedButtonType = jsonConvert.convert<int>(json['canNotBeStackedButtonType']);
	if (canNotBeStackedButtonType != null) {
		orderCouponListModelConfirmOrderCouponDtoList.canNotBeStackedButtonType = canNotBeStackedButtonType;
	}
	final List<String>? skuCodes = jsonConvert.convertListNotNull<String>(json['skuCodes']);
	if (skuCodes != null) {
		orderCouponListModelConfirmOrderCouponDtoList.skuCodes = skuCodes;
	}
	final String? canNotBeStackedContext = jsonConvert.convert<String>(json['canNotBeStackedContext']);
	if (canNotBeStackedContext != null) {
		orderCouponListModelConfirmOrderCouponDtoList.canNotBeStackedContext = canNotBeStackedContext;
	}
	return orderCouponListModelConfirmOrderCouponDtoList;
}

Map<String, dynamic> $OrderCouponListModelConfirmOrderCouponDtoListToJson(OrderCouponListModelConfirmOrderCouponDtoList entity) {
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
	data['realDiscount'] = entity.realDiscount;
	data['timeScopeList'] = entity.timeScopeList;
	data['couponTypeTranslate'] = entity.couponTypeTranslate;
	data['sendType'] = entity.sendType;
	data['invalidType'] = entity.invalidType;
	data['discountPrice'] = entity.discountPrice;
	data['canNotBeStackedTip'] = entity.canNotBeStackedTip;
	data['canNotBeStackedButtonType'] = entity.canNotBeStackedButtonType;
	data['skuCodes'] =  entity.skuCodes;
	data['canNotBeStackedContext'] = entity.canNotBeStackedContext;
	return data;
}