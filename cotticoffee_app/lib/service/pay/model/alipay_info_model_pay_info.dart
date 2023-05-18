import 'package:cotti_client/generated/json/alipay_info_model_pay_info.g.dart';
import 'package:cotti_client/generated/json/base/json_field.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/9 3:33 PM
@JsonSerializable()
class AlipayInfoModelPayInfo {
  AlipayInfoModelPayInfo();

  factory AlipayInfoModelPayInfo.fromJson(Map<String, dynamic> json) =>
      $AlipayInfoModelPayInfoFromJson(json);

  Map<String, dynamic> toJson() => $AlipayInfoModelPayInfoToJson(this);

  @JSONField(name: "alipay_sdk")
  String? alipaySdk;
  String? charset;
  @JSONField(name: "biz_content")
  String? bizContent;
  String? method;
  String? format;
  String? sign;
  @JSONField(name: "notify_url")
  String? notifyUrl;
  String? version;
  @JSONField(name: "app_cert_sn")
  String? appCertSn;
  @JSONField(name: "alipay_root_cert_sn")
  String? alipayRootCertSn;
  @JSONField(name: "app_id")
  String? appId;
  @JSONField(name: "sign_type")
  String? signType;
  String? timestamp;
}
