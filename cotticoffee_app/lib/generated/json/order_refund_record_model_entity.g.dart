import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_refund_record_model_entity.dart';

OrderRefundRecordModelEntity $OrderRefundRecordModelEntityFromJson(Map<String, dynamic> json) {
	final OrderRefundRecordModelEntity orderRefundRecordModelEntity = OrderRefundRecordModelEntity();
	final dynamic orderId = jsonConvert.convert<dynamic>(json['orderId']);
	if (orderId != null) {
		orderRefundRecordModelEntity.orderId = orderId;
	}
	final dynamic orderNo = jsonConvert.convert<dynamic>(json['orderNo']);
	if (orderNo != null) {
		orderRefundRecordModelEntity.orderNo = orderNo;
	}
	final dynamic memberId = jsonConvert.convert<dynamic>(json['memberId']);
	if (memberId != null) {
		orderRefundRecordModelEntity.memberId = memberId;
	}
	final String? refundNo = jsonConvert.convert<String>(json['refundNo']);
	if (refundNo != null) {
		orderRefundRecordModelEntity.refundNo = refundNo;
	}
	final String? refundTime = jsonConvert.convert<String>(json['refundTime']);
	if (refundTime != null) {
		orderRefundRecordModelEntity.refundTime = refundTime;
	}
	final double? refundTotal = jsonConvert.convert<double>(json['refundTotal']);
	if (refundTotal != null) {
		orderRefundRecordModelEntity.refundTotal = refundTotal;
	}
	final List<OrderRefundRecordModelOrderQueryProductDTOList>? orderQueryProductDTOList = jsonConvert.convertListNotNull<OrderRefundRecordModelOrderQueryProductDTOList>(json['orderQueryProductDTOList']);
	if (orderQueryProductDTOList != null) {
		orderRefundRecordModelEntity.orderQueryProductDTOList = orderQueryProductDTOList;
	}
	return orderRefundRecordModelEntity;
}

Map<String, dynamic> $OrderRefundRecordModelEntityToJson(OrderRefundRecordModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['orderId'] = entity.orderId;
	data['orderNo'] = entity.orderNo;
	data['memberId'] = entity.memberId;
	data['refundNo'] = entity.refundNo;
	data['refundTime'] = entity.refundTime;
	data['refundTotal'] = entity.refundTotal;
	data['orderQueryProductDTOList'] =  entity.orderQueryProductDTOList?.map((v) => v.toJson()).toList();
	return data;
}

OrderRefundRecordModelOrderQueryProductDTOList $OrderRefundRecordModelOrderQueryProductDTOListFromJson(Map<String, dynamic> json) {
	final OrderRefundRecordModelOrderQueryProductDTOList orderRefundRecordModelOrderQueryProductDTOList = OrderRefundRecordModelOrderQueryProductDTOList();
	final dynamic id = jsonConvert.convert<dynamic>(json['id']);
	if (id != null) {
		orderRefundRecordModelOrderQueryProductDTOList.id = id;
	}
	final dynamic orderId = jsonConvert.convert<dynamic>(json['orderId']);
	if (orderId != null) {
		orderRefundRecordModelOrderQueryProductDTOList.orderId = orderId;
	}
	final dynamic memberId = jsonConvert.convert<dynamic>(json['memberId']);
	if (memberId != null) {
		orderRefundRecordModelOrderQueryProductDTOList.memberId = memberId;
	}
	final dynamic shopId = jsonConvert.convert<dynamic>(json['shopId']);
	if (shopId != null) {
		orderRefundRecordModelOrderQueryProductDTOList.shopId = shopId;
	}
	final String? skuCode = jsonConvert.convert<String>(json['skuCode']);
	if (skuCode != null) {
		orderRefundRecordModelOrderQueryProductDTOList.skuCode = skuCode;
	}
	final String? skuName = jsonConvert.convert<String>(json['skuName']);
	if (skuName != null) {
		orderRefundRecordModelOrderQueryProductDTOList.skuName = skuName;
	}
	final String? skuNameShow = jsonConvert.convert<String>(json['skuNameShow']);
	if (skuNameShow != null) {
		orderRefundRecordModelOrderQueryProductDTOList.skuNameShow = skuNameShow;
	}
	final dynamic productId = jsonConvert.convert<dynamic>(json['productId']);
	if (productId != null) {
		orderRefundRecordModelOrderQueryProductDTOList.productId = productId;
	}
	final dynamic productType = jsonConvert.convert<dynamic>(json['productType']);
	if (productType != null) {
		orderRefundRecordModelOrderQueryProductDTOList.productType = productType;
	}
	final dynamic productCode = jsonConvert.convert<dynamic>(json['productCode']);
	if (productCode != null) {
		orderRefundRecordModelOrderQueryProductDTOList.productCode = productCode;
	}
	final String? productName = jsonConvert.convert<String>(json['productName']);
	if (productName != null) {
		orderRefundRecordModelOrderQueryProductDTOList.productName = productName;
	}
	final String? productNameShow = jsonConvert.convert<String>(json['productNameShow']);
	if (productNameShow != null) {
		orderRefundRecordModelOrderQueryProductDTOList.productNameShow = productNameShow;
	}
	final dynamic quantity = jsonConvert.convert<dynamic>(json['quantity']);
	if (quantity != null) {
		orderRefundRecordModelOrderQueryProductDTOList.quantity = quantity;
	}
	final dynamic oneCategoryId = jsonConvert.convert<dynamic>(json['oneCategoryId']);
	if (oneCategoryId != null) {
		orderRefundRecordModelOrderQueryProductDTOList.oneCategoryId = oneCategoryId;
	}
	final dynamic twoCategoryId = jsonConvert.convert<dynamic>(json['twoCategoryId']);
	if (twoCategoryId != null) {
		orderRefundRecordModelOrderQueryProductDTOList.twoCategoryId = twoCategoryId;
	}
	final dynamic threeCategoryId = jsonConvert.convert<dynamic>(json['threeCategoryId']);
	if (threeCategoryId != null) {
		orderRefundRecordModelOrderQueryProductDTOList.threeCategoryId = threeCategoryId;
	}
	final dynamic originPrice = jsonConvert.convert<dynamic>(json['originPrice']);
	if (originPrice != null) {
		orderRefundRecordModelOrderQueryProductDTOList.originPrice = originPrice;
	}
	final dynamic payableMoney = jsonConvert.convert<dynamic>(json['payableMoney']);
	if (payableMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.payableMoney = payableMoney;
	}
	final dynamic payMoney = jsonConvert.convert<dynamic>(json['payMoney']);
	if (payMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.payMoney = payMoney;
	}
	final double? refundMoney = jsonConvert.convert<double>(json['refundMoney']);
	if (refundMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.refundMoney = refundMoney;
	}
	final dynamic mayRefundMoney = jsonConvert.convert<dynamic>(json['mayRefundMoney']);
	if (mayRefundMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.mayRefundMoney = mayRefundMoney;
	}
	final dynamic refundStatus = jsonConvert.convert<dynamic>(json['refundStatus']);
	if (refundStatus != null) {
		orderRefundRecordModelOrderQueryProductDTOList.refundStatus = refundStatus;
	}
	final dynamic returnFoodStatus = jsonConvert.convert<dynamic>(json['returnFoodStatus']);
	if (returnFoodStatus != null) {
		orderRefundRecordModelOrderQueryProductDTOList.returnFoodStatus = returnFoodStatus;
	}
	final dynamic productIncome = jsonConvert.convert<dynamic>(json['productIncome']);
	if (productIncome != null) {
		orderRefundRecordModelOrderQueryProductDTOList.productIncome = productIncome;
	}
	final dynamic taxClassification = jsonConvert.convert<dynamic>(json['taxClassification']);
	if (taxClassification != null) {
		orderRefundRecordModelOrderQueryProductDTOList.taxClassification = taxClassification;
	}
	final dynamic taxClassificationId = jsonConvert.convert<dynamic>(json['taxClassificationId']);
	if (taxClassificationId != null) {
		orderRefundRecordModelOrderQueryProductDTOList.taxClassificationId = taxClassificationId;
	}
	final dynamic createTime = jsonConvert.convert<dynamic>(json['createTime']);
	if (createTime != null) {
		orderRefundRecordModelOrderQueryProductDTOList.createTime = createTime;
	}
	final dynamic modifyTime = jsonConvert.convert<dynamic>(json['modifyTime']);
	if (modifyTime != null) {
		orderRefundRecordModelOrderQueryProductDTOList.modifyTime = modifyTime;
	}
	final dynamic orderCreateTime = jsonConvert.convert<dynamic>(json['orderCreateTime']);
	if (orderCreateTime != null) {
		orderRefundRecordModelOrderQueryProductDTOList.orderCreateTime = orderCreateTime;
	}
	final dynamic oldModifyTime = jsonConvert.convert<dynamic>(json['oldModifyTime']);
	if (oldModifyTime != null) {
		orderRefundRecordModelOrderQueryProductDTOList.oldModifyTime = oldModifyTime;
	}
	final dynamic priceDiscountMoney = jsonConvert.convert<dynamic>(json['priceDiscountMoney']);
	if (priceDiscountMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.priceDiscountMoney = priceDiscountMoney;
	}
	final dynamic afterDiscountMoney = jsonConvert.convert<dynamic>(json['afterDiscountMoney']);
	if (afterDiscountMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.afterDiscountMoney = afterDiscountMoney;
	}
	final dynamic packageDiscountMoney = jsonConvert.convert<dynamic>(json['packageDiscountMoney']);
	if (packageDiscountMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.packageDiscountMoney = packageDiscountMoney;
	}
	final dynamic couponDiscountMoney = jsonConvert.convert<dynamic>(json['couponDiscountMoney']);
	if (couponDiscountMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.couponDiscountMoney = couponDiscountMoney;
	}
	final dynamic voucherDiscountMoney = jsonConvert.convert<dynamic>(json['voucherDiscountMoney']);
	if (voucherDiscountMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.voucherDiscountMoney = voucherDiscountMoney;
	}
	final dynamic activityDiscountMoney = jsonConvert.convert<dynamic>(json['activityDiscountMoney']);
	if (activityDiscountMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.activityDiscountMoney = activityDiscountMoney;
	}
	final dynamic channelDiscountMoney = jsonConvert.convert<dynamic>(json['channelDiscountMoney']);
	if (channelDiscountMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.channelDiscountMoney = channelDiscountMoney;
	}
	final dynamic otherDiscountMoney = jsonConvert.convert<dynamic>(json['otherDiscountMoney']);
	if (otherDiscountMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.otherDiscountMoney = otherDiscountMoney;
	}
	final dynamic totalDiscountMoney = jsonConvert.convert<dynamic>(json['totalDiscountMoney']);
	if (totalDiscountMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.totalDiscountMoney = totalDiscountMoney;
	}
	final dynamic dealMoney = jsonConvert.convert<dynamic>(json['dealMoney']);
	if (dealMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.dealMoney = dealMoney;
	}
	final dynamic boxCount = jsonConvert.convert<dynamic>(json['boxCount']);
	if (boxCount != null) {
		orderRefundRecordModelOrderQueryProductDTOList.boxCount = boxCount;
	}
	final dynamic boxPrice = jsonConvert.convert<dynamic>(json['boxPrice']);
	if (boxPrice != null) {
		orderRefundRecordModelOrderQueryProductDTOList.boxPrice = boxPrice;
	}
	final dynamic boxMoney = jsonConvert.convert<dynamic>(json['boxMoney']);
	if (boxMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.boxMoney = boxMoney;
	}
	final dynamic boxPayableMoney = jsonConvert.convert<dynamic>(json['boxPayableMoney']);
	if (boxPayableMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.boxPayableMoney = boxPayableMoney;
	}
	final dynamic boxPayMoney = jsonConvert.convert<dynamic>(json['boxPayMoney']);
	if (boxPayMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.boxPayMoney = boxPayMoney;
	}
	final dynamic boxIncome = jsonConvert.convert<dynamic>(json['boxIncome']);
	if (boxIncome != null) {
		orderRefundRecordModelOrderQueryProductDTOList.boxIncome = boxIncome;
	}
	final dynamic mayInvoiceMoney = jsonConvert.convert<dynamic>(json['mayInvoiceMoney']);
	if (mayInvoiceMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.mayInvoiceMoney = mayInvoiceMoney;
	}
	final dynamic invoicedMoney = jsonConvert.convert<dynamic>(json['invoicedMoney']);
	if (invoicedMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.invoicedMoney = invoicedMoney;
	}
	final dynamic thirdDiscountMoney = jsonConvert.convert<dynamic>(json['thirdDiscountMoney']);
	if (thirdDiscountMoney != null) {
		orderRefundRecordModelOrderQueryProductDTOList.thirdDiscountMoney = thirdDiscountMoney;
	}
	final dynamic couponRecordNo = jsonConvert.convert<dynamic>(json['couponRecordNo']);
	if (couponRecordNo != null) {
		orderRefundRecordModelOrderQueryProductDTOList.couponRecordNo = couponRecordNo;
	}
	final dynamic pocketIndex = jsonConvert.convert<dynamic>(json['pocketIndex']);
	if (pocketIndex != null) {
		orderRefundRecordModelOrderQueryProductDTOList.pocketIndex = pocketIndex;
	}
	final dynamic packageOrNot = jsonConvert.convert<dynamic>(json['packageOrNot']);
	if (packageOrNot != null) {
		orderRefundRecordModelOrderQueryProductDTOList.packageOrNot = packageOrNot;
	}
	final dynamic orderPackageId = jsonConvert.convert<dynamic>(json['orderPackageId']);
	if (orderPackageId != null) {
		orderRefundRecordModelOrderQueryProductDTOList.orderPackageId = orderPackageId;
	}
	final dynamic packageFloor = jsonConvert.convert<dynamic>(json['packageFloor']);
	if (packageFloor != null) {
		orderRefundRecordModelOrderQueryProductDTOList.packageFloor = packageFloor;
	}
	final dynamic refundNo = jsonConvert.convert<dynamic>(json['refundNo']);
	if (refundNo != null) {
		orderRefundRecordModelOrderQueryProductDTOList.refundNo = refundNo;
	}
	final dynamic refundTime = jsonConvert.convert<dynamic>(json['refundTime']);
	if (refundTime != null) {
		orderRefundRecordModelOrderQueryProductDTOList.refundTime = refundTime;
	}
	final String? productImgUrl = jsonConvert.convert<String>(json['productImgUrl']);
	if (productImgUrl != null) {
		orderRefundRecordModelOrderQueryProductDTOList.productImgUrl = productImgUrl;
	}
	final dynamic skuTagCode = jsonConvert.convert<dynamic>(json['skuTagCode']);
	if (skuTagCode != null) {
		orderRefundRecordModelOrderQueryProductDTOList.skuTagCode = skuTagCode;
	}
	final dynamic skuTagName = jsonConvert.convert<dynamic>(json['skuTagName']);
	if (skuTagName != null) {
		orderRefundRecordModelOrderQueryProductDTOList.skuTagName = skuTagName;
	}
	final dynamic thirdProductCode = jsonConvert.convert<dynamic>(json['thirdProductCode']);
	if (thirdProductCode != null) {
		orderRefundRecordModelOrderQueryProductDTOList.thirdProductCode = thirdProductCode;
	}
	final dynamic thirdSkuId = jsonConvert.convert<dynamic>(json['thirdSkuId']);
	if (thirdSkuId != null) {
		orderRefundRecordModelOrderQueryProductDTOList.thirdSkuId = thirdSkuId;
	}
	final dynamic couponIncome = jsonConvert.convert<dynamic>(json['couponIncome']);
	if (couponIncome != null) {
		orderRefundRecordModelOrderQueryProductDTOList.couponIncome = couponIncome;
	}
	final dynamic mergeType = jsonConvert.convert<dynamic>(json['mergeType']);
	if (mergeType != null) {
		orderRefundRecordModelOrderQueryProductDTOList.mergeType = mergeType;
	}
	final String? skuProps = jsonConvert.convert<String>(json['skuProps']);
	if (skuProps != null) {
		orderRefundRecordModelOrderQueryProductDTOList.skuProps = skuProps;
	}
	return orderRefundRecordModelOrderQueryProductDTOList;
}

Map<String, dynamic> $OrderRefundRecordModelOrderQueryProductDTOListToJson(OrderRefundRecordModelOrderQueryProductDTOList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['orderId'] = entity.orderId;
	data['memberId'] = entity.memberId;
	data['shopId'] = entity.shopId;
	data['skuCode'] = entity.skuCode;
	data['skuName'] = entity.skuName;
	data['skuNameShow'] = entity.skuNameShow;
	data['productId'] = entity.productId;
	data['productType'] = entity.productType;
	data['productCode'] = entity.productCode;
	data['productName'] = entity.productName;
	data['productNameShow'] = entity.productNameShow;
	data['quantity'] = entity.quantity;
	data['oneCategoryId'] = entity.oneCategoryId;
	data['twoCategoryId'] = entity.twoCategoryId;
	data['threeCategoryId'] = entity.threeCategoryId;
	data['originPrice'] = entity.originPrice;
	data['payableMoney'] = entity.payableMoney;
	data['payMoney'] = entity.payMoney;
	data['refundMoney'] = entity.refundMoney;
	data['mayRefundMoney'] = entity.mayRefundMoney;
	data['refundStatus'] = entity.refundStatus;
	data['returnFoodStatus'] = entity.returnFoodStatus;
	data['productIncome'] = entity.productIncome;
	data['taxClassification'] = entity.taxClassification;
	data['taxClassificationId'] = entity.taxClassificationId;
	data['createTime'] = entity.createTime;
	data['modifyTime'] = entity.modifyTime;
	data['orderCreateTime'] = entity.orderCreateTime;
	data['oldModifyTime'] = entity.oldModifyTime;
	data['priceDiscountMoney'] = entity.priceDiscountMoney;
	data['afterDiscountMoney'] = entity.afterDiscountMoney;
	data['packageDiscountMoney'] = entity.packageDiscountMoney;
	data['couponDiscountMoney'] = entity.couponDiscountMoney;
	data['voucherDiscountMoney'] = entity.voucherDiscountMoney;
	data['activityDiscountMoney'] = entity.activityDiscountMoney;
	data['channelDiscountMoney'] = entity.channelDiscountMoney;
	data['otherDiscountMoney'] = entity.otherDiscountMoney;
	data['totalDiscountMoney'] = entity.totalDiscountMoney;
	data['dealMoney'] = entity.dealMoney;
	data['boxCount'] = entity.boxCount;
	data['boxPrice'] = entity.boxPrice;
	data['boxMoney'] = entity.boxMoney;
	data['boxPayableMoney'] = entity.boxPayableMoney;
	data['boxPayMoney'] = entity.boxPayMoney;
	data['boxIncome'] = entity.boxIncome;
	data['mayInvoiceMoney'] = entity.mayInvoiceMoney;
	data['invoicedMoney'] = entity.invoicedMoney;
	data['thirdDiscountMoney'] = entity.thirdDiscountMoney;
	data['couponRecordNo'] = entity.couponRecordNo;
	data['pocketIndex'] = entity.pocketIndex;
	data['packageOrNot'] = entity.packageOrNot;
	data['orderPackageId'] = entity.orderPackageId;
	data['packageFloor'] = entity.packageFloor;
	data['refundNo'] = entity.refundNo;
	data['refundTime'] = entity.refundTime;
	data['productImgUrl'] = entity.productImgUrl;
	data['skuTagCode'] = entity.skuTagCode;
	data['skuTagName'] = entity.skuTagName;
	data['thirdProductCode'] = entity.thirdProductCode;
	data['thirdSkuId'] = entity.thirdSkuId;
	data['couponIncome'] = entity.couponIncome;
	data['mergeType'] = entity.mergeType;
	data['skuProps'] = entity.skuProps;
	return data;
}