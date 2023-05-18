import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';

class OrderConfirmRequestModel {
  int? tookFoodMode;
  int? shopMdCode;
  String? latitude;
  String? longitude;
  String? addressLatitude;
  String? addressLongitude;
  int? addressId;
  bool? chooseNotUseCoupon;
  List<String>? couponNoList;
  List<ConfirmGoodsItem>? confirmGoodsItemParams;
  bool? useBounty;

  /// since APP 105 订单是否选择不用代金券券（true-不用券；false-用券）
  bool? chooseNotUseVoucher;

  /// since APP 105 使用的代金券和sku映射（同一个sku使用不同的代金券，分多条数据）
  List<VoucherSkuModelEntity>? useVoucherSkus;

  /// since APP 105 不使用代金券的sku（同一个sku多个不使用，分多条数据）
  List<VoucherSkuModelEntity>? notUseVoucherSkus;

  OrderConfirmRequestModel();

  OrderConfirmRequestModel copy() {
    return OrderConfirmRequestModel()
      ..tookFoodMode = tookFoodMode
      ..shopMdCode = shopMdCode
      ..latitude = latitude
      ..longitude = longitude
      ..addressId = addressId
      ..addressLatitude = addressLatitude
      ..addressLongitude = addressLongitude
      ..chooseNotUseCoupon = chooseNotUseCoupon
      ..couponNoList = couponNoList
      ..useBounty = useBounty
      ..confirmGoodsItemParams = confirmGoodsItemParams
      ..chooseNotUseVoucher = chooseNotUseVoucher
      ..useVoucherSkus = useVoucherSkus
      ..notUseVoucherSkus = notUseVoucherSkus;
  }

  Map<String, dynamic> toMap() {
    var list = confirmGoodsItemParams?.map((e) => e.toMap()).toList();
    var useVoucherSkusList = useVoucherSkus?.map((e) => e.toJson()).toList();
    var notUseVoucherSkusList = notUseVoucherSkus?.map((e) => e.toJson()).toList();

    return {
      "tookFoodMode": tookFoodMode,
      "shopMdCode": shopMdCode,
      "latitude": latitude,
      "longitude": longitude,
      "addressId": addressId,
      "addressLatitude": addressLatitude,
      "addressLongitude": addressLongitude,
      "addressId": addressId,
      "chooseNotUseCoupon": chooseNotUseCoupon,
      "couponNoList": couponNoList,
      "useBounty": useBounty,
      "confirmGoodsItemParams": list,
      "chooseNotUseVoucher": chooseNotUseVoucher,
      "useVoucherSkus": useVoucherSkusList,
      "notUseVoucherSkus": notUseVoucherSkusList,
    };
  }

  factory OrderConfirmRequestModel.fromJson(Map<String, dynamic> json) {
    return OrderConfirmRequestModel()
      ..tookFoodMode = json["tookFoodMode"]
      ..shopMdCode = json["shopMdCode"]
      ..latitude = json["latitude"]
      ..longitude = json["longitude"]
      ..addressId = json["addressId"]
      ..addressLatitude = json["addressLatitude"]
      ..addressLongitude = json["addressLongitude"]
      ..chooseNotUseCoupon = json["chooseNotUseCoupon"]
      ..couponNoList = json["couponNoList"]
      ..useBounty = json["useBounty"]
      ..chooseNotUseVoucher = json["chooseNotUseVoucher"]
      ..confirmGoodsItemParams = (json["confirmGoodsItemParams"] as List<dynamic>)
          .map((e) => ConfirmGoodsItem.fromJson(e))
          .toList()
      ..useVoucherSkus = (json["useVoucherSkus"] as List<dynamic>)
          .map((e) => VoucherSkuModelEntity.fromJson(e))
          .toList()
      ..notUseVoucherSkus = (json["notUseVoucherSkus"] as List<dynamic>)
          .map((e) => VoucherSkuModelEntity.fromJson(e))
          .toList();
  }
}

class ConfirmGoodsItem {
  String? spuNo;
  String? skuNo;
  int? buyNum;
  double? specialPrice;

  ConfirmGoodsItem(this.spuNo, this.skuNo, this.buyNum, this.specialPrice);

  Map<String, dynamic> toMap() => {
        "spuNo": spuNo,
        "skuNo": skuNo,
        "buyNum": buyNum,
        "specialPrice": specialPrice,
      };

  factory ConfirmGoodsItem.fromJson(Map<String, dynamic> json) {
    return ConfirmGoodsItem(json["spuNo"], json["skuNo"], json["buyNum"],
        json["specialPrice"].toString().isEmpty ? 0 : double.parse(json["specialPrice"]));
  }
}
