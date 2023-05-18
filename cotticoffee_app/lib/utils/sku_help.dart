import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/4/20 8:19 下午
class SkuHelp {
  static int activityEndInterval(SkuEntity? skuModel) {
    if (skuModel == null) {
      return 0;
    }
    if (skuModel.specialPriceActivity?.activityEndTime == null) {
      return 0;
    }
    int nowTime = DateTime.now().millisecondsSinceEpoch;
    DateTime? endTime = DateTime.tryParse(skuModel.specialPriceActivity!.activityEndTime!);
    int endTimeTimeStamp = endTime != null ? endTime.millisecondsSinceEpoch : 0;
    if (endTimeTimeStamp == 0) {
      endTimeTimeStamp = int.tryParse(skuModel.specialPriceActivity!.activityEndTime!) ?? 0;
    }
    int difference = endTimeTimeStamp - nowTime;
    if (difference > 0) {
      return difference ~/ 1000;
    } else {
      return 0;
    }
  }

  static bool isActivityProduct(SkuEntity? skuModel) {
    if (skuModel == null) {
      return false;
    }
    int endInterval = activityEndInterval(skuModel);
    if (endInterval > 0 && skuModel.specialActivityLimit?.activityStatus == 0) {
      if (skuModel.noSale == 0) {
        return true;
      }
    }
    return false;
  }
}
