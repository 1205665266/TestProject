import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_express.dart';

OrderExpress $OrderExpressFromJson(Map<String, dynamic> json) {
	final OrderExpress orderExpress = OrderExpress();
	final String? supplierName = jsonConvert.convert<String>(json['supplierName']);
	if (supplierName != null) {
		orderExpress.supplierName = supplierName;
	}
	final String? expressUserName = jsonConvert.convert<String>(json['expressUserName']);
	if (expressUserName != null) {
		orderExpress.expressUserName = expressUserName;
	}
	final String? expressUserPhone = jsonConvert.convert<String>(json['expressUserPhone']);
	if (expressUserPhone != null) {
		orderExpress.expressUserPhone = expressUserPhone;
	}
	final String? expressOrderNo = jsonConvert.convert<String>(json['expressOrderNo']);
	if (expressOrderNo != null) {
		orderExpress.expressOrderNo = expressOrderNo;
	}
	final String? cancelDesc = jsonConvert.convert<String>(json['cancelDesc']);
	if (cancelDesc != null) {
		orderExpress.cancelDesc = cancelDesc;
	}
	final List<DispatchInfo>? dispatchInfoList = jsonConvert.convertListNotNull<DispatchInfo>(json['dispatchInfoList']);
	if (dispatchInfoList != null) {
		orderExpress.dispatchInfoList = dispatchInfoList;
	}
	final List<ExpressInfo>? expressInfoList = jsonConvert.convertListNotNull<ExpressInfo>(json['expressInfoList']);
	if (expressInfoList != null) {
		orderExpress.expressInfoList = expressInfoList;
	}
	return orderExpress;
}

Map<String, dynamic> $OrderExpressToJson(OrderExpress entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['supplierName'] = entity.supplierName;
	data['expressUserName'] = entity.expressUserName;
	data['expressUserPhone'] = entity.expressUserPhone;
	data['expressOrderNo'] = entity.expressOrderNo;
	data['cancelDesc'] = entity.cancelDesc;
	data['dispatchInfoList'] =  entity.dispatchInfoList?.map((v) => v.toJson()).toList();
	data['expressInfoList'] =  entity.expressInfoList?.map((v) => v.toJson()).toList();
	return data;
}

DispatchInfo $DispatchInfoFromJson(Map<String, dynamic> json) {
	final DispatchInfo dispatchInfo = DispatchInfo();
	final String? state = jsonConvert.convert<String>(json['state']);
	if (state != null) {
		dispatchInfo.state = state;
	}
	final String? time = jsonConvert.convert<String>(json['time']);
	if (time != null) {
		dispatchInfo.time = time;
	}
	return dispatchInfo;
}

Map<String, dynamic> $DispatchInfoToJson(DispatchInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['state'] = entity.state;
	data['time'] = entity.time;
	return data;
}

ExpressInfo $ExpressInfoFromJson(Map<String, dynamic> json) {
	final ExpressInfo expressInfo = ExpressInfo();
	final String? context = jsonConvert.convert<String>(json['context']);
	if (context != null) {
		expressInfo.context = context;
	}
	final String? time = jsonConvert.convert<String>(json['time']);
	if (time != null) {
		expressInfo.time = time;
	}
	final String? status = jsonConvert.convert<String>(json['status']);
	if (status != null) {
		expressInfo.status = status;
	}
	return expressInfo;
}

Map<String, dynamic> $ExpressInfoToJson(ExpressInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['context'] = entity.context;
	data['time'] = entity.time;
	data['status'] = entity.status;
	return data;
}