import 'package:cotti_client/pages/product/entity/product_detail_entity.dart';
import 'package:cotti_client/pages/product/entity/product_spec_entity.dart';

class ProductState {
  ProductDetailEntity? productDetailData;

  ProductSpecEntity? productSpecData;

  ///
  /// product spec 用状态
  /// ${specItem.specItemNo}-${specItem.specItemValue} sku的key值示例
  ///
  List<ProductSpecSpecItems> specList = []; // 渲染界面所需的规格项列表
  Map<String, ProductSpecSkuCombinList>? skuMap = {}; // 用于记录指定规格的商品的信息(所有商品)
  List<String>? sellingList = []; // 可售商品item的sku串
  Map<String, ProductSpecSkuCombinList>? saleOutMap = {}; // 用于记录指定规格的商品的信息(售罄)
  List<String>? saleOutList = []; // 售罄item的sku串
  Map<String, ProductSpecSkuCombinList>? noSaleMap = {}; // 用于记录指定规格的商品的信息(不可售)
  List<String>? noSaleList = []; // 不可售item的sku串
  Map<String, String>? currentSelect = {}; // 记录当前选中的sku选项，规格name为key，选中值为value

  ProductSpecSkuCombinList? currentSkuData;
  int recommendType = -1; // 推荐偏好文字提示 -1为空，0是默认，1是选中，2是未选中

  ///
  /// product toolbar 用状态
  ///
  int buyNum = 1;

  ProductState copy() {
    return ProductState()
      ..productDetailData = productDetailData
      ..productSpecData = productSpecData
      // product spec 用状态
      ..specList = specList
      ..skuMap = skuMap
      ..sellingList = sellingList
      ..saleOutMap = saleOutMap
      ..saleOutList = saleOutList
      ..noSaleMap = noSaleMap
      ..noSaleList = noSaleList
      ..currentSelect = currentSelect
      ..currentSkuData = currentSkuData
      ..recommendType = recommendType
      // product spec 用状态
      ..buyNum = buyNum;
  }

  /// 当前选中sku是否是特价商品
  bool get currentSkuIsActive {
    bool isActive = currentSkuData?.specialPriceActivity != null &&
        currentSkuData?.specialPriceActivity?.specialPrice != '' &&
        (currentSkuData?.specialActivityLimitDTO?.limitAmount ?? 0) > 0;

    return isActive;
  }
}
