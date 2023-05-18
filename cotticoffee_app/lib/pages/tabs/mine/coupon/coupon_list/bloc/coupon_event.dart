part of 'coupon_bloc.dart';

abstract class CouponEvent {
  int? requestTimeStamp;

  CouponEvent({this.requestTimeStamp});
}

class CouponGetDataListEvent extends CouponEvent {
  final int pageNo;
  final int tabCode;

  CouponGetDataListEvent({required this.pageNo, required this.tabCode});
}

class CouponTabChangeEvent extends CouponEvent {
  final int tabCode;

  CouponTabChangeEvent({required this.tabCode}):super(requestTimeStamp: DateTime.now().microsecondsSinceEpoch);
}

class CouponGetNumEvent extends CouponEvent {}

class CouponLoadingEvent extends CouponEvent {
  CouponLoadingEvent() : super(requestTimeStamp: DateTime.now().microsecondsSinceEpoch);
}

class CouponRefreshEvent extends CouponEvent {
  final int delayed;

  CouponRefreshEvent({required this.delayed}) : super(requestTimeStamp: DateTime.now().microsecondsSinceEpoch);
}

class CouponBannerEvent extends CouponEvent {}
