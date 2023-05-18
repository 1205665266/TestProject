part of 'coupon_history_bloc.dart';

abstract class CouponHistoryEvent {
  int? requestTimeStamp;

  CouponHistoryEvent({this.requestTimeStamp});
}


class CouponHistoryTabChangeEvent extends CouponHistoryEvent {
  final int queryType;

  CouponHistoryTabChangeEvent({required this.queryType}):super(requestTimeStamp: DateTime.now().microsecondsSinceEpoch);
}

class CouponHistoryLoadingEvent extends CouponHistoryEvent {
  CouponHistoryLoadingEvent() : super(requestTimeStamp: DateTime.now().microsecondsSinceEpoch);
}

class CouponHistoryRefreshEvent extends CouponHistoryEvent {
  final int delayed;

  CouponHistoryRefreshEvent({required this.delayed}) : super(requestTimeStamp: DateTime.now().microsecondsSinceEpoch);
}