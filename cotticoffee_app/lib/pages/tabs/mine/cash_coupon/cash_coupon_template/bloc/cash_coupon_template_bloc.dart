import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/api/cash_coupon_api.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_template_entity.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_template_sub_entity.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/vocher_template_info_entity.dart';
import 'package:cotticommon/utils/log_util.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'cash_coupon_template_event.dart';

part 'cash_coupon_template_state.dart';

class CashCouponTemplateBloc extends Bloc<CashCouponTemplateEvent, CashCouponTemplateState> {
  CashCouponTemplateBloc() : super(CashCouponTemplateState()) {
    on<InitCashCouponTemplateEvent>(_initCashCouponTemplate);
    on<CashCouponSubTemplateEvent>(_getCashCouponSubTemplate);
    on<SubTemplateInfoEvent>(_subTemplateInfo);
  }

  _initCashCouponTemplate(InitCashCouponTemplateEvent event, emit) async {
    if (event.isFirst) {
      state.showLoading = true;
      emit(state.copy());
    }
    await CashCouponApi.getCashTemplateList().then((value) {
      state.cashCouponTemplate = value;
      state.showEmpty = value.voucherTemplateInfoList?.isEmpty ?? true;
    }).catchError((onError) {
      logI("获取代金券模版失败$onError");
    });
    state.refreshStatus = RefreshStatus.completed;
    state.showLoading = false;
    emit(state.copy());
  }

  _getCashCouponSubTemplate(CashCouponSubTemplateEvent event, emit) async {
    String key = event.templateCode + event.value;
    bool isContains = state.cashCouponTemplateSubMap.containsKey(key);
    if (isContains) {
      state.cashCouponTemplateSubMap.remove(key);
      emit(state.copy());
    } else {
      state.showLoading = true;
      emit(state.copy());
      await CashCouponApi.getCashTemplateSubList(
        event.templateCode,
        event.templateName,
        event.value,
      ).then((value) {
        if ((value.cashCouponTemplateSubList ?? []).isNotEmpty) {
          state.cashCouponTemplateSubMap[key] = value;
        }
      }).catchError((onError) {
        logI("获取代金券模版子列表失败$onError");
      });
      state.showLoading = false;
      emit(state.copy());
    }
  }

  _subTemplateInfo(SubTemplateInfoEvent event, emit) async {
    state.vocherTemplateInfo = null;
    emit(state.copy());
    await CashCouponApi.getSubTemplateInfo(event.templateCode).then((value) {
      if (value.no == event.templateCode) {
        state.vocherTemplateInfo = value;
      }
    });
    emit(state.copy());
  }
}
