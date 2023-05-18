import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_cancel_reason_model.dart';

CancelReasonList $CancelReasonListFromJson(Map<String, dynamic> json) {
	final CancelReasonList cancelReasonList = CancelReasonList();
	final List<OrderCancelReasonModel>? orderCancelReasonModels = jsonConvert.convertListNotNull<OrderCancelReasonModel>(json['djCancelReasonDtoList']);
	if (orderCancelReasonModels != null) {
		cancelReasonList.orderCancelReasonModels = orderCancelReasonModels;
	}
	return cancelReasonList;
}

Map<String, dynamic> $CancelReasonListToJson(CancelReasonList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['djCancelReasonDtoList'] =  entity.orderCancelReasonModels?.map((v) => v.toJson()).toList();
	return data;
}

OrderCancelReasonModel $OrderCancelReasonModelFromJson(Map<String, dynamic> json) {
	final OrderCancelReasonModel orderCancelReasonModel = OrderCancelReasonModel();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		orderCancelReasonModel.id = id;
	}
	final int? orderCancelType = jsonConvert.convert<int>(json['orderCancelType']);
	if (orderCancelType != null) {
		orderCancelReasonModel.orderCancelType = orderCancelType;
	}
	final String? orderCancelReason = jsonConvert.convert<String>(json['orderCancelReason']);
	if (orderCancelReason != null) {
		orderCancelReasonModel.orderCancelReason = orderCancelReason;
	}
	final int? orderCancelStatus = jsonConvert.convert<int>(json['orderCancelStatus']);
	if (orderCancelStatus != null) {
		orderCancelReasonModel.orderCancelStatus = orderCancelStatus;
	}
	final int? adapterOrderOrigin = jsonConvert.convert<int>(json['adapterOrderOrigin']);
	if (adapterOrderOrigin != null) {
		orderCancelReasonModel.adapterOrderOrigin = adapterOrderOrigin;
	}
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		orderCancelReasonModel.code = code;
	}
	final bool? canEdit = jsonConvert.convert<bool>(json['canEdit']);
	if (canEdit != null) {
		orderCancelReasonModel.canEdit = canEdit;
	}
	return orderCancelReasonModel;
}

Map<String, dynamic> $OrderCancelReasonModelToJson(OrderCancelReasonModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['orderCancelType'] = entity.orderCancelType;
	data['orderCancelReason'] = entity.orderCancelReason;
	data['orderCancelStatus'] = entity.orderCancelStatus;
	data['adapterOrderOrigin'] = entity.adapterOrderOrigin;
	data['code'] = entity.code;
	data['canEdit'] = entity.canEdit;
	return data;
}