import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/product_spec_entity.g.dart';
import 'dart:convert';

import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/special_activity_limit.dart';
import 'package:cotti_client/pages/tabs/menu/entity/special_price_activity.dart';

@JsonSerializable()
class ProductSpecEntity {

	String? title;
	int? itemId;
	String? itemNo;
	String? itemShowName;
	int? skuOnlineCount;
	dynamic skuList;
	List<ProductSpecSpecItems>? specItems;
	String? litimgUrl;
	String? detailImgUrl;
	dynamic itemNetWeight;
	dynamic capacity;
	String? itemScore;
	dynamic itemSpicyValue;
	dynamic itemLabel;
	dynamic methodName;
	dynamic itemCateName;
	dynamic itemCateValue;
	dynamic businessTypes;
	String? prodCategoryCode;
	dynamic placeOfOrigin;
	dynamic workmanship;
	dynamic flavor;
	dynamic packageTypeCodes;
	dynamic productSort;
	int? taxClassId;
	String? essentials;
	dynamic rank;
	String? sellingPoints;
	dynamic marketingLabel;
	int? makeType;
	List<ProductSpecProductDesc>? productDesc;
	ProductSpecProductTipsInfo? productTipsInfo;
	int? quantityCount;
	int? skuNum;
	bool? skuSamePrice;
	List<ProductSpecSkuCombinList>? skuCombinList;
	int? skuAllSaleOut;
	SkuEntity? firstSku;
	int? lowestPrice;
	dynamic firstActivitySku;
	int? nowTime;
	int? skuNumNew;
	dynamic firstSkuFlag;
	ProductSpecCustomMarketingLabel? customMarketingLabel;
  
  ProductSpecEntity();

  factory ProductSpecEntity.fromJson(Map<String, dynamic> json) => $ProductSpecEntityFromJson(json);

  Map<String, dynamic> toJson() => $ProductSpecEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductSpecSpecItems {

	String? specItemNo;
	String? specItemName;
	List<ProductSpecSpecItemsSpecValueList>? specValueList;
  
  ProductSpecSpecItems();

  factory ProductSpecSpecItems.fromJson(Map<String, dynamic> json) => $ProductSpecSpecItemsFromJson(json);

  Map<String, dynamic> toJson() => $ProductSpecSpecItemsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductSpecSpecItemsSpecValueList {

	String? name;
	String? value;
	bool? selected;
	int? recommendFlag;
  
  ProductSpecSpecItemsSpecValueList();

  factory ProductSpecSpecItemsSpecValueList.fromJson(Map<String, dynamic> json) => $ProductSpecSpecItemsSpecValueListFromJson(json);

  Map<String, dynamic> toJson() => $ProductSpecSpecItemsSpecValueListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductSpecProductDesc {

	String? descName;
	String? descContent;
  
  ProductSpecProductDesc();

  factory ProductSpecProductDesc.fromJson(Map<String, dynamic> json) => $ProductSpecProductDescFromJson(json);

  Map<String, dynamic> toJson() => $ProductSpecProductDescToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductSpecProductTipsInfo {

	String? content;
  
  ProductSpecProductTipsInfo();

  factory ProductSpecProductTipsInfo.fromJson(Map<String, dynamic> json) => $ProductSpecProductTipsInfoFromJson(json);

  Map<String, dynamic> toJson() => $ProductSpecProductTipsInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductSpecSkuCombinList {

	int? quantity;
	int? haltSale;
	int? noSale;
	int? noSaleType;
	String? noSaleMsg;
	dynamic skuId;
	String? skuNo;
	String? skuBarcode;
	List<ProductSpecSkuCombinListSkusSpecs>? skusSpecs;
	String? skuName;
	String? skuShowName;
	dynamic activityPrice;
	int? sellPrice;
	int? standardPrice;
	SpecialPriceActivity? specialPriceActivity;
	int? defaultSku;
	String? qrCodeUrl;
	List<ProductSpecSkuCombinListBusinessTypes>? businessTypes;
	int? tagPrintStatus;
	int? lowestPrice;
	bool? saleOut;
	dynamic activityPriceStr;
	String? sellPriceStr;
	String? standardPriceStr;
	String? lowestPriceStr;
	SpecialActivityLimit? specialActivityLimitDTO;
	int? tempSortId;
	dynamic memberLimitNum;
	dynamic shopLimitNum;
	dynamic oncePrice;
	dynamic oncePriceStr;
	dynamic oncePriceDetailStr;
	bool? displayOncePrice;
	String? spuShowName;
  
  ProductSpecSkuCombinList();

  factory ProductSpecSkuCombinList.fromJson(Map<String, dynamic> json) => $ProductSpecSkuCombinListFromJson(json);

  Map<String, dynamic> toJson() => $ProductSpecSkuCombinListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductSpecSkuCombinListSkusSpecs {

	late String specItemValue;
	String? specItemValueName;
	late String specItemNo;
	String? specItemName;
  
  ProductSpecSkuCombinListSkusSpecs();

  factory ProductSpecSkuCombinListSkusSpecs.fromJson(Map<String, dynamic> json) => $ProductSpecSkuCombinListSkusSpecsFromJson(json);

  Map<String, dynamic> toJson() => $ProductSpecSkuCombinListSkusSpecsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductSpecSkuCombinListBusinessTypes {

	String? name;
	int? value;
  
  ProductSpecSkuCombinListBusinessTypes();

  factory ProductSpecSkuCombinListBusinessTypes.fromJson(Map<String, dynamic> json) => $ProductSpecSkuCombinListBusinessTypesFromJson(json);

  Map<String, dynamic> toJson() => $ProductSpecSkuCombinListBusinessTypesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductSpecFirstSku {

	int? quantity;
	int? haltSale;
	int? noSale;
	dynamic noSaleType;
	dynamic noSaleMsg;
	dynamic skuId;
	String? skuNo;
	String? skuBarcode;
	List<ProductSpecFirstSkuSkusSpecs>? skusSpecs;
	String? skuName;
	String? skuShowName;
	dynamic activityPrice;
	int? sellPrice;
	int? standardPrice;
	dynamic specialPriceActivity;
	int? defaultSku;
	String? qrCodeUrl;
	List<ProductSpecFirstSkuBusinessTypes>? businessTypes;
	int? tagPrintStatus;
	int? lowestPrice;
	bool? saleOut;
	dynamic activityPriceStr;
	String? sellPriceStr;
	String? standardPriceStr;
	String? lowestPriceStr;
	dynamic specialActivityLimitDTO;
	int? tempSortId;
	dynamic memberLimitNum;
	dynamic shopLimitNum;
	dynamic oncePrice;
	dynamic oncePriceStr;
	dynamic oncePriceDetailStr;
	bool? displayOncePrice;
	String? spuShowName;
  
  ProductSpecFirstSku();

  factory ProductSpecFirstSku.fromJson(Map<String, dynamic> json) => $ProductSpecFirstSkuFromJson(json);

  Map<String, dynamic> toJson() => $ProductSpecFirstSkuToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductSpecFirstSkuSkusSpecs {

	String? specItemValue;
	String? specItemValueName;
	String? specItemNo;
	String? specItemName;
  
  ProductSpecFirstSkuSkusSpecs();

  factory ProductSpecFirstSkuSkusSpecs.fromJson(Map<String, dynamic> json) => $ProductSpecFirstSkuSkusSpecsFromJson(json);

  Map<String, dynamic> toJson() => $ProductSpecFirstSkuSkusSpecsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductSpecFirstSkuBusinessTypes {

	String? name;
	int? value;
  
  ProductSpecFirstSkuBusinessTypes();

  factory ProductSpecFirstSkuBusinessTypes.fromJson(Map<String, dynamic> json) => $ProductSpecFirstSkuBusinessTypesFromJson(json);

  Map<String, dynamic> toJson() => $ProductSpecFirstSkuBusinessTypesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductSpecCustomMarketingLabel {

	List<String>? labelList;
  
  ProductSpecCustomMarketingLabel();

  factory ProductSpecCustomMarketingLabel.fromJson(Map<String, dynamic> json) => $ProductSpecCustomMarketingLabelFromJson(json);

  Map<String, dynamic> toJson() => $ProductSpecCustomMarketingLabelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}