import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/member_address_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class MemberAddressEntity {
  late int id;
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
  int? checked;
  String? street;

  int? addressId;

  MemberAddressEntity();

  static MemberAddressEntity def(){
    return MemberAddressEntity()..sex=1..id=-1;
  }

  factory MemberAddressEntity.fromJson(Map<String, dynamic> json) =>
      $MemberAddressEntityFromJson(json);

  Map<String, dynamic> toJson() => $MemberAddressEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
