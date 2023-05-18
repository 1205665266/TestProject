import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/service/pay/model/wechat_pay_info_model.dart';

WechatPayInfoModel $WechatPayInfoModelFromJson(Map<String, dynamic> json) {
	final WechatPayInfoModel wechatPayInfoModel = WechatPayInfoModel();
	final WechatPayInfoPayInfo? payInfo = jsonConvert.convert<WechatPayInfoPayInfo>(json['payInfo']);
	if (payInfo != null) {
		wechatPayInfoModel.payInfo = payInfo;
	}
	final String? recordNo = jsonConvert.convert<String>(json['recordNo']);
	if (recordNo != null) {
		wechatPayInfoModel.recordNo = recordNo;
	}
	final String? status = jsonConvert.convert<String>(json['status']);
	if (status != null) {
		wechatPayInfoModel.status = status;
	}
	return wechatPayInfoModel;
}

Map<String, dynamic> $WechatPayInfoModelToJson(WechatPayInfoModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['payInfo'] = entity.payInfo?.toJson();
	data['recordNo'] = entity.recordNo;
	data['status'] = entity.status;
	return data;
}

WechatPayInfoPayInfo $WechatPayInfoPayInfoFromJson(Map<String, dynamic> json) {
	final WechatPayInfoPayInfo wechatPayInfoPayInfo = WechatPayInfoPayInfo();
	final String? appid = jsonConvert.convert<String>(json['appid']);
	if (appid != null) {
		wechatPayInfoPayInfo.appid = appid;
	}
	final String? noncestr = jsonConvert.convert<String>(json['noncestr']);
	if (noncestr != null) {
		wechatPayInfoPayInfo.noncestr = noncestr;
	}
	final String? package = jsonConvert.convert<String>(json['package']);
	if (package != null) {
		wechatPayInfoPayInfo.package = package;
	}
	final String? partnerid = jsonConvert.convert<String>(json['partnerid']);
	if (partnerid != null) {
		wechatPayInfoPayInfo.partnerid = partnerid;
	}
	final String? prepayid = jsonConvert.convert<String>(json['prepayid']);
	if (prepayid != null) {
		wechatPayInfoPayInfo.prepayid = prepayid;
	}
	final String? sign = jsonConvert.convert<String>(json['sign']);
	if (sign != null) {
		wechatPayInfoPayInfo.sign = sign;
	}
	final String? timestamp = jsonConvert.convert<String>(json['timestamp']);
	if (timestamp != null) {
		wechatPayInfoPayInfo.timestamp = timestamp;
	}
	return wechatPayInfoPayInfo;
}

Map<String, dynamic> $WechatPayInfoPayInfoToJson(WechatPayInfoPayInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['appid'] = entity.appid;
	data['noncestr'] = entity.noncestr;
	data['package'] = entity.package;
	data['partnerid'] = entity.partnerid;
	data['prepayid'] = entity.prepayid;
	data['sign'] = entity.sign;
	data['timestamp'] = entity.timestamp;
	return data;
}