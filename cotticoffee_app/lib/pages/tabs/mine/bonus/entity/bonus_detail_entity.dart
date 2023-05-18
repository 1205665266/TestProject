import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/bonus_detail_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class BonusDetailEntity {

	/// 余额
	int? balance;
	/// 收入
	int? income;
	/// 支出
	int? expenditure;
	/// v4已过期合计
	int? expired;
	/// v4即将到期
	int? expiring;
	/// v4即将到期日期
	String? expiringDate;
	/// v4奖励金 和 钱的兑换比例，1比1 时 1, 10比1 时 10
	int? ratio;
	/// 奖励金规则
	String? pointRuleDesc;

  BonusDetailEntity();

  factory BonusDetailEntity.fromJson(Map<String, dynamic> json) => $BonusDetailEntityFromJson(json);

  Map<String, dynamic> toJson() => $BonusDetailEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}