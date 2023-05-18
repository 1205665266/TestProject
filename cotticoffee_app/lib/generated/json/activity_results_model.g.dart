import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/common/activity/model/activity_results_model.dart';

ActivityResultsModel $ActivityResultsModelFromJson(Map<String, dynamic> json) {
	final ActivityResultsModel activityResultsModel = ActivityResultsModel();
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		activityResultsModel.status = status;
	}
	final String? message = jsonConvert.convert<String>(json['message']);
	if (message != null) {
		activityResultsModel.message = message;
	}
	return activityResultsModel;
}

Map<String, dynamic> $ActivityResultsModelToJson(ActivityResultsModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['status'] = entity.status;
	data['message'] = entity.message;
	return data;
}