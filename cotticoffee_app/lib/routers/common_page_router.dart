import 'dart:convert';

import 'package:cotti_client/pages/common/activity/share_image_page.dart';
import 'package:cotti_client/pages/common/address/search_address/address_search_list_page.dart';
import 'package:cotti_client/pages/common/address/take_address/address_list_page.dart';
import 'package:cotti_client/pages/common/city/city_list_page.dart';
import 'package:cotti_client/pages/common/city/entity/city_list_data_entity.dart';
import 'package:cotti_client/pages/common/common_ad/common_ad_page.dart';
import 'package:cotti_client/pages/common/store/store_list_page.dart';
import 'package:cotti_client/pages/splash/ad_screen/ad_screen_page.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:fluro/fluro.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/9 15:59
class CommonPageRouter extends ModuleRouteManager {
  static const String adScreenPage = "/pages/splash/ad_screen/ad_screen_page.dart";
  static const String takeAddressListPage = '/pages/common/takeAddress/addressListPage';
  static const String storeListPage = '/pages/store/storeListPage';
  static const String commonAd = '/pages/common_ad/commonAdPage';
  static const String cityListPage = '/pages/common/city/cityListPage';
  static const String shareImagePage = '/pages/common/activity/shareImagePage';

  static const String addressSearchListPage =
      '/pages/common/address/searchAddress/addressSearchListPage';

  @override
  List<RouteEntry> get routes => [
        RouteEntry(
          adScreenPage,
          handler: Handler(handlerFunc: (context, params) {
            return const AdScreenWidget();
          }),
        ),
        RouteEntry(
          takeAddressListPage,
          handler: Handler(handlerFunc: (context, params) {
            ///是否可以选中地址
            final String isSelectParams = params['isSelectTakeAddress']?.first ?? 'true';

            ///是否自动匹配外卖门店，默认匹配，[isSelectParams] 为true,次参数生效
            final String isShopMatch = params['isShopMatch']?.first ?? 'true';
            return AddressListPage(
              isSelectTakeAddress: isSelectParams == 'true',
              isShopMatch: isShopMatch == 'true',
            );
          }),
        ),
        RouteEntry(
          storeListPage,
          handler: Handler(handlerFunc: (context, params) {
            final String isFromConfirm = params['isFromConfirm']?.first ?? 'false';

            return StoreListPage(isFromConfirm: isFromConfirm == 'true',);
          }),
        ),
        RouteEntry(
          commonAd,
          handler: Handler(handlerFunc: (context, params) {
            String adCode = params['adCode']?.first ?? '';
            String shareCode = params['shareCode']?.first ?? '';
            return CommonAdPage(adCode: adCode, shareCode: shareCode);
          }),
        ),
        RouteEntry(
          cityListPage,
          handler: Handler(handlerFunc: (context, params) {
            bool isAll = (params['isAll']?.first ?? '') == 'true';
            bool fromConfirm = (params['fromConfirm']?.first ?? '') == 'true';
            logI('fromConfirm = ==== router =$params');
            return CityListPage(
              isAll: isAll,
              fromConfirm: fromConfirm,
            );
          }),
        ),
        RouteEntry(
          addressSearchListPage,
          handler: Handler(handlerFunc: (context, params) {
            Map argument = context!.settings!.arguments as Map;
            CityListDataData cityModel = argument['selectedCityModel'];
            return AddressSearchListPage(cityModel);
          }),
        ),
        RouteEntry(
          shareImagePage,
          handler: Handler(handlerFunc: (context, params) {
            String imageListStr = params['imageList']?.first ?? "";
            String qrImageUrl = params['qrImageUrl']?.first ?? '';
            List<String> imageList =
                (json.decode(imageListStr) as List).map((e) => e as String).toList();
            return ShareImagePage(imageList, qrImageUrl);
          }),
        )
      ];
}
