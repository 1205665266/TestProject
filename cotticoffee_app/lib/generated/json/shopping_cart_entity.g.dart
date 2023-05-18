import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/shopping_cart/entity/shopping_cart_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';

import 'package:cotti_client/pages/tabs/menu/entity/special_activity_limit.dart';

import 'package:cotti_client/pages/tabs/menu/entity/special_price_activity.dart';


ShoppingCartEntity $ShoppingCartEntityFromJson(Map<String, dynamic> json) {
	final ShoppingCartEntity shoppingCartEntity = ShoppingCartEntity();
	final int? shopId = jsonConvert.convert<int>(json['shopId']);
	if (shopId != null) {
		shoppingCartEntity.shopId = shopId;
	}
	final int? shopMdCode = jsonConvert.convert<int>(json['shopMdCode']);
	if (shopMdCode != null) {
		shoppingCartEntity.shopMdCode = shopMdCode;
	}
	final List<GoodsItem>? cartGoodsItemList = jsonConvert.convertListNotNull<GoodsItem>(json['cartGoodsItemList']);
	if (cartGoodsItemList != null) {
		shoppingCartEntity.cartGoodsItemList = cartGoodsItemList;
	}
	final String? totalMoney = jsonConvert.convert<String>(json['totalMoney']);
	if (totalMoney != null) {
		shoppingCartEntity.totalMoney = totalMoney;
	}
	final String? discountMoney = jsonConvert.convert<String>(json['discountMoney']);
	if (discountMoney != null) {
		shoppingCartEntity.discountMoney = discountMoney;
	}
	final bool? shopIsOpen = jsonConvert.convert<bool>(json['shopIsOpen']);
	if (shopIsOpen != null) {
		shoppingCartEntity.shopIsOpen = shopIsOpen;
	}
	final bool? showDelayTips = jsonConvert.convert<bool>(json['showDelayTips']);
	if (showDelayTips != null) {
		shoppingCartEntity.showDelayTips = showDelayTips;
	}
	final String? delayDeliveryMsg = jsonConvert.convert<String>(json['delayDeliveryMsg']);
	if (delayDeliveryMsg != null) {
		shoppingCartEntity.delayDeliveryMsg = delayDeliveryMsg;
	}
	final CouponDiscountTip? couponDiscountTip = jsonConvert.convert<CouponDiscountTip>(json['couponDiscountTip']);
	if (couponDiscountTip != null) {
		shoppingCartEntity.couponDiscountTip = couponDiscountTip;
	}
	final DeliveryDiscountTip? deliveryDiscountTip = jsonConvert.convert<DeliveryDiscountTip>(json['deliveryDiscountTip']);
	if (deliveryDiscountTip != null) {
		shoppingCartEntity.deliveryDiscountTip = deliveryDiscountTip;
	}
	final FinanceDetail? financeDetail = jsonConvert.convert<FinanceDetail>(json['financeDetail']);
	if (financeDetail != null) {
		shoppingCartEntity.financeDetail = financeDetail;
	}
	final bool? gtCartItemMaxLimit = jsonConvert.convert<bool>(json['gtCartItemMaxLimit']);
	if (gtCartItemMaxLimit != null) {
		shoppingCartEntity.gtCartItemMaxLimit = gtCartItemMaxLimit;
	}
	final int? currentTimeMillis = jsonConvert.convert<int>(json['currentTimeMillis']);
	if (currentTimeMillis != null) {
		shoppingCartEntity.currentTimeMillis = currentTimeMillis;
	}
	final String? totalLineThroughPrice = jsonConvert.convert<String>(json['totalLineThroughPrice']);
	if (totalLineThroughPrice != null) {
		shoppingCartEntity.totalLineThroughPrice = totalLineThroughPrice;
	}
	return shoppingCartEntity;
}

Map<String, dynamic> $ShoppingCartEntityToJson(ShoppingCartEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['shopId'] = entity.shopId;
	data['shopMdCode'] = entity.shopMdCode;
	data['cartGoodsItemList'] =  entity.cartGoodsItemList?.map((v) => v.toJson()).toList();
	data['totalMoney'] = entity.totalMoney;
	data['discountMoney'] = entity.discountMoney;
	data['shopIsOpen'] = entity.shopIsOpen;
	data['showDelayTips'] = entity.showDelayTips;
	data['delayDeliveryMsg'] = entity.delayDeliveryMsg;
	data['couponDiscountTip'] = entity.couponDiscountTip?.toJson();
	data['deliveryDiscountTip'] = entity.deliveryDiscountTip?.toJson();
	data['financeDetail'] = entity.financeDetail?.toJson();
	data['gtCartItemMaxLimit'] = entity.gtCartItemMaxLimit;
	data['currentTimeMillis'] = entity.currentTimeMillis;
	data['totalLineThroughPrice'] = entity.totalLineThroughPrice;
	return data;
}

GoodsItem $GoodsItemFromJson(Map<String, dynamic> json) {
	final GoodsItem goodsItem = GoodsItem();
	final String? itemNo = jsonConvert.convert<String>(json['itemNo']);
	if (itemNo != null) {
		goodsItem.itemNo = itemNo;
	}
	final num? itemId = jsonConvert.convert<num>(json['itemId']);
	if (itemId != null) {
		goodsItem.itemId = itemId;
	}
	final num? skuId = jsonConvert.convert<num>(json['skuId']);
	if (skuId != null) {
		goodsItem.skuId = skuId;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		goodsItem.title = title;
	}
	final String? image = jsonConvert.convert<String>(json['image']);
	if (image != null) {
		goodsItem.image = image;
	}
	final String? salePrice = jsonConvert.convert<String>(json['salePrice']);
	if (salePrice != null) {
		goodsItem.salePrice = salePrice;
	}
	final String? lineThroughPrice = jsonConvert.convert<String>(json['lineThroughPrice']);
	if (lineThroughPrice != null) {
		goodsItem.lineThroughPrice = lineThroughPrice;
	}
	final int? buyNum = jsonConvert.convert<int>(json['buyNum']);
	if (buyNum != null) {
		goodsItem.buyNum = buyNum;
	}
	final int? stockNum = jsonConvert.convert<int>(json['stockNum']);
	if (stockNum != null) {
		goodsItem.stockNum = stockNum;
	}
	final String? netWeight = jsonConvert.convert<String>(json['netWeight']);
	if (netWeight != null) {
		goodsItem.netWeight = netWeight;
	}
	final int? soldOut = jsonConvert.convert<int>(json['soldOut']);
	if (soldOut != null) {
		goodsItem.soldOut = soldOut;
	}
	final int? saleable = jsonConvert.convert<int>(json['saleable']);
	if (saleable != null) {
		goodsItem.saleable = saleable;
	}
	final String? notSaleableReason = jsonConvert.convert<String>(json['notSaleableReason']);
	if (notSaleableReason != null) {
		goodsItem.notSaleableReason = notSaleableReason;
	}
	final int? selectedStatus = jsonConvert.convert<int>(json['selectedStatus']);
	if (selectedStatus != null) {
		goodsItem.selectedStatus = selectedStatus;
	}
	final int? addCartTime = jsonConvert.convert<int>(json['addCartTime']);
	if (addCartTime != null) {
		goodsItem.addCartTime = addCartTime;
	}
	final String? skuCode = jsonConvert.convert<String>(json['skuCode']);
	if (skuCode != null) {
		goodsItem.skuCode = skuCode;
	}
	final List<SkuSpec>? skusSpecs = jsonConvert.convertListNotNull<SkuSpec>(json['skusSpecs']);
	if (skusSpecs != null) {
		goodsItem.skusSpecs = skusSpecs;
	}
	final String? spuShowName = jsonConvert.convert<String>(json['spuShowName']);
	if (spuShowName != null) {
		goodsItem.spuShowName = spuShowName;
	}
	final String? skuShowName = jsonConvert.convert<String>(json['skuShowName']);
	if (skuShowName != null) {
		goodsItem.skuShowName = skuShowName;
	}
	final bool? existOtherSku = jsonConvert.convert<bool>(json['existOtherSku']);
	if (existOtherSku != null) {
		goodsItem.existOtherSku = existOtherSku;
	}
	final SpecialPriceActivity? specialPriceActivity = jsonConvert.convert<SpecialPriceActivity>(json['specialPriceActivityApiDTO']);
	if (specialPriceActivity != null) {
		goodsItem.specialPriceActivity = specialPriceActivity;
	}
	final bool? specialActivityGood = jsonConvert.convert<bool>(json['specialActivityGood']);
	if (specialActivityGood != null) {
		goodsItem.specialActivityGood = specialActivityGood;
	}
	final bool? singleSkuItem = jsonConvert.convert<bool>(json['singleSkuItem']);
	if (singleSkuItem != null) {
		goodsItem.singleSkuItem = singleSkuItem;
	}
	final SpecialActivityLimit? specialActivityLimit = jsonConvert.convert<SpecialActivityLimit>(json['specialActivityLimitDTO']);
	if (specialActivityLimit != null) {
		goodsItem.specialActivityLimit = specialActivityLimit;
	}
	final bool? showLimitCouponNumMsg = jsonConvert.convert<bool>(json['showLimitCouponNumMsg']);
	if (showLimitCouponNumMsg != null) {
		goodsItem.showLimitCouponNumMsg = showLimitCouponNumMsg;
	}
	final int? processPriceCounponNum = jsonConvert.convert<int>(json['processPriceCounponNum']);
	if (processPriceCounponNum != null) {
		goodsItem.processPriceCounponNum = processPriceCounponNum;
	}
	final int? processPriceSpecialNum = jsonConvert.convert<int>(json['processPriceSpecialNum']);
	if (processPriceSpecialNum != null) {
		goodsItem.processPriceSpecialNum = processPriceSpecialNum;
	}
	final int? mealType = jsonConvert.convert<int>(json['mealType']);
	if (mealType != null) {
		goodsItem.mealType = mealType;
	}
	final List<int>? businessTypes = jsonConvert.convertListNotNull<int>(json['businessTypes']);
	if (businessTypes != null) {
		goodsItem.businessTypes = businessTypes;
	}
	return goodsItem;
}

Map<String, dynamic> $GoodsItemToJson(GoodsItem entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['itemNo'] = entity.itemNo;
	data['itemId'] = entity.itemId;
	data['skuId'] = entity.skuId;
	data['title'] = entity.title;
	data['image'] = entity.image;
	data['salePrice'] = entity.salePrice;
	data['lineThroughPrice'] = entity.lineThroughPrice;
	data['buyNum'] = entity.buyNum;
	data['stockNum'] = entity.stockNum;
	data['netWeight'] = entity.netWeight;
	data['soldOut'] = entity.soldOut;
	data['saleable'] = entity.saleable;
	data['notSaleableReason'] = entity.notSaleableReason;
	data['selectedStatus'] = entity.selectedStatus;
	data['addCartTime'] = entity.addCartTime;
	data['skuCode'] = entity.skuCode;
	data['skusSpecs'] =  entity.skusSpecs?.map((v) => v.toJson()).toList();
	data['spuShowName'] = entity.spuShowName;
	data['skuShowName'] = entity.skuShowName;
	data['existOtherSku'] = entity.existOtherSku;
	data['specialPriceActivityApiDTO'] = entity.specialPriceActivity?.toJson();
	data['specialActivityGood'] = entity.specialActivityGood;
	data['singleSkuItem'] = entity.singleSkuItem;
	data['specialActivityLimitDTO'] = entity.specialActivityLimit?.toJson();
	data['showLimitCouponNumMsg'] = entity.showLimitCouponNumMsg;
	data['processPriceCounponNum'] = entity.processPriceCounponNum;
	data['processPriceSpecialNum'] = entity.processPriceSpecialNum;
	data['mealType'] = entity.mealType;
	data['businessTypes'] =  entity.businessTypes;
	return data;
}

CouponDiscountTip $CouponDiscountTipFromJson(Map<String, dynamic> json) {
	final CouponDiscountTip couponDiscountTip = CouponDiscountTip();
	final String? reducedMoney = jsonConvert.convert<String>(json['reducedMoney']);
	if (reducedMoney != null) {
		couponDiscountTip.reducedMoney = reducedMoney;
	}
	final String? onecePriceDiscountMoney = jsonConvert.convert<String>(json['onecePriceDiscountMoney']);
	if (onecePriceDiscountMoney != null) {
		couponDiscountTip.onecePriceDiscountMoney = onecePriceDiscountMoney;
	}
	final String? stillOweMoney = jsonConvert.convert<String>(json['stillOweMoney']);
	if (stillOweMoney != null) {
		couponDiscountTip.stillOweMoney = stillOweMoney;
	}
	final String? canHaveMoney = jsonConvert.convert<String>(json['canHaveMoney']);
	if (canHaveMoney != null) {
		couponDiscountTip.canHaveMoney = canHaveMoney;
	}
	final int? couponType = jsonConvert.convert<int>(json['couponType']);
	if (couponType != null) {
		couponDiscountTip.couponType = couponType;
	}
	final int? maturityType = jsonConvert.convert<int>(json['maturityType']);
	if (maturityType != null) {
		couponDiscountTip.maturityType = maturityType;
	}
	final int? isUserVoucher = jsonConvert.convert<int>(json['isUserVoucher']);
	if (isUserVoucher != null) {
		couponDiscountTip.isUserVoucher = isUserVoucher;
	}
	return couponDiscountTip;
}

Map<String, dynamic> $CouponDiscountTipToJson(CouponDiscountTip entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['reducedMoney'] = entity.reducedMoney;
	data['onecePriceDiscountMoney'] = entity.onecePriceDiscountMoney;
	data['stillOweMoney'] = entity.stillOweMoney;
	data['canHaveMoney'] = entity.canHaveMoney;
	data['couponType'] = entity.couponType;
	data['maturityType'] = entity.maturityType;
	data['isUserVoucher'] = entity.isUserVoucher;
	return data;
}

DeliveryDiscountTip $DeliveryDiscountTipFromJson(Map<String, dynamic> json) {
	final DeliveryDiscountTip deliveryDiscountTip = DeliveryDiscountTip();
	final String? deliveryMoney = jsonConvert.convert<String>(json['deliveryMoney']);
	if (deliveryMoney != null) {
		deliveryDiscountTip.deliveryMoney = deliveryMoney;
	}
	final String? deliveryDiscountAmount = jsonConvert.convert<String>(json['deliveryDiscountAmount']);
	if (deliveryDiscountAmount != null) {
		deliveryDiscountTip.deliveryDiscountAmount = deliveryDiscountAmount;
	}
	final String? payDeliveryMoney = jsonConvert.convert<String>(json['payDeliveryMoney']);
	if (payDeliveryMoney != null) {
		deliveryDiscountTip.payDeliveryMoney = payDeliveryMoney;
	}
	final String? startDeliveryMoney = jsonConvert.convert<String>(json['startDeliveryMoney']);
	if (startDeliveryMoney != null) {
		deliveryDiscountTip.startDeliveryMoney = startDeliveryMoney;
	}
	final int? deliverType = jsonConvert.convert<int>(json['deliverType']);
	if (deliverType != null) {
		deliveryDiscountTip.deliverType = deliverType;
	}
	final int? gradientfreeType = jsonConvert.convert<int>(json['gradientfreeType']);
	if (gradientfreeType != null) {
		deliveryDiscountTip.gradientfreeType = gradientfreeType;
	}
	final String? stillOweDeliveryMoney = jsonConvert.convert<String>(json['stillOweDeliveryMoney']);
	if (stillOweDeliveryMoney != null) {
		deliveryDiscountTip.stillOweDeliveryMoney = stillOweDeliveryMoney;
	}
	final String? nextLevelFreeDeliveryMoney = jsonConvert.convert<String>(json['nextLevelFreeDeliveryMoney']);
	if (nextLevelFreeDeliveryMoney != null) {
		deliveryDiscountTip.nextLevelFreeDeliveryMoney = nextLevelFreeDeliveryMoney;
	}
	final String? freeThresholdMoney = jsonConvert.convert<String>(json['freeThresholdMoney']);
	if (freeThresholdMoney != null) {
		deliveryDiscountTip.freeThresholdMoney = freeThresholdMoney;
	}
	final bool? firstOrderFreeDeliveryFee = jsonConvert.convert<bool>(json['firstOrderFreeDeliveryFee']);
	if (firstOrderFreeDeliveryFee != null) {
		deliveryDiscountTip.firstOrderFreeDeliveryFee = firstOrderFreeDeliveryFee;
	}
	return deliveryDiscountTip;
}

Map<String, dynamic> $DeliveryDiscountTipToJson(DeliveryDiscountTip entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['deliveryMoney'] = entity.deliveryMoney;
	data['deliveryDiscountAmount'] = entity.deliveryDiscountAmount;
	data['payDeliveryMoney'] = entity.payDeliveryMoney;
	data['startDeliveryMoney'] = entity.startDeliveryMoney;
	data['deliverType'] = entity.deliverType;
	data['gradientfreeType'] = entity.gradientfreeType;
	data['stillOweDeliveryMoney'] = entity.stillOweDeliveryMoney;
	data['nextLevelFreeDeliveryMoney'] = entity.nextLevelFreeDeliveryMoney;
	data['freeThresholdMoney'] = entity.freeThresholdMoney;
	data['firstOrderFreeDeliveryFee'] = entity.firstOrderFreeDeliveryFee;
	return data;
}

FinanceDetail $FinanceDetailFromJson(Map<String, dynamic> json) {
	final FinanceDetail financeDetail = FinanceDetail();
	final String? totalProductMoney = jsonConvert.convert<String>(json['totalProductMoney']);
	if (totalProductMoney != null) {
		financeDetail.totalProductMoney = totalProductMoney;
	}
	final String? totalProductDiscountMoney = jsonConvert.convert<String>(json['totalProductDiscountMoney']);
	if (totalProductDiscountMoney != null) {
		financeDetail.totalProductDiscountMoney = totalProductDiscountMoney;
	}
	final String? couponDiscountMoney = jsonConvert.convert<String>(json['couponDiscountMoney']);
	if (couponDiscountMoney != null) {
		financeDetail.couponDiscountMoney = couponDiscountMoney;
	}
	final String? bountyDiscountMoney = jsonConvert.convert<String>(json['bountyDiscountMoney']);
	if (bountyDiscountMoney != null) {
		financeDetail.bountyDiscountMoney = bountyDiscountMoney;
	}
	final String? specialDiscountAmount = jsonConvert.convert<String>(json['specialDiscountAmount']);
	if (specialDiscountAmount != null) {
		financeDetail.specialDiscountAmount = specialDiscountAmount;
	}
	return financeDetail;
}

Map<String, dynamic> $FinanceDetailToJson(FinanceDetail entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['totalProductMoney'] = entity.totalProductMoney;
	data['totalProductDiscountMoney'] = entity.totalProductDiscountMoney;
	data['couponDiscountMoney'] = entity.couponDiscountMoney;
	data['bountyDiscountMoney'] = entity.bountyDiscountMoney;
	data['specialDiscountAmount'] = entity.specialDiscountAmount;
	return data;
}