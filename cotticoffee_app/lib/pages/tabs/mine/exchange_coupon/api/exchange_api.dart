import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/entity/coupon_exchange_entity.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/entity/validate_entity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/2/16 13:57
class ExchangeApi {
  static const _validate = '/couponExchange/validate';
  static const _exchange = '/couponExchange/exchange';

  static Future<ValidateEntity> validateCode(String exchangeCode) {
    return CottiNetWork().post(
      _validate,
      showToast: false,
      data: {'exchangeCode': exchangeCode},
    ).then((value) => ValidateEntity.fromJson(value));
  }

  static Future<CouponExchangeEntity> exchangeCoupon(String exchangeCode, String couponTemplateNo) {
    return CottiNetWork().post(
      _exchange,
      showToast: false,
      data: {'exchangeCode': exchangeCode, 'couponTemplateNo': couponTemplateNo},
    ).then((value) => CouponExchangeEntity.fromJson(value));
  }
}
