import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/marketing_label_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class MarketingLabelEntity {

	String? name;
	String? value;
  
  MarketingLabelEntity();

  factory MarketingLabelEntity.fromJson(Map<String, dynamic> json) => $MarketingLabelEntityFromJson(json);

  Map<String, dynamic> toJson() => $MarketingLabelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}