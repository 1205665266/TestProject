import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/common/activity/model/check_qualification_result_model.dart';

CheckQualificationResultModel $CheckQualificationResultModelFromJson(Map<String, dynamic> json) {
	final CheckQualificationResultModel checkQualificationResultModel = CheckQualificationResultModel();
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		checkQualificationResultModel.status = status;
	}
	final String? message = jsonConvert.convert<String>(json['message']);
	if (message != null) {
		checkQualificationResultModel.message = message;
	}
	return checkQualificationResultModel;
}

Map<String, dynamic> $CheckQualificationResultModelToJson(CheckQualificationResultModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['status'] = entity.status;
	data['message'] = entity.message;
	return data;
}