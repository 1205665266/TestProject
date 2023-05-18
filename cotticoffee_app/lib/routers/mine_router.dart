import 'package:cotti_client/pages/common/address/search_address/address_search_page.dart';
import 'package:cotti_client/pages/tabs/mine/bonus/pages/bonus_page.dart';
import 'package:cotti_client/pages/tabs/mine/bonus/pages/bonus_rules_page.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/cash_coupon_list/cash_coupon_list_page.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/cash_coupon_template/cash_template_list_page.dart';
import 'package:cotti_client/pages/tabs/mine/coupon/coupon_list/coupon_list_page.dart';
import 'package:cotti_client/pages/tabs/mine/coupon/history/coupon_history_list_page.dart';
import 'package:cotti_client/pages/tabs/mine/edit_user_info/edit_user_page.dart';
import 'package:cotti_client/pages/tabs/mine/edit_user_info/mine_info_edit_page.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/exchange_coupon_page.dart';
import 'package:cotti_client/pages/tabs/mine/setting/about_page.dart';
import 'package:cotti_client/pages/tabs/mine/setting/account_security_page.dart';
import 'package:cotti_client/pages/tabs/mine/setting/license_page.dart';
import 'package:cotti_client/pages/tabs/mine/setting/setting_page.dart';
import 'package:cotti_client/pages/tabs/mine/setting/shop_license_detail_page.dart';
import 'package:cotti_client/pages/tabs/mine/setting/shop_license_page.dart';
import 'package:cotti_client/pages/tabs/mine/setting/virtual_settings.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

import '../pages/tabs/mine/cash_coupon/history/cash_coupon_history_page.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/12 7:18 PM
class MineRouter extends ModuleRouteManager {
  static const String settingPage = '/pages/tabs/mine/setting';
  static const String aboutPage = '/pages/tabs/mine/setting/aboutPage';
  static const String virtualSettings = '/pages/tabs/mine/setting/virtual_settings';
  static const String licensePage = '/pages/tabs/mine/setting/licensePage';
  static const String shopLicensePage = '/pages/tabs/mine/setting/shopLicensePage';
  static const String shopLicenseDetailPage = '/pages/tabs/mine/setting/shopLicenseDetailPage';
  static const String accountSecurityPage = '/pages/tabs/mine/setting/accountSecurityPage';
  static const String editUserPage = '/pages/tabs/mine/editUserInfo/editUserPage';
  static const String mineInfoEdit = '/pages/tabs/mine/editUserInfo/mineInfoEdit';

  static const String couponListPage = '/pages/tabs/mine/coupon/couponListPage';
  static const String cashCouponHistoryPage =
      '/pages/tabs/mine/cash_coupon/history/cash_coupon_history_page.dart';
  static const String cashPackageListPage = '/pages/tabs/mine/cash_coupon/CashPackageListPage';
  static const String couponHistoryListPage = '/pages/tabs/mine/coupon/couponHistoryListPage';
  static const String cashCouponListPage =
      '/pages/tabs/mine/cash_coupon/cash_coupon/cash_coupon_list_page.dart';

  static const String bonusPage = '/pages/tabs/mine/bonus/bonusPage';
  static const String bonusRulesPage = '/pages/tabs/mine/bonus/bonusRulesPage';
  static const String addressSearchPage = 'pages/common/address/search_address/address_search_page';
  static const String exchangeCouponPage =
      "/pages/tabs/mine/exchange_coupon/exchange_coupon_page.dart";

  @override
  List<RouteEntry> get routes => [
        RouteEntry(
          settingPage,
          handler: Handler(handlerFunc: (context, params) {
            return const SettingPage();
          }),
        ),
        RouteEntry(
          aboutPage,
          handler: Handler(handlerFunc: (context, params) {
            return const AboutPage();
          }),
        ),
        RouteEntry(
          licensePage,
          handler: Handler(handlerFunc: (context, params) {
            return const LicensePage();
          }),
        ),
        RouteEntry(
          shopLicensePage,
          handler: Handler(handlerFunc: (context, params) {
            return const ShopLicensePage();
          }),
        ),
        RouteEntry(
          shopLicenseDetailPage,
          handler: Handler(handlerFunc: (BuildContext? context, _) {
            Object? obj = context?.settings?.arguments;
            List<String> images = [];
            if (obj != null) {
              images = obj as List<String>;
            }
            return ShopLicenseDetailPage(images: images);
          }),
        ),
        RouteEntry(
          accountSecurityPage,
          handler: Handler(handlerFunc: (_, __) {
            return const AccountSecurityPage();
          }),
        ),
        RouteEntry(
          editUserPage,
          handler: Handler(handlerFunc: (_, __) {
            return const EditUserPage();
          }),
        ),
        RouteEntry(
          mineInfoEdit,
          handler: Handler(handlerFunc: (_, __) {
            return const MineInfoEdit();
          }),
        ),
        RouteEntry(
          couponListPage,
          handler: Handler(handlerFunc: (_, __) {
            return const CouponListPage();
          }),
        ),
        RouteEntry(
          cashCouponHistoryPage,
          handler: Handler(handlerFunc: (_, __) {
            return const CashCouponHistoryPage();
          }),
        ),
        RouteEntry(
          cashPackageListPage,
          handler: Handler(handlerFunc: (_, __) {
            return const CashTemplateListPage();
          }),
        ),
        RouteEntry(
          couponHistoryListPage,
          handler: Handler(handlerFunc: (_, __) {
            return const CouponHistoryListPage();
          }),
        ),
        RouteEntry(
          cashCouponListPage,
          handler: Handler(handlerFunc: (_, params) {
            String recentlyExpiredCount = params["recentlyExpiredCount"]?.first ?? '0';
            return CashCouponListPage(recentlyExpiredCount: recentlyExpiredCount);
          }),
        ),
        RouteEntry(
          bonusPage,
          handler: Handler(handlerFunc: (_, __) {
            return const BonusPage();
          }),
        ),
        RouteEntry(
          virtualSettings,
          handler: Handler(handlerFunc: (_, __) {
            return const VirtualSettings();
          }),
        ),
        RouteEntry(
          bonusRulesPage,
          handler: Handler(handlerFunc: (context, params) {
            logW('params == $params');
            List<String>? rules = params['rules'];
            return BonusRulesPage(rules: rules?.first ?? "");
          }),
        ),
        RouteEntry(
          exchangeCouponPage,
          handler: Handler(handlerFunc: (context, params) {
            List<String>? param = params['title'];
            String title = '';
            if (param?.isNotEmpty ?? false) {
              title = param!.first;
            }
            return ExchangeCouponPage(title: title);
          }),
        ),
        RouteEntry(
          addressSearchPage,
          handler: Handler(handlerFunc: (context, params) {
            logW('params == $params');
            List<String>? lats = params['lat'];
            List<String>? lons = params['lon'];
            String? lat = lats?.first;
            String? lon = lons?.first;
            double? la;
            if (lat != null) {
              la = double.tryParse(lat);
            }
            double? lo;
            if (lon != null) {
              lo = double.tryParse(lon);
            }
            return AddressSearchPage(
              lat: la,
              lon: lo,
            );
          }),
        ),
      ];
}
