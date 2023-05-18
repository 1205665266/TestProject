import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_url_model.dart';

OrderUrlModel $OrderUrlModelFromJson(Map<String, dynamic> json) {
	final OrderUrlModel orderUrlModel = OrderUrlModel();
	final dynamic code = jsonConvert.convert<dynamic>(json['code']);
	if (code != null) {
		orderUrlModel.code = code;
	}
	final OrderUrlData? data = jsonConvert.convert<OrderUrlData>(json['data']);
	if (data != null) {
		orderUrlModel.data = data;
	}
	final String? message = jsonConvert.convert<String>(json['message']);
	if (message != null) {
		orderUrlModel.message = message;
	}
	final bool? success = jsonConvert.convert<bool>(json['success']);
	if (success != null) {
		orderUrlModel.success = success;
	}
	final String? traceId = jsonConvert.convert<String>(json['traceId']);
	if (traceId != null) {
		orderUrlModel.traceId = traceId;
	}
	return orderUrlModel;
}

Map<String, dynamic> $OrderUrlModelToJson(OrderUrlModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['code'] = entity.code;
	data['data'] = entity.data.toJson();
	data['message'] = entity.message;
	data['success'] = entity.success;
	data['traceId'] = entity.traceId;
	return data;
}

OrderUrlData $OrderUrlDataFromJson(Map<String, dynamic> json) {
	final OrderUrlData orderUrlData = OrderUrlData();
	final dynamic success = jsonConvert.convert<dynamic>(json['success']);
	if (success != null) {
		orderUrlData.success = success;
	}
	final String? url = jsonConvert.convert<String>(json['url']);
	if (url != null) {
		orderUrlData.url = url;
	}
	final String? bookKey = jsonConvert.convert<String>(json['bookKey']);
	if (bookKey != null) {
		orderUrlData.bookKey = bookKey;
	}
	return orderUrlData;
}

Map<String, dynamic> $OrderUrlDataToJson(OrderUrlData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['success'] = entity.success;
	data['url'] = entity.url;
	data['bookKey'] = entity.bookKey;
	return data;
}