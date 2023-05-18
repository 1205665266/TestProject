import 'package:cotti_client/pages/tabs/order/entity/order_cancel_reason_model.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderState {
  final List<Tab> tabs = [
    Tab("当前订单", 1),
    Tab("历史订单", 2),
  ];
  final int pageSize = 20;

  // 当前tab index
  int pageIndex = 0;
  int pageNo = 1;
  int status = 1;
  bool isChangeTab = false;
  bool showLoading = true;
  int? cancelOrderId;
  int? requestTimeStamp = 0;
  List<OrderModel> orderList = [];
  OrderDetailModelCancleOrderConfigDTO? cancelOrderConfigDTO;
  int getCancelReasonTimeStamp = 0;
  int getCancelReasonTimeStampInDetail = 0;
  LoadStatus loadStatus = LoadStatus.idle;
  List<OrderCancelReasonModel> cancelReason = [];
  RefreshStatus refreshStatus = RefreshStatus.idle;

  OrderState copy() {
    return OrderState()
      ..pageNo = pageNo
      ..status = status
      ..pageIndex = pageIndex
      ..orderList = orderList
      ..cancelOrderConfigDTO = cancelOrderConfigDTO
      ..isChangeTab = isChangeTab
      ..loadStatus = loadStatus
      ..showLoading = showLoading
      ..cancelReason = cancelReason
      ..refreshStatus = refreshStatus
      ..cancelOrderId = cancelOrderId
      ..requestTimeStamp = requestTimeStamp
      ..getCancelReasonTimeStamp = getCancelReasonTimeStamp
      ..getCancelReasonTimeStampInDetail = getCancelReasonTimeStampInDetail;
  }

  OrderState copyReasonTimeStamp(int cancelReasonTimeStamp) {
    return copy()..getCancelReasonTimeStamp = cancelReasonTimeStamp;
  }
  OrderState copyReasonTimeStampInDetail(int cancelReasonTimeStamp) {
    return copy()..getCancelReasonTimeStampInDetail = cancelReasonTimeStamp;
  }
}

class Tab {
  String name;
  int status;

  Tab(this.name, this.status);
}
