import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/common/address/search_address/entity/poi_address_model.dart';

PoiAddressModel $PoiAddressModelFromJson(Map<String, dynamic> json) {
	final PoiAddressModel poiAddressModel = PoiAddressModel();
	final List<PoiAddressData>? data = jsonConvert.convertListNotNull<PoiAddressData>(json['data']);
	if (data != null) {
		poiAddressModel.data = data;
	}
	return poiAddressModel;
}

Map<String, dynamic> $PoiAddressModelToJson(PoiAddressModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['data'] =  entity.data.map((v) => v.toJson()).toList();
	return data;
}

PoiAddressData $PoiAddressDataFromJson(Map<String, dynamic> json) {
	final PoiAddressData poiAddressData = PoiAddressData();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		poiAddressData.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		poiAddressData.name = name;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		poiAddressData.address = address;
	}
	final double? lat = jsonConvert.convert<double>(json['lat']);
	if (lat != null) {
		poiAddressData.lat = lat;
	}
	final double? lng = jsonConvert.convert<double>(json['lng']);
	if (lng != null) {
		poiAddressData.lng = lng;
	}
	final String? distance = jsonConvert.convert<String>(json['distance']);
	if (distance != null) {
		poiAddressData.distance = distance;
	}
	final String? province = jsonConvert.convert<String>(json['province']);
	if (province != null) {
		poiAddressData.province = province;
	}
	final String? city = jsonConvert.convert<String>(json['city']);
	if (city != null) {
		poiAddressData.city = city;
	}
	final String? citycode = jsonConvert.convert<String>(json['citycode']);
	if (citycode != null) {
		poiAddressData.citycode = citycode;
	}
	final String? district = jsonConvert.convert<String>(json['district']);
	if (district != null) {
		poiAddressData.district = district;
	}
	return poiAddressData;
}

Map<String, dynamic> $PoiAddressDataToJson(PoiAddressData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['address'] = entity.address;
	data['lat'] = entity.lat;
	data['lng'] = entity.lng;
	data['distance'] = entity.distance;
	data['province'] = entity.province;
	data['city'] = entity.city;
	data['citycode'] = entity.citycode;
	data['district'] = entity.district;
	return data;
}