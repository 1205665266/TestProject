import 'package:bloc/bloc.dart';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotticommon/cotticommon.dart';

import 'first_order_free_event.dart';
import 'first_order_free_state.dart';

class FirstOrderFreeBloc extends Bloc<FirstOrderFreeEvent, FirstOrderFreeState> {
  FirstOrderFreeBloc() : super(FirstOrderFreeState()) {
    on<CheckMemberFirstOrderFree>(_checkMemberFirstOrderFree);
  }

  _checkMemberFirstOrderFree(_, emit) async {
    if (state.isLoading) {
      return;
    }
    state.isLoading = true;
    await CottiNetWork()
        .post("/person/memberFirstOrderFreeShipping", showToast: false)
        .then((value) {
      state.firstOrderFreeDeliveryFee = value['firstOrderFreeDeliveryFee'];
    }).catchError((onError) {
      logE(onError);
      state.firstOrderFreeDeliveryFee = false;
    });
    state.isLoading = false;
    emit(state.copy());
  }
}
