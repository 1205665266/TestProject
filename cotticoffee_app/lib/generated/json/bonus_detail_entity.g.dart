import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/bonus/entity/bonus_detail_entity.dart';

BonusDetailEntity $BonusDetailEntityFromJson(Map<String, dynamic> json) {
	final BonusDetailEntity bonusDetailEntity = BonusDetailEntity();
	final int? balance = jsonConvert.convert<int>(json['balance']);
	if (balance != null) {
		bonusDetailEntity.balance = balance;
	}
	final int? income = jsonConvert.convert<int>(json['income']);
	if (income != null) {
		bonusDetailEntity.income = income;
	}
	final int? expenditure = jsonConvert.convert<int>(json['expenditure']);
	if (expenditure != null) {
		bonusDetailEntity.expenditure = expenditure;
	}
	final int? expired = jsonConvert.convert<int>(json['expired']);
	if (expired != null) {
		bonusDetailEntity.expired = expired;
	}
	final int? expiring = jsonConvert.convert<int>(json['expiring']);
	if (expiring != null) {
		bonusDetailEntity.expiring = expiring;
	}
	final String? expiringDate = jsonConvert.convert<String>(json['expiringDate']);
	if (expiringDate != null) {
		bonusDetailEntity.expiringDate = expiringDate;
	}
	final int? ratio = jsonConvert.convert<int>(json['ratio']);
	if (ratio != null) {
		bonusDetailEntity.ratio = ratio;
	}
	final String? pointRuleDesc = jsonConvert.convert<String>(json['pointRuleDesc']);
	if (pointRuleDesc != null) {
		bonusDetailEntity.pointRuleDesc = pointRuleDesc;
	}
	return bonusDetailEntity;
}

Map<String, dynamic> $BonusDetailEntityToJson(BonusDetailEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['balance'] = entity.balance;
	data['income'] = entity.income;
	data['expenditure'] = entity.expenditure;
	data['expired'] = entity.expired;
	data['expiring'] = entity.expiring;
	data['expiringDate'] = entity.expiringDate;
	data['ratio'] = entity.ratio;
	data['pointRuleDesc'] = entity.pointRuleDesc;
	return data;
}