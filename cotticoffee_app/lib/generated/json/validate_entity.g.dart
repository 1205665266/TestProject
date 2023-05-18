import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/entity/validate_entity.dart';

ValidateEntity $ValidateEntityFromJson(Map<String, dynamic> json) {
	final ValidateEntity validateEntity = ValidateEntity();
	final String? productName = jsonConvert.convert<String>(json['productName']);
	if (productName != null) {
		validateEntity.productName = productName;
	}
	final String? originalAmount = jsonConvert.convert<String>(json['originalAmount']);
	if (originalAmount != null) {
		validateEntity.originalAmount = originalAmount;
	}
	final String? payAmount = jsonConvert.convert<String>(json['payAmount']);
	if (payAmount != null) {
		validateEntity.payAmount = payAmount;
	}
	final String? couponName = jsonConvert.convert<String>(json['couponName']);
	if (couponName != null) {
		validateEntity.couponName = couponName;
	}
	final String? couponSubtitle = jsonConvert.convert<String>(json['couponSubtitle']);
	if (couponSubtitle != null) {
		validateEntity.couponSubtitle = couponSubtitle;
	}
	final String? num = jsonConvert.convert<String>(json['num']);
	if (num != null) {
		validateEntity.num = num;
	}
	final String? couponTemplateNo = jsonConvert.convert<String>(json['couponTemplateNo']);
	if (couponTemplateNo != null) {
		validateEntity.couponTemplateNo = couponTemplateNo;
	}
	final int? total = jsonConvert.convert<int>(json['total']);
	if (total != null) {
		validateEntity.total = total;
	}
	final int? templateType = jsonConvert.convert<int>(json['templateType']);
	if (templateType != null) {
		validateEntity.templateType = templateType;
	}
	final int? templateProductType = jsonConvert.convert<int>(json['templateProductType']);
	if (templateProductType != null) {
		validateEntity.templateProductType = templateProductType;
	}
	return validateEntity;
}

Map<String, dynamic> $ValidateEntityToJson(ValidateEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['productName'] = entity.productName;
	data['originalAmount'] = entity.originalAmount;
	data['payAmount'] = entity.payAmount;
	data['couponName'] = entity.couponName;
	data['couponSubtitle'] = entity.couponSubtitle;
	data['num'] = entity.num;
	data['couponTemplateNo'] = entity.couponTemplateNo;
	data['total'] = entity.total;
	data['templateType'] = entity.templateType;
	data['templateProductType'] = entity.templateProductType;
	return data;
}