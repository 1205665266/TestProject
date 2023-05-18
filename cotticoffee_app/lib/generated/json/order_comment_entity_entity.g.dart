import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/entity/order_comment_entity_entity.dart';

OrderCommentEntityEntity $OrderCommentEntityEntityFromJson(Map<String, dynamic> json) {
	final OrderCommentEntityEntity orderCommentEntityEntity = OrderCommentEntityEntity();
	final int? orderSatisfaction = jsonConvert.convert<int>(json['orderSatisfaction']);
	if (orderSatisfaction != null) {
		orderCommentEntityEntity.orderSatisfaction = orderSatisfaction;
	}
	final List<String>? orderEvaluateLabels = jsonConvert.convertListNotNull<String>(json['orderEvaluateLabels']);
	if (orderEvaluateLabels != null) {
		orderCommentEntityEntity.orderEvaluateLabels = orderEvaluateLabels;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		orderCommentEntityEntity.content = content;
	}
	final List<String>? imageUrls = jsonConvert.convertListNotNull<String>(json['imageUrls']);
	if (imageUrls != null) {
		orderCommentEntityEntity.imageUrls = imageUrls;
	}
	final String? orderCreateTime = jsonConvert.convert<String>(json['orderCreateTime']);
	if (orderCreateTime != null) {
		orderCommentEntityEntity.orderCreateTime = orderCreateTime;
	}
	final String? evaluateCreateTime = jsonConvert.convert<String>(json['evaluateCreateTime']);
	if (evaluateCreateTime != null) {
		orderCommentEntityEntity.evaluateCreateTime = evaluateCreateTime;
	}
	final String? shopName = jsonConvert.convert<String>(json['shopName']);
	if (shopName != null) {
		orderCommentEntityEntity.shopName = shopName;
	}
	final List<OrderCommentEntityOrderItemCommentList>? orderItemCommentList = jsonConvert.convertListNotNull<OrderCommentEntityOrderItemCommentList>(json['orderItemCommentList']);
	if (orderItemCommentList != null) {
		orderCommentEntityEntity.orderItemCommentList = orderItemCommentList;
	}
	return orderCommentEntityEntity;
}

Map<String, dynamic> $OrderCommentEntityEntityToJson(OrderCommentEntityEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['orderSatisfaction'] = entity.orderSatisfaction;
	data['orderEvaluateLabels'] =  entity.orderEvaluateLabels;
	data['content'] = entity.content;
	data['imageUrls'] =  entity.imageUrls;
	data['orderCreateTime'] = entity.orderCreateTime;
	data['evaluateCreateTime'] = entity.evaluateCreateTime;
	data['shopName'] = entity.shopName;
	data['orderItemCommentList'] =  entity.orderItemCommentList?.map((v) => v.toJson()).toList();
	return data;
}

OrderCommentEntityOrderItemCommentList $OrderCommentEntityOrderItemCommentListFromJson(Map<String, dynamic> json) {
	final OrderCommentEntityOrderItemCommentList orderCommentEntityOrderItemCommentList = OrderCommentEntityOrderItemCommentList();
	final String? skuCode = jsonConvert.convert<String>(json['skuCode']);
	if (skuCode != null) {
		orderCommentEntityOrderItemCommentList.skuCode = skuCode;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		orderCommentEntityOrderItemCommentList.name = name;
	}
	final String? thumbnail = jsonConvert.convert<String>(json['thumbnail']);
	if (thumbnail != null) {
		orderCommentEntityOrderItemCommentList.thumbnail = thumbnail;
	}
	final int? goodsSatisfaction = jsonConvert.convert<int>(json['goodsSatisfaction']);
	if (goodsSatisfaction != null) {
		orderCommentEntityOrderItemCommentList.goodsSatisfaction = goodsSatisfaction;
	}
	final List<String>? evaluateLabels = jsonConvert.convertListNotNull<String>(json['evaluateLabels']);
	if (evaluateLabels != null) {
		orderCommentEntityOrderItemCommentList.evaluateLabels = evaluateLabels;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		orderCommentEntityOrderItemCommentList.content = content;
	}
	final List<String>? imageUrls = jsonConvert.convertListNotNull<String>(json['imageUrls']);
	if (imageUrls != null) {
		orderCommentEntityOrderItemCommentList.imageUrls = imageUrls;
	}
	final int? startCount = jsonConvert.convert<int>(json['startCount']);
	if (startCount != null) {
		orderCommentEntityOrderItemCommentList.startCount = startCount;
	}
	final String? skuProps = jsonConvert.convert<String>(json['skuProps']);
	if (skuProps != null) {
		orderCommentEntityOrderItemCommentList.skuProps = skuProps;
	}
	return orderCommentEntityOrderItemCommentList;
}

Map<String, dynamic> $OrderCommentEntityOrderItemCommentListToJson(OrderCommentEntityOrderItemCommentList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['skuCode'] = entity.skuCode;
	data['name'] = entity.name;
	data['thumbnail'] = entity.thumbnail;
	data['goodsSatisfaction'] = entity.goodsSatisfaction;
	data['evaluateLabels'] =  entity.evaluateLabels;
	data['content'] = entity.content;
	data['imageUrls'] =  entity.imageUrls;
	data['startCount'] = entity.startCount;
	data['skuProps'] = entity.skuProps;
	return data;
}