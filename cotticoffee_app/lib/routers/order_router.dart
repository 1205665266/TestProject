import 'dart:convert';

import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/order_confirm_page.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/order_detail_page.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/order_evaluate_detail_page.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/order_evaluate_page.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:fluro/fluro.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/9 3:39 PM
class OrderRouter extends ModuleRouteManager {
  static const String orderDetailPage = '/pages/tabs/order/order_detail';
  static const String orderEvaluatePage = '/pages/tabs/order/order_evaluate';
  static const String orderConfirmPage = '/pages/tabs/order/order_confirm';
  static const String orderEvaluateDetailPage =
      '/pages/tabs/order/order_evaluate/order_evaluate_detail';


  @override
  List<RouteEntry> get routes => [
        RouteEntry(
          orderDetailPage,
          handler: Handler(handlerFunc: (context, params) {
            final String orderNo = params['orderNo']?.first ?? '';
            final String isEvaluatePush = params['isEvaluatePush']?.first ?? '';
            final String delay = params['delay']?.first ?? '';

            // 埋点
            SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.orderDetailView, {});

            return OrderDetailPage(
              orderNo: orderNo,
              isEvaluatePush: isEvaluatePush == 'true',
              isDelay: delay == 'true'
            );
          }),
        ),
        RouteEntry(
          orderEvaluatePage,
          handler: Handler(handlerFunc: (context, params) {
            final String orderNo = params['orderNo']?.first ?? '';
            return OrderEvaluatePage(
              orderNo: orderNo,
            );
          }),
        ),
        RouteEntry(
          orderEvaluateDetailPage,
          handler: Handler(handlerFunc: (context, params) {
            final String orderNo = params['orderNo']?.first ?? '';
            final String showPopup = params['showPopup']?.first ?? '';
            return OrderEvaluateDetailPage(
              orderNo: orderNo,
                showPopup: showPopup == 'true',
            );
          }),
        ),
        RouteEntry(
          orderConfirmPage,
          handler: Handler(handlerFunc: (context, params) {
            final String fromDetail = params['fromDetail']?.first ?? '';
            final String productInfoStr = params['productInfo']?.first ?? '';
            Map<String, dynamic>? productInfo;
            if (productInfoStr.isNotEmpty) {
              productInfo = json.decode(productInfoStr);
            }

            // 埋点
            SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.orderConfirmPageView,
                {"from_page": fromDetail == 'true' ? 2 : 1});

            return OrderConfirmPage(
              fromDetail: fromDetail == 'true',
              productInfo: productInfo,
            );
          }),
        ),
      ];
}
