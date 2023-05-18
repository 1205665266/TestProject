import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/service/pay/model/pay_type_model.dart';

PayTypeModel $PayTypeModelFromJson(Map<String, dynamic> json) {
	final PayTypeModel payTypeModel = PayTypeModel();
	final String? payType = jsonConvert.convert<String>(json['payType']);
	if (payType != null) {
		payTypeModel.payType = payType;
	}
	final String? showIcon = jsonConvert.convert<String>(json['showIcon']);
	if (showIcon != null) {
		payTypeModel.showIcon = showIcon;
	}
	final String? showName = jsonConvert.convert<String>(json['showName']);
	if (showName != null) {
		payTypeModel.showName = showName;
	}
	final int? payFrom = jsonConvert.convert<int>(json['payFrom']);
	if (payFrom != null) {
		payTypeModel.payFrom = payFrom;
	}
	return payTypeModel;
}

Map<String, dynamic> $PayTypeModelToJson(PayTypeModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['payType'] = entity.payType;
	data['showIcon'] = entity.showIcon;
	data['showName'] = entity.showName;
	data['payFrom'] = entity.payFrom;
	return data;
}