import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/pages/tabs/order/api/order_api.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_event.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_state.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  OrderDetailBloc() : super(OrderDetailState()) {
    on<InitOrderInfoEvent>(_initOrderInfo);
    on<UpdateOrderEvent>(_updateOrderInfo);
    on<OnRefreshDetailEvent>(_onRefresh);
    on<OnRequestDeliveryDetailEvent>(_requestDeliveryDetail);
    on<OnRequestRefundRecordEvent>(_requestRefundRecord);
    on<GrantSystemNotificationEvent>(_grantSystemNotification);
  }

  Timer? _timer;
  Timer? _deliveryTimer;
  bool isRequesting = false;
  bool hasStartLoopDeliveryDetail = false;

  _grantSystemNotification(GrantSystemNotificationEvent event, emit) async {
    var status = await Permission.notification.status;
    emit(state.copy()..systemNotification = status == PermissionStatus.granted);

  }


  _requestRefundRecord(OnRequestRefundRecordEvent event, emit) async {
    await OrderApi.getRefundRecord(state.orderId, Constant.memberId)
        .then((value) {
      state.refundRecordList = value;
    }).catchError((onError) => logI('获取退款记录失败${state.orderId}'));

    emit(state.copy()..getRefundRecordListTimeStamp = DateTime.now().microsecondsSinceEpoch);
  }

  _requestDeliveryDetail(OnRequestDeliveryDetailEvent event, emit) async {
    hasStartLoopDeliveryDetail = true;
    await OrderApi.getDeliveryDetail(state.orderId).then((value) {
      emit(state.copy(orderDeliveryDetailModelEntity: value));
    }).catchError((onError) => logI('获取订单配送详情失败${state.orderId}'));

  }

  _stopLoopDeliveryDetail() {
    hasStartLoopDeliveryDetail = false;
    _deliveryTimer?.cancel();
  }

  _initOrderInfo(InitOrderInfoEvent event, emit) async {
    state.showLoading = true;
    state.orderId = event.orderId;
    emit(state.copy());
    await OrderApi.getOrderDetail(event.orderId).then((value) {
      state.orderDetail = value;
      _startPeriodic();
      // 如果当前状态是 平台配送 && 配送中，则轮询配送详情
      if (!hasStartLoopDeliveryDetail && value.orderStatusStr?.status == 'DELIVERING' && value.expressMode == 1) {
        add(OnRequestDeliveryDetailEvent());
        _startLoopDeliveryPeriodic(event.orderId);
      } else {
        _stopLoopDeliveryDetail();
      }
    }).catchError((onError) => logI('获取订单详情失败${event.orderId}'));
    state.showLoading = false;
    emit(state.copy());
  }

  _onRefresh(OnRefreshDetailEvent event, emit) async {
    var copyState = state.copy();
    copyState.refreshStatus = RefreshStatus.idle;
    emit(copyState);
    copyState = state.copy();
    await OrderApi.getOrderDetail(state.orderId).then((value) {
      copyState.orderDetail = value;
    }).catchError((onError) => logI('获取订单详情失败${state.orderId}'));
    copyState.refreshStatus = RefreshStatus.completed;
    emit(copyState.copy());
  }

  _startPeriodic() async {
    _timer = Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      if (state.orderDetail?.status == 10 || state.orderDetail?.status == 20) {
        add(UpdateOrderEvent());
      }
    });
  }

  _startLoopDeliveryPeriodic(String orderId) async {
    _deliveryTimer = Timer.periodic(const Duration(milliseconds: 10 * 1000), (timer) {

      add(OnRequestDeliveryDetailEvent());

    });
  }

  _updateOrderInfo(_, emit) async {
    if (isRequesting) {
      return;
    }
    isRequesting = true;
    await OrderApi.getOrderDetail(state.orderId).then((value) {
      isRequesting = false;
      // 如果当前状态是配送中，则轮询配送详情
      if(!hasStartLoopDeliveryDetail) {
        if (value.orderStatusStr?.status == 'DELIVERING' && value.expressMode == 1) {
          add(OnRequestDeliveryDetailEvent());
          _startLoopDeliveryPeriodic(state.orderId);
        } else {
          _stopLoopDeliveryDetail();
        }
      }

      emit(state.copy()..orderDetail = value);
    }).catchError((onError) {
      isRequesting = false;
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _deliveryTimer?.cancel();
    return super.close();
  }
}
