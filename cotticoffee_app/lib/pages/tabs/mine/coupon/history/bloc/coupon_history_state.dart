part of 'coupon_history_bloc.dart';

class CouponHistoryState {
  bool showLoading = false;

  /// 1 已失效 2 已使用
  int queryType = 2;

  int pageNo = 1;

  /// 优惠券数组
  List<OrderCouponListModelConfirmOrderCouponDtoList>? couponList;

  List<Tab> tabs = [
    Tab("已使用", 2),
    Tab("已失效", 1),
  ];

  LoadStatus loadStatus = LoadStatus.idle;
  RefreshStatus refreshStatus = RefreshStatus.idle;
  int requestTimeStamp = 0;

  static CouponHistoryState init() {
    return CouponHistoryState()..showLoading = false;
  }

  CouponHistoryState copy() {
    return CouponHistoryState()
      ..showLoading = showLoading
      ..couponList = couponList
      ..queryType = queryType
      ..pageNo = pageNo
      ..tabs = tabs
      ..loadStatus = loadStatus
      ..refreshStatus = refreshStatus
      ..showLoading = showLoading;
  }
}
