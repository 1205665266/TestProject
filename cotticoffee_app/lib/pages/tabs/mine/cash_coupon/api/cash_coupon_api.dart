import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_template_entity.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_template_sub_entity.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/vocher_template_info_entity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/8 10:56
class CashCouponApi {
  ///可用代金券列表
  static const String _available = "/vocher/available/cash";

  ///代金券模版列表
  static const String _cashTemplateList = "/vocher/available/cashTemplate/list";

  ///代金券模版子列表
  static const String _cashTemplateSubList = "/vocher/available/cashTemplate/subList";

  ///历史代金券列表
  static const String _historyCashList = "/vocher/history/cash";

  static const String _subTemplateInfo = "/vocher/available/cashTemplate/subTemplateInfo";

  ///tabCode 1： 查全部可用优惠券 2： 即将过期可用优惠券 3： 待生效优惠券
  static Future<List<CashCouponEntity>> getAvailableList(int pageNo, int pageSize) {
    return CottiNetWork().post(_available, data: {
      "pageNo": pageNo,
      "pageSize": pageSize,
      "tabCode": 2,
    }).then((value) => JsonConvert().convertListNotNull<CashCouponEntity>(value) ?? []);
  }

  static Future<CashCouponTemplateEntity> getCashTemplateList() {
    return CottiNetWork()
        .post(_cashTemplateList)
        .then((value) => CashCouponTemplateEntity.fromJson(value));
  }

  static Future<CashCouponTemplateSubEntity> getCashTemplateSubList(
      String templateCode, String templateName, String value) {
    return CottiNetWork().post(_cashTemplateSubList, data: {
      "templateCode": templateCode,
      "templateName": templateName,
      "value": value
    }).then((value) => CashCouponTemplateSubEntity.fromJson(value));
  }

  /// queryType 查询类型（仅对历史优惠券接口生效） 1： 查已过期 2： 查已使用
  static Future<List<CashCouponEntity>> getHistoryCashList(
      int pageNo, int pageSize, int queryType) {
    return CottiNetWork().post(_historyCashList, data: {
      "pageNo": pageNo,
      "pageSize": pageSize,
      "queryType": queryType,
    }).then((value) => JsonConvert().convertListNotNull<CashCouponEntity>(value) ?? []);
  }

  static Future<VocherTemplateInfoEntity> getSubTemplateInfo(String templateCode) {
    return CottiNetWork().post(_subTemplateInfo, data: {
      "templateCode": templateCode,
    }).then((value) => VocherTemplateInfoEntity.fromJson(value));
  }
}
