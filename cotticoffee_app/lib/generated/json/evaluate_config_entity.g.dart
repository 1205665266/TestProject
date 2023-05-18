import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/entity/evaluate_config_entity.dart';

EvaluateConfigEntity $EvaluateConfigEntityFromJson(Map<String, dynamic> json) {
	final EvaluateConfigEntity evaluateConfigEntity = EvaluateConfigEntity();
	final bool? canComment = jsonConvert.convert<bool>(json['canComment']);
	if (canComment != null) {
		evaluateConfigEntity.canComment = canComment;
	}
	final int? canNotCommentCause = jsonConvert.convert<int>(json['canNotCommentCause']);
	if (canNotCommentCause != null) {
		evaluateConfigEntity.canNotCommentCause = canNotCommentCause;
	}
	final String? canNotCommentCauseStr = jsonConvert.convert<String>(json['canNotCommentCauseStr']);
	if (canNotCommentCauseStr != null) {
		evaluateConfigEntity.canNotCommentCauseStr = canNotCommentCauseStr;
	}
	final int? goodsSatisfiedMinStarCount = jsonConvert.convert<int>(json['goodsSatisfiedMinStarCount']);
	if (goodsSatisfiedMinStarCount != null) {
		evaluateConfigEntity.goodsSatisfiedMinStarCount = goodsSatisfiedMinStarCount;
	}
	final List<EvaluateConfigOrderItemList>? orderItemList = jsonConvert.convertListNotNull<EvaluateConfigOrderItemList>(json['orderItemList']);
	if (orderItemList != null) {
		evaluateConfigEntity.orderItemList = orderItemList;
	}
	final List<String>? orderSatisfiedLabels = jsonConvert.convertListNotNull<String>(json['orderSatisfiedLabels']);
	if (orderSatisfiedLabels != null) {
		evaluateConfigEntity.orderSatisfiedLabels = orderSatisfiedLabels;
	}
	final List<String>? orderDissatisfiedLabels = jsonConvert.convertListNotNull<String>(json['orderDissatisfiedLabels']);
	if (orderDissatisfiedLabels != null) {
		evaluateConfigEntity.orderDissatisfiedLabels = orderDissatisfiedLabels;
	}
	final List<String>? goodsSatisfiedLabels = jsonConvert.convertListNotNull<String>(json['goodsSatisfiedLabels']);
	if (goodsSatisfiedLabels != null) {
		evaluateConfigEntity.goodsSatisfiedLabels = goodsSatisfiedLabels;
	}
	final List<String>? goodsDissatisfiedLabels = jsonConvert.convertListNotNull<String>(json['goodsDissatisfiedLabels']);
	if (goodsDissatisfiedLabels != null) {
		evaluateConfigEntity.goodsDissatisfiedLabels = goodsDissatisfiedLabels;
	}
	return evaluateConfigEntity;
}

Map<String, dynamic> $EvaluateConfigEntityToJson(EvaluateConfigEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['canComment'] = entity.canComment;
	data['canNotCommentCause'] = entity.canNotCommentCause;
	data['canNotCommentCauseStr'] = entity.canNotCommentCauseStr;
	data['goodsSatisfiedMinStarCount'] = entity.goodsSatisfiedMinStarCount;
	data['orderItemList'] =  entity.orderItemList?.map((v) => v.toJson()).toList();
	data['orderSatisfiedLabels'] =  entity.orderSatisfiedLabels;
	data['orderDissatisfiedLabels'] =  entity.orderDissatisfiedLabels;
	data['goodsSatisfiedLabels'] =  entity.goodsSatisfiedLabels;
	data['goodsDissatisfiedLabels'] =  entity.goodsDissatisfiedLabels;
	return data;
}

EvaluateConfigOrderItemList $EvaluateConfigOrderItemListFromJson(Map<String, dynamic> json) {
	final EvaluateConfigOrderItemList evaluateConfigOrderItemList = EvaluateConfigOrderItemList();
	final String? skuCode = jsonConvert.convert<String>(json['skuCode']);
	if (skuCode != null) {
		evaluateConfigOrderItemList.skuCode = skuCode;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		evaluateConfigOrderItemList.name = name;
	}
	final String? thumbnail = jsonConvert.convert<String>(json['thumbnail']);
	if (thumbnail != null) {
		evaluateConfigOrderItemList.thumbnail = thumbnail;
	}
	final String? skuProps = jsonConvert.convert<String>(json['skuProps']);
	if (skuProps != null) {
		evaluateConfigOrderItemList.skuProps = skuProps;
	}
	return evaluateConfigOrderItemList;
}

Map<String, dynamic> $EvaluateConfigOrderItemListToJson(EvaluateConfigOrderItemList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['skuCode'] = entity.skuCode;
	data['name'] = entity.name;
	data['thumbnail'] = entity.thumbnail;
	data['skuProps'] = entity.skuProps;
	return data;
}