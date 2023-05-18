import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/shopping_cart/entity/specials_daily_limit_check_entity.dart';

SpecialsDailyLimitCheckEntity $SpecialsDailyLimitCheckEntityFromJson(Map<String, dynamic> json) {
	final SpecialsDailyLimitCheckEntity specialsDailyLimitCheckEntity = SpecialsDailyLimitCheckEntity();
	final bool? displayToastTips = jsonConvert.convert<bool>(json['displayToastTips']);
	if (displayToastTips != null) {
		specialsDailyLimitCheckEntity.displayToastTips = displayToastTips;
	}
	final String? toastTips = jsonConvert.convert<String>(json['toastTips']);
	if (toastTips != null) {
		specialsDailyLimitCheckEntity.toastTips = toastTips;
	}
	return specialsDailyLimitCheckEntity;
}

Map<String, dynamic> $SpecialsDailyLimitCheckEntityToJson(SpecialsDailyLimitCheckEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['displayToastTips'] = entity.displayToastTips;
	data['toastTips'] = entity.toastTips;
	return data;
}