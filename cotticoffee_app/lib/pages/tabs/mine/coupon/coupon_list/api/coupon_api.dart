import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/tabs/mine/coupon/coupon_list/bloc/coupon_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/coupon/coupon_list/entity/coupon_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_list_model_entity.dart';

class CouponApi {
  static const _getCoupListUrl = "/vocher/available";
  static const _getHistoryCoupListUrl = "/vocher/history";

  static Future<List<OrderCouponListModelConfirmOrderCouponDtoList>> getDataList({
   required int pageNo, required int tabCode
  }) {
    return CottiNetWork().post(_getCoupListUrl, data: {
      "pageNo": pageNo,
      "pageSize": 50,
      "tabCode": tabCode
  }).then((value){
    List<OrderCouponListModelConfirmOrderCouponDtoList> list = [];
    for(Map<String,dynamic> json in value){
      OrderCouponListModelConfirmOrderCouponDtoList item = OrderCouponListModelConfirmOrderCouponDtoList.fromJson(json);
      list.add(item);
    }
    return list;
    });
  }


  static Future<List<OrderCouponListModelConfirmOrderCouponDtoList>> getHistoryDataList({
    required int pageNo, required int queryType
  }) {
    return CottiNetWork().post(_getHistoryCoupListUrl, data: {
      "pageNo": pageNo,
      "pageSize": 50,
      "queryType": queryType
    }).then((value){
      List<OrderCouponListModelConfirmOrderCouponDtoList> list = [];
      for(Map<String,dynamic> json in value){
        OrderCouponListModelConfirmOrderCouponDtoList item = OrderCouponListModelConfirmOrderCouponDtoList.fromJson(json);
        list.add(item);
      }
      return list;
    });
  }

}
