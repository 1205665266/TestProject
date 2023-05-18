import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/service/location/position_info_entity.dart';

PositionInfoEntity $PositionInfoEntityFromJson(Map<String, dynamic> json) {
	final PositionInfoEntity positionInfoEntity = PositionInfoEntity();
	final int? locationType = jsonConvert.convert<int>(json['locationType']);
	if (locationType != null) {
		positionInfoEntity.locationType = locationType;
	}
	final double? latitude = jsonConvert.convert<double>(json['latitude']);
	if (latitude != null) {
		positionInfoEntity.latitude = latitude;
	}
	final double? longitude = jsonConvert.convert<double>(json['longitude']);
	if (longitude != null) {
		positionInfoEntity.longitude = longitude;
	}
	final double? accuracy = jsonConvert.convert<double>(json['accuracy']);
	if (accuracy != null) {
		positionInfoEntity.accuracy = accuracy;
	}
	final double? altitude = jsonConvert.convert<double>(json['altitude']);
	if (altitude != null) {
		positionInfoEntity.altitude = altitude;
	}
	final double? bearing = jsonConvert.convert<double>(json['bearing']);
	if (bearing != null) {
		positionInfoEntity.bearing = bearing;
	}
	final double? speed = jsonConvert.convert<double>(json['speed']);
	if (speed != null) {
		positionInfoEntity.speed = speed;
	}
	final String? country = jsonConvert.convert<String>(json['country']);
	if (country != null) {
		positionInfoEntity.country = country;
	}
	final String? province = jsonConvert.convert<String>(json['province']);
	if (province != null) {
		positionInfoEntity.province = province;
	}
	final String? city = jsonConvert.convert<String>(json['city']);
	if (city != null) {
		positionInfoEntity.city = city;
	}
	final String? district = jsonConvert.convert<String>(json['district']);
	if (district != null) {
		positionInfoEntity.district = district;
	}
	final String? street = jsonConvert.convert<String>(json['street']);
	if (street != null) {
		positionInfoEntity.street = street;
	}
	final String? streetNumber = jsonConvert.convert<String>(json['streetNumber']);
	if (streetNumber != null) {
		positionInfoEntity.streetNumber = streetNumber;
	}
	final String? cityCode = jsonConvert.convert<String>(json['cityCode']);
	if (cityCode != null) {
		positionInfoEntity.cityCode = cityCode;
	}
	final int? adCode = jsonConvert.convert<int>(json['adCode']);
	if (adCode != null) {
		positionInfoEntity.adCode = adCode;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		positionInfoEntity.address = address;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		positionInfoEntity.description = description;
	}
	return positionInfoEntity;
}

Map<String, dynamic> $PositionInfoEntityToJson(PositionInfoEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['locationType'] = entity.locationType;
	data['latitude'] = entity.latitude;
	data['longitude'] = entity.longitude;
	data['accuracy'] = entity.accuracy;
	data['altitude'] = entity.altitude;
	data['bearing'] = entity.bearing;
	data['speed'] = entity.speed;
	data['country'] = entity.country;
	data['province'] = entity.province;
	data['city'] = entity.city;
	data['district'] = entity.district;
	data['street'] = entity.street;
	data['streetNumber'] = entity.streetNumber;
	data['cityCode'] = entity.cityCode;
	data['adCode'] = entity.adCode;
	data['address'] = entity.address;
	data['description'] = entity.description;
	return data;
}