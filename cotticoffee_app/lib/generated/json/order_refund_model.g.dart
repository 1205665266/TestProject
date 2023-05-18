import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_refund_model.dart';

OrderRefundModel $OrderRefundModelFromJson(Map<String, dynamic> json) {
	final OrderRefundModel orderRefundModel = OrderRefundModel();
	final int? orderId = jsonConvert.convert<int>(json['orderId']);
	if (orderId != null) {
		orderRefundModel.orderId = orderId;
	}
	final String? orderNo = jsonConvert.convert<String>(json['orderNo']);
	if (orderNo != null) {
		orderRefundModel.orderNo = orderNo;
	}
	final int? memberId = jsonConvert.convert<int>(json['memberId']);
	if (memberId != null) {
		orderRefundModel.memberId = memberId;
	}
	final String? refundNo = jsonConvert.convert<String>(json['refundNo']);
	if (refundNo != null) {
		orderRefundModel.refundNo = refundNo;
	}
	final String? refundTime = jsonConvert.convert<String>(json['refundTime']);
	if (refundTime != null) {
		orderRefundModel.refundTime = refundTime;
	}
	final double? refundTotal = jsonConvert.convert<double>(json['refundTotal']);
	if (refundTotal != null) {
		orderRefundModel.refundTotal = refundTotal;
	}
	final List<OrderRefundProductList>? orderProductList = jsonConvert.convertListNotNull<OrderRefundProductList>(json['orderQueryProductDTOList']);
	if (orderProductList != null) {
		orderRefundModel.orderProductList = orderProductList;
	}
	return orderRefundModel;
}

Map<String, dynamic> $OrderRefundModelToJson(OrderRefundModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['orderId'] = entity.orderId;
	data['orderNo'] = entity.orderNo;
	data['memberId'] = entity.memberId;
	data['refundNo'] = entity.refundNo;
	data['refundTime'] = entity.refundTime;
	data['refundTotal'] = entity.refundTotal;
	data['orderQueryProductDTOList'] =  entity.orderProductList?.map((v) => v.toJson()).toList();
	return data;
}

OrderRefundProductList $OrderRefundProductListFromJson(Map<String, dynamic> json) {
	final OrderRefundProductList orderRefundProductList = OrderRefundProductList();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		orderRefundProductList.id = id;
	}
	final int? orderId = jsonConvert.convert<int>(json['orderId']);
	if (orderId != null) {
		orderRefundProductList.orderId = orderId;
	}
	final int? memberId = jsonConvert.convert<int>(json['memberId']);
	if (memberId != null) {
		orderRefundProductList.memberId = memberId;
	}
	final int? shopId = jsonConvert.convert<int>(json['shopId']);
	if (shopId != null) {
		orderRefundProductList.shopId = shopId;
	}
	final String? skuCode = jsonConvert.convert<String>(json['skuCode']);
	if (skuCode != null) {
		orderRefundProductList.skuCode = skuCode;
	}
	final String? skuName = jsonConvert.convert<String>(json['skuName']);
	if (skuName != null) {
		orderRefundProductList.skuName = skuName;
	}
	final String? skuNameShow = jsonConvert.convert<String>(json['skuNameShow']);
	if (skuNameShow != null) {
		orderRefundProductList.skuNameShow = skuNameShow;
	}
	final int? productId = jsonConvert.convert<int>(json['productId']);
	if (productId != null) {
		orderRefundProductList.productId = productId;
	}
	final int? productType = jsonConvert.convert<int>(json['productType']);
	if (productType != null) {
		orderRefundProductList.productType = productType;
	}
	final String? productCode = jsonConvert.convert<String>(json['productCode']);
	if (productCode != null) {
		orderRefundProductList.productCode = productCode;
	}
	final String? productName = jsonConvert.convert<String>(json['productName']);
	if (productName != null) {
		orderRefundProductList.productName = productName;
	}
	final String? productNameShow = jsonConvert.convert<String>(json['productNameShow']);
	if (productNameShow != null) {
		orderRefundProductList.productNameShow = productNameShow;
	}
	final int? quantity = jsonConvert.convert<int>(json['quantity']);
	if (quantity != null) {
		orderRefundProductList.quantity = quantity;
	}
	final int? oneCategoryId = jsonConvert.convert<int>(json['oneCategoryId']);
	if (oneCategoryId != null) {
		orderRefundProductList.oneCategoryId = oneCategoryId;
	}
	final int? twoCategoryId = jsonConvert.convert<int>(json['twoCategoryId']);
	if (twoCategoryId != null) {
		orderRefundProductList.twoCategoryId = twoCategoryId;
	}
	final int? threeCategoryId = jsonConvert.convert<int>(json['threeCategoryId']);
	if (threeCategoryId != null) {
		orderRefundProductList.threeCategoryId = threeCategoryId;
	}
	final double? originPrice = jsonConvert.convert<double>(json['originPrice']);
	if (originPrice != null) {
		orderRefundProductList.originPrice = originPrice;
	}
	final double? payableMoney = jsonConvert.convert<double>(json['payableMoney']);
	if (payableMoney != null) {
		orderRefundProductList.payableMoney = payableMoney;
	}
	final double? payMoney = jsonConvert.convert<double>(json['payMoney']);
	if (payMoney != null) {
		orderRefundProductList.payMoney = payMoney;
	}
	final double? refundMoney = jsonConvert.convert<double>(json['refundMoney']);
	if (refundMoney != null) {
		orderRefundProductList.refundMoney = refundMoney;
	}
	final double? mayRefundMoney = jsonConvert.convert<double>(json['mayRefundMoney']);
	if (mayRefundMoney != null) {
		orderRefundProductList.mayRefundMoney = mayRefundMoney;
	}
	final int? refundStatus = jsonConvert.convert<int>(json['refundStatus']);
	if (refundStatus != null) {
		orderRefundProductList.refundStatus = refundStatus;
	}
	final int? returnFoodStatus = jsonConvert.convert<int>(json['returnFoodStatus']);
	if (returnFoodStatus != null) {
		orderRefundProductList.returnFoodStatus = returnFoodStatus;
	}
	final double? productIncome = jsonConvert.convert<double>(json['productIncome']);
	if (productIncome != null) {
		orderRefundProductList.productIncome = productIncome;
	}
	final String? taxClassification = jsonConvert.convert<String>(json['taxClassification']);
	if (taxClassification != null) {
		orderRefundProductList.taxClassification = taxClassification;
	}
	final int? taxClassificationId = jsonConvert.convert<int>(json['taxClassificationId']);
	if (taxClassificationId != null) {
		orderRefundProductList.taxClassificationId = taxClassificationId;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		orderRefundProductList.createTime = createTime;
	}
	final String? modifyTime = jsonConvert.convert<String>(json['modifyTime']);
	if (modifyTime != null) {
		orderRefundProductList.modifyTime = modifyTime;
	}
	final String? orderCreateTime = jsonConvert.convert<String>(json['orderCreateTime']);
	if (orderCreateTime != null) {
		orderRefundProductList.orderCreateTime = orderCreateTime;
	}
	final String? oldModifyTime = jsonConvert.convert<String>(json['oldModifyTime']);
	if (oldModifyTime != null) {
		orderRefundProductList.oldModifyTime = oldModifyTime;
	}
	final double? priceDiscountMoney = jsonConvert.convert<double>(json['priceDiscountMoney']);
	if (priceDiscountMoney != null) {
		orderRefundProductList.priceDiscountMoney = priceDiscountMoney;
	}
	final double? afterDiscountMoney = jsonConvert.convert<double>(json['afterDiscountMoney']);
	if (afterDiscountMoney != null) {
		orderRefundProductList.afterDiscountMoney = afterDiscountMoney;
	}
	final double? packageDiscountMoney = jsonConvert.convert<double>(json['packageDiscountMoney']);
	if (packageDiscountMoney != null) {
		orderRefundProductList.packageDiscountMoney = packageDiscountMoney;
	}
	final double? couponDiscountMoney = jsonConvert.convert<double>(json['couponDiscountMoney']);
	if (couponDiscountMoney != null) {
		orderRefundProductList.couponDiscountMoney = couponDiscountMoney;
	}
	final double? voucherDiscountMoney = jsonConvert.convert<double>(json['voucherDiscountMoney']);
	if (voucherDiscountMoney != null) {
		orderRefundProductList.voucherDiscountMoney = voucherDiscountMoney;
	}
	final double? activityDiscountMoney = jsonConvert.convert<double>(json['activityDiscountMoney']);
	if (activityDiscountMoney != null) {
		orderRefundProductList.activityDiscountMoney = activityDiscountMoney;
	}
	final double? channelDiscountMoney = jsonConvert.convert<double>(json['channelDiscountMoney']);
	if (channelDiscountMoney != null) {
		orderRefundProductList.channelDiscountMoney = channelDiscountMoney;
	}
	final double? otherDiscountMoney = jsonConvert.convert<double>(json['otherDiscountMoney']);
	if (otherDiscountMoney != null) {
		orderRefundProductList.otherDiscountMoney = otherDiscountMoney;
	}
	final double? totalDiscountMoney = jsonConvert.convert<double>(json['totalDiscountMoney']);
	if (totalDiscountMoney != null) {
		orderRefundProductList.totalDiscountMoney = totalDiscountMoney;
	}
	final double? dealMoney = jsonConvert.convert<double>(json['dealMoney']);
	if (dealMoney != null) {
		orderRefundProductList.dealMoney = dealMoney;
	}
	final double? boxCount = jsonConvert.convert<double>(json['boxCount']);
	if (boxCount != null) {
		orderRefundProductList.boxCount = boxCount;
	}
	final double? boxPrice = jsonConvert.convert<double>(json['boxPrice']);
	if (boxPrice != null) {
		orderRefundProductList.boxPrice = boxPrice;
	}
	final double? boxMoney = jsonConvert.convert<double>(json['boxMoney']);
	if (boxMoney != null) {
		orderRefundProductList.boxMoney = boxMoney;
	}
	final double? boxPayableMoney = jsonConvert.convert<double>(json['boxPayableMoney']);
	if (boxPayableMoney != null) {
		orderRefundProductList.boxPayableMoney = boxPayableMoney;
	}
	final double? boxPayMoney = jsonConvert.convert<double>(json['boxPayMoney']);
	if (boxPayMoney != null) {
		orderRefundProductList.boxPayMoney = boxPayMoney;
	}
	final double? boxIncome = jsonConvert.convert<double>(json['boxIncome']);
	if (boxIncome != null) {
		orderRefundProductList.boxIncome = boxIncome;
	}
	final double? mayInvoiceMoney = jsonConvert.convert<double>(json['mayInvoiceMoney']);
	if (mayInvoiceMoney != null) {
		orderRefundProductList.mayInvoiceMoney = mayInvoiceMoney;
	}
	final double? invoicedMoney = jsonConvert.convert<double>(json['invoicedMoney']);
	if (invoicedMoney != null) {
		orderRefundProductList.invoicedMoney = invoicedMoney;
	}
	final double? thirdDiscountMoney = jsonConvert.convert<double>(json['thirdDiscountMoney']);
	if (thirdDiscountMoney != null) {
		orderRefundProductList.thirdDiscountMoney = thirdDiscountMoney;
	}
	final String? couponRecordNo = jsonConvert.convert<String>(json['couponRecordNo']);
	if (couponRecordNo != null) {
		orderRefundProductList.couponRecordNo = couponRecordNo;
	}
	final int? pocketIndex = jsonConvert.convert<int>(json['pocketIndex']);
	if (pocketIndex != null) {
		orderRefundProductList.pocketIndex = pocketIndex;
	}
	final int? packageOrNot = jsonConvert.convert<int>(json['packageOrNot']);
	if (packageOrNot != null) {
		orderRefundProductList.packageOrNot = packageOrNot;
	}
	final int? orderPackageId = jsonConvert.convert<int>(json['orderPackageId']);
	if (orderPackageId != null) {
		orderRefundProductList.orderPackageId = orderPackageId;
	}
	final int? packageFloor = jsonConvert.convert<int>(json['packageFloor']);
	if (packageFloor != null) {
		orderRefundProductList.packageFloor = packageFloor;
	}
	final String? refundNo = jsonConvert.convert<String>(json['refundNo']);
	if (refundNo != null) {
		orderRefundProductList.refundNo = refundNo;
	}
	final String? refundTime = jsonConvert.convert<String>(json['refundTime']);
	if (refundTime != null) {
		orderRefundProductList.refundTime = refundTime;
	}
	final String? productImgUrl = jsonConvert.convert<String>(json['productImgUrl']);
	if (productImgUrl != null) {
		orderRefundProductList.productImgUrl = productImgUrl;
	}
	final String? skuTagCode = jsonConvert.convert<String>(json['skuTagCode']);
	if (skuTagCode != null) {
		orderRefundProductList.skuTagCode = skuTagCode;
	}
	final String? skuTagName = jsonConvert.convert<String>(json['skuTagName']);
	if (skuTagName != null) {
		orderRefundProductList.skuTagName = skuTagName;
	}
	final String? thirdProductCode = jsonConvert.convert<String>(json['thirdProductCode']);
	if (thirdProductCode != null) {
		orderRefundProductList.thirdProductCode = thirdProductCode;
	}
	final int? thirdSkuId = jsonConvert.convert<int>(json['thirdSkuId']);
	if (thirdSkuId != null) {
		orderRefundProductList.thirdSkuId = thirdSkuId;
	}
	final double? couponIncome = jsonConvert.convert<double>(json['couponIncome']);
	if (couponIncome != null) {
		orderRefundProductList.couponIncome = couponIncome;
	}
	final int? mergeType = jsonConvert.convert<int>(json['mergeType']);
	if (mergeType != null) {
		orderRefundProductList.mergeType = mergeType;
	}
	return orderRefundProductList;
}

Map<String, dynamic> $OrderRefundProductListToJson(OrderRefundProductList entity) {
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
	return data;
}