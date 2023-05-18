import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/menu/search/entity/item_label_model.dart';

ItemLabelModel $ItemLabelModelFromJson(Map<String, dynamic> json) {
	final ItemLabelModel itemLabelModel = ItemLabelModel();
	final List<SearchItemLabel>? itemLabelList = jsonConvert.convertListNotNull<SearchItemLabel>(json['itemLabelDTOs']);
	if (itemLabelList != null) {
		itemLabelModel.itemLabelList = itemLabelList;
	}
	final List<SearchProductParam>? productParamList = jsonConvert.convertListNotNull<SearchProductParam>(json['productParamValueDTOs']);
	if (productParamList != null) {
		itemLabelModel.productParamList = productParamList;
	}
	return itemLabelModel;
}

Map<String, dynamic> $ItemLabelModelToJson(ItemLabelModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['itemLabelDTOs'] =  entity.itemLabelList?.map((v) => v.toJson()).toList();
	data['productParamValueDTOs'] =  entity.productParamList?.map((v) => v.toJson()).toList();
	return data;
}

SearchItemLabel $SearchItemLabelFromJson(Map<String, dynamic> json) {
	final SearchItemLabel searchItemLabel = SearchItemLabel();
	final String? itemLabel = jsonConvert.convert<String>(json['itemLabel']);
	if (itemLabel != null) {
		searchItemLabel.itemLabel = itemLabel;
	}
	final num? itemId = jsonConvert.convert<num>(json['itemId']);
	if (itemId != null) {
		searchItemLabel.itemId = itemId;
	}
	final String? itemNo = jsonConvert.convert<String>(json['itemNo']);
	if (itemNo != null) {
		searchItemLabel.itemNo = itemNo;
	}
	final String? itemName = jsonConvert.convert<String>(json['itemName']);
	if (itemName != null) {
		searchItemLabel.itemName = itemName;
	}
	return searchItemLabel;
}

Map<String, dynamic> $SearchItemLabelToJson(SearchItemLabel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['itemLabel'] = entity.itemLabel;
	data['itemId'] = entity.itemId;
	data['itemNo'] = entity.itemNo;
	data['itemName'] = entity.itemName;
	return data;
}

SearchProductParam $SearchProductParamFromJson(Map<String, dynamic> json) {
	final SearchProductParam searchProductParam = SearchProductParam();
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		searchProductParam.code = code;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		searchProductParam.name = name;
	}
	return searchProductParam;
}

Map<String, dynamic> $SearchProductParamToJson(SearchProductParam entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['code'] = entity.code;
	data['name'] = entity.name;
	return data;
}