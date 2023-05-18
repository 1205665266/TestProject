

import 'dart:convert';

import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';

class OrderSubmitRequestModel {

  /// 取货方式 0 ，“堂食” 1, "自提" 2, "外送到家"
  int? tookFoodMode;
  /// 门店主数据编号
  int? shopMdCode;
  /// 折扣后商品总价（商品折扣）
  double? totalAmount4ProductDiscount;
  /// 订单应付金额
  double? orderPayableMoney;
  /// 配送费总原价
  double? totalDeliveryMoney;
  /// 订单来源 1，"用户端-iOS", 2, "用户端-Android", 3, "微信小程序", 4, "网点收银APP" 5，“电商小程序”
  int? origin;
  /// 订单类型（1-立即单；2-预约单）
  int? type;
  /// 设备ID
  String? deviceId;
  /// 支付方式（微信、支付宝、银联，来源：配置中心）
  int? payFrom;
  /// 20221203 食堂-三方储值卡名称
  String? canteenCardName;
  /// mapType
  int? mapType;
  /// 优惠券编号集合
  List<String>? couponNoList;
  /// 订单备注
  String? remark;
  /// 外卖起送价
  double? startDeliveryMoney;
  /// 奖励金优惠金额
  double? bountyDiscountMoney;
  ///当前订单抵扣奖励金数量
  int? bountyDeductionNum;
  /// 奖励金兑换比例
  int? bountyRatio;
  /// 城市主数据编码
  int? cityMdCode;
  /// 免配送费金额
  double? freeThresholdMoney;
  /// 商品金额
  double? totalProductMoney;
  /// 商品支付金额（不包含打包费，配送费）
  double? totalPayAmount4Product;
  /// 分享人ID
  String? shareMemberId;
  /// 提交订单商品项
  List<SubmitGoodsItem>? submitItemParamList;

  ///地址纬度
  String? latitude;
  /// 地址经度
  String? longitude;
  /// 配送地址ID
  num? addressId;
  /// 1130新增 配送费减免list\
  List<OrderConfirmModelFinanceDetailDispatchFeeDiscountList>? dispathcFeeDiscountList;

  /// 20221213 会员是否有免配送费权益 0 否 1是
  int? benefitStatus;
  /// 20221213 权益类型 FIRST_ORDER_FREE(1, "首单外卖免配送费");
  int? benefitType;

  /// since APP 105 使用的代金券和sku映射（同一个sku使用不同的代金券，分多条数据）
  List<VoucherSkuModelEntity>? useVoucherSkus;


  OrderSubmitRequestModel({
      this.tookFoodMode,
      this.shopMdCode,
      this.totalAmount4ProductDiscount,
      this.orderPayableMoney,
      this.totalDeliveryMoney,
      this.origin,
      this.type,
      this.deviceId,
      this.payFrom,
      this.canteenCardName,
      this.mapType,
      this.couponNoList,
      this.remark,
      this.startDeliveryMoney,
      this.bountyDiscountMoney,
      this.bountyDeductionNum,
      this.bountyRatio,
      this.cityMdCode,
      this.freeThresholdMoney,
      this.totalProductMoney,
      this.totalPayAmount4Product,
      this.shareMemberId,
      this.submitItemParamList,
      this.latitude,
      this.longitude,
      this.addressId,
      this.dispathcFeeDiscountList,
      this.benefitType,
      this.benefitStatus,
    this.useVoucherSkus,
  });

  Map<String, dynamic> toMap() {
    
    var goodItemListMap = submitItemParamList?.map((e) => e.toMap()).toList();
    var dispathcFeeDiscountListMap = dispathcFeeDiscountList?.map((e) => e.toJson()).toList();

    List<dynamic>? useVoucherSkusMap = useVoucherSkus?.map((e) => e.toMap()).toList();

    return {
      "tookFoodMode": tookFoodMode,
      "shopMdCode": shopMdCode,
      "totalAmount4ProductDiscount": totalAmount4ProductDiscount,
      "orderPayableMoney": orderPayableMoney,
      "totalDeliveryMoney": totalDeliveryMoney,
      "origin": origin,
      "type": type,
      "deviceId": deviceId,
      "payFrom": payFrom,
      "canteenCardName": canteenCardName,
      "mapType": mapType,
      "remark": remark,
      "startDeliveryMoney": startDeliveryMoney,
      "bountyDiscountMoney": bountyDiscountMoney,
      "bountyDeductionNum": bountyDeductionNum,
      "bountyRatio": bountyRatio,
      "cityMdCode": cityMdCode,
      "freeThresholdMoney": freeThresholdMoney,
      "totalProductMoney": totalProductMoney,
      "totalPayAmount4Product": totalPayAmount4Product,
      "shareMemberId": shareMemberId,
      "submitItemParamList": goodItemListMap,
      "latitude": latitude,
      "longitude": longitude,
      "addressId": addressId,
      "couponNoList": couponNoList,
      "dispathcFeeDiscountList": dispathcFeeDiscountListMap,
      "benefitType": benefitType,
      "benefitStatus": benefitStatus,
      "useVoucherSkus": useVoucherSkusMap
    };
  }
}

class SubmitGoodsItem {
  String? spuNo;
  String? skuNo;
  int? buyNum;
  double? specialPrice;
  String? skuShowName;


  SubmitGoodsItem(this.spuNo, this.skuNo, this.buyNum, this.specialPrice, this.skuShowName);

  Map<String, dynamic> toMap() => {
    "spuCode": spuNo,
    "skuCode": skuNo,
    "buyNum": buyNum,
    "specialPrice": specialPrice,
    "skuShowName": skuShowName,
  };
}