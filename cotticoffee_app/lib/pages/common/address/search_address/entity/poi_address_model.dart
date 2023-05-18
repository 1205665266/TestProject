


import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/poi_address_model.g.dart';

@JsonSerializable()
class PoiAddressModel {

	PoiAddressModel();

	factory PoiAddressModel.fromJson(Map<String, dynamic> json) => $PoiAddressModelFromJson(json);

	Map<String, dynamic> toJson() => $PoiAddressModelToJson(this);

	late List<PoiAddressData> data;
}

@JsonSerializable()
class PoiAddressData {

	PoiAddressData();

	factory PoiAddressData.fromJson(Map<String, dynamic> json) => $PoiAddressDataFromJson(json);

	Map<String, dynamic> toJson() => $PoiAddressDataToJson(this);

	String? id;
	String? name;
	String? address;
	late double lat;
	late double lng;
	String? distance;
	String? province;
	String? city;
	String? citycode;
	String? district;
}
