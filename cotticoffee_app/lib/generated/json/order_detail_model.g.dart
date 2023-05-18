import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_express.dart';

import 'package:cotti_client/pages/tabs/order/entity/order_status_str_entity.dart';


OrderDetailModel $OrderDetailModelFromJson(Map<String, dynamic> json) {
	final OrderDetailModel orderDetailModel = OrderDetailModel();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		orderDetailModel.id = id;
	}
	final String? orderNo = jsonConvert.convert<String>(json['orderNo']);
	if (orderNo != null) {
		orderDetailModel.orderNo = orderNo;
	}
	final int? memberId = jsonConvert.convert<int>(json['memberId']);
	if (memberId != null) {
		orderDetailModel.memberId = memberId;
	}
	final String? mobile = jsonConvert.convert<String>(json['mobile']);
	if (mobile != null) {
		orderDetailModel.mobile = mobile;
	}
	final int? shopId = jsonConvert.convert<int>(json['shopId']);
	if (shopId != null) {
		orderDetailModel.shopId = shopId;
	}
	final double? latitude = jsonConvert.convert<double>(json['latitude']);
	if (latitude != null) {
		orderDetailModel.latitude = latitude;
	}
	final double? longitude = jsonConvert.convert<double>(json['longitude']);
	if (longitude != null) {
		orderDetailModel.longitude = longitude;
	}
	final int? origin = jsonConvert.convert<int>(json['origin']);
	if (origin != null) {
		orderDetailModel.origin = origin;
	}
	final int? type = jsonConvert.convert<int>(json['type']);
	if (type != null) {
		orderDetailModel.type = type;
	}
	final int? actualType = jsonConvert.convert<int>(json['actualType']);
	if (actualType != null) {
		orderDetailModel.actualType = actualType;
	}
	final int? finishType = jsonConvert.convert<int>(json['finishType']);
	if (finishType != null) {
		orderDetailModel.finishType = finishType;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		orderDetailModel.status = status;
	}
	final int? productStatus = jsonConvert.convert<int>(json['productStatus']);
	if (productStatus != null) {
		orderDetailModel.productStatus = productStatus;
	}
	final int? expressStatus = jsonConvert.convert<int>(json['expressStatus']);
	if (expressStatus != null) {
		orderDetailModel.expressStatus = expressStatus;
	}
	final int? invoiceStatus = jsonConvert.convert<int>(json['invoiceStatus']);
	if (invoiceStatus != null) {
		orderDetailModel.invoiceStatus = invoiceStatus;
	}
	final int? refundStatus = jsonConvert.convert<int>(json['refundStatus']);
	if (refundStatus != null) {
		orderDetailModel.refundStatus = refundStatus;
	}
	final int? expressMode = jsonConvert.convert<int>(json['expressMode']);
	if (expressMode != null) {
		orderDetailModel.expressMode = expressMode;
	}
	final int? isYouzanMigrate = jsonConvert.convert<int>(json['isYouzanMigrate']);
	if (isYouzanMigrate != null) {
		orderDetailModel.isYouzanMigrate = isYouzanMigrate;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		orderDetailModel.createTime = createTime;
	}
	final String? refundTime = jsonConvert.convert<String>(json['refundTime']);
	if (refundTime != null) {
		orderDetailModel.refundTime = refundTime;
	}
	final String? modifyTime = jsonConvert.convert<String>(json['modifyTime']);
	if (modifyTime != null) {
		orderDetailModel.modifyTime = modifyTime;
	}
	final String? cancelTime = jsonConvert.convert<String>(json['cancelTime']);
	if (cancelTime != null) {
		orderDetailModel.cancelTime = cancelTime;
	}
	final int? deadLineSeconds = jsonConvert.convert<int>(json['deadLineSeconds']);
	if (deadLineSeconds != null) {
		orderDetailModel.deadLineSeconds = deadLineSeconds;
	}
	final String? paymentDeadlineTime = jsonConvert.convert<String>(json['paymentDeadlineTime']);
	if (paymentDeadlineTime != null) {
		orderDetailModel.paymentDeadlineTime = paymentDeadlineTime;
	}
	final String? payTime = jsonConvert.convert<String>(json['payTime']);
	if (payTime != null) {
		orderDetailModel.payTime = payTime;
	}
	final num? finishTime = jsonConvert.convert<num>(json['finishTime']);
	if (finishTime != null) {
		orderDetailModel.finishTime = finishTime;
	}
	final int? channel = jsonConvert.convert<int>(json['channel']);
	if (channel != null) {
		orderDetailModel.channel = channel;
	}
	final String? brandNo = jsonConvert.convert<String>(json['brandNo']);
	if (brandNo != null) {
		orderDetailModel.brandNo = brandNo;
	}
	final String? shopOperationMode = jsonConvert.convert<String>(json['shopOperationMode']);
	if (shopOperationMode != null) {
		orderDetailModel.shopOperationMode = shopOperationMode;
	}
	final int? cooperationMode = jsonConvert.convert<int>(json['cooperationMode']);
	if (cooperationMode != null) {
		orderDetailModel.cooperationMode = cooperationMode;
	}
	final int? saleNature = jsonConvert.convert<int>(json['saleNature']);
	if (saleNature != null) {
		orderDetailModel.saleNature = saleNature;
	}
	final String? cityCode = jsonConvert.convert<String>(json['cityCode']);
	if (cityCode != null) {
		orderDetailModel.cityCode = cityCode;
	}
	final int? productQuantity = jsonConvert.convert<int>(json['productQuantity']);
	if (productQuantity != null) {
		orderDetailModel.productQuantity = productQuantity;
	}
	final int? hiddenCancel = jsonConvert.convert<int>(json['hiddenCancel']);
	if (hiddenCancel != null) {
		orderDetailModel.hiddenCancel = hiddenCancel;
	}
	final int? hiddenExpressPhone = jsonConvert.convert<int>(json['hiddenExpressPhone']);
	if (hiddenExpressPhone != null) {
		orderDetailModel.hiddenExpressPhone = hiddenExpressPhone;
	}
	final int? isEvaluate = jsonConvert.convert<int>(json['isEvaluate']);
	if (isEvaluate != null) {
		orderDetailModel.isEvaluate = isEvaluate;
	}
	final int? allowEvaluate = jsonConvert.convert<int>(json['allowEvaluate']);
	if (allowEvaluate != null) {
		orderDetailModel.allowEvaluate = allowEvaluate;
	}
	final int? takeType = jsonConvert.convert<int>(json['takeType']);
	if (takeType != null) {
		orderDetailModel.takeType = takeType;
	}
	final String? expectTakeBeginTime = jsonConvert.convert<String>(json['expectTakeBeginTime']);
	if (expectTakeBeginTime != null) {
		orderDetailModel.expectTakeBeginTime = expectTakeBeginTime;
	}
	final String? expectTakeEndTime = jsonConvert.convert<String>(json['expectTakeEndTime']);
	if (expectTakeEndTime != null) {
		orderDetailModel.expectTakeEndTime = expectTakeEndTime;
	}
	final String? distributorExpectTime = jsonConvert.convert<String>(json['distributorExpectTime']);
	if (distributorExpectTime != null) {
		orderDetailModel.distributorExpectTime = distributorExpectTime;
	}
	final String? takeTypeStr = jsonConvert.convert<String>(json['takeTypeStr']);
	if (takeTypeStr != null) {
		orderDetailModel.takeTypeStr = takeTypeStr;
	}
	final OrderQueryFinance? orderQueryFinance = jsonConvert.convert<OrderQueryFinance>(json['orderFinanceDetail']);
	if (orderQueryFinance != null) {
		orderDetailModel.orderQueryFinance = orderQueryFinance;
	}
	final OrderQueryExtend? orderQueryExtend = jsonConvert.convert<OrderQueryExtend>(json['orderExtendDetail']);
	if (orderQueryExtend != null) {
		orderDetailModel.orderQueryExtend = orderQueryExtend;
	}
	final OrderQueryPay? orderQueryPay = jsonConvert.convert<OrderQueryPay>(json['orderPayDetail']);
	if (orderQueryPay != null) {
		orderDetailModel.orderQueryPay = orderQueryPay;
	}
	final OrderExpress? orderExpress = jsonConvert.convert<OrderExpress>(json['orderExpressDetail']);
	if (orderExpress != null) {
		orderDetailModel.orderExpress = orderExpress;
	}
	final OrderQueryCancel? orderQueryCancel = jsonConvert.convert<OrderQueryCancel>(json['orderCancelDetail']);
	if (orderQueryCancel != null) {
		orderDetailModel.orderQueryCancel = orderQueryCancel;
	}
	final List<OrderQueryProduct>? orderQueryProducts = jsonConvert.convertListNotNull<OrderQueryProduct>(json['orderProducts']);
	if (orderQueryProducts != null) {
		orderDetailModel.orderQueryProducts = orderQueryProducts;
	}
	final OrderStatusStrEntity? orderStatusStr = jsonConvert.convert<OrderStatusStrEntity>(json['orderStatusStrMsg']);
	if (orderStatusStr != null) {
		orderDetailModel.orderStatusStr = orderStatusStr;
	}
	final String? takeNoEmptyContext = jsonConvert.convert<String>(json['takeNoEmptyContext']);
	if (takeNoEmptyContext != null) {
		orderDetailModel.takeNoEmptyContext = takeNoEmptyContext;
	}
	final String? canteenCardHiddenCancelContext = jsonConvert.convert<String>(json['canteenCardHiddenCancelContext']);
	if (canteenCardHiddenCancelContext != null) {
		orderDetailModel.canteenCardHiddenCancelContext = canteenCardHiddenCancelContext;
	}
	final String? canteenCardName = jsonConvert.convert<String>(json['canteenCardName']);
	if (canteenCardName != null) {
		orderDetailModel.canteenCardName = canteenCardName;
	}
	final String? canteenPaySerialNumber = jsonConvert.convert<String>(json['canteenPaySerialNumber']);
	if (canteenPaySerialNumber != null) {
		orderDetailModel.canteenPaySerialNumber = canteenPaySerialNumber;
	}
	final OrderDetailModelCancleOrderConfigDTO? cancleOrderConfigDTO = jsonConvert.convert<OrderDetailModelCancleOrderConfigDTO>(json['cancleOrderConfigDTO']);
	if (cancleOrderConfigDTO != null) {
		orderDetailModel.cancleOrderConfigDTO = cancleOrderConfigDTO;
	}
	return orderDetailModel;
}

Map<String, dynamic> $OrderDetailModelToJson(OrderDetailModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['orderNo'] = entity.orderNo;
	data['memberId'] = entity.memberId;
	data['mobile'] = entity.mobile;
	data['shopId'] = entity.shopId;
	data['latitude'] = entity.latitude;
	data['longitude'] = entity.longitude;
	data['origin'] = entity.origin;
	data['type'] = entity.type;
	data['actualType'] = entity.actualType;
	data['finishType'] = entity.finishType;
	data['status'] = entity.status;
	data['productStatus'] = entity.productStatus;
	data['expressStatus'] = entity.expressStatus;
	data['invoiceStatus'] = entity.invoiceStatus;
	data['refundStatus'] = entity.refundStatus;
	data['expressMode'] = entity.expressMode;
	data['isYouzanMigrate'] = entity.isYouzanMigrate;
	data['createTime'] = entity.createTime;
	data['refundTime'] = entity.refundTime;
	data['modifyTime'] = entity.modifyTime;
	data['cancelTime'] = entity.cancelTime;
	data['deadLineSeconds'] = entity.deadLineSeconds;
	data['paymentDeadlineTime'] = entity.paymentDeadlineTime;
	data['payTime'] = entity.payTime;
	data['finishTime'] = entity.finishTime;
	data['channel'] = entity.channel;
	data['brandNo'] = entity.brandNo;
	data['shopOperationMode'] = entity.shopOperationMode;
	data['cooperationMode'] = entity.cooperationMode;
	data['saleNature'] = entity.saleNature;
	data['cityCode'] = entity.cityCode;
	data['productQuantity'] = entity.productQuantity;
	data['hiddenCancel'] = entity.hiddenCancel;
	data['hiddenExpressPhone'] = entity.hiddenExpressPhone;
	data['isEvaluate'] = entity.isEvaluate;
	data['allowEvaluate'] = entity.allowEvaluate;
	data['takeType'] = entity.takeType;
	data['expectTakeBeginTime'] = entity.expectTakeBeginTime;
	data['expectTakeEndTime'] = entity.expectTakeEndTime;
	data['distributorExpectTime'] = entity.distributorExpectTime;
	data['takeTypeStr'] = entity.takeTypeStr;
	data['orderFinanceDetail'] = entity.orderQueryFinance?.toJson();
	data['orderExtendDetail'] = entity.orderQueryExtend?.toJson();
	data['orderPayDetail'] = entity.orderQueryPay?.toJson();
	data['orderExpressDetail'] = entity.orderExpress?.toJson();
	data['orderCancelDetail'] = entity.orderQueryCancel?.toJson();
	data['orderProducts'] =  entity.orderQueryProducts?.map((v) => v.toJson()).toList();
	data['orderStatusStrMsg'] = entity.orderStatusStr?.toJson();
	data['takeNoEmptyContext'] = entity.takeNoEmptyContext;
	data['canteenCardHiddenCancelContext'] = entity.canteenCardHiddenCancelContext;
	data['canteenCardName'] = entity.canteenCardName;
	data['canteenPaySerialNumber'] = entity.canteenPaySerialNumber;
	data['cancleOrderConfigDTO'] = entity.cancleOrderConfigDTO?.toJson();
	return data;
}

OrderQueryFinance $OrderQueryFinanceFromJson(Map<String, dynamic> json) {
	final OrderQueryFinance orderQueryFinance = OrderQueryFinance();
	final double? totalProductMoney = jsonConvert.convert<double>(json['totalProductMoney']);
	if (totalProductMoney != null) {
		orderQueryFinance.totalProductMoney = totalProductMoney;
	}
	final double? totalOriginMoney = jsonConvert.convert<double>(json['totalOriginMoney']);
	if (totalOriginMoney != null) {
		orderQueryFinance.totalOriginMoney = totalOriginMoney;
	}
	final double? totalPayableMoney = jsonConvert.convert<double>(json['totalPayableMoney']);
	if (totalPayableMoney != null) {
		orderQueryFinance.totalPayableMoney = totalPayableMoney;
	}
	final double? totalRefundMoney = jsonConvert.convert<double>(json['totalRefundMoney']);
	if (totalRefundMoney != null) {
		orderQueryFinance.totalRefundMoney = totalRefundMoney;
	}
	final double? actuallyMoney = jsonConvert.convert<double>(json['actuallyMoney']);
	if (actuallyMoney != null) {
		orderQueryFinance.actuallyMoney = actuallyMoney;
	}
	final double? totalDiscountMoney = jsonConvert.convert<double>(json['totalDiscountMoney']);
	if (totalDiscountMoney != null) {
		orderQueryFinance.totalDiscountMoney = totalDiscountMoney;
	}
	final double? orderActuallyPayMoney = jsonConvert.convert<double>(json['orderActuallyPayMoney']);
	if (orderActuallyPayMoney != null) {
		orderQueryFinance.orderActuallyPayMoney = orderActuallyPayMoney;
	}
	final double? invoiceMoney = jsonConvert.convert<double>(json['invoiceMoney']);
	if (invoiceMoney != null) {
		orderQueryFinance.invoiceMoney = invoiceMoney;
	}
	final double? invoicedMoney = jsonConvert.convert<double>(json['invoicedMoney']);
	if (invoicedMoney != null) {
		orderQueryFinance.invoicedMoney = invoicedMoney;
	}
	final double? mayRefundMoney = jsonConvert.convert<double>(json['mayRefundMoney']);
	if (mayRefundMoney != null) {
		orderQueryFinance.mayRefundMoney = mayRefundMoney;
	}
	final double? priceDiscountMoney = jsonConvert.convert<double>(json['priceDiscountMoney']);
	if (priceDiscountMoney != null) {
		orderQueryFinance.priceDiscountMoney = priceDiscountMoney;
	}
	final double? couponDiscountMoney = jsonConvert.convert<double>(json['couponDiscountMoney']);
	if (couponDiscountMoney != null) {
		orderQueryFinance.couponDiscountMoney = couponDiscountMoney;
	}
	final double? voucherDiscountMoney = jsonConvert.convert<double>(json['voucherDiscountMoney']);
	if (voucherDiscountMoney != null) {
		orderQueryFinance.voucherDiscountMoney = voucherDiscountMoney;
	}
	final double? specialDiscountMoney = jsonConvert.convert<double>(json['specialDiscountMoney']);
	if (specialDiscountMoney != null) {
		orderQueryFinance.specialDiscountMoney = specialDiscountMoney;
	}
	final double? awardDiscountMoney = jsonConvert.convert<double>(json['awardDiscountMoney']);
	if (awardDiscountMoney != null) {
		orderQueryFinance.awardDiscountMoney = awardDiscountMoney;
	}
	final double? totalDeliveryMoney = jsonConvert.convert<double>(json['totalDeliveryMoney']);
	if (totalDeliveryMoney != null) {
		orderQueryFinance.totalDeliveryMoney = totalDeliveryMoney;
	}
	final double? deliveryPayMoney = jsonConvert.convert<double>(json['deliveryPayMoney']);
	if (deliveryPayMoney != null) {
		orderQueryFinance.deliveryPayMoney = deliveryPayMoney;
	}
	final int? deliveryDiscountType = jsonConvert.convert<int>(json['deliveryDiscountType']);
	if (deliveryDiscountType != null) {
		orderQueryFinance.deliveryDiscountType = deliveryDiscountType;
	}
	return orderQueryFinance;
}

Map<String, dynamic> $OrderQueryFinanceToJson(OrderQueryFinance entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['totalProductMoney'] = entity.totalProductMoney;
	data['totalOriginMoney'] = entity.totalOriginMoney;
	data['totalPayableMoney'] = entity.totalPayableMoney;
	data['totalRefundMoney'] = entity.totalRefundMoney;
	data['actuallyMoney'] = entity.actuallyMoney;
	data['totalDiscountMoney'] = entity.totalDiscountMoney;
	data['orderActuallyPayMoney'] = entity.orderActuallyPayMoney;
	data['invoiceMoney'] = entity.invoiceMoney;
	data['invoicedMoney'] = entity.invoicedMoney;
	data['mayRefundMoney'] = entity.mayRefundMoney;
	data['priceDiscountMoney'] = entity.priceDiscountMoney;
	data['couponDiscountMoney'] = entity.couponDiscountMoney;
	data['voucherDiscountMoney'] = entity.voucherDiscountMoney;
	data['specialDiscountMoney'] = entity.specialDiscountMoney;
	data['awardDiscountMoney'] = entity.awardDiscountMoney;
	data['totalDeliveryMoney'] = entity.totalDeliveryMoney;
	data['deliveryPayMoney'] = entity.deliveryPayMoney;
	data['deliveryDiscountType'] = entity.deliveryDiscountType;
	return data;
}

OrderQueryExtend $OrderQueryExtendFromJson(Map<String, dynamic> json) {
	final OrderQueryExtend orderQueryExtend = OrderQueryExtend();
	final int? shopId = jsonConvert.convert<int>(json['shopId']);
	if (shopId != null) {
		orderQueryExtend.shopId = shopId;
	}
	final String? shopName = jsonConvert.convert<String>(json['shopName']);
	if (shopName != null) {
		orderQueryExtend.shopName = shopName;
	}
	final String? shopCity = jsonConvert.convert<String>(json['shopCity']);
	if (shopCity != null) {
		orderQueryExtend.shopCity = shopCity;
	}
	final String? shopAddress = jsonConvert.convert<String>(json['shopAddress']);
	if (shopAddress != null) {
		orderQueryExtend.shopAddress = shopAddress;
	}
	final String? shopPhone = jsonConvert.convert<String>(json['shopPhone']);
	if (shopPhone != null) {
		orderQueryExtend.shopPhone = shopPhone;
	}
	final String? memberRemark = jsonConvert.convert<String>(json['memberRemark']);
	if (memberRemark != null) {
		orderQueryExtend.memberRemark = memberRemark;
	}
	final String? takeNo = jsonConvert.convert<String>(json['takeNo']);
	if (takeNo != null) {
		orderQueryExtend.takeNo = takeNo;
	}
	final int? memberSex = jsonConvert.convert<int>(json['memberSex']);
	if (memberSex != null) {
		orderQueryExtend.memberSex = memberSex;
	}
	final String? shopSequenceNumber = jsonConvert.convert<String>(json['shopSequenceNumber']);
	if (shopSequenceNumber != null) {
		orderQueryExtend.shopSequenceNumber = shopSequenceNumber;
	}
	final String? memberNickName = jsonConvert.convert<String>(json['memberNickName']);
	if (memberNickName != null) {
		orderQueryExtend.memberNickName = memberNickName;
	}
	final int? takeNoStatus = jsonConvert.convert<int>(json['takeNoStatus']);
	if (takeNoStatus != null) {
		orderQueryExtend.takeNoStatus = takeNoStatus;
	}
	final String? shopMdCode = jsonConvert.convert<String>(json['shopMdCode']);
	if (shopMdCode != null) {
		orderQueryExtend.shopMdCode = shopMdCode;
	}
	final String? memberNo = jsonConvert.convert<String>(json['memberNo']);
	if (memberNo != null) {
		orderQueryExtend.memberNo = memberNo;
	}
	final String? takeAddress = jsonConvert.convert<String>(json['takeAddress']);
	if (takeAddress != null) {
		orderQueryExtend.takeAddress = takeAddress;
	}
	final String? takePoiAddress = jsonConvert.convert<String>(json['takePoiAddress']);
	if (takePoiAddress != null) {
		orderQueryExtend.takePoiAddress = takePoiAddress;
	}
	final int? takeHumSex = jsonConvert.convert<int>(json['takeHumSex']);
	if (takeHumSex != null) {
		orderQueryExtend.takeHumSex = takeHumSex;
	}
	final String? takeHumPhone = jsonConvert.convert<String>(json['takeHumPhone']);
	if (takeHumPhone != null) {
		orderQueryExtend.takeHumPhone = takeHumPhone;
	}
	final String? takeHumName = jsonConvert.convert<String>(json['takeHumName']);
	if (takeHumName != null) {
		orderQueryExtend.takeHumName = takeHumName;
	}
	final String? logisticsDynamics = jsonConvert.convert<String>(json['logisticsDynamics']);
	if (logisticsDynamics != null) {
		orderQueryExtend.logisticsDynamics = logisticsDynamics;
	}
	final String? takeawayUserPhone = jsonConvert.convert<String>(json['takeawayUserPhone']);
	if (takeawayUserPhone != null) {
		orderQueryExtend.takeawayUserPhone = takeawayUserPhone;
	}
	return orderQueryExtend;
}

Map<String, dynamic> $OrderQueryExtendToJson(OrderQueryExtend entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['shopId'] = entity.shopId;
	data['shopName'] = entity.shopName;
	data['shopCity'] = entity.shopCity;
	data['shopAddress'] = entity.shopAddress;
	data['shopPhone'] = entity.shopPhone;
	data['memberRemark'] = entity.memberRemark;
	data['takeNo'] = entity.takeNo;
	data['memberSex'] = entity.memberSex;
	data['shopSequenceNumber'] = entity.shopSequenceNumber;
	data['memberNickName'] = entity.memberNickName;
	data['takeNoStatus'] = entity.takeNoStatus;
	data['shopMdCode'] = entity.shopMdCode;
	data['memberNo'] = entity.memberNo;
	data['takeAddress'] = entity.takeAddress;
	data['takePoiAddress'] = entity.takePoiAddress;
	data['takeHumSex'] = entity.takeHumSex;
	data['takeHumPhone'] = entity.takeHumPhone;
	data['takeHumName'] = entity.takeHumName;
	data['logisticsDynamics'] = entity.logisticsDynamics;
	data['takeawayUserPhone'] = entity.takeawayUserPhone;
	return data;
}

OrderQueryPay $OrderQueryPayFromJson(Map<String, dynamic> json) {
	final OrderQueryPay orderQueryPay = OrderQueryPay();
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		orderQueryPay.status = status;
	}
	final String? payNo = jsonConvert.convert<String>(json['payNo']);
	if (payNo != null) {
		orderQueryPay.payNo = payNo;
	}
	final int? payMode = jsonConvert.convert<int>(json['payMode']);
	if (payMode != null) {
		orderQueryPay.payMode = payMode;
	}
	final int? payFrom = jsonConvert.convert<int>(json['payFrom']);
	if (payFrom != null) {
		orderQueryPay.payFrom = payFrom;
	}
	final String? payFormName = jsonConvert.convert<String>(json['payFormName']);
	if (payFormName != null) {
		orderQueryPay.payFormName = payFormName;
	}
	final double? payMoney = jsonConvert.convert<double>(json['payMoney']);
	if (payMoney != null) {
		orderQueryPay.payMoney = payMoney;
	}
	return orderQueryPay;
}

Map<String, dynamic> $OrderQueryPayToJson(OrderQueryPay entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['status'] = entity.status;
	data['payNo'] = entity.payNo;
	data['payMode'] = entity.payMode;
	data['payFrom'] = entity.payFrom;
	data['payFormName'] = entity.payFormName;
	data['payMoney'] = entity.payMoney;
	return data;
}

OrderQueryCancel $OrderQueryCancelFromJson(Map<String, dynamic> json) {
	final OrderQueryCancel orderQueryCancel = OrderQueryCancel();
	final int? cancelUserType = jsonConvert.convert<int>(json['cancelUserType']);
	if (cancelUserType != null) {
		orderQueryCancel.cancelUserType = cancelUserType;
	}
	final String? cancelReason = jsonConvert.convert<String>(json['cancelReason']);
	if (cancelReason != null) {
		orderQueryCancel.cancelReason = cancelReason;
	}
	final int? cancelReasonType = jsonConvert.convert<int>(json['cancelReasonType']);
	if (cancelReasonType != null) {
		orderQueryCancel.cancelReasonType = cancelReasonType;
	}
	return orderQueryCancel;
}

Map<String, dynamic> $OrderQueryCancelToJson(OrderQueryCancel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['cancelUserType'] = entity.cancelUserType;
	data['cancelReason'] = entity.cancelReason;
	data['cancelReasonType'] = entity.cancelReasonType;
	return data;
}

OrderQueryProduct $OrderQueryProductFromJson(Map<String, dynamic> json) {
	final OrderQueryProduct orderQueryProduct = OrderQueryProduct();
	final String? productImgUrl = jsonConvert.convert<String>(json['productImgUrl']);
	if (productImgUrl != null) {
		orderQueryProduct.productImgUrl = productImgUrl;
	}
	final String? skuCode = jsonConvert.convert<String>(json['skuCode']);
	if (skuCode != null) {
		orderQueryProduct.skuCode = skuCode;
	}
	final String? skuName = jsonConvert.convert<String>(json['skuName']);
	if (skuName != null) {
		orderQueryProduct.skuName = skuName;
	}
	final String? skuNameShow = jsonConvert.convert<String>(json['skuNameShow']);
	if (skuNameShow != null) {
		orderQueryProduct.skuNameShow = skuNameShow;
	}
	final int? productId = jsonConvert.convert<int>(json['productId']);
	if (productId != null) {
		orderQueryProduct.productId = productId;
	}
	final String? productCode = jsonConvert.convert<String>(json['productCode']);
	if (productCode != null) {
		orderQueryProduct.productCode = productCode;
	}
	final String? productName = jsonConvert.convert<String>(json['productName']);
	if (productName != null) {
		orderQueryProduct.productName = productName;
	}
	final String? productNameShow = jsonConvert.convert<String>(json['productNameShow']);
	if (productNameShow != null) {
		orderQueryProduct.productNameShow = productNameShow;
	}
	final double? originPrice = jsonConvert.convert<double>(json['originPrice']);
	if (originPrice != null) {
		orderQueryProduct.originPrice = originPrice;
	}
	final double? afterDiscountMoney = jsonConvert.convert<double>(json['afterDiscountMoney']);
	if (afterDiscountMoney != null) {
		orderQueryProduct.afterDiscountMoney = afterDiscountMoney;
	}
	final int? quantity = jsonConvert.convert<int>(json['quantity']);
	if (quantity != null) {
		orderQueryProduct.quantity = quantity;
	}
	final double? payableMoney = jsonConvert.convert<double>(json['payableMoney']);
	if (payableMoney != null) {
		orderQueryProduct.payableMoney = payableMoney;
	}
	final double? payMoney = jsonConvert.convert<double>(json['payMoney']);
	if (payMoney != null) {
		orderQueryProduct.payMoney = payMoney;
	}
	final double? refundMoney = jsonConvert.convert<double>(json['refundMoney']);
	if (refundMoney != null) {
		orderQueryProduct.refundMoney = refundMoney;
	}
	final int? refundStatus = jsonConvert.convert<int>(json['refundStatus']);
	if (refundStatus != null) {
		orderQueryProduct.refundStatus = refundStatus;
	}
	final int? returnFoodStatus = jsonConvert.convert<int>(json['returnFoodStatus']);
	if (returnFoodStatus != null) {
		orderQueryProduct.returnFoodStatus = returnFoodStatus;
	}
	final String? preferenceTypeDesc = jsonConvert.convert<String>(json['preferenceTypeDesc']);
	if (preferenceTypeDesc != null) {
		orderQueryProduct.preferenceTypeDesc = preferenceTypeDesc;
	}
	return orderQueryProduct;
}

Map<String, dynamic> $OrderQueryProductToJson(OrderQueryProduct entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['productImgUrl'] = entity.productImgUrl;
	data['skuCode'] = entity.skuCode;
	data['skuName'] = entity.skuName;
	data['skuNameShow'] = entity.skuNameShow;
	data['productId'] = entity.productId;
	data['productCode'] = entity.productCode;
	data['productName'] = entity.productName;
	data['productNameShow'] = entity.productNameShow;
	data['originPrice'] = entity.originPrice;
	data['afterDiscountMoney'] = entity.afterDiscountMoney;
	data['quantity'] = entity.quantity;
	data['payableMoney'] = entity.payableMoney;
	data['payMoney'] = entity.payMoney;
	data['refundMoney'] = entity.refundMoney;
	data['refundStatus'] = entity.refundStatus;
	data['returnFoodStatus'] = entity.returnFoodStatus;
	data['preferenceTypeDesc'] = entity.preferenceTypeDesc;
	return data;
}

OrderDetailModelCancleOrderConfigDTO $OrderDetailModelCancleOrderConfigDTOFromJson(Map<String, dynamic> json) {
	final OrderDetailModelCancleOrderConfigDTO orderDetailModelCancleOrderConfigDTO = OrderDetailModelCancleOrderConfigDTO();
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		orderDetailModelCancleOrderConfigDTO.title = title;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		orderDetailModelCancleOrderConfigDTO.content = content;
	}
	final List<OrderDetailModelCancleOrderConfigDTODescription>? description = jsonConvert.convertListNotNull<OrderDetailModelCancleOrderConfigDTODescription>(json['description']);
	if (description != null) {
		orderDetailModelCancleOrderConfigDTO.description = description;
	}
	return orderDetailModelCancleOrderConfigDTO;
}

Map<String, dynamic> $OrderDetailModelCancleOrderConfigDTOToJson(OrderDetailModelCancleOrderConfigDTO entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['title'] = entity.title;
	data['content'] = entity.content;
	data['description'] =  entity.description?.map((v) => v.toJson()).toList();
	return data;
}

OrderDetailModelCancleOrderConfigDTODescription $OrderDetailModelCancleOrderConfigDTODescriptionFromJson(Map<String, dynamic> json) {
	final OrderDetailModelCancleOrderConfigDTODescription orderDetailModelCancleOrderConfigDTODescription = OrderDetailModelCancleOrderConfigDTODescription();
	final String? head = jsonConvert.convert<String>(json['head']);
	if (head != null) {
		orderDetailModelCancleOrderConfigDTODescription.head = head;
	}
	final String? text = jsonConvert.convert<String>(json['text']);
	if (text != null) {
		orderDetailModelCancleOrderConfigDTODescription.text = text;
	}
	return orderDetailModelCancleOrderConfigDTODescription;
}

Map<String, dynamic> $OrderDetailModelCancleOrderConfigDTODescriptionToJson(OrderDetailModelCancleOrderConfigDTODescription entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['head'] = entity.head;
	data['text'] = entity.text;
	return data;
}