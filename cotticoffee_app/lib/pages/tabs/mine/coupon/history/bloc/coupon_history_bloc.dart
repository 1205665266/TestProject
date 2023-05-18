import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/tabs/mine/coupon/coupon_list/api/coupon_api.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_list_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'coupon_history_event.dart';
part 'coupon_history_state.dart';

class CouponHistoryBloc extends Bloc<CouponHistoryEvent, CouponHistoryState> {
  CouponHistoryBloc() : super(CouponHistoryState.init()) {
    on<CouponHistoryTabChangeEvent>(_tabChange);
    on<CouponHistoryLoadingEvent>(_loading);
    on<CouponHistoryRefreshEvent>(_refresh);
  }

  _loading(CouponHistoryLoadingEvent event, emit)async{
    state.loadStatus = LoadStatus.loading;
    state.requestTimeStamp = event.requestTimeStamp ?? 0;
    await CouponApi.getHistoryDataList(queryType: state.queryType, pageNo: state.pageNo + 1).then((value) {
      state.loadStatus = LoadStatus.idle;
      if (state.requestTimeStamp == event.requestTimeStamp) {
        if (value.isNotEmpty) {
          state.pageNo++;
          state.couponList?.addAll(value);
        } else {
          state.loadStatus = LoadStatus.noMore;
        }
      }
    }).catchError((error) {
      state.loadStatus = LoadStatus.failed;
    });
    emit(state.copy());
  }

  _refresh(CouponHistoryRefreshEvent event,emit) async {
    state.pageNo = 1;
    state.refreshStatus = RefreshStatus.idle;
    state.loadStatus = LoadStatus.loading;
    state.requestTimeStamp = event.requestTimeStamp!;
    emit(state.copy());
    await Future.delayed(Duration(seconds: event.delayed)).then(
          (value) => CouponApi.getHistoryDataList(queryType: state.queryType, pageNo: state.pageNo).then((value) {
        if (state.requestTimeStamp == event.requestTimeStamp) {
          state.couponList = value;
        }
      }).catchError((onError) {}),
    );
    state.refreshStatus = RefreshStatus.completed;
    emit(state.copy());
  }

  _tabChange(CouponHistoryTabChangeEvent event,emit) async {
    state.queryType = event.queryType;
    state.pageNo = 1;
    state.refreshStatus = RefreshStatus.idle;
    state.loadStatus = LoadStatus.loading;
    state.requestTimeStamp = event.requestTimeStamp!;
    emit(state.copy());

    try {
      List<OrderCouponListModelConfirmOrderCouponDtoList> list =
          await CouponApi.getHistoryDataList(pageNo: state.pageNo, queryType: state.queryType);

      emit(state.copy()
        ..couponList = list
        ..refreshStatus = RefreshStatus.completed);
    } catch (error) {
      emit(state.copy()..refreshStatus = RefreshStatus.completed);
    }
  }
}
