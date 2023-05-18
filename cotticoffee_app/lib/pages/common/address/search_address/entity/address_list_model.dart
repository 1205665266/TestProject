import 'package:cotti_client/generated/json/address_list_model.g.dart';
import 'package:cotticommon/generated/json/base/json_field.dart';



@JsonSerializable()
class AddressListModel {

	AddressListModel();

	factory AddressListModel.fromJson(Map<String, dynamic> json) => $AddressListModelFromJson(json);

	Map<String, dynamic> toJson() => $AddressListModelToJson(this);

	int? code;
	int? count;
	String? message;
	bool? success;
	late List<AddressListData> address;
	late List<AddressListData> addressOutOfRange;
	String? traceId;
}

@JsonSerializable()
class AddressListData {

	AddressListData();

	factory AddressListData.fromJson(Map<String, dynamic> json) => $AddressListDataFromJson(json);

	Map<String, dynamic> toJson() => $AddressListDataToJson(this);

	int? id;
	int? memberId;
	String? province;
	String? city;
	int? cityMdCode;
	String? county;
	String? location;
	String? address;
	String? lng;
	String? lat;
	int? coordinatesType;
	int? labelId;
	String? labelName;
	String? contact;
	String? contactPhone;
	int? sex;
	int? defaultFlag;
	String? createTime;
	String? modifyTime;
	int? supportWay;
	// String? street;
}
