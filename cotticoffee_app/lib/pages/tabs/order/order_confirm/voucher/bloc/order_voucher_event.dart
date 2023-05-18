part of 'order_voucher_bloc.dart';

abstract class OrderVoucherEvent {}

class OrderVoucherInitEvent extends OrderVoucherEvent {
  final List<VoucherSkuModelEntity> goodsItems;
  final BuildContext context;
  /// 默认需要重置sku.show属性，调整代金券入口不需要
  final bool resetShow;

  OrderVoucherInitEvent({this.resetShow=true, required this.context, required this.goodsItems});
}

class OrderVoucherChangeEvent extends OrderVoucherEvent {
  final VoucherSkuModelEntity goodsItem;
  final CashCouponEntity voucherModel;
  final BuildContext context;

  OrderVoucherChangeEvent(
      {required this.context, required this.goodsItem, required this.voucherModel});
}

class OrderVoucherNoUseEvent extends OrderVoucherEvent {
  final BuildContext context;
  VoucherSkuModelEntity? skuModelEntity;

  OrderVoucherNoUseEvent({required this.context, this.skuModelEntity});
}

class OrderVoucherResumeEvent extends OrderVoucherEvent {
  OrderVoucherResumeEvent();
}

class OrderVoucherSaveEvent extends OrderVoucherEvent {
  final BuildContext context;

  OrderVoucherSaveEvent({required this.context});
}

class VoucherTabChangeEvent extends OrderVoucherEvent {
  final int tabIndex;
  final BuildContext context;
  final VoucherSkuModelEntity skuModel;

  VoucherTabChangeEvent({required this.tabIndex, required this.context, required this.skuModel});
}

class VoucherLoadMoreEvent extends OrderVoucherEvent {
  final BuildContext context;
  final VoucherSkuModelEntity skuModel;

  VoucherLoadMoreEvent({required this.context, required this.skuModel});
}

class VoucherRefreshEvent extends OrderVoucherEvent {
  final BuildContext context;
  final VoucherSkuModelEntity skuModel;

  VoucherRefreshEvent({required this.context, required this.skuModel});
}

class ShowVoucherRootPopupEvent extends OrderVoucherEvent {
  final BuildContext context;

  ShowVoucherRootPopupEvent({
    required this.context,
  });
}

class ShowVoucherSubPopupEvent extends OrderVoucherEvent {
  final VoucherSkuModelEntity goodsItem;
  final BuildContext context;

  ShowVoucherSubPopupEvent({
    required this.goodsItem,
    required this.context,
  });
}

class VoucherSkuListCloseEvent extends OrderVoucherEvent {
  final BuildContext context;

  VoucherSkuListCloseEvent({required this.context});
}

class VoucherAdjustEvent extends OrderVoucherEvent {
  final OrderCouponListModelConfirmOrderCouponDtoList coupon;
  final BuildContext context;

  VoucherAdjustEvent({required this.coupon, required this.context});
}
