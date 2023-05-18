abstract class OrderDetailEvent {}

class InitOrderInfoEvent extends OrderDetailEvent {
  final String orderId;

  InitOrderInfoEvent(this.orderId);
}
class GrantSystemNotificationEvent extends OrderDetailEvent {}
class UpdateOrderEvent extends OrderDetailEvent {}
class OnRefreshDetailEvent extends OrderDetailEvent {}
class OnRequestDeliveryDetailEvent extends OrderDetailEvent {}
class OnRequestRefundRecordEvent extends OrderDetailEvent {}
