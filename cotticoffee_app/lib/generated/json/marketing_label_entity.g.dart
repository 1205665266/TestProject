import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/menu/entity/marketing_label_entity.dart';

MarketingLabelEntity $MarketingLabelEntityFromJson(Map<String, dynamic> json) {
	final MarketingLabelEntity marketingLabelEntity = MarketingLabelEntity();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		marketingLabelEntity.name = name;
	}
	final String? value = jsonConvert.convert<String>(json['value']);
	if (value != null) {
		marketingLabelEntity.value = value;
	}
	return marketingLabelEntity;
}

Map<String, dynamic> $MarketingLabelEntityToJson(MarketingLabelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['value'] = entity.value;
	return data;
}