import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/specials_daily_limit_check_entity.g.dart';

@JsonSerializable()
class SpecialsDailyLimitCheckEntity {
  bool? displayToastTips;
  String? toastTips;

  SpecialsDailyLimitCheckEntity();

  factory SpecialsDailyLimitCheckEntity.fromJson(Map<String, dynamic> json) =>
      $SpecialsDailyLimitCheckEntityFromJson(json);

  Map<String, dynamic> toJson() => $SpecialsDailyLimitCheckEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
