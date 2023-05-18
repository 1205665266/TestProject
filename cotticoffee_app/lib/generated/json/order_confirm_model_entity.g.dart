import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';


OrderConfirmModelEntity $OrderConfirmModelEntityFromJson(Map<String, dynamic> json) {
	final OrderConfirmModelEntity orderConfirmModelEntity = OrderConfirmModelEntity();
	final String? takeFoodModeFilterContext = jsonConvert.convert<String>(json['takeFoodModeFilterContext']);
	if (takeFoodModeFilterContext != null) {
		orderConfirmModelEntity.takeFoodModeFilterContext = takeFoodModeFilterContext;
	}
	final OrderConfirmModelShop? shop = jsonConvert.convert<OrderConfirmModelShop>(json['shop']);
	if (shop != null) {
		orderConfirmModelEntity.shop = shop;
	}
	final bool? isBusiness = jsonConvert.convert<bool>(json['isBusiness']);
	if (isBusiness != null) {
		orderConfirmModelEntity.isBusiness = isBusiness;
	}
	final bool? isDispatch = jsonConvert.convert<bool>(json['isDispatch']);
	if (isDispatch != null) {
		orderConfirmModelEntity.isDispatch = isDispatch;
	}
	final String? estimateTip = jsonConvert.convert<String>(json['estimateTip']);
	if (estimateTip != null) {
		orderConfirmModelEntity.estimateTip = estimateTip;
	}
	final String? dispatchTime = jsonConvert.convert<String>(json['dispatchTime']);
	if (dispatchTime != null) {
		orderConfirmModelEntity.dispatchTime = dispatchTime;
	}
	final String? estimateTime = jsonConvert.convert<String>(json['estimateTime']);
	if (estimateTime != null) {
		orderConfirmModelEntity.estimateTime = estimateTime;
	}
	final String? estimateContext = jsonConvert.convert<String>(json['estimateContext']);
	if (estimateContext != null) {
		orderConfirmModelEntity.estimateContext = estimateContext;
	}
	final double? limitDistance = jsonConvert.convert<double>(json['limitDistance']);
	if (limitDistance != null) {
		orderConfirmModelEntity.limitDistance = limitDistance;
	}
	final double? tempDistance = jsonConvert.convert<double>(json['tempDistance']);
	if (tempDistance != null) {
		orderConfirmModelEntity.tempDistance = tempDistance;
	}
	final int? shopMdCode = jsonConvert.convert<int>(json['shopMdCode']);
	if (shopMdCode != null) {
		orderConfirmModelEntity.shopMdCode = shopMdCode;
	}
	final List<OrderConfirmModelConfirmGoodsItems>? confirmGoodsItems = jsonConvert.convertListNotNull<OrderConfirmModelConfirmGoodsItems>(json['confirmGoodsItems']);
	if (confirmGoodsItems != null) {
		orderConfirmModelEntity.confirmGoodsItems = confirmGoodsItems;
	}
	final double? totalMoney = jsonConvert.convert<double>(json['totalMoney']);
	if (totalMoney != null) {
		orderConfirmModelEntity.totalMoney = totalMoney;
	}
	final double? discountMoney = jsonConvert.convert<double>(json['discountMoney']);
	if (discountMoney != null) {
		orderConfirmModelEntity.discountMoney = discountMoney;
	}
	final dynamic shopIsOpen = jsonConvert.convert<dynamic>(json['shopIsOpen']);
	if (shopIsOpen != null) {
		orderConfirmModelEntity.shopIsOpen = shopIsOpen;
	}
	final dynamic showDeliverTakeInfo = jsonConvert.convert<dynamic>(json['showDeliverTakeInfo']);
	if (showDeliverTakeInfo != null) {
		orderConfirmModelEntity.showDeliverTakeInfo = showDeliverTakeInfo;
	}
	final dynamic deliverTakeStr = jsonConvert.convert<dynamic>(json['deliverTakeStr']);
	if (deliverTakeStr != null) {
		orderConfirmModelEntity.deliverTakeStr = deliverTakeStr;
	}
	final dynamic expectedDeliveryTime = jsonConvert.convert<dynamic>(json['expectedDeliveryTime']);
	if (expectedDeliveryTime != null) {
		orderConfirmModelEntity.expectedDeliveryTime = expectedDeliveryTime;
	}
	final dynamic fromDateTime = jsonConvert.convert<dynamic>(json['fromDateTime']);
	if (fromDateTime != null) {
		orderConfirmModelEntity.fromDateTime = fromDateTime;
	}
	final dynamic toDateTime = jsonConvert.convert<dynamic>(json['toDateTime']);
	if (toDateTime != null) {
		orderConfirmModelEntity.toDateTime = toDateTime;
	}
	final OrderConfirmModelFinanceDetail? financeDetail = jsonConvert.convert<OrderConfirmModelFinanceDetail>(json['financeDetail']);
	if (financeDetail != null) {
		orderConfirmModelEntity.financeDetail = financeDetail;
	}
	final int? orderType = jsonConvert.convert<int>(json['orderType']);
	if (orderType != null) {
		orderConfirmModelEntity.orderType = orderType;
	}
	final String? bountyRuleDesc = jsonConvert.convert<String>(json['bountyRuleDesc']);
	if (bountyRuleDesc != null) {
		orderConfirmModelEntity.bountyRuleDesc = bountyRuleDesc;
	}
	final int? bountyRatio = jsonConvert.convert<int>(json['bountyRatio']);
	if (bountyRatio != null) {
		orderConfirmModelEntity.bountyRatio = bountyRatio;
	}
	final dynamic deliverRuleDesc = jsonConvert.convert<dynamic>(json['deliverRuleDesc']);
	if (deliverRuleDesc != null) {
		orderConfirmModelEntity.deliverRuleDesc = deliverRuleDesc;
	}
	final bool? bestDiscountPlan = jsonConvert.convert<bool>(json['bestDiscountPlan']);
	if (bestDiscountPlan != null) {
		orderConfirmModelEntity.bestDiscountPlan = bestDiscountPlan;
	}
	final List<String>? couponNoList = jsonConvert.convertListNotNull<String>(json['couponNoList']);
	if (couponNoList != null) {
		orderConfirmModelEntity.couponNoList = couponNoList;
	}
	final bool? chooseNotUseCoupon = jsonConvert.convert<bool>(json['chooseNotUseCoupon']);
	if (chooseNotUseCoupon != null) {
		orderConfirmModelEntity.chooseNotUseCoupon = chooseNotUseCoupon;
	}
	final bool? hasOptionalTimeList = jsonConvert.convert<bool>(json['hasOptionalTimeList']);
	if (hasOptionalTimeList != null) {
		orderConfirmModelEntity.hasOptionalTimeList = hasOptionalTimeList;
	}
	final int? availableCouponCount = jsonConvert.convert<int>(json['availableCouponCount']);
	if (availableCouponCount != null) {
		orderConfirmModelEntity.availableCouponCount = availableCouponCount;
	}
	final bool? useBounty = jsonConvert.convert<bool>(json['useBounty']);
	if (useBounty != null) {
		orderConfirmModelEntity.useBounty = useBounty;
	}
	final int? checkCode = jsonConvert.convert<int>(json['checkCode']);
	if (checkCode != null) {
		orderConfirmModelEntity.checkCode = checkCode;
	}
	final String? checkMsg = jsonConvert.convert<String>(json['checkMsg']);
	if (checkMsg != null) {
		orderConfirmModelEntity.checkMsg = checkMsg;
	}
	final String? notClickableMsg = jsonConvert.convert<String>(json['notClickableMsg']);
	if (notClickableMsg != null) {
		orderConfirmModelEntity.notClickableMsg = notClickableMsg;
	}
	final bool? startDeliveryMsg = jsonConvert.convert<bool>(json['startDeliveryMsg']);
	if (startDeliveryMsg != null) {
		orderConfirmModelEntity.startDeliveryMsg = startDeliveryMsg;
	}
	final String? speciaPirceChangeMsg = jsonConvert.convert<String>(json['speciaPirceChangeMsg']);
	if (speciaPirceChangeMsg != null) {
		orderConfirmModelEntity.speciaPirceChangeMsg = speciaPirceChangeMsg;
	}
	final int? benefitStatus = jsonConvert.convert<int>(json['benefitStatus']);
	if (benefitStatus != null) {
		orderConfirmModelEntity.benefitStatus = benefitStatus;
	}
	final int? benefitType = jsonConvert.convert<int>(json['benefitType']);
	if (benefitType != null) {
		orderConfirmModelEntity.benefitType = benefitType;
	}
	final String? benefitDeliverRuleDesc = jsonConvert.convert<String>(json['benefitDeliverRuleDesc']);
	if (benefitDeliverRuleDesc != null) {
		orderConfirmModelEntity.benefitDeliverRuleDesc = benefitDeliverRuleDesc;
	}
	final int? availableVoucherCount = jsonConvert.convert<int>(json['availableVoucherCount']);
	if (availableVoucherCount != null) {
		orderConfirmModelEntity.availableVoucherCount = availableVoucherCount;
	}
	final int? memberAvailableVoucherCount = jsonConvert.convert<int>(json['memberAvailableVoucherCount']);
	if (memberAvailableVoucherCount != null) {
		orderConfirmModelEntity.memberAvailableVoucherCount = memberAvailableVoucherCount;
	}
	final String? usedVoucherName = jsonConvert.convert<String>(json['usedVoucherName']);
	if (usedVoucherName != null) {
		orderConfirmModelEntity.usedVoucherName = usedVoucherName;
	}
	final String? usedCouponName = jsonConvert.convert<String>(json['usedCouponName']);
	if (usedCouponName != null) {
		orderConfirmModelEntity.usedCouponName = usedCouponName;
	}
	final List<VoucherSkuModelEntity>? canUseVoucherProductList = jsonConvert.convertListNotNull<VoucherSkuModelEntity>(json['canUseVoucherProductList']);
	if (canUseVoucherProductList != null) {
		orderConfirmModelEntity.canUseVoucherProductList = canUseVoucherProductList;
	}
	final List<VoucherSkuModelEntity>? useVoucherSkus = jsonConvert.convertListNotNull<VoucherSkuModelEntity>(json['useVoucherSkus']);
	if (useVoucherSkus != null) {
		orderConfirmModelEntity.useVoucherSkus = useVoucherSkus;
	}
	final String? discountPlanContext = jsonConvert.convert<String>(json['discountPlanContext']);
	if (discountPlanContext != null) {
		orderConfirmModelEntity.discountPlanContext = discountPlanContext;
	}
	final int? couponRecommendFlag = jsonConvert.convert<int>(json['couponRecommendFlag']);
	if (couponRecommendFlag != null) {
		orderConfirmModelEntity.couponRecommendFlag = couponRecommendFlag;
	}
	return orderConfirmModelEntity;
}

Map<String, dynamic> $OrderConfirmModelEntityToJson(OrderConfirmModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['takeFoodModeFilterContext'] = entity.takeFoodModeFilterContext;
	data['shop'] = entity.shop?.toJson();
	data['isBusiness'] = entity.isBusiness;
	data['isDispatch'] = entity.isDispatch;
	data['estimateTip'] = entity.estimateTip;
	data['dispatchTime'] = entity.dispatchTime;
	data['estimateTime'] = entity.estimateTime;
	data['estimateContext'] = entity.estimateContext;
	data['limitDistance'] = entity.limitDistance;
	data['tempDistance'] = entity.tempDistance;
	data['shopMdCode'] = entity.shopMdCode;
	data['confirmGoodsItems'] =  entity.confirmGoodsItems?.map((v) => v.toJson()).toList();
	data['totalMoney'] = entity.totalMoney;
	data['discountMoney'] = entity.discountMoney;
	data['shopIsOpen'] = entity.shopIsOpen;
	data['showDeliverTakeInfo'] = entity.showDeliverTakeInfo;
	data['deliverTakeStr'] = entity.deliverTakeStr;
	data['expectedDeliveryTime'] = entity.expectedDeliveryTime;
	data['fromDateTime'] = entity.fromDateTime;
	data['toDateTime'] = entity.toDateTime;
	data['financeDetail'] = entity.financeDetail?.toJson();
	data['orderType'] = entity.orderType;
	data['bountyRuleDesc'] = entity.bountyRuleDesc;
	data['bountyRatio'] = entity.bountyRatio;
	data['deliverRuleDesc'] = entity.deliverRuleDesc;
	data['bestDiscountPlan'] = entity.bestDiscountPlan;
	data['couponNoList'] =  entity.couponNoList;
	data['chooseNotUseCoupon'] = entity.chooseNotUseCoupon;
	data['hasOptionalTimeList'] = entity.hasOptionalTimeList;
	data['availableCouponCount'] = entity.availableCouponCount;
	data['useBounty'] = entity.useBounty;
	data['checkCode'] = entity.checkCode;
	data['checkMsg'] = entity.checkMsg;
	data['notClickableMsg'] = entity.notClickableMsg;
	data['startDeliveryMsg'] = entity.startDeliveryMsg;
	data['speciaPirceChangeMsg'] = entity.speciaPirceChangeMsg;
	data['benefitStatus'] = entity.benefitStatus;
	data['benefitType'] = entity.benefitType;
	data['benefitDeliverRuleDesc'] = entity.benefitDeliverRuleDesc;
	data['availableVoucherCount'] = entity.availableVoucherCount;
	data['memberAvailableVoucherCount'] = entity.memberAvailableVoucherCount;
	data['usedVoucherName'] = entity.usedVoucherName;
	data['usedCouponName'] = entity.usedCouponName;
	data['canUseVoucherProductList'] =  entity.canUseVoucherProductList?.map((v) => v.toJson()).toList();
	data['useVoucherSkus'] =  entity.useVoucherSkus?.map((v) => v.toJson()).toList();
	data['discountPlanContext'] = entity.discountPlanContext;
	data['couponRecommendFlag'] = entity.couponRecommendFlag;
	return data;
}

OrderConfirmModelShop $OrderConfirmModelShopFromJson(Map<String, dynamic> json) {
	final OrderConfirmModelShop orderConfirmModelShop = OrderConfirmModelShop();
	final OrderConfirmModelShopBase? base = jsonConvert.convert<OrderConfirmModelShopBase>(json['base']);
	if (base != null) {
		orderConfirmModelShop.base = base;
	}
	final OrderConfirmModelShopOperation? operation = jsonConvert.convert<OrderConfirmModelShopOperation>(json['operation']);
	if (operation != null) {
		orderConfirmModelShop.operation = operation;
	}
	final OrderConfirmModelShopPosition? position = jsonConvert.convert<OrderConfirmModelShopPosition>(json['position']);
	if (position != null) {
		orderConfirmModelShop.position = position;
	}
	final OrderConfirmModelShopDeliveryShopDispatcher? deliveryShopDispatcher = jsonConvert.convert<OrderConfirmModelShopDeliveryShopDispatcher>(json['deliveryShopDispatcher']);
	if (deliveryShopDispatcher != null) {
		orderConfirmModelShop.deliveryShopDispatcher = deliveryShopDispatcher;
	}
	return orderConfirmModelShop;
}

Map<String, dynamic> $OrderConfirmModelShopToJson(OrderConfirmModelShop entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['base'] = entity.base?.toJson();
	data['operation'] = entity.operation?.toJson();
	data['position'] = entity.position?.toJson();
	data['deliveryShopDispatcher'] = entity.deliveryShopDispatcher?.toJson();
	return data;
}

OrderConfirmModelShopBase $OrderConfirmModelShopBaseFromJson(Map<String, dynamic> json) {
	final OrderConfirmModelShopBase orderConfirmModelShopBase = OrderConfirmModelShopBase();
	final int? tenantMdCode = jsonConvert.convert<int>(json['tenantMdCode']);
	if (tenantMdCode != null) {
		orderConfirmModelShopBase.tenantMdCode = tenantMdCode;
	}
	final int? brandMdCode = jsonConvert.convert<int>(json['brandMdCode']);
	if (brandMdCode != null) {
		orderConfirmModelShopBase.brandMdCode = brandMdCode;
	}
	final String? shopShowNo = jsonConvert.convert<String>(json['shopShowNo']);
	if (shopShowNo != null) {
		orderConfirmModelShopBase.shopShowNo = shopShowNo;
	}
	final String? brandName = jsonConvert.convert<String>(json['brandName']);
	if (brandName != null) {
		orderConfirmModelShopBase.brandName = brandName;
	}
	final int? shopMdCode = jsonConvert.convert<int>(json['shopMdCode']);
	if (shopMdCode != null) {
		orderConfirmModelShopBase.shopMdCode = shopMdCode;
	}
	final String? shopName = jsonConvert.convert<String>(json['shopName']);
	if (shopName != null) {
		orderConfirmModelShopBase.shopName = shopName;
	}
	final int? cityMdCode = jsonConvert.convert<int>(json['cityMdCode']);
	if (cityMdCode != null) {
		orderConfirmModelShopBase.cityMdCode = cityMdCode;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		orderConfirmModelShopBase.status = status;
	}
	final int? shopType = jsonConvert.convert<int>(json['shopType']);
	if (shopType != null) {
		orderConfirmModelShopBase.shopType = shopType;
	}
	final int? formType = jsonConvert.convert<int>(json['formType']);
	if (formType != null) {
		orderConfirmModelShopBase.formType = formType;
	}
	final String? color = jsonConvert.convert<String>(json['color']);
	if (color != null) {
		orderConfirmModelShopBase.color = color;
	}
	final String? iconUrl = jsonConvert.convert<String>(json['iconUrl']);
	if (iconUrl != null) {
		orderConfirmModelShopBase.iconUrl = iconUrl;
	}
	final String? shopTypeName = jsonConvert.convert<String>(json['shopTypeName']);
	if (shopTypeName != null) {
		orderConfirmModelShopBase.shopTypeName = shopTypeName;
	}
	return orderConfirmModelShopBase;
}

Map<String, dynamic> $OrderConfirmModelShopBaseToJson(OrderConfirmModelShopBase entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['tenantMdCode'] = entity.tenantMdCode;
	data['brandMdCode'] = entity.brandMdCode;
	data['shopShowNo'] = entity.shopShowNo;
	data['brandName'] = entity.brandName;
	data['shopMdCode'] = entity.shopMdCode;
	data['shopName'] = entity.shopName;
	data['cityMdCode'] = entity.cityMdCode;
	data['status'] = entity.status;
	data['shopType'] = entity.shopType;
	data['formType'] = entity.formType;
	data['color'] = entity.color;
	data['iconUrl'] = entity.iconUrl;
	data['shopTypeName'] = entity.shopTypeName;
	return data;
}

OrderConfirmModelShopOperation $OrderConfirmModelShopOperationFromJson(Map<String, dynamic> json) {
	final OrderConfirmModelShopOperation orderConfirmModelShopOperation = OrderConfirmModelShopOperation();
	final dynamic email = jsonConvert.convert<dynamic>(json['email']);
	if (email != null) {
		orderConfirmModelShopOperation.email = email;
	}
	final String? phoneNumber = jsonConvert.convert<String>(json['phoneNumber']);
	if (phoneNumber != null) {
		orderConfirmModelShopOperation.phoneNumber = phoneNumber;
	}
	final int? operationMode = jsonConvert.convert<int>(json['operationMode']);
	if (operationMode != null) {
		orderConfirmModelShopOperation.operationMode = operationMode;
	}
	final List<int>? mealTakeMode = jsonConvert.convertListNotNull<int>(json['mealTakeMode']);
	if (mealTakeMode != null) {
		orderConfirmModelShopOperation.mealTakeMode = mealTakeMode;
	}
	final List<int>? dineMode = jsonConvert.convertListNotNull<int>(json['dineMode']);
	if (dineMode != null) {
		orderConfirmModelShopOperation.dineMode = dineMode;
	}
	final List<dynamic>? deliveryChannel = jsonConvert.convertListNotNull<dynamic>(json['deliveryChannel']);
	if (deliveryChannel != null) {
		orderConfirmModelShopOperation.deliveryChannel = deliveryChannel;
	}
	final List<int>? orderMode = jsonConvert.convertListNotNull<int>(json['orderMode']);
	if (orderMode != null) {
		orderConfirmModelShopOperation.orderMode = orderMode;
	}
	final bool? closed = jsonConvert.convert<bool>(json['closed']);
	if (closed != null) {
		orderConfirmModelShopOperation.closed = closed;
	}
	final bool? dispatched = jsonConvert.convert<bool>(json['dispatched']);
	if (dispatched != null) {
		orderConfirmModelShopOperation.dispatched = dispatched;
	}
	final String? currentSaleTime = jsonConvert.convert<String>(json['currentSaleTime']);
	if (currentSaleTime != null) {
		orderConfirmModelShopOperation.currentSaleTime = currentSaleTime;
	}
	final List<OrderConfirmModelShopOperationCurrentSaleTimeList>? currentSaleTimeList = jsonConvert.convertListNotNull<OrderConfirmModelShopOperationCurrentSaleTimeList>(json['currentSaleTimeList']);
	if (currentSaleTimeList != null) {
		orderConfirmModelShopOperation.currentSaleTimeList = currentSaleTimeList;
	}
	final bool? startLive = jsonConvert.convert<bool>(json['startLive']);
	if (startLive != null) {
		orderConfirmModelShopOperation.startLive = startLive;
	}
	final int? trial = jsonConvert.convert<int>(json['trial']);
	if (trial != null) {
		orderConfirmModelShopOperation.trial = trial;
	}
	final String? planSetUpTime = jsonConvert.convert<String>(json['planSetUpTime']);
	if (planSetUpTime != null) {
		orderConfirmModelShopOperation.planSetUpTime = planSetUpTime;
	}
	final String? setUpTime = jsonConvert.convert<String>(json['setUpTime']);
	if (setUpTime != null) {
		orderConfirmModelShopOperation.setUpTime = setUpTime;
	}
	final dynamic areaManagerMdCode = jsonConvert.convert<dynamic>(json['areaManagerMdCode']);
	if (areaManagerMdCode != null) {
		orderConfirmModelShopOperation.areaManagerMdCode = areaManagerMdCode;
	}
	final int? forceClosed = jsonConvert.convert<int>(json['forceClosed']);
	if (forceClosed != null) {
		orderConfirmModelShopOperation.forceClosed = forceClosed;
	}
	final String? crossSaleTime = jsonConvert.convert<String>(json['crossSaleTime']);
	if (crossSaleTime != null) {
		orderConfirmModelShopOperation.crossSaleTime = crossSaleTime;
	}
	final String? crossDispatchTime = jsonConvert.convert<String>(json['crossDispatchTime']);
	if (crossDispatchTime != null) {
		orderConfirmModelShopOperation.crossDispatchTime = crossDispatchTime;
	}
	final String? currentDispatchTime = jsonConvert.convert<String>(json['currentDispatchTime']);
	if (currentDispatchTime != null) {
		orderConfirmModelShopOperation.currentDispatchTime = currentDispatchTime;
	}
	return orderConfirmModelShopOperation;
}

Map<String, dynamic> $OrderConfirmModelShopOperationToJson(OrderConfirmModelShopOperation entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['email'] = entity.email;
	data['phoneNumber'] = entity.phoneNumber;
	data['operationMode'] = entity.operationMode;
	data['mealTakeMode'] =  entity.mealTakeMode;
	data['dineMode'] =  entity.dineMode;
	data['deliveryChannel'] =  entity.deliveryChannel;
	data['orderMode'] =  entity.orderMode;
	data['closed'] = entity.closed;
	data['dispatched'] = entity.dispatched;
	data['currentSaleTime'] = entity.currentSaleTime;
	data['currentSaleTimeList'] =  entity.currentSaleTimeList?.map((v) => v.toJson()).toList();
	data['startLive'] = entity.startLive;
	data['trial'] = entity.trial;
	data['planSetUpTime'] = entity.planSetUpTime;
	data['setUpTime'] = entity.setUpTime;
	data['areaManagerMdCode'] = entity.areaManagerMdCode;
	data['forceClosed'] = entity.forceClosed;
	data['crossSaleTime'] = entity.crossSaleTime;
	data['crossDispatchTime'] = entity.crossDispatchTime;
	data['currentDispatchTime'] = entity.currentDispatchTime;
	return data;
}

OrderConfirmModelShopOperationCurrentSaleTimeList $OrderConfirmModelShopOperationCurrentSaleTimeListFromJson(Map<String, dynamic> json) {
	final OrderConfirmModelShopOperationCurrentSaleTimeList orderConfirmModelShopOperationCurrentSaleTimeList = OrderConfirmModelShopOperationCurrentSaleTimeList();
	final int? isCrossDay = jsonConvert.convert<int>(json['isCrossDay']);
	if (isCrossDay != null) {
		orderConfirmModelShopOperationCurrentSaleTimeList.isCrossDay = isCrossDay;
	}
	final String? start = jsonConvert.convert<String>(json['start']);
	if (start != null) {
		orderConfirmModelShopOperationCurrentSaleTimeList.start = start;
	}
	final String? end = jsonConvert.convert<String>(json['end']);
	if (end != null) {
		orderConfirmModelShopOperationCurrentSaleTimeList.end = end;
	}
	return orderConfirmModelShopOperationCurrentSaleTimeList;
}

Map<String, dynamic> $OrderConfirmModelShopOperationCurrentSaleTimeListToJson(OrderConfirmModelShopOperationCurrentSaleTimeList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['isCrossDay'] = entity.isCrossDay;
	data['start'] = entity.start;
	data['end'] = entity.end;
	return data;
}

OrderConfirmModelShopPosition $OrderConfirmModelShopPositionFromJson(Map<String, dynamic> json) {
	final OrderConfirmModelShopPosition orderConfirmModelShopPosition = OrderConfirmModelShopPosition();
	final double? locationLongitude = jsonConvert.convert<double>(json['locationLongitude']);
	if (locationLongitude != null) {
		orderConfirmModelShopPosition.locationLongitude = locationLongitude;
	}
	final double? locationLatitude = jsonConvert.convert<double>(json['locationLatitude']);
	if (locationLatitude != null) {
		orderConfirmModelShopPosition.locationLatitude = locationLatitude;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		orderConfirmModelShopPosition.address = address;
	}
	final double? distance = jsonConvert.convert<double>(json['distance']);
	if (distance != null) {
		orderConfirmModelShopPosition.distance = distance;
	}
	final double? stepDistance = jsonConvert.convert<double>(json['stepDistance']);
	if (stepDistance != null) {
		orderConfirmModelShopPosition.stepDistance = stepDistance;
	}
	return orderConfirmModelShopPosition;
}

Map<String, dynamic> $OrderConfirmModelShopPositionToJson(OrderConfirmModelShopPosition entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['locationLongitude'] = entity.locationLongitude;
	data['locationLatitude'] = entity.locationLatitude;
	data['address'] = entity.address;
	data['distance'] = entity.distance;
	data['stepDistance'] = entity.stepDistance;
	return data;
}

OrderConfirmModelShopDeliveryShopDispatcher $OrderConfirmModelShopDeliveryShopDispatcherFromJson(Map<String, dynamic> json) {
	final OrderConfirmModelShopDeliveryShopDispatcher orderConfirmModelShopDeliveryShopDispatcher = OrderConfirmModelShopDeliveryShopDispatcher();
	final int? dispatchType = jsonConvert.convert<int>(json['dispatchType']);
	if (dispatchType != null) {
		orderConfirmModelShopDeliveryShopDispatcher.dispatchType = dispatchType;
	}
	final String? distributorNo = jsonConvert.convert<String>(json['distributorNo']);
	if (distributorNo != null) {
		orderConfirmModelShopDeliveryShopDispatcher.distributorNo = distributorNo;
	}
	final String? distributorName = jsonConvert.convert<String>(json['distributorName']);
	if (distributorName != null) {
		orderConfirmModelShopDeliveryShopDispatcher.distributorName = distributorName;
	}
	final int? dispatchWay = jsonConvert.convert<int>(json['dispatchWay']);
	if (dispatchWay != null) {
		orderConfirmModelShopDeliveryShopDispatcher.dispatchWay = dispatchWay;
	}
	return orderConfirmModelShopDeliveryShopDispatcher;
}

Map<String, dynamic> $OrderConfirmModelShopDeliveryShopDispatcherToJson(OrderConfirmModelShopDeliveryShopDispatcher entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['dispatchType'] = entity.dispatchType;
	data['distributorNo'] = entity.distributorNo;
	data['distributorName'] = entity.distributorName;
	data['dispatchWay'] = entity.dispatchWay;
	return data;
}

OrderConfirmModelConfirmGoodsItems $OrderConfirmModelConfirmGoodsItemsFromJson(Map<String, dynamic> json) {
	final OrderConfirmModelConfirmGoodsItems orderConfirmModelConfirmGoodsItems = OrderConfirmModelConfirmGoodsItems();
	final String? itemNo = jsonConvert.convert<String>(json['itemNo']);
	if (itemNo != null) {
		orderConfirmModelConfirmGoodsItems.itemNo = itemNo;
	}
	final dynamic itemId = jsonConvert.convert<dynamic>(json['itemId']);
	if (itemId != null) {
		orderConfirmModelConfirmGoodsItems.itemId = itemId;
	}
	final dynamic skuId = jsonConvert.convert<dynamic>(json['skuId']);
	if (skuId != null) {
		orderConfirmModelConfirmGoodsItems.skuId = skuId;
	}
	final String? skuNo = jsonConvert.convert<String>(json['skuNo']);
	if (skuNo != null) {
		orderConfirmModelConfirmGoodsItems.skuNo = skuNo;
	}
	final dynamic skuName = jsonConvert.convert<dynamic>(json['skuName']);
	if (skuName != null) {
		orderConfirmModelConfirmGoodsItems.skuName = skuName;
	}
	final String? skuShowName = jsonConvert.convert<String>(json['skuShowName']);
	if (skuShowName != null) {
		orderConfirmModelConfirmGoodsItems.skuShowName = skuShowName;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		orderConfirmModelConfirmGoodsItems.title = title;
	}
	final String? image = jsonConvert.convert<String>(json['image']);
	if (image != null) {
		orderConfirmModelConfirmGoodsItems.image = image;
	}
	final double? facePrice = jsonConvert.convert<double>(json['facePrice']);
	if (facePrice != null) {
		orderConfirmModelConfirmGoodsItems.facePrice = facePrice;
	}
	final double? lineThroughPrice = jsonConvert.convert<double>(json['lineThroughPrice']);
	if (lineThroughPrice != null) {
		orderConfirmModelConfirmGoodsItems.lineThroughPrice = lineThroughPrice;
	}
	final double? specialPrice = jsonConvert.convert<double>(json['specialPrice']);
	if (specialPrice != null) {
		orderConfirmModelConfirmGoodsItems.specialPrice = specialPrice;
	}
	final dynamic specialAvaNum = jsonConvert.convert<dynamic>(json['specialAvaNum']);
	if (specialAvaNum != null) {
		orderConfirmModelConfirmGoodsItems.specialAvaNum = specialAvaNum;
	}
	final int? buyNum = jsonConvert.convert<int>(json['buyNum']);
	if (buyNum != null) {
		orderConfirmModelConfirmGoodsItems.buyNum = buyNum;
	}
	final String? categoryCode = jsonConvert.convert<String>(json['categoryCode']);
	if (categoryCode != null) {
		orderConfirmModelConfirmGoodsItems.categoryCode = categoryCode;
	}
	final dynamic preferenceType = jsonConvert.convert<dynamic>(json['preferenceType']);
	if (preferenceType != null) {
		orderConfirmModelConfirmGoodsItems.preferenceType = preferenceType;
	}
	final String? preferenceTypeDesc = jsonConvert.convert<String>(json['preferenceTypeDesc']);
	if (preferenceTypeDesc != null) {
		orderConfirmModelConfirmGoodsItems.preferenceTypeDesc = preferenceTypeDesc;
	}
	return orderConfirmModelConfirmGoodsItems;
}

Map<String, dynamic> $OrderConfirmModelConfirmGoodsItemsToJson(OrderConfirmModelConfirmGoodsItems entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['itemNo'] = entity.itemNo;
	data['itemId'] = entity.itemId;
	data['skuId'] = entity.skuId;
	data['skuNo'] = entity.skuNo;
	data['skuName'] = entity.skuName;
	data['skuShowName'] = entity.skuShowName;
	data['title'] = entity.title;
	data['image'] = entity.image;
	data['facePrice'] = entity.facePrice;
	data['lineThroughPrice'] = entity.lineThroughPrice;
	data['specialPrice'] = entity.specialPrice;
	data['specialAvaNum'] = entity.specialAvaNum;
	data['buyNum'] = entity.buyNum;
	data['categoryCode'] = entity.categoryCode;
	data['preferenceType'] = entity.preferenceType;
	data['preferenceTypeDesc'] = entity.preferenceTypeDesc;
	return data;
}

OrderConfirmModelFinanceDetail $OrderConfirmModelFinanceDetailFromJson(Map<String, dynamic> json) {
	final OrderConfirmModelFinanceDetail orderConfirmModelFinanceDetail = OrderConfirmModelFinanceDetail();
	final double? totalProductMoney = jsonConvert.convert<double>(json['totalProductMoney']);
	if (totalProductMoney != null) {
		orderConfirmModelFinanceDetail.totalProductMoney = totalProductMoney;
	}
	final double? totalProductDiscountMoney = jsonConvert.convert<double>(json['totalProductDiscountMoney']);
	if (totalProductDiscountMoney != null) {
		orderConfirmModelFinanceDetail.totalProductDiscountMoney = totalProductDiscountMoney;
	}
	final double? couponDiscountMoney = jsonConvert.convert<double>(json['couponDiscountMoney']);
	if (couponDiscountMoney != null) {
		orderConfirmModelFinanceDetail.couponDiscountMoney = couponDiscountMoney;
	}
	final double? specialOfferDiscountMoney = jsonConvert.convert<double>(json['specialOfferDiscountMoney']);
	if (specialOfferDiscountMoney != null) {
		orderConfirmModelFinanceDetail.specialOfferDiscountMoney = specialOfferDiscountMoney;
	}
	final double? totalBounty = jsonConvert.convert<double>(json['totalBounty']);
	if (totalBounty != null) {
		orderConfirmModelFinanceDetail.totalBounty = totalBounty;
	}
	final double? bountyDiscountMoney = jsonConvert.convert<double>(json['bountyDiscountMoney']);
	if (bountyDiscountMoney != null) {
		orderConfirmModelFinanceDetail.bountyDiscountMoney = bountyDiscountMoney;
	}
	final int? bountyDeductionNum = jsonConvert.convert<int>(json['bountyDeductionNum']);
	if (bountyDeductionNum != null) {
		orderConfirmModelFinanceDetail.bountyDeductionNum = bountyDeductionNum;
	}
	final double? deliveryMoney = jsonConvert.convert<double>(json['deliveryMoney']);
	if (deliveryMoney != null) {
		orderConfirmModelFinanceDetail.deliveryMoney = deliveryMoney;
	}
	final double? startDeliveryMoney = jsonConvert.convert<double>(json['startDeliveryMoney']);
	if (startDeliveryMoney != null) {
		orderConfirmModelFinanceDetail.startDeliveryMoney = startDeliveryMoney;
	}
	final double? deliveryPayMoney = jsonConvert.convert<double>(json['deliveryPayMoney']);
	if (deliveryPayMoney != null) {
		orderConfirmModelFinanceDetail.deliveryPayMoney = deliveryPayMoney;
	}
	final double? freeThresholdMoney = jsonConvert.convert<double>(json['freeThresholdMoney']);
	if (freeThresholdMoney != null) {
		orderConfirmModelFinanceDetail.freeThresholdMoney = freeThresholdMoney;
	}
	final double? totalPayAmount4Product = jsonConvert.convert<double>(json['totalPayAmount4Product']);
	if (totalPayAmount4Product != null) {
		orderConfirmModelFinanceDetail.totalPayAmount4Product = totalPayAmount4Product;
	}
	final double? totalAmount4ProductDiscount = jsonConvert.convert<double>(json['totalAmount4ProductDiscount']);
	if (totalAmount4ProductDiscount != null) {
		orderConfirmModelFinanceDetail.totalAmount4ProductDiscount = totalAmount4ProductDiscount;
	}
	final String? totalVoucherDiscountMoney = jsonConvert.convert<String>(json['totalVoucherDiscountMoney']);
	if (totalVoucherDiscountMoney != null) {
		orderConfirmModelFinanceDetail.totalVoucherDiscountMoney = totalVoucherDiscountMoney;
	}
	final List<OrderConfirmModelFinanceDetailDispatchFeeDiscountList>? dispathcFeeDiscountList = jsonConvert.convertListNotNull<OrderConfirmModelFinanceDetailDispatchFeeDiscountList>(json['dispathcFeeDiscountList']);
	if (dispathcFeeDiscountList != null) {
		orderConfirmModelFinanceDetail.dispathcFeeDiscountList = dispathcFeeDiscountList;
	}
	return orderConfirmModelFinanceDetail;
}

Map<String, dynamic> $OrderConfirmModelFinanceDetailToJson(OrderConfirmModelFinanceDetail entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['totalProductMoney'] = entity.totalProductMoney;
	data['totalProductDiscountMoney'] = entity.totalProductDiscountMoney;
	data['couponDiscountMoney'] = entity.couponDiscountMoney;
	data['specialOfferDiscountMoney'] = entity.specialOfferDiscountMoney;
	data['totalBounty'] = entity.totalBounty;
	data['bountyDiscountMoney'] = entity.bountyDiscountMoney;
	data['bountyDeductionNum'] = entity.bountyDeductionNum;
	data['deliveryMoney'] = entity.deliveryMoney;
	data['startDeliveryMoney'] = entity.startDeliveryMoney;
	data['deliveryPayMoney'] = entity.deliveryPayMoney;
	data['freeThresholdMoney'] = entity.freeThresholdMoney;
	data['totalPayAmount4Product'] = entity.totalPayAmount4Product;
	data['totalAmount4ProductDiscount'] = entity.totalAmount4ProductDiscount;
	data['totalVoucherDiscountMoney'] = entity.totalVoucherDiscountMoney;
	data['dispathcFeeDiscountList'] =  entity.dispathcFeeDiscountList?.map((v) => v.toJson()).toList();
	return data;
}

OrderConfirmModelFinanceDetailDispatchFeeDiscountList $OrderConfirmModelFinanceDetailDispatchFeeDiscountListFromJson(Map<String, dynamic> json) {
	final OrderConfirmModelFinanceDetailDispatchFeeDiscountList orderConfirmModelFinanceDetailDispatchFeeDiscountList = OrderConfirmModelFinanceDetailDispatchFeeDiscountList();
	final double? lowerLimitAmount = jsonConvert.convert<double>(json['lowerLimitAmount']);
	if (lowerLimitAmount != null) {
		orderConfirmModelFinanceDetailDispatchFeeDiscountList.lowerLimitAmount = lowerLimitAmount;
	}
	final double? discountAmount = jsonConvert.convert<double>(json['discountAmount']);
	if (discountAmount != null) {
		orderConfirmModelFinanceDetailDispatchFeeDiscountList.discountAmount = discountAmount;
	}
	return orderConfirmModelFinanceDetailDispatchFeeDiscountList;
}

Map<String, dynamic> $OrderConfirmModelFinanceDetailDispatchFeeDiscountListToJson(OrderConfirmModelFinanceDetailDispatchFeeDiscountList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['lowerLimitAmount'] = entity.lowerLimitAmount;
	data['discountAmount'] = entity.discountAmount;
	return data;
}