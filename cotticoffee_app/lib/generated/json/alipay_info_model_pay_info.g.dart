import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/service/pay/model/alipay_info_model_pay_info.dart';

AlipayInfoModelPayInfo $AlipayInfoModelPayInfoFromJson(Map<String, dynamic> json) {
	final AlipayInfoModelPayInfo alipayInfoModelPayInfo = AlipayInfoModelPayInfo();
	final String? alipaySdk = jsonConvert.convert<String>(json['alipay_sdk']);
	if (alipaySdk != null) {
		alipayInfoModelPayInfo.alipaySdk = alipaySdk;
	}
	final String? charset = jsonConvert.convert<String>(json['charset']);
	if (charset != null) {
		alipayInfoModelPayInfo.charset = charset;
	}
	final String? bizContent = jsonConvert.convert<String>(json['biz_content']);
	if (bizContent != null) {
		alipayInfoModelPayInfo.bizContent = bizContent;
	}
	final String? method = jsonConvert.convert<String>(json['method']);
	if (method != null) {
		alipayInfoModelPayInfo.method = method;
	}
	final String? format = jsonConvert.convert<String>(json['format']);
	if (format != null) {
		alipayInfoModelPayInfo.format = format;
	}
	final String? sign = jsonConvert.convert<String>(json['sign']);
	if (sign != null) {
		alipayInfoModelPayInfo.sign = sign;
	}
	final String? notifyUrl = jsonConvert.convert<String>(json['notify_url']);
	if (notifyUrl != null) {
		alipayInfoModelPayInfo.notifyUrl = notifyUrl;
	}
	final String? version = jsonConvert.convert<String>(json['version']);
	if (version != null) {
		alipayInfoModelPayInfo.version = version;
	}
	final String? appCertSn = jsonConvert.convert<String>(json['app_cert_sn']);
	if (appCertSn != null) {
		alipayInfoModelPayInfo.appCertSn = appCertSn;
	}
	final String? alipayRootCertSn = jsonConvert.convert<String>(json['alipay_root_cert_sn']);
	if (alipayRootCertSn != null) {
		alipayInfoModelPayInfo.alipayRootCertSn = alipayRootCertSn;
	}
	final String? appId = jsonConvert.convert<String>(json['app_id']);
	if (appId != null) {
		alipayInfoModelPayInfo.appId = appId;
	}
	final String? signType = jsonConvert.convert<String>(json['sign_type']);
	if (signType != null) {
		alipayInfoModelPayInfo.signType = signType;
	}
	final String? timestamp = jsonConvert.convert<String>(json['timestamp']);
	if (timestamp != null) {
		alipayInfoModelPayInfo.timestamp = timestamp;
	}
	return alipayInfoModelPayInfo;
}

Map<String, dynamic> $AlipayInfoModelPayInfoToJson(AlipayInfoModelPayInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['alipay_sdk'] = entity.alipaySdk;
	data['charset'] = entity.charset;
	data['biz_content'] = entity.bizContent;
	data['method'] = entity.method;
	data['format'] = entity.format;
	data['sign'] = entity.sign;
	data['notify_url'] = entity.notifyUrl;
	data['version'] = entity.version;
	data['app_cert_sn'] = entity.appCertSn;
	data['alipay_root_cert_sn'] = entity.alipayRootCertSn;
	data['app_id'] = entity.appId;
	data['sign_type'] = entity.signType;
	data['timestamp'] = entity.timestamp;
	return data;
}