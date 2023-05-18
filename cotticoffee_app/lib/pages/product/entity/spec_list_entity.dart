import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/spec_list_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class SpecListEntity {

	String? specItemName;
	String? specItemNo;
	List<SpecListSpecValueList>? specValueList;
  
  SpecListEntity();

  factory SpecListEntity.fromJson(Map<String, dynamic> json) => $SpecListEntityFromJson(json);

  Map<String, dynamic> toJson() => $SpecListEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class SpecListSpecValueList {

	String? name;
	String? value;
	int? recommendFlag;
	bool? selected;
  
  SpecListSpecValueList();

  factory SpecListSpecValueList.fromJson(Map<String, dynamic> json) => $SpecListSpecValueListFromJson(json);

  Map<String, dynamic> toJson() => $SpecListSpecValueListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}