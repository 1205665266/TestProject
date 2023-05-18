import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/check_qualification_result_model.g.dart';


@JsonSerializable()
class CheckQualificationResultModel     {

	CheckQualificationResultModel();

	factory CheckQualificationResultModel.fromJson(Map<String, dynamic> json) => $CheckQualificationResultModelFromJson(json);

	Map<String, dynamic> toJson() => $CheckQualificationResultModelToJson(this);

  int? status;
  String? message;
}
