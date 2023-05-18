import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/api/cash_coupon_api.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'cash_coupon_event.dart';

part 'cash_coupon_state.dart';

class CashCouponBloc extends Bloc<CashCouponEvent, CashCouponState> {
  CashCouponBloc() : super(CashCouponState()) {
    on<CashTabChangeEvent>(_tabChange);
    on<CashLoadingEvent>(_onLoading);
    on<CashRefreshEvent>(_onRefresh);
  }

  _tabChange(CashTabChangeEvent event, emit) {
    state.cashCouponList.clear();
    state.showEmpty = false;
    emit(state.copy());
    add(CashRefreshEvent(event.queryType));
  }

  _onLoading(CashLoadingEvent event, emit) async {
    state.loadStatus = LoadStatus.loading;
    state.requestTimeStamp = event.requestTimeStamp;
    await _getCashCouponList(event.queryType, state.pageNo + 1).then((value) {
      if (state.requestTimeStamp == event.requestTimeStamp) {
        if (value.isNotEmpty) {
          state.pageNo++;
          state.cashCouponList.addAll(value);
          state.loadStatus = LoadStatus.idle;
        } else {
          state.loadStatus = LoadStatus.noMore;
        }
      }
    }).catchError((error) {
      state.loadStatus = LoadStatus.failed;
    });
    emit(state.copy());
  }

  _onRefresh(CashRefreshEvent event, emit) async {
    state.pageNo = 1;
    state.refreshStatus = RefreshStatus.idle;
    state.loadStatus = LoadStatus.loading;
    state.requestTimeStamp = event.requestTimeStamp;
    emit(state.copy());
    await _getCashCouponList(event.queryType, state.pageNo).then((value) {
      if (state.requestTimeStamp == event.requestTimeStamp) {
        state.cashCouponList = value;
        state.showEmpty = value.isEmpty;
      }
    }).catchError((onError) => logI("刷新失败$onError"));
    state.refreshStatus = RefreshStatus.completed;
    if (state.cashCouponList.isNotEmpty && state.cashCouponList.length < 6) {
      add(CashLoadingEvent(event.queryType));
    }
    emit(state.copy());
  }

  Future<List<CashCouponEntity>> _getCashCouponList(QueryType queryType, int pageNo) {
    if (queryType == QueryType.due) {
      return CashCouponApi.getAvailableList(pageNo, state.pageSize);
    } else if (queryType == QueryType.used || queryType == QueryType.expired) {
      return CashCouponApi.getHistoryCashList(pageNo, state.pageSize, queryType.type);
    }
    return Future.value([]);
  }
}
