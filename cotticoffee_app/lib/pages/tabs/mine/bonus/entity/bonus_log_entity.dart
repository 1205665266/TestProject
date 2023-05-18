import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/bonus_log_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class BonusLogEntity {

  /// 说明(下单抵扣)
	String? businessName;
  /// 操作类型，1 收入（+），2 支出（-）
	int? operationType;
  /// 操作值
	int? operationValue;
  /// 操作日期(yyyy年MM月dd日)
	String? operationDate;
  /// 订单号（可为空）
	String? orderNo;
  
  BonusLogEntity();

  factory BonusLogEntity.fromJson(Map<String, dynamic> json) => $BonusLogEntityFromJson(json);

  Map<String, dynamic> toJson() => $BonusLogEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}