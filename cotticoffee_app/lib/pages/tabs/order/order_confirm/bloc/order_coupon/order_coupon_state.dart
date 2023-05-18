part of 'order_coupon_bloc.dart';

class OrderCouponState {

  int pageNo = 1;
  int tabIndex = 0;

  OrderCouponCountModelEntity? orderCouponCountModelEntity;

  List<OrderCouponListModelConfirmOrderCouponDtoList> couponList = [];

  LoadStatus loadStatus = LoadStatus.idle;
  RefreshStatus refreshStatus = RefreshStatus.idle;

  bool showLoading = false;

  OrderCouponState copy() {
    return OrderCouponState()
        ..orderCouponCountModelEntity = orderCouponCountModelEntity
        ..couponList = couponList
        ..loadStatus = loadStatus
        ..refreshStatus = refreshStatus
        ..showLoading = showLoading
        ..tabIndex = tabIndex
        ..pageNo = pageNo;
  }
}
