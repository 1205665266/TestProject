part of 'red_envelop_bloc.dart';

abstract class RedEnvelopEvent {
  String? orderId;

  RedEnvelopEvent(this.orderId);
}

class SharingShareEvent extends RedEnvelopEvent {
  ///订单号

  SharingShareEvent(String orderId) : super(orderId);
}
