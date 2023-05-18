import 'package:decimal/decimal.dart';

/// Description:距离换算 小于1000显示xx m,大于1000 显示xx km，保留
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/11 11:28
class DistanceUtil {
  static String convertDistance(num? distance, {int fractionDigits = 1}) {
    if(distance == null){
      return "0m";
    }
    if (distance < 1000) {
      return "${distance}m";
    } else {
      String temp = Decimal.parse("${distance / 1000}").toStringAsFixed(fractionDigits);
      return "${temp}km";
    }
  }
}
