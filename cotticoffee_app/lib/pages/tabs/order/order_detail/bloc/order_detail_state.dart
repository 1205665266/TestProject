import 'package:cotti_client/pages/tabs/order/entity/order_delivery_detail_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_refund_record_model_entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderDetailState {
  String orderId = '';
  bool showLoading = false;
  OrderDetailModel? orderDetail;
  OrderDeliveryDetailModelEntity? orderDeliveryDetailModelEntity;
  List<OrderRefundRecordModelEntity> refundRecordList = [];
  int getRefundRecordListTimeStamp = 0;

  bool systemNotification = false;

  RefreshStatus refreshStatus = RefreshStatus.idle;

  OrderDetailState copy({OrderDeliveryDetailModelEntity? orderDeliveryDetailModelEntity}) {
    return OrderDetailState()
      ..orderId = orderId
      ..orderDetail = orderDetail
      ..showLoading = showLoading
      ..refreshStatus = refreshStatus
      ..refundRecordList = refundRecordList
      ..getRefundRecordListTimeStamp = getRefundRecordListTimeStamp
      ..orderDeliveryDetailModelEntity = orderDeliveryDetailModelEntity ?? this.orderDeliveryDetailModelEntity
      ..systemNotification = systemNotification;
  }

  OrderDetailState copyRecordTimeStamp(int refundRecordListTimeStamp) {
    return copy()..getRefundRecordListTimeStamp = refundRecordListTimeStamp;
  }

  ///是否是自提
  bool get isSelfTake => orderDetail?.takeType == 0 || orderDetail?.takeType == 1;

  ///是否是外卖
  bool get isTakeOut => orderDetail?.takeType == 2;

  ///配送中， 并且是平台配送
  bool get isShowMap =>
      orderDetail?.orderStatusStr?.status == 'DELIVERING' && orderDetail?.expressMode == 1;
}
