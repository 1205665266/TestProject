import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/wechat_pay_info_model.g.dart';

@JsonSerializable()
class WechatPayInfoModel {

	WechatPayInfoModel();

	factory WechatPayInfoModel.fromJson(Map<String, dynamic> json) => $WechatPayInfoModelFromJson(json);

	Map<String, dynamic> toJson() => $WechatPayInfoModelToJson(this);

  WechatPayInfoPayInfo? payInfo;
  String? recordNo;
  String? status;
}

@JsonSerializable()
class WechatPayInfoPayInfo {

	WechatPayInfoPayInfo();

	factory WechatPayInfoPayInfo.fromJson(Map<String, dynamic> json) => $WechatPayInfoPayInfoFromJson(json);

	Map<String, dynamic> toJson() => $WechatPayInfoPayInfoToJson(this);

  String? appid;
  String? noncestr;
  String? package;
  String? partnerid;
  String? prepayid;
  String? sign;
  String? timestamp;
}
