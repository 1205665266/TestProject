

import 'package:azlistview/azlistview.dart';
import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/city_list_model.g.dart';

@JsonSerializable()
class CityListModel {

	CityListModel();
	factory CityListModel.fromJson(Map<String, dynamic> json) => $CityListModelFromJson(json);

	Map<String, dynamic> toJson() => $CityListModelToJson(this);

	int? code;
	String? message;
	String? busCode;
	String? busMessage;
	List<CityListData>? data;
}

@JsonSerializable()
class CityListData extends ISuspensionBean{

	CityListData();
	factory CityListData.fromJson(Map<String, dynamic> json) => $CityListDataFromJson(json);

	Map<String, dynamic> toJson() => $CityListDataToJson(this);

	int? cityMdCode;
	String? cityName;
	String? cityPinyin;
	String? tagIndex;
	String? namePinyin;

	@override
	String getSuspensionTag() => tagIndex!;

	bool isEmpty(){
    return cityMdCode == null &&
        cityName == null &&
        cityPinyin == null &&
        tagIndex == null &&
        namePinyin == null;
  }
}
