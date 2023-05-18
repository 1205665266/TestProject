import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_root_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_classify.dart';


MenuRootEntity $MenuRootEntityFromJson(Map<String, dynamic> json) {
	final MenuRootEntity menuRootEntity = MenuRootEntity();
	final List<MenuClassify>? rootList = jsonConvert.convertListNotNull<MenuClassify>(json['rootList']);
	if (rootList != null) {
		menuRootEntity.rootList = rootList;
	}
	final int? positionForCarousell = jsonConvert.convert<int>(json['positionForCarousell']);
	if (positionForCarousell != null) {
		menuRootEntity.positionForCarousell = positionForCarousell;
	}
	final num? nowTime = jsonConvert.convert<num>(json['nowTime']);
	if (nowTime != null) {
		menuRootEntity.nowTime = nowTime;
	}
	return menuRootEntity;
}

Map<String, dynamic> $MenuRootEntityToJson(MenuRootEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['rootList'] =  entity.rootList?.map((v) => v.toJson()).toList();
	data['positionForCarousell'] = entity.positionForCarousell;
	data['nowTime'] = entity.nowTime;
	return data;
}