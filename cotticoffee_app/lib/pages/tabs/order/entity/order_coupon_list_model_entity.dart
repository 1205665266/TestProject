import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_coupon_list_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class OrderCouponListModelEntity {
  List<OrderCouponListModelConfirmOrderCouponDtoList>? confirmOrderCouponDtoList;

  OrderCouponListModelEntity();

  factory OrderCouponListModelEntity.fromJson(Map<String, dynamic> json) =>
      $OrderCouponListModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderCouponListModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderCouponListModelConfirmOrderCouponDtoList {
  int? tenantCode;
  String? couponNo;
  int? couponType;
  double? condition;
  double? value;
  String? strValue;
  double? limit;
  int? productType;
  String? terminalScope;
  String? takeFoodScope;
  bool? available;
  String? activityNo;
  String? templateNo;
  String? couponName;
  String? couponSubTitle;
  String? title;
  String? threshold;
  String? couponRestrict;
  String? couponDesc;
  dynamic couponImage;
  String? startTime;
  String? endTime;
  dynamic realDiscount;
  dynamic timeScopeList;
  int? couponTypeTranslate;

  //来源
  //8,"会员充赠活动发券"
  // 9,"抖音团购兑换"
  int? sendType;

  //失效类型 失效类型 (10.已过期 20.已退款 30.已失效)
  int? invalidType;

  /// 根据优惠券匹配到订单中的商品计算优惠的金额
  double? discountPrice;

  /// since APP105 不能叠加使用tip
  String? canNotBeStackedTip;
  /// since APP105 不能叠加使用按钮类型 1 替换使用 2调整代金券
  int? canNotBeStackedButtonType;
  /// since APP105 订单中可调整代金券的商品列表
  List<String>? skuCodes;

  /// 确认订单页面 与 代金券冲突时显示的文案；
  String? canNotBeStackedContext;

  OrderCouponListModelConfirmOrderCouponDtoList();

  factory OrderCouponListModelConfirmOrderCouponDtoList.fromJson(Map<String, dynamic> json) =>
      $OrderCouponListModelConfirmOrderCouponDtoListFromJson(json);

  Map<String, dynamic> toJson() => $OrderCouponListModelConfirmOrderCouponDtoListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
