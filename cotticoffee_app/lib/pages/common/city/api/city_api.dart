import 'package:cotti_client/pages/common/city/entity/city_list_data_entity.dart';
import 'package:cotticommon/utils/log_util.dart';

import '../../../../network/cotti_net_work.dart';

class CityApi {
  static const String _getCity = "/shop/getCity";
  static const String _cityList = "/shop/cityList";

  ///带单列表地址
  static const String allCityListUrl = "/address/listCity";

  static Future<CityListDataData> getCity(
      {double? latitude, double? longitude, bool defaultCity = false}) {
    return CottiNetWork()
        .post(_getCity, data: {
          "latitude": latitude,
          "longitude": longitude,
          "defaultCity": defaultCity,
        })
        .then((value) => CityListDataData.fromJson(value))
        .catchError((onError) {
          logW('获取门店信息失败');
          return CityListDataData();
        });
  }

  static Future<CityListDataEntity> cityList({bool isAll = false, bool fromConfirm = false}) {
    Map<String, dynamic> data = {};
    if (!isAll) {
      data = fromConfirm ? {'shopStatus': [1]} : {'shopStatus': [0,1]};
    }
    logI('fromConfirm = ==== cityList $fromConfirm');
    return CottiNetWork()
        .post(isAll ? allCityListUrl : _cityList, data: data)
        .then((value) => CityListDataEntity.fromJson({"data": value}))
        .catchError((onError) {
      logW('获取城市列表失败');
      return CityListDataEntity();
    });
  }
}
