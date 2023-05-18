import 'dart:async';
import 'dart:convert' as convert;

import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/service/pay/model/alipay_info_model_model.dart';
import 'package:cotticommon/cotticommon.dart';

import 'model/pay_type_model.dart';
import 'model/wechat_pay_info_model.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/3/14 9:15 下午
class PayApi {
  static const String orderConformPayTypeListUrl = "/customer/pay/type/list";

  /// 获取微信支付信息
  static const String weChatPayInfoUrl = "/customer/pay/wxpay/app";

  /// 获取支付宝支付信息
  static const String aLiPayInfoUrl = "/customer/pay/alipay/app";

  static const String _keyCachePayType = "KEY_CACHE_PAY_TYPE";

  static Future<List<PayTypeModel>> getPayList({Map<String, dynamic>? data}) {
    String cachePayType = SpUtil.getString(_keyCachePayType);
    return CottiNetWork().post(orderConformPayTypeListUrl, data: data?? {
      "shopMdCode": 1,
      "tookFoodMode": 0
    }).then((value) {
      logI("getPayList====>result =$value");
      SpUtil.putString(_keyCachePayType, convert.jsonEncode(value));
      List listObj = value ?? [];
      return listObj.map((e) => PayTypeModel.fromJson(e)).toList();
    }).catchError((onError) {
      if (cachePayType.isNotEmpty) {
        List listObj = convert.jsonDecode(cachePayType) ?? [];
        return listObj.map((e) => PayTypeModel.fromJson(e)).toList();
      }
    });
  }

  static Future<WechatPayInfoModel> wechatPayInfo(Map<String, dynamic> params) {
    return CottiNetWork()
        .post(weChatPayInfoUrl, data: params)
        .then((value) => WechatPayInfoModel.fromJson(value));
  }

  static Future<AlipayInfoModelModel> alipayInfo(Map<String, dynamic> params) {
    return CottiNetWork()
        .post(aLiPayInfoUrl, data: params)
        .then((value) => AlipayInfoModelModel.fromJson(value));
  }
}
