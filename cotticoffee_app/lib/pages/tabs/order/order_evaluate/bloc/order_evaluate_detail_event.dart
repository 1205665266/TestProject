part of 'order_evaluate_detail_bloc.dart';

@immutable
abstract class OrderEvaluateDetailEvent {}

class OrderEvaluateDetailInitEvent extends OrderEvaluateDetailEvent {

  final String orderId;

  OrderEvaluateDetailInitEvent({required this.orderId});
}