import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/menu/entity/special_price_activity.dart';

SpecialPriceActivity $SpecialPriceActivityFromJson(Map<String, dynamic> json) {
	final SpecialPriceActivity specialPriceActivity = SpecialPriceActivity();
	final String? activityNo = jsonConvert.convert<String>(json['activityNo']);
	if (activityNo != null) {
		specialPriceActivity.activityNo = activityNo;
	}
	final String? activityName = jsonConvert.convert<String>(json['activityName']);
	if (activityName != null) {
		specialPriceActivity.activityName = activityName;
	}
	final String? activityStartTime = jsonConvert.convert<String>(json['activityStartTime']);
	if (activityStartTime != null) {
		specialPriceActivity.activityStartTime = activityStartTime;
	}
	final String? activityEndTime = jsonConvert.convert<String>(json['activityEndTime']);
	if (activityEndTime != null) {
		specialPriceActivity.activityEndTime = activityEndTime;
	}
	final String? specialPrice = jsonConvert.convert<String>(json['specialPrice']);
	if (specialPrice != null) {
		specialPriceActivity.specialPrice = specialPrice;
	}
	final int? dailyLimit = jsonConvert.convert<int>(json['dailyLimit']);
	if (dailyLimit != null) {
		specialPriceActivity.dailyLimit = dailyLimit;
	}
	final int? dailySale = jsonConvert.convert<int>(json['dailySale']);
	if (dailySale != null) {
		specialPriceActivity.dailySale = dailySale;
	}
	final int? totalSale = jsonConvert.convert<int>(json['totalSale']);
	if (totalSale != null) {
		specialPriceActivity.totalSale = totalSale;
	}
	final int? activityType = jsonConvert.convert<int>(json['activityType']);
	if (activityType != null) {
		specialPriceActivity.activityType = activityType;
	}
	final String? activityTypeName = jsonConvert.convert<String>(json['activityTypeName']);
	if (activityTypeName != null) {
		specialPriceActivity.activityTypeName = activityTypeName;
	}
	return specialPriceActivity;
}

Map<String, dynamic> $SpecialPriceActivityToJson(SpecialPriceActivity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['activityNo'] = entity.activityNo;
	data['activityName'] = entity.activityName;
	data['activityStartTime'] = entity.activityStartTime;
	data['activityEndTime'] = entity.activityEndTime;
	data['specialPrice'] = entity.specialPrice;
	data['dailyLimit'] = entity.dailyLimit;
	data['dailySale'] = entity.dailySale;
	data['totalSale'] = entity.totalSale;
	data['activityType'] = entity.activityType;
	data['activityTypeName'] = entity.activityTypeName;
	return data;
}