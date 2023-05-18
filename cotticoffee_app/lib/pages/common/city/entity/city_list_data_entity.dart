import 'dart:convert';
import 'package:azlistview/azlistview.dart';
import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/city_list_data_entity.g.dart';

@JsonSerializable()
class CityListDataEntity {

	int? code;
	String? message;
	String? busCode;
	String? busMessage;
	List<CityListDataData>? data;
  
  CityListDataEntity();

  factory CityListDataEntity.fromJson(Map<String, dynamic> json) => $CityListDataEntityFromJson(json);

  Map<String, dynamic> toJson() => $CityListDataEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CityListDataData extends ISuspensionBean {

	String? cityName;
	int? cityMdCode;
	dynamic cityAreaMdCode;
	String? cityPinyin;
	int? provinceMdCode;
	String? provinceName;
	dynamic county;
	dynamic parentMdCode;
	dynamic postCode;
	dynamic level;

	String? tagIndex;
	String? namePinyin;
  
  CityListDataData();

  factory CityListDataData.fromJson(Map<String, dynamic> json) => $CityListDataDataFromJson(json);

  Map<String, dynamic> toJson() => $CityListDataDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  @override
  String getSuspensionTag() => tagIndex!;
}