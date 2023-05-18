import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/service/pay/model/alipay_info_model_model.dart';
import 'package:cotti_client/service/pay/model/alipay_info_model_pay_info.dart';


AlipayInfoModelModel $AlipayInfoModelModelFromJson(Map<String, dynamic> json) {
	final AlipayInfoModelModel alipayInfoModelModel = AlipayInfoModelModel();
	final AlipayInfoModelPayInfo? payInfo = jsonConvert.convert<AlipayInfoModelPayInfo>(json['payInfo']);
	if (payInfo != null) {
		alipayInfoModelModel.payInfo = payInfo;
	}
	final String? recordNo = jsonConvert.convert<String>(json['recordNo']);
	if (recordNo != null) {
		alipayInfoModelModel.recordNo = recordNo;
	}
	final String? status = jsonConvert.convert<String>(json['status']);
	if (status != null) {
		alipayInfoModelModel.status = status;
	}
	return alipayInfoModelModel;
}

Map<String, dynamic> $AlipayInfoModelModelToJson(AlipayInfoModelModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['payInfo'] = entity.payInfo?.toJson();
	data['recordNo'] = entity.recordNo;
	data['status'] = entity.status;
	return data;
}