part of 'cash_coupon_template_bloc.dart';

@immutable
abstract class CashCouponTemplateEvent {}

class InitCashCouponTemplateEvent extends CashCouponTemplateEvent {
  final bool isFirst;

  InitCashCouponTemplateEvent({this.isFirst = false});
}

class CashCouponSubTemplateEvent extends CashCouponTemplateEvent {
  final String templateCode;
  final String templateName;
  final String value;

  CashCouponSubTemplateEvent(this.templateCode, this.templateName, this.value);
}

class SubTemplateInfoEvent extends CashCouponTemplateEvent {
  final String templateCode;

  SubTemplateInfoEvent(this.templateCode);
}
