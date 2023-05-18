part of 'order_confirm_bloc.dart';

class OrderConfirmState {
  OrderConfirmModelEntity? orderConfirmModelEntity;
  OrderSubmitModelEntity? orderSubmitModelEntity;
  // 推荐优惠券列表
  List<String> recommendCouponList = [];
  List<String> remarkList = [];
  String remark = "";

  OrderConfirmRequestModel orderConfirmRequestModel = OrderConfirmRequestModel();


  /// 代码拼接的sku列表，用于sku列表的显示；
  List<VoucherSkuModelEntity>? voucherSkusList;
  /// 原始的sku list数据
  List<VoucherSkuModelEntity>? voucherSkusRawList;
  /// since APP 105 sku是否选择不用代金券券（true-不用券；false-用券）
  bool? chooseNotUseCashCoupon;
  /// 记录不使用代金券的列表，确认订单接口返回后需要匹配不使用的状态；
  List<VoucherSkuModelEntity>? chooseNotUseCashCouponList;

  bool showLoading = false;

  bool showConfirmLoading = false;

  PayTypeModel? currentPayTypeModel;

  // 支付列表
  List<PayTypeModel>? payTypeList;

  // 用于显示自取中的《外带》《堂食》
  int currentTakeTypeMode = 1;

  bool notConfirmShopTip = false;

  // 是否是立即购买
  bool fromDetail = false;

  // 进入确认订单时 取餐类型是否是外卖
  int firstConfirmTakeModeTye = Constant.selfTakeModeCode;

  ///配送地址
  MemberAddressEntity? address;

  OrderConfirmState copy() {
    return OrderConfirmState()
      ..orderConfirmModelEntity = orderConfirmModelEntity
      ..orderSubmitModelEntity = orderSubmitModelEntity
      ..recommendCouponList = recommendCouponList
      ..orderConfirmRequestModel = orderConfirmRequestModel
      ..showLoading = showLoading
      ..voucherSkusList = voucherSkusList
      ..voucherSkusRawList = voucherSkusRawList
      ..currentPayTypeModel = currentPayTypeModel
      ..payTypeList = payTypeList
      ..currentTakeTypeMode = currentTakeTypeMode
      ..remark = remark
      ..remarkList = remarkList
      ..fromDetail = fromDetail
      ..notConfirmShopTip = notConfirmShopTip
      ..firstConfirmTakeModeTye = firstConfirmTakeModeTye
      ..address = address
      ..chooseNotUseCashCoupon = chooseNotUseCashCoupon
      ..chooseNotUseCashCouponList = chooseNotUseCashCouponList;
  }

  bool get isAliPay {
    logI( 'result ${ currentPayTypeModel?.payType == 'alipay'}');
    return currentPayTypeModel?.payType == 'alipay';
  }

  bool get isCanteen {
    return currentPayTypeModel?.payType == 'alipay';
  }
}
