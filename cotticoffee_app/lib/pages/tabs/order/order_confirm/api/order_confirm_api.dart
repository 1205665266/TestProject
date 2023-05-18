import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_count_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_list_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_submit_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/order_cal_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/order_voucher_count_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/order_voucher_dto_entity.dart';
import 'package:cotticommon/cotticommon.dart';

class OrderConfirmApi {
  static const _orderConfirmApi = "/order/confirmOrder";
  static const _orderSubmitApi = "/order/submitOrder";
  static const _orderFetchCouponCountApi = "/voucher/getConfirmOrderCouponCount";
  static const _orderFetchCouponListApi = "/voucher/getConfirmOrderCouponList";
  static const _orderFetchRecommendRemarkListApi = "/order/getRemarkList";
  static const _orderFetchVoucherCountApi = "/voucher/getConfirmOrderVoucherCount";
  static const _orderConfirmOrderCalApi = "/order/confirmOrderCal";

  static const _confirmOrderVoucherListApi = "/voucher/getConfirmOrderVoucherList";

  static Future<OrderConfirmModelEntity> confirmOrder(dynamic data) {
    return CottiNetWork()
        .post(_orderConfirmApi, data: data)
        .then((value) => OrderConfirmModelEntity.fromJson(value));
  }

  static Future<OrderSubmitModelEntity> submitOrder(Map<String, dynamic>? data) {
    return CottiNetWork()
        .post(_orderSubmitApi, data: data).then((value) => OrderSubmitModelEntity.fromJson(value));
  }


  static Future<OrderCouponCountModelEntity> fetchCouponCount(Map<String, dynamic>? data) {
    return CottiNetWork()
        .post(_orderFetchCouponCountApi, data: data)
        .then((value) => OrderCouponCountModelEntity.fromJson(value));
  }

  static Future<OrderCouponListModelEntity> fetchCouponList(Map<String, dynamic>? data) {
    return CottiNetWork()
        .post(_orderFetchCouponListApi, data: data)
        .then((value) {
          return OrderCouponListModelEntity.fromJson(value);
    });
  }

  static Future<List<dynamic>> fetchRecommendRemarkList() {
    return CottiNetWork()
        .post(_orderFetchRecommendRemarkListApi, data: {})
        .then((value) {
          logI("备注标签--->$value");
          return value;
    });
  }

  static Future<OrderVoucherCountModelEntity> fetchVoucherCount(Map<String, dynamic>? data) {
    return CottiNetWork()
        .post(_orderFetchVoucherCountApi, data: data)
        .then((value) => OrderVoucherCountModelEntity.fromJson(value));
  }

  static Future<OrderCalEntity> confirmOrderCal(Map<String, dynamic>? data) {
    return CottiNetWork()
        .post(_orderConfirmOrderCalApi, data: data)
        .then((value) => OrderCalEntity.fromJson(value));
  }

  static Future<OrderVoucherDtoEntity> getConfirmOrderVoucherList(Map<String, dynamic>? data) {
    return CottiNetWork()
        .post(_confirmOrderVoucherListApi, data: data)
        .then((value) => OrderVoucherDtoEntity.fromJson(value));
  }
}
