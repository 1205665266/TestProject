import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/common/address/search_address/entity/address_list_model.dart';

AddressListModel $AddressListModelFromJson(Map<String, dynamic> json) {
	final AddressListModel addressListModel = AddressListModel();
	final int? code = jsonConvert.convert<int>(json['code']);
	if (code != null) {
		addressListModel.code = code;
	}
	final int? count = jsonConvert.convert<int>(json['count']);
	if (count != null) {
		addressListModel.count = count;
	}
	final String? message = jsonConvert.convert<String>(json['message']);
	if (message != null) {
		addressListModel.message = message;
	}
	final bool? success = jsonConvert.convert<bool>(json['success']);
	if (success != null) {
		addressListModel.success = success;
	}
	final List<AddressListData>? address = jsonConvert.convertListNotNull<AddressListData>(json['address']);
	if (address != null) {
		addressListModel.address = address;
	}
	final List<AddressListData>? addressOutOfRange = jsonConvert.convertListNotNull<AddressListData>(json['addressOutOfRange']);
	if (addressOutOfRange != null) {
		addressListModel.addressOutOfRange = addressOutOfRange;
	}
	final String? traceId = jsonConvert.convert<String>(json['traceId']);
	if (traceId != null) {
		addressListModel.traceId = traceId;
	}
	return addressListModel;
}

Map<String, dynamic> $AddressListModelToJson(AddressListModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['code'] = entity.code;
	data['count'] = entity.count;
	data['message'] = entity.message;
	data['success'] = entity.success;
	data['address'] =  entity.address.map((v) => v.toJson()).toList();
	data['addressOutOfRange'] =  entity.addressOutOfRange.map((v) => v.toJson()).toList();
	data['traceId'] = entity.traceId;
	return data;
}

AddressListData $AddressListDataFromJson(Map<String, dynamic> json) {
	final AddressListData addressListData = AddressListData();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		addressListData.id = id;
	}
	final int? memberId = jsonConvert.convert<int>(json['memberId']);
	if (memberId != null) {
		addressListData.memberId = memberId;
	}
	final String? province = jsonConvert.convert<String>(json['province']);
	if (province != null) {
		addressListData.province = province;
	}
	final String? city = jsonConvert.convert<String>(json['city']);
	if (city != null) {
		addressListData.city = city;
	}
	final int? cityMdCode = jsonConvert.convert<int>(json['cityMdCode']);
	if (cityMdCode != null) {
		addressListData.cityMdCode = cityMdCode;
	}
	final String? county = jsonConvert.convert<String>(json['county']);
	if (county != null) {
		addressListData.county = county;
	}
	final String? location = jsonConvert.convert<String>(json['location']);
	if (location != null) {
		addressListData.location = location;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		addressListData.address = address;
	}
	final String? lng = jsonConvert.convert<String>(json['lng']);
	if (lng != null) {
		addressListData.lng = lng;
	}
	final String? lat = jsonConvert.convert<String>(json['lat']);
	if (lat != null) {
		addressListData.lat = lat;
	}
	final int? coordinatesType = jsonConvert.convert<int>(json['coordinatesType']);
	if (coordinatesType != null) {
		addressListData.coordinatesType = coordinatesType;
	}
	final int? labelId = jsonConvert.convert<int>(json['labelId']);
	if (labelId != null) {
		addressListData.labelId = labelId;
	}
	final String? labelName = jsonConvert.convert<String>(json['labelName']);
	if (labelName != null) {
		addressListData.labelName = labelName;
	}
	final String? contact = jsonConvert.convert<String>(json['contact']);
	if (contact != null) {
		addressListData.contact = contact;
	}
	final String? contactPhone = jsonConvert.convert<String>(json['contactPhone']);
	if (contactPhone != null) {
		addressListData.contactPhone = contactPhone;
	}
	final int? sex = jsonConvert.convert<int>(json['sex']);
	if (sex != null) {
		addressListData.sex = sex;
	}
	final int? defaultFlag = jsonConvert.convert<int>(json['defaultFlag']);
	if (defaultFlag != null) {
		addressListData.defaultFlag = defaultFlag;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		addressListData.createTime = createTime;
	}
	final String? modifyTime = jsonConvert.convert<String>(json['modifyTime']);
	if (modifyTime != null) {
		addressListData.modifyTime = modifyTime;
	}
	final int? supportWay = jsonConvert.convert<int>(json['supportWay']);
	if (supportWay != null) {
		addressListData.supportWay = supportWay;
	}
	return addressListData;
}

Map<String, dynamic> $AddressListDataToJson(AddressListData entity) {
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
	return data;
}