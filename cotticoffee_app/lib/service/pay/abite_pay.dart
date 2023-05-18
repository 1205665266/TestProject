import 'dart:async';

import 'package:cotti_client/utils/abite_pay_util.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'model/pay_type_model.dart';
import 'pay_api.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/3/14 9:35 下午
class AbitePay {
  static final AbitePay _singleton = AbitePay._internal();
  ABiteWeChatPayUtil weChatPayUtil = ABiteWeChatPayUtil();

  AbitePay._internal();

  factory AbitePay() => _singleton;

  Future<List<PayTypeModel>> cottiPayList({Map<String, dynamic>? data}) async {
    return PayApi.getPayList(data: data);
  }

  Future<ABitePayResult> pay(
      PayTypeModel payType, String orderId, String orderNo) async {
    if (payType.payType == "wxpay") {
      return wechatPay(orderId, orderNo);
    } else if (payType.payType == "alipay") {
      return alipay(orderId, orderNo);
    }
    return const ABitePayResult(state: ABitPayState.unknown, msg: "未找到支付类型");
  }

  Future<ABitePayResult> wechatPay(String orderId, String orderNo) async {
    Completer<ABitePayResult> completer = Completer();
    PayApi.wechatPayInfo({"orderId": orderId, "orderNo": orderNo})
        .then((value) {
      if(value.payInfo == null) {
        if(value.status == 'success') {
          completer.complete(const ABitePayResult(
              state: ABitPayState.succeed, msg: '订单支付成功'));
        } else {
          completer.complete(const ABitePayResult(
              state: ABitPayState.failure, msg: '订单支付失败'));
        }
        return;
      }
      weChatPayUtil.pay(
          appId: value.payInfo?.appid ?? '',
          partnerId: value.payInfo?.partnerid ?? '',
          prepayId: value.payInfo?.prepayid ?? '',
          packageValue: value.payInfo?.package ?? '',
          nonceStr: value.payInfo?.noncestr ?? '',
          timeStamp: int.tryParse(value.payInfo?.timestamp ?? '0') ?? 0,
          sign: value.payInfo?.sign ?? '',
          resultCallBack: (ABitePayResult wxPayResult) {
            if (wxPayResult.state == ABitPayState.succeed) {
              var sensorProperties = {
                "NewMemberString": 0.toString(),
              };
              SensorsAnalyticsFlutterPlugin.registerSuperProperties(
                  sensorProperties);
            }
            completer.complete(wxPayResult);
          });
    }).catchError((onError) {
      completer.completeError(
          ABitePayResult(state: ABitPayState.failure, msg: onError.toString()));
    });
    return completer.future;
  }

  Future<ABitePayResult> alipay(String orderId, String orderNo) async {
    Completer<ABitePayResult> completer = Completer();
    PayApi.alipayInfo({"orderId": orderId, "orderNo": orderNo})
        .then((alipayModel) {
          if(alipayModel.payInfo == null) {
            if(alipayModel.status == 'success') {
              completer.complete(const ABitePayResult(
                  state: ABitPayState.succeed, msg: '订单支付成功'));
            } else {
              completer.complete(const ABitePayResult(
                  state: ABitPayState.failure, msg: '订单支付失败'));
            }
            return;
          }
      String infoStr = "alipay_sdk=${alipayModel.payInfo?.alipaySdk}"
          "&charset=${alipayModel.payInfo?.charset}"
          "&biz_content=${alipayModel.payInfo?.bizContent}"
          "&method=${alipayModel.payInfo?.method}"
          "&format=${alipayModel.payInfo?.format}"
          "&sign=${alipayModel.payInfo?.sign}"
          "&notify_url=${alipayModel.payInfo?.notifyUrl}"
          "&version=${alipayModel.payInfo?.version}"
          "&app_cert_sn=${alipayModel.payInfo?.appCertSn}"
          "&alipay_root_cert_sn=${alipayModel.payInfo?.alipayRootCertSn}"
          "&app_id=${alipayModel.payInfo?.appId}"
          "&sign_type=${alipayModel.payInfo?.signType}"
          "&timestamp=${alipayModel.payInfo?.timestamp}";
      ABiteAliPayUtil.pay(payInfo: infoStr).then((value) {
        if (value.state == ABitPayState.succeed) {
          var sensorProperties = {
            "NewMemberString": 0.toString(),
          };
          SensorsAnalyticsFlutterPlugin.registerSuperProperties(
              sensorProperties);
        }
        completer.complete(value);
      }).catchError((onError) {
        completer.completeError(ABitePayResult(
            state: ABitPayState.failure, msg: onError.toString()));
      });
    });
    return completer.future;
  }
}
