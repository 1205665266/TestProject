import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/product/entity/spec_list_entity.dart';

SpecListEntity $SpecListEntityFromJson(Map<String, dynamic> json) {
	final SpecListEntity specListEntity = SpecListEntity();
	final String? specItemName = jsonConvert.convert<String>(json['specItemName']);
	if (specItemName != null) {
		specListEntity.specItemName = specItemName;
	}
	final String? specItemNo = jsonConvert.convert<String>(json['specItemNo']);
	if (specItemNo != null) {
		specListEntity.specItemNo = specItemNo;
	}
	final List<SpecListSpecValueList>? specValueList = jsonConvert.convertListNotNull<SpecListSpecValueList>(json['specValueList']);
	if (specValueList != null) {
		specListEntity.specValueList = specValueList;
	}
	return specListEntity;
}

Map<String, dynamic> $SpecListEntityToJson(SpecListEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['specItemName'] = entity.specItemName;
	data['specItemNo'] = entity.specItemNo;
	data['specValueList'] =  entity.specValueList?.map((v) => v.toJson()).toList();
	return data;
}

SpecListSpecValueList $SpecListSpecValueListFromJson(Map<String, dynamic> json) {
	final SpecListSpecValueList specListSpecValueList = SpecListSpecValueList();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		specListSpecValueList.name = name;
	}
	final String? value = jsonConvert.convert<String>(json['value']);
	if (value != null) {
		specListSpecValueList.value = value;
	}
	final int? recommendFlag = jsonConvert.convert<int>(json['recommendFlag']);
	if (recommendFlag != null) {
		specListSpecValueList.recommendFlag = recommendFlag;
	}
	final bool? selected = jsonConvert.convert<bool>(json['selected']);
	if (selected != null) {
		specListSpecValueList.selected = selected;
	}
	return specListSpecValueList;
}

Map<String, dynamic> $SpecListSpecValueListToJson(SpecListSpecValueList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['value'] = entity.value;
	data['recommendFlag'] = entity.recommendFlag;
	data['selected'] = entity.selected;
	return data;
}