import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/menu/entity/special_activity_limit.dart';

SpecialActivityLimit $SpecialActivityLimitFromJson(Map<String, dynamic> json) {
	final SpecialActivityLimit specialActivityLimit = SpecialActivityLimit();
	final int? activityStatus = jsonConvert.convert<int>(json['activityStatus']);
	if (activityStatus != null) {
		specialActivityLimit.activityStatus = activityStatus;
	}
	final int? limitAmount = jsonConvert.convert<int>(json['limitAmount']);
	if (limitAmount != null) {
		specialActivityLimit.limitAmount = limitAmount;
	}
	final int? activityShowType = jsonConvert.convert<int>(json['activityShowType']);
	if (activityShowType != null) {
		specialActivityLimit.activityShowType = activityShowType;
	}
	final int? memberLimitAmount = jsonConvert.convert<int>(json['memberLimitAmount']);
	if (memberLimitAmount != null) {
		specialActivityLimit.memberLimitAmount = memberLimitAmount;
	}
	final int? shopPlusNum = jsonConvert.convert<int>(json['shopPlusNum']);
	if (shopPlusNum != null) {
		specialActivityLimit.shopPlusNum = shopPlusNum;
	}
	final double? limitProgressBar = jsonConvert.convert<double>(json['limitProgressBar']);
	if (limitProgressBar != null) {
		specialActivityLimit.limitProgressBar = limitProgressBar;
	}
	final double? discountRate = jsonConvert.convert<double>(json['discountRate']);
	if (discountRate != null) {
		specialActivityLimit.discountRate = discountRate;
	}
	final int? specialShowCountdown = jsonConvert.convert<int>(json['specialShowCountdown']);
	if (specialShowCountdown != null) {
		specialActivityLimit.specialShowCountdown = specialShowCountdown;
	}
	return specialActivityLimit;
}

Map<String, dynamic> $SpecialActivityLimitToJson(SpecialActivityLimit entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['activityStatus'] = entity.activityStatus;
	data['limitAmount'] = entity.limitAmount;
	data['activityShowType'] = entity.activityShowType;
	data['memberLimitAmount'] = entity.memberLimitAmount;
	data['shopPlusNum'] = entity.shopPlusNum;
	data['limitProgressBar'] = entity.limitProgressBar;
	data['discountRate'] = entity.discountRate;
	data['specialShowCountdown'] = entity.specialShowCountdown;
	return data;
}