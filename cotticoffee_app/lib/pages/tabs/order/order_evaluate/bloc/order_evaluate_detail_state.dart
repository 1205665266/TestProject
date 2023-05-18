part of 'order_evaluate_detail_bloc.dart';

class OrderEvaluateDetailState {
  bool showLoading = false;
  String? orderId;

  OrderCommentEntityEntity? data;

  OrderEvaluateDetailState copy() {
    return OrderEvaluateDetailState()
      ..showLoading = showLoading
      ..orderId = orderId
      ..data = data;
  }
}

