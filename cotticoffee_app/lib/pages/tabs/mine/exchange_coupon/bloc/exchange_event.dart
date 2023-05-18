abstract class ExchangeEvent {}

class ValidateCouponEvent extends ExchangeEvent {
  final String exchangeCode;

  ValidateCouponEvent(this.exchangeCode);
}

class ExchangeCouponEvent extends ExchangeEvent {
  final String exchangeCode;

  ExchangeCouponEvent(this.exchangeCode);
}
