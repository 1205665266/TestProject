import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_submit_model_entity.dart';

OrderSubmitModelEntity $OrderSubmitModelEntityFromJson(Map<String, dynamic> json) {
	final OrderSubmitModelEntity orderSubmitModelEntity = OrderSubmitModelEntity();
	final String? orderId = jsonConvert.convert<String>(json['orderId']);
	if (orderId != null) {
		orderSubmitModelEntity.orderId = orderId;
	}
	final String? orderNo = jsonConvert.convert<String>(json['orderNo']);
	if (orderNo != null) {
		orderSubmitModelEntity.orderNo = orderNo;
	}
	final int? checkCode = jsonConvert.convert<int>(json['checkCode']);
	if (checkCode != null) {
		orderSubmitModelEntity.checkCode = checkCode;
	}
	final String? checkMsg = jsonConvert.convert<String>(json['checkMsg']);
	if (checkMsg != null) {
		orderSubmitModelEntity.checkMsg = checkMsg;
	}
	final List<OrderSubmitModelUnavailableItemList>? unavailableItemList = jsonConvert.convertListNotNull<OrderSubmitModelUnavailableItemList>(json['unavailableItemList']);
	if (unavailableItemList != null) {
		orderSubmitModelEntity.unavailableItemList = unavailableItemList;
	}
	final List<OrderSubmitModelSaleableItemList>? saleableItemList = jsonConvert.convertListNotNull<OrderSubmitModelSaleableItemList>(json['saleableItemList']);
	if (saleableItemList != null) {
		orderSubmitModelEntity.saleableItemList = saleableItemList;
	}
	return orderSubmitModelEntity;
}

Map<String, dynamic> $OrderSubmitModelEntityToJson(OrderSubmitModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['orderId'] = entity.orderId;
	data['orderNo'] = entity.orderNo;
	data['checkCode'] = entity.checkCode;
	data['checkMsg'] = entity.checkMsg;
	data['unavailableItemList'] =  entity.unavailableItemList?.map((v) => v.toJson()).toList();
	data['saleableItemList'] =  entity.saleableItemList?.map((v) => v.toJson()).toList();
	return data;
}

OrderSubmitModelUnavailableItemList $OrderSubmitModelUnavailableItemListFromJson(Map<String, dynamic> json) {
	final OrderSubmitModelUnavailableItemList orderSubmitModelUnavailableItemList = OrderSubmitModelUnavailableItemList();
	final String? spuCode = jsonConvert.convert<String>(json['spuCode']);
	if (spuCode != null) {
		orderSubmitModelUnavailableItemList.spuCode = spuCode;
	}
	final String? skuCode = jsonConvert.convert<String>(json['skuCode']);
	if (skuCode != null) {
		orderSubmitModelUnavailableItemList.skuCode = skuCode;
	}
	final String? skuShowName = jsonConvert.convert<String>(json['skuShowName']);
	if (skuShowName != null) {
		orderSubmitModelUnavailableItemList.skuShowName = skuShowName;
	}
	final int? skuId = jsonConvert.convert<int>(json['skuId']);
	if (skuId != null) {
		orderSubmitModelUnavailableItemList.skuId = skuId;
	}
	final int? buyNum = jsonConvert.convert<int>(json['buyNum']);
	if (buyNum != null) {
		orderSubmitModelUnavailableItemList.buyNum = buyNum;
	}
	final int? quantity = jsonConvert.convert<int>(json['quantity']);
	if (quantity != null) {
		orderSubmitModelUnavailableItemList.quantity = quantity;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		orderSubmitModelUnavailableItemList.title = title;
	}
	final String? image = jsonConvert.convert<String>(json['image']);
	if (image != null) {
		orderSubmitModelUnavailableItemList.image = image;
	}
	final double? facePrice = jsonConvert.convert<double>(json['facePrice']);
	if (facePrice != null) {
		orderSubmitModelUnavailableItemList.facePrice = facePrice;
	}
	final double? lineThroughPrice = jsonConvert.convert<double>(json['lineThroughPrice']);
	if (lineThroughPrice != null) {
		orderSubmitModelUnavailableItemList.lineThroughPrice = lineThroughPrice;
	}
	final int? saleable = jsonConvert.convert<int>(json['saleable']);
	if (saleable != null) {
		orderSubmitModelUnavailableItemList.saleable = saleable;
	}
	final double? specialPrice = jsonConvert.convert<double>(json['specialPrice']);
	if (specialPrice != null) {
		orderSubmitModelUnavailableItemList.specialPrice = specialPrice;
	}
	final int? limitType = jsonConvert.convert<int>(json['limitType']);
	if (limitType != null) {
		orderSubmitModelUnavailableItemList.limitType = limitType;
	}
	return orderSubmitModelUnavailableItemList;
}

Map<String, dynamic> $OrderSubmitModelUnavailableItemListToJson(OrderSubmitModelUnavailableItemList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['spuCode'] = entity.spuCode;
	data['skuCode'] = entity.skuCode;
	data['skuShowName'] = entity.skuShowName;
	data['skuId'] = entity.skuId;
	data['buyNum'] = entity.buyNum;
	data['quantity'] = entity.quantity;
	data['title'] = entity.title;
	data['image'] = entity.image;
	data['facePrice'] = entity.facePrice;
	data['lineThroughPrice'] = entity.lineThroughPrice;
	data['saleable'] = entity.saleable;
	data['specialPrice'] = entity.specialPrice;
	data['limitType'] = entity.limitType;
	return data;
}

OrderSubmitModelSaleableItemList $OrderSubmitModelSaleableItemListFromJson(Map<String, dynamic> json) {
	final OrderSubmitModelSaleableItemList orderSubmitModelSaleableItemList = OrderSubmitModelSaleableItemList();
	final String? spuCode = jsonConvert.convert<String>(json['spuCode']);
	if (spuCode != null) {
		orderSubmitModelSaleableItemList.spuCode = spuCode;
	}
	final String? skuCode = jsonConvert.convert<String>(json['skuCode']);
	if (skuCode != null) {
		orderSubmitModelSaleableItemList.skuCode = skuCode;
	}
	final String? skuShowName = jsonConvert.convert<String>(json['skuShowName']);
	if (skuShowName != null) {
		orderSubmitModelSaleableItemList.skuShowName = skuShowName;
	}
	final int? skuId = jsonConvert.convert<int>(json['skuId']);
	if (skuId != null) {
		orderSubmitModelSaleableItemList.skuId = skuId;
	}
	final int? buyNum = jsonConvert.convert<int>(json['buyNum']);
	if (buyNum != null) {
		orderSubmitModelSaleableItemList.buyNum = buyNum;
	}
	final int? quantity = jsonConvert.convert<int>(json['quantity']);
	if (quantity != null) {
		orderSubmitModelSaleableItemList.quantity = quantity;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		orderSubmitModelSaleableItemList.title = title;
	}
	final String? image = jsonConvert.convert<String>(json['image']);
	if (image != null) {
		orderSubmitModelSaleableItemList.image = image;
	}
	final double? facePrice = jsonConvert.convert<double>(json['facePrice']);
	if (facePrice != null) {
		orderSubmitModelSaleableItemList.facePrice = facePrice;
	}
	final double? lineThroughPrice = jsonConvert.convert<double>(json['lineThroughPrice']);
	if (lineThroughPrice != null) {
		orderSubmitModelSaleableItemList.lineThroughPrice = lineThroughPrice;
	}
	final int? saleable = jsonConvert.convert<int>(json['saleable']);
	if (saleable != null) {
		orderSubmitModelSaleableItemList.saleable = saleable;
	}
	final double? specialPrice = jsonConvert.convert<double>(json['specialPrice']);
	if (specialPrice != null) {
		orderSubmitModelSaleableItemList.specialPrice = specialPrice;
	}
	final int? limitType = jsonConvert.convert<int>(json['limitType']);
	if (limitType != null) {
		orderSubmitModelSaleableItemList.limitType = limitType;
	}
	return orderSubmitModelSaleableItemList;
}

Map<String, dynamic> $OrderSubmitModelSaleableItemListToJson(OrderSubmitModelSaleableItemList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['spuCode'] = entity.spuCode;
	data['skuCode'] = entity.skuCode;
	data['skuShowName'] = entity.skuShowName;
	data['skuId'] = entity.skuId;
	data['buyNum'] = entity.buyNum;
	data['quantity'] = entity.quantity;
	data['title'] = entity.title;
	data['image'] = entity.image;
	data['facePrice'] = entity.facePrice;
	data['lineThroughPrice'] = entity.lineThroughPrice;
	data['saleable'] = entity.saleable;
	data['specialPrice'] = entity.specialPrice;
	data['limitType'] = entity.limitType;
	return data;
}