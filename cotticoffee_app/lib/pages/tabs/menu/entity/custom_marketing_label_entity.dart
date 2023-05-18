import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/custom_marketing_label_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class CustomMarketingLabelEntity {

	List<String>? labelList;
  
  CustomMarketingLabelEntity();

  factory CustomMarketingLabelEntity.fromJson(Map<String, dynamic> json) => $CustomMarketingLabelEntityFromJson(json);

  Map<String, dynamic> toJson() => $CustomMarketingLabelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}