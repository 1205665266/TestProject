import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_confirm_model_entity.g.dart';
import 'dart:convert';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';

@JsonSerializable()
class OrderConfirmModelEntity {

	String? takeFoodModeFilterContext;
	OrderConfirmModelShop? shop;
	bool? isBusiness;
	bool? isDispatch;
	String? estimateTip;
	String? dispatchTime;
	String? estimateTime;
	String? estimateContext;
	double? limitDistance;
	double? tempDistance;
	int? shopMdCode;
	List<OrderConfirmModelConfirmGoodsItems>? confirmGoodsItems;
	double? totalMoney;
	double? discountMoney;
	dynamic shopIsOpen;
	dynamic showDeliverTakeInfo;
	dynamic deliverTakeStr;
	dynamic expectedDeliveryTime;
	dynamic fromDateTime;
	dynamic toDateTime;
	OrderConfirmModelFinanceDetail? financeDetail;
	int? orderType;
	String? bountyRuleDesc;
	int? bountyRatio;
	dynamic deliverRuleDesc;
	bool? bestDiscountPlan;
	List<String>? couponNoList;
	bool? chooseNotUseCoupon;
	bool? hasOptionalTimeList;
	int? availableCouponCount;
	bool? useBounty;
	int? checkCode;
	String? checkMsg;
	String? notClickableMsg;
	bool? startDeliveryMsg;
	String? speciaPirceChangeMsg;

	int? benefitStatus;
	int? benefitType;
	String? benefitDeliverRuleDesc;


	/// since APP 105 可用代金券数量
	int? availableVoucherCount;

	/// since APP 105 会员可用代金券数量
	int? memberAvailableVoucherCount;

	/// since APP 105 订单使用代金券数量如果是1时，代金券名称
	String? usedVoucherName;

	/// since APP 105 订单使用优惠数量是1时，优惠券名称
	String? usedCouponName;

	/// since APP 105 订单可使用代金券的商品列表
	List<VoucherSkuModelEntity>? canUseVoucherProductList;

	/// since APP 105 订单使用的代金券和sku映射（同一个sku使用不同的代金券，分多条数据）
	List<VoucherSkuModelEntity>? useVoucherSkus;

	/// since APP 105 优惠方案文案
	String? discountPlanContext;


	/// since APP 105 1.前端清空缓存的推荐优惠券  2、用前端存储的推荐优惠券（有存储显示标签，无存储不显示） 3、前端存储的优惠券更新，并显示标签
	int? couponRecommendFlag;

  
  OrderConfirmModelEntity();

  factory OrderConfirmModelEntity.fromJson(Map<String, dynamic> json) => $OrderConfirmModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderConfirmModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderConfirmModelShop {

	OrderConfirmModelShopBase? base;
	OrderConfirmModelShopOperation? operation;
	OrderConfirmModelShopPosition? position;
	OrderConfirmModelShopDeliveryShopDispatcher? deliveryShopDispatcher;
  
  OrderConfirmModelShop();

  factory OrderConfirmModelShop.fromJson(Map<String, dynamic> json) => $OrderConfirmModelShopFromJson(json);

  Map<String, dynamic> toJson() => $OrderConfirmModelShopToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderConfirmModelShopBase {

	int? tenantMdCode;
	int? brandMdCode;
	String? shopShowNo;
	String? brandName;
	int? shopMdCode;
	String? shopName;
	int? cityMdCode;
	int? status;
	int? shopType;
	int? formType;
	String? color;
  String? iconUrl;
	String? shopTypeName;

  OrderConfirmModelShopBase();

  factory OrderConfirmModelShopBase.fromJson(Map<String, dynamic> json) => $OrderConfirmModelShopBaseFromJson(json);

  Map<String, dynamic> toJson() => $OrderConfirmModelShopBaseToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderConfirmModelShopOperation {

	dynamic email;
	String? phoneNumber;
	int? operationMode;
	List<int>? mealTakeMode;
	List<int>? dineMode;
	List<dynamic>? deliveryChannel;
	List<int>? orderMode;
	bool? closed;
	bool? dispatched;
	String? currentSaleTime;
	List<OrderConfirmModelShopOperationCurrentSaleTimeList>? currentSaleTimeList;
	bool? startLive;
	int? trial;
	String? planSetUpTime;
	String? setUpTime;
	dynamic areaManagerMdCode;
	int? forceClosed;
	String? crossSaleTime;
	String? crossDispatchTime;
	String? currentDispatchTime;
  
  OrderConfirmModelShopOperation();

  factory OrderConfirmModelShopOperation.fromJson(Map<String, dynamic> json) => $OrderConfirmModelShopOperationFromJson(json);

  Map<String, dynamic> toJson() => $OrderConfirmModelShopOperationToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderConfirmModelShopOperationCurrentSaleTimeList {

	int? isCrossDay;
	String? start;
	String? end;
  
  OrderConfirmModelShopOperationCurrentSaleTimeList();

  factory OrderConfirmModelShopOperationCurrentSaleTimeList.fromJson(Map<String, dynamic> json) => $OrderConfirmModelShopOperationCurrentSaleTimeListFromJson(json);

  Map<String, dynamic> toJson() => $OrderConfirmModelShopOperationCurrentSaleTimeListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderConfirmModelShopPosition {

	double? locationLongitude;
	double? locationLatitude;
	String? address;
	double? distance;
	double? stepDistance;
  
  OrderConfirmModelShopPosition();

  factory OrderConfirmModelShopPosition.fromJson(Map<String, dynamic> json) => $OrderConfirmModelShopPositionFromJson(json);

  Map<String, dynamic> toJson() => $OrderConfirmModelShopPositionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderConfirmModelShopDeliveryShopDispatcher {

	int? dispatchType;
	String? distributorNo;
	String? distributorName;
	int? dispatchWay;
  
  OrderConfirmModelShopDeliveryShopDispatcher();

  factory OrderConfirmModelShopDeliveryShopDispatcher.fromJson(Map<String, dynamic> json) => $OrderConfirmModelShopDeliveryShopDispatcherFromJson(json);

  Map<String, dynamic> toJson() => $OrderConfirmModelShopDeliveryShopDispatcherToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderConfirmModelConfirmGoodsItems {

	String? itemNo;
	dynamic itemId;
	dynamic skuId;
	String? skuNo;
	dynamic skuName;
	String? skuShowName;
	String? title;
	String? image;
	double? facePrice;
	double? lineThroughPrice;
	double? specialPrice;
	dynamic specialAvaNum;
	int? buyNum;
	String? categoryCode;
	dynamic preferenceType;
	String? preferenceTypeDesc;
  
  OrderConfirmModelConfirmGoodsItems();

  factory OrderConfirmModelConfirmGoodsItems.fromJson(Map<String, dynamic> json) => $OrderConfirmModelConfirmGoodsItemsFromJson(json);

  Map<String, dynamic> toJson() => $OrderConfirmModelConfirmGoodsItemsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderConfirmModelFinanceDetail {

	double? totalProductMoney;
	double? totalProductDiscountMoney;
	double? couponDiscountMoney;
	double? specialOfferDiscountMoney;
	double? totalBounty;
	double? bountyDiscountMoney;
	int? bountyDeductionNum;
	double? deliveryMoney;
	double? startDeliveryMoney;
	double? deliveryPayMoney;
	double? freeThresholdMoney;
	double? totalPayAmount4Product;
	double? totalAmount4ProductDiscount;

	/// 代金券折扣金额
	String? totalVoucherDiscountMoney;

	List<OrderConfirmModelFinanceDetailDispatchFeeDiscountList>? dispathcFeeDiscountList;
  
  OrderConfirmModelFinanceDetail();

  factory OrderConfirmModelFinanceDetail.fromJson(Map<String, dynamic> json) => $OrderConfirmModelFinanceDetailFromJson(json);

  Map<String, dynamic> toJson() => $OrderConfirmModelFinanceDetailToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
@JsonSerializable()
class OrderConfirmModelFinanceDetailDispatchFeeDiscountList {
	/// 满足减免的金额下限
	double? lowerLimitAmount;
	/// 优惠金额
	double? discountAmount;

	OrderConfirmModelFinanceDetailDispatchFeeDiscountList();

	factory OrderConfirmModelFinanceDetailDispatchFeeDiscountList.fromJson(Map<String, dynamic> json) => $OrderConfirmModelFinanceDetailDispatchFeeDiscountListFromJson(json);

	Map<String, dynamic> toJson() => $OrderConfirmModelFinanceDetailDispatchFeeDiscountListToJson(this);
}