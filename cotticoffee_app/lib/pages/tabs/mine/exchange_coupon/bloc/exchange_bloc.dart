import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/api/exchange_api.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/entity/coupon_exchange_entity.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/entity/error_tips_info.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/entity/validate_entity.dart';
import 'package:cotti_client/utils/f_toast_util.dart';
import 'exchange_event.dart';
import 'exchange_state.dart';

class ExchangeBloc extends Bloc<ExchangeEvent, ExchangeState> {
  ExchangeBloc() : super(ExchangeState()) {
    on<ValidateCouponEvent>(_validateCoupon);
    on<ExchangeCouponEvent>(_exchangeCoupon);
  }

  _validateCoupon(ValidateCouponEvent event, emit) async {
    emit(state.copy(showLoading: true));
    //
    // state.validateEntity = ValidateEntity()..templateProductType=1..total=3..num = "1"..couponName = "优惠券名称" ..couponTemplateNo = "123"..originalAmount="32"..payAmount="16"..productName="商品名称"..templateType = 1;
    // state.couponExchange = CouponExchangeEntity()..couponName="couponName"..couponSubtitle="couponSubtitle"..num="3";
    // emit(state.copy(showLoading: true,exchangeSuccessTime: DateTime.now().millisecondsSinceEpoch,));

    await ExchangeApi.validateCode(event.exchangeCode)
        .then((value) {
          emit(state.copy(
            validateEntity: value,
            validateSuccessTime: DateTime.now().millisecondsSinceEpoch,
          ));
        })
        .catchError((onError) => _handlerError(onError, emit))
        .whenComplete(() => emit(state.copy(showLoading: false)));
  }

  _exchangeCoupon(ExchangeCouponEvent event, emit) async {
    emit(state.copy(showLoading: true));

    await ExchangeApi.exchangeCoupon(
      event.exchangeCode,
      state.validateEntity?.couponTemplateNo ?? '',
    )
        .then((value) {
          emit(state.copy(
            couponExchange: value,
            exchangeSuccessTime: DateTime.now().millisecondsSinceEpoch,
          ));
        })
        .catchError((onError) => _handlerError(onError, emit))
        .whenComplete(() => emit(state.copy(showLoading: false)));
  }

  _handlerError(onError, emit) {
    String? busCode = onError.data['busCode'];
    String? busMessage = onError.data['busMessage'];
    if (busCode == "100" || busCode == "101" || busCode == "102" || busCode == "103") {
      emit(state.copy(
        errorTipsInfo: ErrorTipsInfo(DateTime.now().millisecondsSinceEpoch, busCode, busMessage),
      ));
    } else {
      FToastUtil.showToast(busMessage ?? "${onError.data['message']}");
    }
  }
}
