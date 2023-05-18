import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/api/order_evaluate_api.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/entity/order_comment_entity_entity.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:meta/meta.dart';

part 'order_evaluate_detail_event.dart';
part 'order_evaluate_detail_state.dart';

class OrderEvaluateDetailBloc extends Bloc<OrderEvaluateDetailEvent, OrderEvaluateDetailState> {
  OrderEvaluateDetailBloc() : super(OrderEvaluateDetailState()) {
    on<OrderEvaluateDetailInitEvent>(_init);
  }

  _init(OrderEvaluateDetailInitEvent event, emit)async{
    await OrderEvaluateApi.getOrderComment(orderId: event.orderId).then((value){
      emit(state.copy()..showLoading=false..data=value);
    }).catchError((error){
      logI('catchError == $error');
      emit(state.copy()..showLoading=false);
    });
  }


}
