
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_count_request_model.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';

class OrderCouponListRequestModel {

  int? queryType;
  int? shopMdCode;
  int? diningCode;
  double? deliverFee;
  List<ProductItem>? products;

  /// since APP 105 使用的代金券和sku映射（同一个sku使用不同的代金券，分多条数据）
  List<VoucherSkuModelEntity>? useVoucherSkus;
  /// since APP105 订单中不使用代金券的sku列表（同一种sku，多个不适用代金券，传多个）
  List<VoucherSkuModelEntity>? notUseVoucherSkus;
  /// since APP105 订单已使用的优惠券No
  String? usedCouponNo;
  /// since APP105 订单已使用的优惠券名称
  String? usedCouponName;
  /// since APP105 订单已使用的优惠券减免金额
  String? usedCouponReductionMoney;

  /// 标记选中
  String? bestCouponNo;

  int pageNo = 1;
  final int pageSize = 20;


  OrderCouponListRequestModel(this.queryType, this.shopMdCode, this.diningCode, this.deliverFee,
      this.products);

  Map<String, dynamic> toMap() => {
    "pageNo": pageNo,
    "pageSize": pageSize,
    "queryType": queryType,
    "shopMdCode": shopMdCode,
    "diningCode": diningCode,
    "deliverFee": deliverFee,
    "products": products?.map((e) => e.toMap()).toList(),
    "useVoucherSkus": useVoucherSkus?.map((e) => e.toMap()).toList(),
    "notUseVoucherSkus": notUseVoucherSkus?.map((e) => e.toMap()).toList(),
    "usedCouponNo": usedCouponNo,
    "usedCouponName": usedCouponName,
    "usedCouponReductionMoney": usedCouponReductionMoney,
    "bestCouponNo": bestCouponNo
  };
}