import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/coupon_bounty_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class CouponBountyEntity {
  CouponBountyCouponMsg? couponMsg;
  CouponBountyBountyMsg? bountyMsg;

  CouponBountyEntity();

  factory CouponBountyEntity.fromJson(Map<String, dynamic> json) =>
      $CouponBountyEntityFromJson(json);

  Map<String, dynamic> toJson() => $CouponBountyEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CouponBountyCouponMsg {
  ///	 优惠券总数量
  int? totalCouponAmount;

  /// 即将过期的优惠券数量
  int? expiringSoonCouponAmount;
  ///
  int? ineffectiveCount;

  /// 可用代金券数量
  int? availableVoucherCount;

  /// 快过期代金券数量
  int? closeExpiryVoucherCount;

  /// 开关：是否展示代金券 字段设置逻辑: 开关开->true 开关关->判断是否可用代金券数量为0，==0->false ,>0->true
  bool? showVoucher;

  CouponBountyCouponMsg();

  factory CouponBountyCouponMsg.fromJson(Map<String, dynamic> json) =>
      $CouponBountyCouponMsgFromJson(json);

  Map<String, dynamic> toJson() => $CouponBountyCouponMsgToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CouponBountyBountyMsg {
  int? bounty;
  bool? display;

  CouponBountyBountyMsg();

  factory CouponBountyBountyMsg.fromJson(Map<String, dynamic> json) =>
      $CouponBountyBountyMsgFromJson(json);

  Map<String, dynamic> toJson() => $CouponBountyBountyMsgToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
