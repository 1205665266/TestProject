import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/menu/entity/custom_marketing_label_entity.dart';

CustomMarketingLabelEntity $CustomMarketingLabelEntityFromJson(Map<String, dynamic> json) {
	final CustomMarketingLabelEntity customMarketingLabelEntity = CustomMarketingLabelEntity();
	final List<String>? labelList = jsonConvert.convertListNotNull<String>(json['labelList']);
	if (labelList != null) {
		customMarketingLabelEntity.labelList = labelList;
	}
	return customMarketingLabelEntity;
}

Map<String, dynamic> $CustomMarketingLabelEntityToJson(CustomMarketingLabelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['labelList'] =  entity.labelList;
	return data;
}