part of 'coupon_bloc.dart';

class CouponState {
  bool showLoading = false;
  bool showEmpty = false;

  /// 1 全部 2 即将过期 3 待生效
  int tabCode = 1;



  /// 优惠券数组
  List<OrderCouponListModelConfirmOrderCouponDtoList>? couponList;

  List<CouponTab> tabs = [
    CouponTab(name: "全部", status: 1, showCount: true,count: 0),
    CouponTab(name: "即将过期", status: 2, showCount: true,count: 0),
    CouponTab(name: "待生效", status: 3, showCount: true,count: 0),
  ];


  BannerModel? bannerModel;

  int pageNo = 1;
  LoadStatus loadStatus = LoadStatus.idle;
  RefreshStatus refreshStatus = RefreshStatus.idle;
  int requestTimeStamp = 0;

  static CouponState init() {
    return CouponState()..showLoading = false;
  }

  CouponState copy() {
    return CouponState()
      ..showLoading = showLoading
      ..showEmpty = showEmpty
      ..couponList = couponList
      ..tabCode = tabCode
      ..pageNo = pageNo
      ..tabs = tabs
      ..bannerModel = bannerModel
      ..loadStatus = loadStatus
      ..refreshStatus = refreshStatus
      ..showLoading = showLoading;
  }
}

class CouponTab extends Tab {
  /// 总数
  final int count;

  final bool showCount;

  String get title {
    return showCount ? "$name($count)" : name;
  }

  CouponTab({required String name, required int status,required this.count, this.showCount = false})
      : super(name, status);
}
