import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/product/entity/product_detail_entity.dart';
import 'package:cotti_client/pages/product/entity/product_spec_entity.dart';

class ProductApi {
  static const itemDetailUrl = '/item/itemDetail';
  static const itemSpecsUrl = '/item/itemSpecs';
  static const _itemSpecsCoupon = "/item/itemSpecsCoupon";

  static Future<ProductDetailEntity> getProductDetail({
    required String itemNo,
    required int shopMdCode,
    required int takeFoodMode,
    required List businessTypes,
    String? selectSkuCode,
  }) {
    return CottiNetWork().post(
      itemDetailUrl,
      data: {
        "itemNo": itemNo,
        "shopMdCode": shopMdCode,
        "takeFoodMode": takeFoodMode,
        "businessTypes": businessTypes,
        "selectSkuCode": selectSkuCode
      },
    ).then((value) => ProductDetailEntity.fromJson(value));
  }

  static Future<ProductSpecEntity> getProductSpecs(
      {required String itemNo,
      required int shopMdCode,
      required int takeFoodMode,
      required List businessTypes,
      String? selectSkuCode}) {
    return CottiNetWork().post(
      itemSpecsUrl,
      data: {
        "itemNo": itemNo,
        "shopMdCode": shopMdCode,
        "takeFoodMode": takeFoodMode,
        "businessTypes": businessTypes,
        "selectSkuCode": selectSkuCode
      },
    ).then((value) => ProductSpecEntity.fromJson(value));
  }

  static Future<ProductSpecSkuCombinList> getProductSpecsCoupon(
    String skuCode,
    String cagetoryCode,
    int shopMdCode,
    String itemNo,
    int takeFoodMode,
    List? businessTypes,
  ) {
    return CottiNetWork().post(
      _itemSpecsCoupon,
      showToast: false,
      data: {
        "skuCode": skuCode,
        "cagetoryCode": cagetoryCode,
        "shopMdCode": shopMdCode,
        "itemNo": itemNo,
        "takeFoodMode": takeFoodMode,
        "businessTypes": businessTypes,
      },
    ).then((value) => ProductSpecSkuCombinList.fromJson(value));
  }
}
