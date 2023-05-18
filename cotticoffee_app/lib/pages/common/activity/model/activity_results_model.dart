
import 'package:cotti_client/generated/json/activity_results_model.g.dart';
import 'package:cotti_client/generated/json/base/json_field.dart';

@JsonSerializable()
class ActivityResultsModel {

	ActivityResultsModel();

	factory ActivityResultsModel.fromJson(Map<String, dynamic> json) => $ActivityResultsModelFromJson(json);

	Map<String, dynamic> toJson() => $ActivityResultsModelToJson(this);

  late int status;
  late String message;
}
