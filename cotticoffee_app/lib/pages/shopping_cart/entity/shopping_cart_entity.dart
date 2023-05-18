import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/shopping_cart_entity.g.dart';
import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/special_activity_limit.dart';
import 'package:cotti_client/pages/tabs/menu/entity/special_price_activity.dart';

@JsonSerializable()
class ShoppingCartEntity {
  int? shopId;
  int? shopMdCode;
  List<GoodsItem>? cartGoodsItemList;
  String? totalMoney;
  String? discountMoney;
  bool? shopIsOpen;
  bool? showDelayTips;
  String? delayDeliveryMsg;
  CouponDiscountTip? couponDiscountTip;
  DeliveryDiscountTip? deliveryDiscountTip;
  FinanceDetail? financeDetail;
  bool? gtCartItemMaxLimit;
  int? currentTimeMillis;
  String? totalLineThroughPrice;

  ShoppingCartEntity();

  factory ShoppingCartEntity.fromJson(Map<String, dynamic> json) =>
      $ShoppingCartEntityFromJson(json);

  Map<String, dynamic> toJson() => $ShoppingCartEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class GoodsItem {
  String? itemNo;
  num? itemId;
  num? skuId;
  String? title;
  String? image;
  String? salePrice;
  String? lineThroughPrice;
  int? buyNum;
  int? stockNum;
  String? netWeight;
  int? soldOut;
  int? saleable;
  String? notSaleableReason;
  int? selectedStatus;
  int? addCartTime;
  late String skuCode;
  List<SkuSpec>? skusSpecs;
  String? spuShowName;
  String? skuShowName;
  bool? existOtherSku;
  @JSONField(name: 'specialPriceActivityApiDTO')
  SpecialPriceActivity? specialPriceActivity;
  bool? specialActivityGood;
  bool? singleSkuItem;
  @JSONField(name: 'specialActivityLimitDTO')
  SpecialActivityLimit? specialActivityLimit;
  bool? showLimitCouponNumMsg;
  int? processPriceCounponNum;
  int? processPriceSpecialNum;
  int? mealType;
  List<int>? businessTypes;

  GoodsItem();

  factory GoodsItem.fromJson(Map<String, dynamic> json) => $GoodsItemFromJson(json);

  Map<String, dynamic> toJson() => $GoodsItemToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CouponDiscountTip {
  String? reducedMoney;
  String? onecePriceDiscountMoney;
  String? stillOweMoney;
  String? canHaveMoney;
  int? couponType;
  int? maturityType;
  ///是否匹配了代金券 --- 代金券版本新增 0 未匹配 1匹配 老版本默认0 没有该字段也默认为0
  int? isUserVoucher;

  CouponDiscountTip();

  factory CouponDiscountTip.fromJson(Map<String, dynamic> json) => $CouponDiscountTipFromJson(json);

  Map<String, dynamic> toJson() => $CouponDiscountTipToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeliveryDiscountTip {
  ///标准运费
  String? deliveryMoney;

  ///配送费减免金额
  String? deliveryDiscountAmount;

  ///实付运费
  String? payDeliveryMoney;

  ///	起送价
  String? startDeliveryMoney;

  ///配送费类型 1 免配送费 2 未减免配送费 3 部分减免配送费 4 全部减免配送费
  int? deliverType;

  ///梯度减免类型 1 再买免费 2 再买减免
  int? gradientfreeType;

  ///还差金额
  String? stillOweDeliveryMoney;

  ///下一级可免配送费
  String? nextLevelFreeDeliveryMoney;

  ///免费配送标准
  String? freeThresholdMoney;

  bool? firstOrderFreeDeliveryFee;

  DeliveryDiscountTip();

  factory DeliveryDiscountTip.fromJson(Map<String, dynamic> json) =>
      $DeliveryDiscountTipFromJson(json);

  Map<String, dynamic> toJson() => $DeliveryDiscountTipToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class FinanceDetail {
  String? totalProductMoney;
  String? totalProductDiscountMoney;
  String? couponDiscountMoney;
  String? bountyDiscountMoney;
  String? specialDiscountAmount;

  FinanceDetail();

  factory FinanceDetail.fromJson(Map<String, dynamic> json) => $FinanceDetailFromJson(json);

  Map<String, dynamic> toJson() => $FinanceDetailToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
