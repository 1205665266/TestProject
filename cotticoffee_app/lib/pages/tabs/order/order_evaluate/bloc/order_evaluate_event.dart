part of 'order_evaluate_bloc.dart';

abstract class OrderEvaluateEvent {}

class InitEvent extends OrderEvaluateEvent {
  late String orderId;
  InitEvent(this.orderId);
}

class OrderEvaluateGetConfigEvent extends OrderEvaluateEvent {
  final String orderId;
  OrderEvaluateGetConfigEvent({required this.orderId});
}

class SatisfiedOptionsSelectedEvent extends OrderEvaluateEvent {
  final List<String> selectedOptions;
  SatisfiedOptionsSelectedEvent(this.selectedOptions);
}

class SatisfiedSelectedEvent extends OrderEvaluateEvent {
  final bool isSatisfied;
  SatisfiedSelectedEvent(this.isSatisfied);
}

class EditEvaluateMessageEvent extends OrderEvaluateEvent {
  final String evaluateMessage;
  EditEvaluateMessageEvent(this.evaluateMessage);
}

class EditAssetsEvent extends OrderEvaluateEvent {
  final List<AssetEntity> selectAssets;
  EditAssetsEvent(this.selectAssets);
}

class SubmitEvaluateEvent extends OrderEvaluateEvent {
  final BuildContext context;

  SubmitEvaluateEvent({required this.context});
}
