part of 'order_coupon_bloc.dart';

abstract class OrderCouponEvent {}


class OrderFetchCouponCountEvent extends OrderCouponEvent {

  OrderCouponCountRequestModel? orderCouponCountRequestModel;

  OrderFetchCouponCountEvent(this.orderCouponCountRequestModel);
}

class OrderFetchCouponListEvent extends OrderCouponEvent {
  OrderCouponListRequestModel? orderCouponListRequestModel;
  int tabIndex;

  OrderFetchCouponListEvent(this.tabIndex, this.orderCouponListRequestModel);
}

class OrderFetchCouponListRefreshEvent extends OrderCouponEvent {
  OrderCouponListRequestModel? orderCouponListRequestModel;

  OrderFetchCouponListRefreshEvent(this.orderCouponListRequestModel);
}

class OrderFetchCouponListLoadMoreEvent extends OrderCouponEvent {
  OrderCouponListRequestModel? orderCouponListRequestModel;

  OrderFetchCouponListLoadMoreEvent(this.orderCouponListRequestModel);
}


