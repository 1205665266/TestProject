import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/special_price_activity.g.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/4/18 10:28 上午
@JsonSerializable()
class SpecialPriceActivity {
  SpecialPriceActivity();

  factory SpecialPriceActivity.fromJson(Map<String, dynamic> json) =>
      $SpecialPriceActivityFromJson(json);

  Map<String, dynamic> toJson() => $SpecialPriceActivityToJson(this);

  ///活动编号
  String? activityNo;

  ///活动名称
  String? activityName;

  ///活动开始时间
  String? activityStartTime;

  ///活动结束时间
  String? activityEndTime;

  ///活动价格（特价） 单位：分
  String? specialPrice;

  ///每日限量（总部创建活动没有限量）
  int? dailyLimit;

  ///  int? dailyLimit;今日已售
  int? dailySale;

  ///总售量
  int? totalSale;

  ///活动类型
  int? activityType;

  String? activityTypeName;
}
