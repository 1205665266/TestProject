import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/take_address_entity.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';


TakeAddressEntity $TakeAddressEntityFromJson(Map<String, dynamic> json) {
	final TakeAddressEntity takeAddressEntity = TakeAddressEntity();
	final int? jumpFlag = jsonConvert.convert<int>(json['jumpFlag']);
	if (jumpFlag != null) {
		takeAddressEntity.jumpFlag = jumpFlag;
	}
	final MemberAddressEntity? checkedAddress = jsonConvert.convert<MemberAddressEntity>(json['checkedAddress']);
	if (checkedAddress != null) {
		takeAddressEntity.checkedAddress = checkedAddress;
	}
	final List<MemberAddressEntity>? address = jsonConvert.convertListNotNull<MemberAddressEntity>(json['address']);
	if (address != null) {
		takeAddressEntity.address = address;
	}
	final List<MemberAddressEntity>? addressOutOfRange = jsonConvert.convertListNotNull<MemberAddressEntity>(json['addressOutOfRange']);
	if (addressOutOfRange != null) {
		takeAddressEntity.addressOutOfRange = addressOutOfRange;
	}
	return takeAddressEntity;
}

Map<String, dynamic> $TakeAddressEntityToJson(TakeAddressEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['jumpFlag'] = entity.jumpFlag;
	data['checkedAddress'] = entity.checkedAddress?.toJson();
	data['address'] =  entity.address?.map((v) => v.toJson()).toList();
	data['addressOutOfRange'] =  entity.addressOutOfRange?.map((v) => v.toJson()).toList();
	return data;
}