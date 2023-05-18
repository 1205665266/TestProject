import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/bonus/entity/bonus_log_entity.dart';

BonusLogEntity $BonusLogEntityFromJson(Map<String, dynamic> json) {
	final BonusLogEntity bonusLogEntity = BonusLogEntity();
	final String? businessName = jsonConvert.convert<String>(json['businessName']);
	if (businessName != null) {
		bonusLogEntity.businessName = businessName;
	}
	final int? operationType = jsonConvert.convert<int>(json['operationType']);
	if (operationType != null) {
		bonusLogEntity.operationType = operationType;
	}
	final int? operationValue = jsonConvert.convert<int>(json['operationValue']);
	if (operationValue != null) {
		bonusLogEntity.operationValue = operationValue;
	}
	final String? operationDate = jsonConvert.convert<String>(json['operationDate']);
	if (operationDate != null) {
		bonusLogEntity.operationDate = operationDate;
	}
	final String? orderNo = jsonConvert.convert<String>(json['orderNo']);
	if (orderNo != null) {
		bonusLogEntity.orderNo = orderNo;
	}
	return bonusLogEntity;
}

Map<String, dynamic> $BonusLogEntityToJson(BonusLogEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['businessName'] = entity.businessName;
	data['operationType'] = entity.operationType;
	data['operationValue'] = entity.operationValue;
	data['operationDate'] = entity.operationDate;
	data['orderNo'] = entity.orderNo;
	return data;
}