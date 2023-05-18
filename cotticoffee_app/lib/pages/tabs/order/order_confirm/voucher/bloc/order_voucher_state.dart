part of 'order_voucher_bloc.dart';

enum OrderVoucherSource {
  goodsList,
  confirmPage,
}

class OrderVoucherState {
  OrderVoucherSource source = OrderVoucherSource.confirmPage;

  /// 原始列表
  List<VoucherSkuModelEntity>? goodsItems;

  /// 用于显示的列表
  List<VoucherSkuModelEntity>? showItems;

  OrderVoucherCountModelEntity? orderVoucherCountModelEntity;

  OrderConfirmModelFinanceDetail? financeDetail;

  bool edit = false;

  LoadStatus loadStatus = LoadStatus.idle;
  RefreshStatus refreshStatus = RefreshStatus.idle;
  bool showLoading = false;

  int pageNo = 1;
  int tabIndex = 0;

  List<CashCouponEntity> voucherList = [];

  OrderVoucherDtoEntity? voucherCountDto;

  /// since APP 105 sku是否选择不用代金券券（true-不用券；false-用券）
  bool? chooseNotUseCashCoupon;

  /// since APP 105 订单使用优惠数量是1时，优惠券名称
  String? usedCouponName;

  /// 标记是否需要重新匹配优惠券
  bool renewConpon = false;


  OrderVoucherState();

  OrderVoucherState copy() {
    return OrderVoucherState()
      ..goodsItems = goodsItems
      ..source = source
      ..chooseNotUseCashCoupon = chooseNotUseCashCoupon
      ..loadStatus = loadStatus
      ..financeDetail = financeDetail
      ..refreshStatus = refreshStatus
      ..voucherList = voucherList
      ..showItems = showItems
      ..pageNo = pageNo
      ..showLoading = showLoading
      ..tabIndex = tabIndex
      // ..confirmCalEntity = confirmCalEntity
      ..voucherCountDto = voucherCountDto
      ..usedCouponName = usedCouponName
      ..renewConpon = renewConpon
      ..edit = edit;
  }
}
