part of 'cash_coupon_bloc.dart';

abstract class CashCouponEvent {
  int requestTimeStamp = DateTime.now().millisecondsSinceEpoch;
  QueryType queryType;

  CashCouponEvent(this.queryType);
}

class CashTabChangeEvent extends CashCouponEvent {
  CashTabChangeEvent(QueryType queryType) : super(queryType);
}

class CashLoadingEvent extends CashCouponEvent {
  CashLoadingEvent(QueryType queryType) : super(queryType);
}

class CashRefreshEvent extends CashCouponEvent {
  CashRefreshEvent(QueryType queryType) : super(queryType);
}
