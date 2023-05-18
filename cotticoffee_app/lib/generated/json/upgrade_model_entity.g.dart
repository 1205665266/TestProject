import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/upgrade/upgrade_model_entity.dart';

UpgradeModelEntity $UpgradeModelEntityFromJson(Map<String, dynamic> json) {
	final UpgradeModelEntity upgradeModelEntity = UpgradeModelEntity();
	final int? forceType = jsonConvert.convert<int>(json['forceType']);
	if (forceType != null) {
		upgradeModelEntity.forceType = forceType;
	}
	final String? focusVersion = jsonConvert.convert<String>(json['focusVersion']);
	if (focusVersion != null) {
		upgradeModelEntity.focusVersion = focusVersion;
	}
	final String? buildVersion = jsonConvert.convert<String>(json['buildVersion']);
	if (buildVersion != null) {
		upgradeModelEntity.buildVersion = buildVersion;
	}
	final String? msg = jsonConvert.convert<String>(json['msg']);
	if (msg != null) {
		upgradeModelEntity.msg = msg;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		upgradeModelEntity.address = address;
	}
	final String? md5Sign = jsonConvert.convert<String>(json['md5Sign']);
	if (md5Sign != null) {
		upgradeModelEntity.md5Sign = md5Sign;
	}
	final String? upgradeTime = jsonConvert.convert<String>(json['upgradeTime']);
	if (upgradeTime != null) {
		upgradeModelEntity.upgradeTime = upgradeTime;
	}
	final int? appChannel = jsonConvert.convert<int>(json['appChannel']);
	if (appChannel != null) {
		upgradeModelEntity.appChannel = appChannel;
	}
	return upgradeModelEntity;
}

Map<String, dynamic> $UpgradeModelEntityToJson(UpgradeModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['forceType'] = entity.forceType;
	data['focusVersion'] = entity.focusVersion;
	data['buildVersion'] = entity.buildVersion;
	data['msg'] = entity.msg;
	data['address'] = entity.address;
	data['md5Sign'] = entity.md5Sign;
	data['upgradeTime'] = entity.upgradeTime;
	data['appChannel'] = entity.appChannel;
	return data;
}