import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/tabs/mine/bonus/entity/bonus_detail_entity.dart';
import 'package:cotti_client/pages/tabs/mine/bonus/entity/bonus_log_entity.dart';

class BonusApi {
  static const _bonusLogUrl = "/points/change/log";
  static const _bonusDetailUrl = "/points/detail";

  static Future<List<BonusLogEntity>> getLogList({required int pageNo}) {
    return CottiNetWork().post(_bonusLogUrl, data: {"page": pageNo, "pageSize": 20}).then((value) {
      List<BonusLogEntity> list = [];
      for (Map<String, dynamic> json in value["items"] ?? []) {
        BonusLogEntity item = BonusLogEntity.fromJson(json);
        list.add(item);
      }
      return list;
    });
  }

  static Future<BonusDetailEntity> getDetail() {
    return CottiNetWork().get(_bonusDetailUrl).then((value) => BonusDetailEntity.fromJson(value));
  }
}
