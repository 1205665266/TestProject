import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/pages/tabs/order/api/order_api.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_model.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderState()) {
    on<SwitchOrderStatusEvent>(_switchOrderStatus);
    on<OnLoadingEvent>(_onLoading);
    on<OnRefreshEvent>(_onRefresh);
    on<OnRefreshFirstPageEvent>(_refreshCurrentList);
    on<CancelReasonListEvent>(_cancelReasonList);
    on<OrderDetailCancelReasonListEvent>(_cancelReasonListInDetail);
    on<CancelOrderEvent>(_cancelOrder);
    on<ChangeTabEvent>(_changeTab);
  }

  Timer? _timer;

  // 当tab处于当前订单，并且第一页数据存在
  _refreshCurrentList(event, emit) async {
    await OrderApi.getOrderList(state.tabs[0].status, 1, state.pageSize).then((result) {
      List<OrderModel> value = result.orders ?? [];

      // 如果当前已经切换到历史订单，则取消定时
      if (state.status == state.tabs[1].status) {
        _timer?.cancel();
        return;
      }

      if (value.isNotEmpty) {
        int end = value.indexWhere(
            (newItem) => (state.orderList.indexWhere((oldItem) => newItem.id == oldItem.id)) != -1);

        logI('end===>$end');
        state.orderList.replaceRange(0, state.orderList.length - end, value);
      }

      // 如果没有待支付订单， 则取消轮询
      if (state.orderList.indexWhere((element) => element.status == 10) == -1) {
        _timer?.cancel();
      }

      state.cancelOrderConfigDTO = result.cancleOrderConfigDTO;

      emit(state.copy());
    }).catchError((onError) {
      logE(onError);
    });
  }

  _startPeriodic() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(const Duration(milliseconds: 5000), (timer) async {
      if (Constant.hasLogin) {
        add(OnRefreshFirstPageEvent());
      } else {
        if (_timer != null) {
          _timer?.cancel();
        }
      }
    });
  }

  _changeTab(ChangeTabEvent event, emit) {
    emit(state.copy()..isChangeTab = event.isChangingTab);
  }

  _switchOrderStatus(SwitchOrderStatusEvent event, emit) async {
    state.pageNo = 1;
    state.isChangeTab = false;
    state.orderList.clear();
    state.status = event.status;
    state.pageIndex = event.status - 1;
    state.loadStatus = LoadStatus.loading;
    state.requestTimeStamp = event.requestTimeStamp;
    state.showLoading = true;
    emit(state.copy());
    await OrderApi.getOrderList(event.status, state.pageNo, state.pageSize).then((result) {
      List<OrderModel> value = result.orders ?? [];
      state.loadStatus = LoadStatus.idle;
      if (state.requestTimeStamp == event.requestTimeStamp) {
        state.orderList.clear();
        state.orderList = value;
        state.cancelOrderConfigDTO = result.cancleOrderConfigDTO;
      }
      // 当前在当前订单tab 并且 第一页包含待支付订单
      if (state.status == state.tabs[0].status &&
          state.orderList.indexWhere((element) => element.status == 10) != -1) {
        _startPeriodic();
      }
    }).catchError((onError) {
      logE(onError);
      state.loadStatus = LoadStatus.failed;
    });
    state.showLoading = false;
    emit(state.copy());
  }

  _onLoading(event, emit) async {
    state.loadStatus = LoadStatus.loading;
    state.requestTimeStamp = event.requestTimeStamp;
    await OrderApi.getOrderList(state.status, state.pageNo + 1, state.pageSize).then((result) {
      state.loadStatus = LoadStatus.idle;
      List<OrderModel> value = result.orders ?? [];
      state.cancelOrderConfigDTO = result.cancleOrderConfigDTO;
      if (state.requestTimeStamp == event.requestTimeStamp) {
        if (value.isNotEmpty) {
          state.pageNo++;
          state.orderList.addAll(value);
        } else {
          state.loadStatus = LoadStatus.noMore;
        }
      }
    }).catchError((error) {
      state.loadStatus = LoadStatus.failed;
    });
    emit(state.copy());
  }

  _onRefresh(OnRefreshEvent event, emit) async {
    state.pageNo = 1;
    state.refreshStatus = RefreshStatus.idle;
    state.loadStatus = LoadStatus.loading;
    state.requestTimeStamp = event.requestTimeStamp!;
    emit(state.copy());
    await Future.delayed(Duration(seconds: event.delayed)).then(
      (value) => OrderApi.getOrderList(state.status, state.pageNo, state.pageSize).then((result) {
        List<OrderModel> value = result.orders ?? [];
        state.cancelOrderConfigDTO = result.cancleOrderConfigDTO;
        state.loadStatus = LoadStatus.idle;
        if (state.requestTimeStamp == event.requestTimeStamp) {
          state.orderList = value;
        }
      }).catchError((onError) {
        state.loadStatus = LoadStatus.failed;
      }),
    );
    state.refreshStatus = RefreshStatus.completed;
    emit(state.copy());
  }

  _cancelReasonList(event, emit) async {
    state.showLoading = true;
    emit(state.copy());
    await OrderApi.getCancelReasonList(1, 1).then((value) {
      state.cancelReason = value;
      state.cancelOrderId = event.orderId;
      emit(state.copyReasonTimeStamp(event.timeStamp));
    }).catchError((onError) {});
    state.showLoading = false;
    emit(state.copy());
  }

  _cancelReasonListInDetail(event, emit) async {
    state.showLoading = true;
    emit(state.copy());
    await OrderApi.getCancelReasonList(1, 1).then((value) {
      state.cancelReason = value;
      state.cancelOrderId = event.orderId;
      emit(state.copyReasonTimeStampInDetail(event.timeStamp));
    }).catchError((onError) {});
    state.showLoading = false;
    emit(state.copy());
  }

  _cancelOrder(CancelOrderEvent event, emit) async {
    state.showLoading = true;
    emit(state.copy());
    await OrderApi.cancelOrderRequest(
      event.orderId ?? 0,
      event.orderCancelReasonId,
      event.otherReasons,
    ).then((value) {
      if (event.callBack != null) {
        event.callBack!(value);
      }
      if (value) {
        ToastUtil.show("取消成功");
      }
    }).catchError((onError) {
      if (event.status != 10 && event.callBack != null) {
        event.callBack!(false);
      } else {
        // 刷新
        add(OnRefreshEvent(1));
        String? errorMessage;
        if (onError.data != null) {
          errorMessage = onError.data['busMessage'];
        }
        if ((errorMessage?.isNotEmpty ?? false)) {
          ToastUtil.show(errorMessage!);
        }
      }
    });
    state.showLoading = false;
    emit(state.copy());
  }
}
