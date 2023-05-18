import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/global/entity/static_text_entity.dart';

StaticTextEntity $StaticTextEntityFromJson(Map<String, dynamic> json) {
	final StaticTextEntity staticTextEntity = StaticTextEntity();
	final CommonContext? commonContext = jsonConvert.convert<CommonContext>(json['commonContext']);
	if (commonContext != null) {
		staticTextEntity.commonContext = commonContext;
	}
	final ConfirmOrderPage? confirmOrderPage = jsonConvert.convert<ConfirmOrderPage>(json['confirmOrderPage']);
	if (confirmOrderPage != null) {
		staticTextEntity.confirmOrderPage = confirmOrderPage;
	}
	return staticTextEntity;
}

Map<String, dynamic> $StaticTextEntityToJson(StaticTextEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['commonContext'] = entity.commonContext?.toJson();
	data['confirmOrderPage'] = entity.confirmOrderPage?.toJson();
	return data;
}

CommonContext $CommonContextFromJson(Map<String, dynamic> json) {
	final CommonContext commonContext = CommonContext();
	final String? specialActivityLabelForOrder = jsonConvert.convert<String>(json['specialActivityLabelForOrder']);
	if (specialActivityLabelForOrder != null) {
		commonContext.specialActivityLabelForOrder = specialActivityLabelForOrder;
	}
	final String? specialActivityLabel = jsonConvert.convert<String>(json['specialActivityLabel']);
	if (specialActivityLabel != null) {
		commonContext.specialActivityLabel = specialActivityLabel;
	}
	final String? buyNow = jsonConvert.convert<String>(json['buyNow']);
	if (buyNow != null) {
		commonContext.buyNow = buyNow;
	}
	final String? guidanceToBeOpened = jsonConvert.convert<String>(json['guidanceToBeOpened']);
	if (guidanceToBeOpened != null) {
		commonContext.guidanceToBeOpened = guidanceToBeOpened;
	}
	return commonContext;
}

Map<String, dynamic> $CommonContextToJson(CommonContext entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['specialActivityLabelForOrder'] = entity.specialActivityLabelForOrder;
	data['specialActivityLabel'] = entity.specialActivityLabel;
	data['buyNow'] = entity.buyNow;
	data['guidanceToBeOpened'] = entity.guidanceToBeOpened;
	return data;
}

ConfirmOrderPage $ConfirmOrderPageFromJson(Map<String, dynamic> json) {
	final ConfirmOrderPage confirmOrderPage = ConfirmOrderPage();
	final String? firstOrderFreeDispatchRuleTitle = jsonConvert.convert<String>(json['firstOrderFreeDispatchRuleTitle']);
	if (firstOrderFreeDispatchRuleTitle != null) {
		confirmOrderPage.firstOrderFreeDispatchRuleTitle = firstOrderFreeDispatchRuleTitle;
	}
	return confirmOrderPage;
}

Map<String, dynamic> $ConfirmOrderPageToJson(ConfirmOrderPage entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['firstOrderFreeDispatchRuleTitle'] = entity.firstOrderFreeDispatchRuleTitle;
	return data;
}