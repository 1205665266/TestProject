import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/take_address_entity.g.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';

@JsonSerializable()
class TakeAddressEntity {
  int? jumpFlag;
  MemberAddressEntity? checkedAddress;

  ///可用地址列表
  List<MemberAddressEntity>? address;

  ///超出范围地址列表
  List<MemberAddressEntity>? addressOutOfRange;

  TakeAddressEntity();

  factory TakeAddressEntity.fromJson(Map<String, dynamic> json) => $TakeAddressEntityFromJson(json);

  Map<String, dynamic> toJson() => $TakeAddressEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
