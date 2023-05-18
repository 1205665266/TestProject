import 'package:cotti_client/pages/tabs/mine/exchange_coupon/entity/validate_entity.dart';

import '../entity/coupon_exchange_entity.dart';
import '../entity/error_tips_info.dart';

class ExchangeState {
  bool showLoading = false;
  ValidateEntity? validateEntity;
  CouponExchangeEntity? couponExchange;

  ///券号验证成功时间戳
  int validateSuccessTime = 0;

  ///券号兑换成功时间戳
  int exchangeSuccessTime = 0;

  ErrorTipsInfo? errorTipsInfo;

  ExchangeState copy({
    bool? showLoading,
    ValidateEntity? validateEntity,
    CouponExchangeEntity? couponExchange,
    int? validateSuccessTime,
    int? exchangeSuccessTime,
    ErrorTipsInfo? errorTipsInfo,
  }) {
    return ExchangeState()
      ..validateSuccessTime = validateSuccessTime ?? this.validateSuccessTime
      ..exchangeSuccessTime = exchangeSuccessTime ?? this.exchangeSuccessTime
      ..validateEntity = validateEntity ?? this.validateEntity
      ..couponExchange = couponExchange ?? this.couponExchange
      ..errorTipsInfo = errorTipsInfo ?? this.errorTipsInfo
      ..showLoading = showLoading ?? this.showLoading;
  }
}
