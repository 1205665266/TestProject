import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/cash_coupon_entity.g.dart';

/// Description: 代金券item实体类
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/15 10:20
@JsonSerializable()
class CashCouponEntity {
  /// 发券合作商名称
  String? partnerName;

  ///代金券字段 使用时间
  String? useTime;

  ///代金券字段 失效时间
  String? invalidTime;

  ///代金券字段 聚合数量 模版子列表使用
  int? count;

  ///代金券字段 分组长度 ，大于100时提示 代金券太多啦，请在有效期内及时使用 列表中冗余此字段
  int? groupNum;
  int? tenantCode;
  String? couponNo;
  int? couponType;
  int? condition;
  double? value;
  String? strValue;
  int? limit;
  int? productType;
  String? terminalScope;
  String? takeFoodScope;
  bool? available;
  String? activityNo;
  String? templateNo;

  ///代金券名称
  String? couponName;
  String? couponSubTitle;

  ///券标题
  String? title;
  String? threshold;
  String? couponRestrict;
  String? couponDesc;
  String? couponImage;
  String? startTime;
  String? endTime;
  List<String>? timeScopeList;
  int? couponTypeTranslate;
  String? recentlyExpiredDate;

  /// 失效类型 EXPIRE(10, "已过期") REFUND(20, "已退款") ACTIVITY_INVALID(30, "活动强制失效");
  int? invalidType;

  //来源
  //8,"会员充赠活动发券"
  // 9,"抖音团购兑换"
  int? sendType;

  /// since APP105 代金券是否已占用 1 占用
  int? occupied;

  /// since APP105 不能叠加使用tip
  String? canNotBeStackedTip;

  /// since APP105 不能叠加使用按钮类型 1 替换使用 2调整代金券
  int? canNotBeStackedButtonType;

  /// since APP105 订单中可调整代金券的商品列表
  List<String>? skuCodes;

  CashCouponEntity();

  factory CashCouponEntity.fromJson(Map<String, dynamic> json) => $CashCouponEntityFromJson(json);

  Map<String, dynamic> toJson() => $CashCouponEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
