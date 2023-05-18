class OrderCouponCountRequestModel {
  ///
  double? deliverFee;
  int? shopMdCode;
  int? diningCode;

  List<ProductItem>? products;


  OrderCouponCountRequestModel(this.deliverFee, this.shopMdCode, this.diningCode, this.products);

  Map<String, dynamic> toMap() => {
      "deliverFee": deliverFee,
      "shopMdCode": shopMdCode,
      "diningCode": diningCode,
      "products": products?.map((e) => e.toMap()).toList(),
    };
}


class ProductItem {
  String? cagetoryCode;
  String? spuCode;
  String? skuCode;
  double? baseUnitPrice;
  double? saleUnitPrice;
  int? purchaseNums;

  ProductItem(this.cagetoryCode, this.spuCode, this.skuCode, this.baseUnitPrice, this.saleUnitPrice,
      this.purchaseNums);


  Map<String, dynamic> toMap() => {
    "cagetoryCode": cagetoryCode,
    "spuCode": spuCode,
    "skuCode": skuCode,
    "baseUnitPrice": baseUnitPrice,
    "saleUnitPrice": saleUnitPrice,
    "purchaseNums": purchaseNums,
  };

}