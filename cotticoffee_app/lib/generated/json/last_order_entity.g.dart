import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/help/entity/last_order_entity.dart';

LastOrderEntity $LastOrderEntityFromJson(Map<String, dynamic> json) {
	final LastOrderEntity lastOrderEntity = LastOrderEntity();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		lastOrderEntity.id = id;
	}
	final String? orderNo = jsonConvert.convert<String>(json['orderNo']);
	if (orderNo != null) {
		lastOrderEntity.orderNo = orderNo;
	}
	final int? memberId = jsonConvert.convert<int>(json['memberId']);
	if (memberId != null) {
		lastOrderEntity.memberId = memberId;
	}
	final int? productQuantity = jsonConvert.convert<int>(json['productQuantity']);
	if (productQuantity != null) {
		lastOrderEntity.productQuantity = productQuantity;
	}
	final double? totalPayableMoney = jsonConvert.convert<double>(json['totalPayableMoney']);
	if (totalPayableMoney != null) {
		lastOrderEntity.totalPayableMoney = totalPayableMoney;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		lastOrderEntity.status = status;
	}
	final String? statusStr = jsonConvert.convert<String>(json['statusStr']);
	if (statusStr != null) {
		lastOrderEntity.statusStr = statusStr;
	}
	final int? createTime = jsonConvert.convert<int>(json['createTime']);
	if (createTime != null) {
		lastOrderEntity.createTime = createTime;
	}
	final String? memberNickName = jsonConvert.convert<String>(json['memberNickName']);
	if (memberNickName != null) {
		lastOrderEntity.memberNickName = memberNickName;
	}
	final List<String>? productNames = jsonConvert.convertListNotNull<String>(json['productNames']);
	if (productNames != null) {
		lastOrderEntity.productNames = productNames;
	}
	return lastOrderEntity;
}

Map<String, dynamic> $LastOrderEntityToJson(LastOrderEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['orderNo'] = entity.orderNo;
	data['memberId'] = entity.memberId;
	data['productQuantity'] = entity.productQuantity;
	data['totalPayableMoney'] = entity.totalPayableMoney;
	data['status'] = entity.status;
	data['statusStr'] = entity.statusStr;
	data['createTime'] = entity.createTime;
	data['memberNickName'] = entity.memberNickName;
	data['productNames'] =  entity.productNames;
	return data;
}