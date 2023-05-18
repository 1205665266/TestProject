import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/pay_type_model.g.dart';


@JsonSerializable()
class PayTypeModel {
  PayTypeModel();

  factory PayTypeModel.fromJson(Map<String, dynamic> json) => $PayTypeModelFromJson(json);

  Map<String, dynamic> toJson() => $PayTypeModelToJson(this);

  String? payType;
  String? showIcon;
  String? showName;
  int? payFrom;
}
