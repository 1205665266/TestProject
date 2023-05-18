part of 'cash_coupon_bloc.dart';

class CashCouponState {
  final int pageSize = 20;
  bool showLoading = false;
  bool showEmpty = false;
  int pageNo = 1;
  LoadStatus loadStatus = LoadStatus.idle;
  RefreshStatus refreshStatus = RefreshStatus.idle;
  int requestTimeStamp = 0;
  List<CashCouponEntity> cashCouponList = [];

  CashCouponState copy() {
    return CashCouponState()
      ..pageNo = pageNo
      ..showEmpty = showEmpty
      ..loadStatus = loadStatus
      ..showLoading = showLoading
      ..refreshStatus = refreshStatus
      ..requestTimeStamp = requestTimeStamp
      ..cashCouponList = cashCouponList;
  }

  List<QueryType> get tabs => [QueryType.used, QueryType.expired];
}

enum QueryType {
  ///即将到期
  due,

  ///已失效
  expired,

  ///已使用
  used,
}

extension QueryTypeEnumExtension on QueryType {
  String get name => ['即将到期', '已失效', '已使用'][index];

  int get type => [0, 1, 2][index];
}
