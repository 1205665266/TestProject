part of 'cash_coupon_template_bloc.dart';

class CashCouponTemplateState {
  bool showEmpty = false;
  bool showLoading = false;
  CashCouponTemplateEntity? cashCouponTemplate;
  VocherTemplateInfoEntity? vocherTemplateInfo;
  RefreshStatus refreshStatus = RefreshStatus.idle;
  Map<String, CashCouponTemplateSubEntity> cashCouponTemplateSubMap = {};

  CashCouponTemplateState copy() {
    return CashCouponTemplateState()
      ..showEmpty = showEmpty
      ..showLoading = showLoading
      ..refreshStatus = refreshStatus
      ..cashCouponTemplate = cashCouponTemplate
      ..vocherTemplateInfo = vocherTemplateInfo
      ..cashCouponTemplateSubMap = cashCouponTemplateSubMap;
  }

  int get recentlyExpiredCount => cashCouponTemplate?.recentlyExpiredCount ?? 0;

  int get listLength =>
      (cashCouponTemplate?.voucherTemplateInfoList?.length ?? 0) +
      (recentlyExpiredCount > 0 ? 1 : 0);
}
