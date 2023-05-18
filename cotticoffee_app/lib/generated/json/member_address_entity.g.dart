import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';

MemberAddressEntity $MemberAddressEntityFromJson(Map<String, dynamic> json) {
	final MemberAddressEntity memberAddressEntity = MemberAddressEntity();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		memberAddressEntity.id = id;
	}
	final int? memberId = jsonConvert.convert<int>(json['memberId']);
	if (memberId != null) {
		memberAddressEntity.memberId = memberId;
	}
	final String? province = jsonConvert.convert<String>(json['province']);
	if (province != null) {
		memberAddressEntity.province = province;
	}
	final String? city = jsonConvert.convert<String>(json['city']);
	if (city != null) {
		memberAddressEntity.city = city;
	}
	final int? cityMdCode = jsonConvert.convert<int>(json['cityMdCode']);
	if (cityMdCode != null) {
		memberAddressEntity.cityMdCode = cityMdCode;
	}
	final String? county = jsonConvert.convert<String>(json['county']);
	if (county != null) {
		memberAddressEntity.county = county;
	}
	final String? location = jsonConvert.convert<String>(json['location']);
	if (location != null) {
		memberAddressEntity.location = location;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		memberAddressEntity.address = address;
	}
	final String? lng = jsonConvert.convert<String>(json['lng']);
	if (lng != null) {
		memberAddressEntity.lng = lng;
	}
	final String? lat = jsonConvert.convert<String>(json['lat']);
	if (lat != null) {
		memberAddressEntity.lat = lat;
	}
	final int? coordinatesType = jsonConvert.convert<int>(json['coordinatesType']);
	if (coordinatesType != null) {
		memberAddressEntity.coordinatesType = coordinatesType;
	}
	final int? labelId = jsonConvert.convert<int>(json['labelId']);
	if (labelId != null) {
		memberAddressEntity.labelId = labelId;
	}
	final String? labelName = jsonConvert.convert<String>(json['labelName']);
	if (labelName != null) {
		memberAddressEntity.labelName = labelName;
	}
	final String? contact = jsonConvert.convert<String>(json['contact']);
	if (contact != null) {
		memberAddressEntity.contact = contact;
	}
	final String? contactPhone = jsonConvert.convert<String>(json['contactPhone']);
	if (contactPhone != null) {
		memberAddressEntity.contactPhone = contactPhone;
	}
	final int? sex = jsonConvert.convert<int>(json['sex']);
	if (sex != null) {
		memberAddressEntity.sex = sex;
	}
	final int? defaultFlag = jsonConvert.convert<int>(json['defaultFlag']);
	if (defaultFlag != null) {
		memberAddressEntity.defaultFlag = defaultFlag;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		memberAddressEntity.createTime = createTime;
	}
	final String? modifyTime = jsonConvert.convert<String>(json['modifyTime']);
	if (modifyTime != null) {
		memberAddressEntity.modifyTime = modifyTime;
	}
	final int? supportWay = jsonConvert.convert<int>(json['supportWay']);
	if (supportWay != null) {
		memberAddressEntity.supportWay = supportWay;
	}
	final int? checked = jsonConvert.convert<int>(json['checked']);
	if (checked != null) {
		memberAddressEntity.checked = checked;
	}
	final String? street = jsonConvert.convert<String>(json['street']);
	if (street != null) {
		memberAddressEntity.street = street;
	}
	final int? addressId = jsonConvert.convert<int>(json['addressId']);
	if (addressId != null) {
		memberAddressEntity.addressId = addressId;
	}
	return memberAddressEntity;
}

Map<String, dynamic> $MemberAddressEntityToJson(MemberAddressEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['memberId'] = entity.memberId;
	data['province'] = entity.province;
	data['city'] = entity.city;
	data['cityMdCode'] = entity.cityMdCode;
	data['county'] = entity.county;
	data['location'] = entity.location;
	data['address'] = entity.address;
	data['lng'] = entity.lng;
	data['lat'] = entity.lat;
	data['coordinatesType'] = entity.coordinatesType;
	data['labelId'] = entity.labelId;
	data['labelName'] = entity.labelName;
	data['contact'] = entity.contact;
	data['contactPhone'] = entity.contactPhone;
	data['sex'] = entity.sex;
	data['defaultFlag'] = entity.defaultFlag;
	data['createTime'] = entity.createTime;
	data['modifyTime'] = entity.modifyTime;
	data['supportWay'] = entity.supportWay;
	data['checked'] = entity.checked;
	data['street'] = entity.street;
	data['addressId'] = entity.addressId;
	return data;
}