import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/user_info_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class UserInfoEntity {
  String? memberNo;
  String? nickname;
  int? sex;
  String? birthday;
  dynamic collectionCount;
  String? headPortrait;
  int? appMessageSwitch;

  UserInfoEntity();

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) => $UserInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
