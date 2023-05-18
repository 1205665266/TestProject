import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/common/city/entity/city_list_data_entity.dart';
import 'package:azlistview/azlistview.dart';


CityListDataEntity $CityListDataEntityFromJson(Map<String, dynamic> json) {
	final CityListDataEntity cityListDataEntity = CityListDataEntity();
	final int? code = jsonConvert.convert<int>(json['code']);
	if (code != null) {
		cityListDataEntity.code = code;
	}
	final String? message = jsonConvert.convert<String>(json['message']);
	if (message != null) {
		cityListDataEntity.message = message;
	}
	final String? busCode = jsonConvert.convert<String>(json['busCode']);
	if (busCode != null) {
		cityListDataEntity.busCode = busCode;
	}
	final String? busMessage = jsonConvert.convert<String>(json['busMessage']);
	if (busMessage != null) {
		cityListDataEntity.busMessage = busMessage;
	}
	final List<CityListDataData>? data = jsonConvert.convertListNotNull<CityListDataData>(json['data']);
	if (data != null) {
		cityListDataEntity.data = data;
	}
	return cityListDataEntity;
}

Map<String, dynamic> $CityListDataEntityToJson(CityListDataEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['code'] = entity.code;
	data['message'] = entity.message;
	data['busCode'] = entity.busCode;
	data['busMessage'] = entity.busMessage;
	data['data'] =  entity.data?.map((v) => v.toJson()).toList();
	return data;
}

CityListDataData $CityListDataDataFromJson(Map<String, dynamic> json) {
	final CityListDataData cityListDataData = CityListDataData();
	final String? cityName = jsonConvert.convert<String>(json['cityName']);
	if (cityName != null) {
		cityListDataData.cityName = cityName;
	}
	final int? cityMdCode = jsonConvert.convert<int>(json['cityMdCode']);
	if (cityMdCode != null) {
		cityListDataData.cityMdCode = cityMdCode;
	}
	final dynamic cityAreaMdCode = jsonConvert.convert<dynamic>(json['cityAreaMdCode']);
	if (cityAreaMdCode != null) {
		cityListDataData.cityAreaMdCode = cityAreaMdCode;
	}
	final String? cityPinyin = jsonConvert.convert<String>(json['cityPinyin']);
	if (cityPinyin != null) {
		cityListDataData.cityPinyin = cityPinyin;
	}
	final int? provinceMdCode = jsonConvert.convert<int>(json['provinceMdCode']);
	if (provinceMdCode != null) {
		cityListDataData.provinceMdCode = provinceMdCode;
	}
	final String? provinceName = jsonConvert.convert<String>(json['provinceName']);
	if (provinceName != null) {
		cityListDataData.provinceName = provinceName;
	}
	final dynamic county = jsonConvert.convert<dynamic>(json['county']);
	if (county != null) {
		cityListDataData.county = county;
	}
	final dynamic parentMdCode = jsonConvert.convert<dynamic>(json['parentMdCode']);
	if (parentMdCode != null) {
		cityListDataData.parentMdCode = parentMdCode;
	}
	final dynamic postCode = jsonConvert.convert<dynamic>(json['postCode']);
	if (postCode != null) {
		cityListDataData.postCode = postCode;
	}
	final dynamic level = jsonConvert.convert<dynamic>(json['level']);
	if (level != null) {
		cityListDataData.level = level;
	}
	final String? tagIndex = jsonConvert.convert<String>(json['tagIndex']);
	if (tagIndex != null) {
		cityListDataData.tagIndex = tagIndex;
	}
	final String? namePinyin = jsonConvert.convert<String>(json['namePinyin']);
	if (namePinyin != null) {
		cityListDataData.namePinyin = namePinyin;
	}
	return cityListDataData;
}

Map<String, dynamic> $CityListDataDataToJson(CityListDataData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['cityName'] = entity.cityName;
	data['cityMdCode'] = entity.cityMdCode;
	data['cityAreaMdCode'] = entity.cityAreaMdCode;
	data['cityPinyin'] = entity.cityPinyin;
	data['provinceMdCode'] = entity.provinceMdCode;
	data['provinceName'] = entity.provinceName;
	data['county'] = entity.county;
	data['parentMdCode'] = entity.parentMdCode;
	data['postCode'] = entity.postCode;
	data['level'] = entity.level;
	data['tagIndex'] = entity.tagIndex;
	data['namePinyin'] = entity.namePinyin;
	return data;
}