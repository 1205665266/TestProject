import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';

class VoucherListRquestModel {
  /// 门店主数据编号
  int? shopMdCode;

  /// 就餐方式(0.堂食,1.外带,2.外卖)
  int? diningCode;

  /// 选择的商品信息
  ProductParamModel? productParam;

  /// 查询类型；1-可用优惠券；2-不可用优惠券
  int? queryType;

  /// 页号（从1开始）
  int? pageNo;

  /// 页大小（默认30）
  int? pageSize;

  /// since APP105 订单已使用的优惠券名称
  String? userdCouponName;

  /// since APP105 订单已使用的优惠券减免金额
  String? userdCouponReductionMoney;

  /// 查询代金券类型 1.可用 2.不可用
  int? voucherType;

  /// since APP 105 使用的代金券和sku映射（同一个sku使用不同的代金券，分多条数据）
  List<VoucherSkuModelEntity>? useVoucherSkus;

  /// 当前选中的代金券，接口用于将选中项排在首位；
  String? bestVoucherNo;

  VoucherListRquestModel();

  VoucherListRquestModel copy() {
    return VoucherListRquestModel()
      ..shopMdCode = shopMdCode
      ..diningCode = diningCode
      ..productParam = productParam
      ..queryType = queryType
      ..pageNo = pageNo
      ..pageSize = pageSize
      ..userdCouponName = userdCouponName
      ..userdCouponReductionMoney = userdCouponReductionMoney
      ..voucherType = voucherType
      ..useVoucherSkus = useVoucherSkus
      ..bestVoucherNo = bestVoucherNo;
  }

  Map<String, dynamic> toMap() {
    var productParamMap = productParam?.toMap();
    var useVoucherSkusList = useVoucherSkus?.map((e) => e.toMap()).toList();
    return {
      "shopMdCode": shopMdCode,
      "diningCode": diningCode,
      "productParam": productParamMap,
      "queryType": queryType,
      "pageNo": pageNo,
      "pageSize": pageSize,
      "userdCouponName": userdCouponName,
      "userdCouponReductionMoney": userdCouponReductionMoney,
      "voucherType": voucherType,
      "useVoucherSkus": useVoucherSkusList,
      "bestVoucherNo": bestVoucherNo,
    };
  }

  factory VoucherListRquestModel.fromJson(Map<String, dynamic> json) {
    return VoucherListRquestModel()
      ..shopMdCode = json["shopMdCode"]
      ..diningCode = json["diningCode"]
      ..productParam = ProductParamModel.fromJson(json["productParam"])
      ..queryType = json["queryType"]
      ..pageNo = json["pageNo"]
      ..pageSize = json["pageSize"]
      ..userdCouponName = json["userdCouponName"]
      ..userdCouponReductionMoney = json["userdCouponReductionMoney"]
      ..voucherType = json["voucherType"]
      ..bestVoucherNo = json["bestVoucherNo"]
      ..useVoucherSkus = (json["useVoucherSkus"] as List<dynamic>)
          .map((e) => VoucherSkuModelEntity.fromJson(e))
          .toList();
  }
}

class ProductParamModel {

  /// 商品分类
  String? cagetoryCode;
  /// 商品编码
  String? spuCode;
  /// sku编码
  String? skuCode;
  /// 商品基础单价
  double? baseUnitPrice;
  /// 商品促销单价
  double? saleUnitPrice;
  /// 购买数量
  int? purchaseNums;
  /// 优惠券减免金额
  double? couponDiscountMoney;
  /// 特价价格
  String? specialPrice;

  ProductParamModel();

  Map<String, dynamic> toMap() {
    return {
      "cagetoryCode": cagetoryCode,
      "spuCode": spuCode,
      "skuCode": skuCode,
      "baseUnitPrice": baseUnitPrice,
      "saleUnitPrice": saleUnitPrice,
      "purchaseNums": purchaseNums,
      "couponDiscountMoney": couponDiscountMoney,
      "specialPrice" : specialPrice
    };
  }

  factory ProductParamModel.fromJson(Map<String, dynamic> json) {
    return ProductParamModel()
      ..cagetoryCode = json["cagetoryCode"]
      ..spuCode = json["spuCode"]
      ..skuCode = json["skuCode"]
      ..baseUnitPrice = json["baseUnitPrice"]
      ..saleUnitPrice = json["saleUnitPrice"]
      ..purchaseNums = json["purchaseNums"]
      ..couponDiscountMoney = json["couponDiscountMoney"];
  }

}
