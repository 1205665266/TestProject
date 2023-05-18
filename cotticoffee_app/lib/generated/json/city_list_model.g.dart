import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/common/address/search_address/entity/city_list_model.dart';
import 'package:azlistview/azlistview.dart';


CityListModel $CityListModelFromJson(Map<String, dynamic> json) {
	final CityListModel cityListModel = CityListModel();
	final int? code = jsonConvert.convert<int>(json['code']);
	if (code != null) {
		cityListModel.code = code;
	}
	final String? message = jsonConvert.convert<String>(json['message']);
	if (message != null) {
		cityListModel.message = message;
	}
	final String? busCode = jsonConvert.convert<String>(json['busCode']);
	if (busCode != null) {
		cityListModel.busCode = busCode;
	}
	final String? busMessage = jsonConvert.convert<String>(json['busMessage']);
	if (busMessage != null) {
		cityListModel.busMessage = busMessage;
	}
	final List<CityListData>? data = jsonConvert.convertListNotNull<CityListData>(json['data']);
	if (data != null) {
		cityListModel.data = data;
	}
	return cityListModel;
}

Map<String, dynamic> $CityListModelToJson(CityListModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['code'] = entity.code;
	data['message'] = entity.message;
	data['busCode'] = entity.busCode;
	data['busMessage'] = entity.busMessage;
	data['data'] =  entity.data?.map((v) => v.toJson()).toList();
	return data;
}

CityListData $CityListDataFromJson(Map<String, dynamic> json) {
	final CityListData cityListData = CityListData();
	final int? cityMdCode = jsonConvert.convert<int>(json['cityMdCode']);
	if (cityMdCode != null) {
		cityListData.cityMdCode = cityMdCode;
	}
	final String? cityName = jsonConvert.convert<String>(json['cityName']);
	if (cityName != null) {
		cityListData.cityName = cityName;
	}
	final String? cityPinyin = jsonConvert.convert<String>(json['cityPinyin']);
	if (cityPinyin != null) {
		cityListData.cityPinyin = cityPinyin;
	}
	final String? tagIndex = jsonConvert.convert<String>(json['tagIndex']);
	if (tagIndex != null) {
		cityListData.tagIndex = tagIndex;
	}
	final String? namePinyin = jsonConvert.convert<String>(json['namePinyin']);
	if (namePinyin != null) {
		cityListData.namePinyin = namePinyin;
	}
	return cityListData;
}

Map<String, dynamic> $CityListDataToJson(CityListData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['cityMdCode'] = entity.cityMdCode;
	data['cityName'] = entity.cityName;
	data['cityPinyin'] = entity.cityPinyin;
	data['tagIndex'] = entity.tagIndex;
	data['namePinyin'] = entity.namePinyin;
	return data;
}