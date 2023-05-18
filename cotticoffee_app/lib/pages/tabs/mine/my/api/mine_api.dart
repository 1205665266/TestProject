import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/tabs/mine/my/entity/coupon_bounty_entity.dart';
import 'package:cotti_client/pages/tabs/mine/my/entity/coupon_exchange_statement_entity.dart';
import 'package:cotti_client/pages/tabs/mine/my/entity/user_info_entity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/11 2:44 PM
class MineApi {
  static const _getPersonalInfo = "/person/getPersonalInfo";
  static const _getCouponAndBounty = "/vocher/getCouponAndBounty";
  static const _updatePersonalInfo = "/person/updatePersonalInfo";
  static const _getCouponExchange = "/couponExchange/getCouponExchangeContext";
  static const String _homeLoginPrompt = "/person/homeLoginPrompt";

  static Future<UserInfoEntity> getPersonalInfo() {
    return CottiNetWork()
        .post(_getPersonalInfo, showToast: false)
        .then((value) => UserInfoEntity.fromJson(value));
  }

  static Future<String> getHomeLoginPrompt() {
    return CottiNetWork()
        .post(_homeLoginPrompt, showToast: false)
        .then((value) => value['promptStr']);
  }

  static Future<CouponBountyEntity> getCouponAndBounty() {
    return CottiNetWork()
        .post(_getCouponAndBounty)
        .then((value) => CouponBountyEntity.fromJson(value));
  }

  static Future updatePersonalInfo(
      String? nickname, int? sex, String? birthday, int? appMessageSwitch) {
    return CottiNetWork().post(_updatePersonalInfo, data: {
      'nickname': nickname,
      'sex': sex,
      'birthday': birthday,
      'appMessageSwitch': appMessageSwitch,
    });
  }

  static Future<CouponExchangeStatementEntity> getCouponExchange() {
    return CottiNetWork()
        .post(_getCouponExchange,showToast: false)
        .then((value) => CouponExchangeStatementEntity.fromJson(value));
  }
}
