import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_config_entity.dart';

MenuConfigEntity $MenuConfigEntityFromJson(Map<String, dynamic> json) {
	final MenuConfigEntity menuConfigEntity = MenuConfigEntity();
	final String? recentOrderMenuCode = jsonConvert.convert<String>(json['recentOrderMenuCode']);
	if (recentOrderMenuCode != null) {
		menuConfigEntity.recentOrderMenuCode = recentOrderMenuCode;
	}
	final String? discountMenuCode = jsonConvert.convert<String>(json['discountMenuCode']);
	if (discountMenuCode != null) {
		menuConfigEntity.discountMenuCode = discountMenuCode;
	}
	return menuConfigEntity;
}

Map<String, dynamic> $MenuConfigEntityToJson(MenuConfigEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['recentOrderMenuCode'] = entity.recentOrderMenuCode;
	data['discountMenuCode'] = entity.discountMenuCode;
	return data;
}