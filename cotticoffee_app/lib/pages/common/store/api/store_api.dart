import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';
import 'package:cotti_client/pages/common/store/entity/store_list_data_entity.dart';
import 'package:cotticommon/cotticommon.dart';

import '../../city/entity/city_list_data_entity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/9 14:16
class StoreApi {
  static const String _homePageGetShopDetail = "/shop/homePageGetShopDetail";
  static const String _searchShopList = "/shop/searchShopList";
  static const String _getCity = "/shop/getCity";

  ///获取门店定位
  static Future<ShopInfoEntity> getShopInfoDetail(int takeFoodMode,
      {double? longitude,
      double? latitude,
      int? addressId,
      num? shopCode,
      bool? needToBeOpenShop,
      bool? filterNonoperating}) {
    return CottiNetWork().post(
      _homePageGetShopDetail,
      showToast: false,
      data: {
        "takeFoodMode": takeFoodMode,
        "customerLongitude": longitude,
        "customerLatitude": latitude,
        "addressId": addressId,
        "shopIdType": 3, //1:有赞线下门店id 2:有赞线上门店id 3:主数据id 这里固定写3
        "shopCode": shopCode,
        "needToBeOpenShop": needToBeOpenShop,
        "filterNonoperating": filterNonoperating ?? false
      },
    ).then((value) => ShopInfoEntity.fromJson(value));
  }

  static Future<StoreListDataEntity> getShopList(int cityMdCode,
      {double? latitude,
      double? longitude,
      String? shopMdName,
      int? takeFoodMode,
      double? userLatitude,
      double? userLongitude,
      bool? needToBeOpenShop}) {
    return CottiNetWork()
        .post(_searchShopList, data: {
          "cityMdCode": cityMdCode,
          "latitude": latitude,
          "longitude": longitude,
          "shopMdName": shopMdName,
          "takeFoodMode": takeFoodMode,
          "userLatitude": userLatitude,
          "userLongitude": userLongitude,
          "needToBeOpenShop": needToBeOpenShop,
        })
        .then((value) => StoreListDataEntity.fromJson(value))
        .catchError((onError) {
          logW('获取门店信息失败');
          return StoreListDataEntity();
        });
  }

  static Future<CityListDataData> getCity({
    double? latitude,
    double? longitude,
  }) {
    return CottiNetWork()
        .post(_getCity, data: {
          "latitude": latitude,
          "longitude": longitude,
        })
        .then((value) => CityListDataData.fromJson(value))
        .catchError((onError) {
          logW('获取门店信息失败');
          return CityListDataData();
        });
  }
}
