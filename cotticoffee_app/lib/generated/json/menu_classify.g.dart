import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_classify.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_item_entity.dart';


MenuClassify $MenuClassifyFromJson(Map<String, dynamic> json) {
	final MenuClassify menuClassify = MenuClassify();
	final int? key = jsonConvert.convert<int>(json['key']);
	if (key != null) {
		menuClassify.key = key;
	}
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		menuClassify.id = id;
	}
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		menuClassify.code = code;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		menuClassify.name = name;
	}
	final int? sort = jsonConvert.convert<int>(json['sort']);
	if (sort != null) {
		menuClassify.sort = sort;
	}
	final String? iconUrl = jsonConvert.convert<String>(json['iconUrl']);
	if (iconUrl != null) {
		menuClassify.iconUrl = iconUrl;
	}
	final String? adPicUrl = jsonConvert.convert<String>(json['adPicUrl']);
	if (adPicUrl != null) {
		menuClassify.adPicUrl = adPicUrl;
	}
	final String? tagUrl = jsonConvert.convert<String>(json['tagUrl']);
	if (tagUrl != null) {
		menuClassify.tagUrl = tagUrl;
	}
	final String? classifyDesc = jsonConvert.convert<String>(json['classifyDesc']);
	if (classifyDesc != null) {
		menuClassify.classifyDesc = classifyDesc;
	}
	final int? adType = jsonConvert.convert<int>(json['adType']);
	if (adType != null) {
		menuClassify.adType = adType;
	}
	final String? adInfo = jsonConvert.convert<String>(json['adInfo']);
	if (adInfo != null) {
		menuClassify.adInfo = adInfo;
	}
	final List<MenuItemEntity>? items = jsonConvert.convertListNotNull<MenuItemEntity>(json['items']);
	if (items != null) {
		menuClassify.items = items;
	}
	final List<MenuItemEntity>? saleOutItems = jsonConvert.convertListNotNull<MenuItemEntity>(json['saleOutItems']);
	if (saleOutItems != null) {
		menuClassify.saleOutItems = saleOutItems;
	}
	final List<MenuClassify>? subList = jsonConvert.convertListNotNull<MenuClassify>(json['subList']);
	if (subList != null) {
		menuClassify.subList = subList;
	}
	final List<MenuClassify>? triList = jsonConvert.convertListNotNull<MenuClassify>(json['triList']);
	if (triList != null) {
		menuClassify.triList = triList;
	}
	final int? tag = jsonConvert.convert<int>(json['tag']);
	if (tag != null) {
		menuClassify.tag = tag;
	}
	return menuClassify;
}

Map<String, dynamic> $MenuClassifyToJson(MenuClassify entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['key'] = entity.key;
	data['id'] = entity.id;
	data['code'] = entity.code;
	data['name'] = entity.name;
	data['sort'] = entity.sort;
	data['iconUrl'] = entity.iconUrl;
	data['adPicUrl'] = entity.adPicUrl;
	data['tagUrl'] = entity.tagUrl;
	data['classifyDesc'] = entity.classifyDesc;
	data['adType'] = entity.adType;
	data['adInfo'] = entity.adInfo;
	data['items'] =  entity.items?.map((v) => v.toJson()).toList();
	data['saleOutItems'] =  entity.saleOutItems?.map((v) => v.toJson()).toList();
	data['subList'] =  entity.subList?.map((v) => v.toJson()).toList();
	data['triList'] =  entity.triList?.map((v) => v.toJson()).toList();
	data['tag'] = entity.tag;
	return data;
}