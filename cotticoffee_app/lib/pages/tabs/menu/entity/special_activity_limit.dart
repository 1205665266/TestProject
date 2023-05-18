import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/special_activity_limit.g.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/6/9 6:23 下午
@JsonSerializable()
class SpecialActivityLimit {
  SpecialActivityLimit();

  factory SpecialActivityLimit.fromJson(Map<String, dynamic> json) =>
      $SpecialActivityLimitFromJson(json);

  Map<String, dynamic> toJson() => $SpecialActivityLimitToJson(this);

  ///活动是否结束 0 活动进行中 1 活动完全结束 2 当日活动结束
  int? activityStatus;

  ///限制数量
  int? limitAmount;

  ///活动信息显示逻辑：1、用户每日限购 ，2、用户总限购 3、门店限量 4、倒计时
  int? activityShowType;

  int? memberLimitAmount;
  int? shopPlusNum;
  double? limitProgressBar;
  double? discountRate;

  ///app2.2 特价活动倒计时展示控制
  ///前端判断活动倒计时是否展示，小于该时间时即展示
  int? specialShowCountdown;
}
