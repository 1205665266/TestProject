import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/menu/search/entity/search_label.dart';

SearchLabel $SearchLabelFromJson(Map<String, dynamic> json) {
	final SearchLabel searchLabel = SearchLabel();
	final String? itemId = jsonConvert.convert<String>(json['itemId']);
	if (itemId != null) {
		searchLabel.itemId = itemId;
	}
	final String? labelText = jsonConvert.convert<String>(json['labelText']);
	if (labelText != null) {
		searchLabel.labelText = labelText;
	}
	final String? itemNo = jsonConvert.convert<String>(json['itemNo']);
	if (itemNo != null) {
		searchLabel.itemNo = itemNo;
	}
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		searchLabel.type = type;
	}
	final bool? isCuisines = jsonConvert.convert<bool>(json['isCuisines']);
	if (isCuisines != null) {
		searchLabel.isCuisines = isCuisines;
	}
	return searchLabel;
}

Map<String, dynamic> $SearchLabelToJson(SearchLabel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['itemId'] = entity.itemId;
	data['labelText'] = entity.labelText;
	data['itemNo'] = entity.itemNo;
	data['type'] = entity.type;
	data['isCuisines'] = entity.isCuisines;
	return data;
}