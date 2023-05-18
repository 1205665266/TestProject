import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/product_detail_entity.g.dart';
import 'dart:convert';

import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';

@JsonSerializable()
class ProductDetailEntity {

	String? title;
	dynamic itemId;
	String? itemNo;
	dynamic methodName;
	dynamic itemSpicyValue;
	dynamic itemStyle;
	String? itemLabel;
	dynamic minPrice;
	dynamic lineThroughPrice;
	String? unit;
	String? sellPoint;
	dynamic itemNetWeight;
	dynamic displaySpecList;
	dynamic safetyPicUrls;
	dynamic quantity;
	dynamic isDisplay;
	List<ProductDetailTopMedias>? topMedias;
	List<ProductDetailSkuList>? skuList;
	ProductDetailRecommendations? recommendations;
	String? litimgUrl;
	List<dynamic>? batchingNutrients;
	dynamic cookStorage;
	dynamic cookThaw;
	dynamic freezingShelfLife;
	dynamic refrigerationShelfLife;
	dynamic commonShelfLife;
	dynamic capacity;
	dynamic feature;
	List<ProductDetailIntroMedias>? introMedias;
	dynamic placeOfOrigin;
	dynamic workmanship;
	dynamic flavor;
	String? processMethods;
	dynamic characteristicPicUrls;
	SkuEntity? firstSku;
	List<ProductDetailMarketingLabel>? marketingLabel;
	ProductDetailCustomMarketingLabel? customMarketingLabel;
	dynamic taste;
	List<dynamic>? methods;
	dynamic cookMethod;
	int? sales;
	int? configShowLimitNum;
	int? configShowLimitTime;
	int? memberLimitShow;
	String? deliveryTimeStr;
	String? deliveryInfoStr;
	dynamic customerServiceAddress;
	bool? shareSwitch;
	List<String>? brandPicList;
	List<ProductDetailProductDesc>? productDesc;
	ProductDetailProductTipsInfo? productTipsInfo;
	int? nowTime;
	int? skuNumNew;
	String? appletShareTitle;
	String? appletShareUrl;
	String? appletLitimgUrl;
	String? appletPageimgUrl;
	dynamic activityShareTitle;
  
  ProductDetailEntity();

  factory ProductDetailEntity.fromJson(Map<String, dynamic> json) => $ProductDetailEntityFromJson(json);

  Map<String, dynamic> toJson() => $ProductDetailEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductDetailTopMedias {

	int? mediaType;
	String? mediaUrl;
	dynamic targetUrl;
	int? sort;
	dynamic videoCoverUrl;
	dynamic fid;
  
  ProductDetailTopMedias();

  factory ProductDetailTopMedias.fromJson(Map<String, dynamic> json) => $ProductDetailTopMediasFromJson(json);

  Map<String, dynamic> toJson() => $ProductDetailTopMediasToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductDetailSkuList {

	String? skuNo;
	dynamic skuId;
	int? lowestPrice;
	bool? saleOut;
	int? quantity;
	int? haltSale;
	int? noSale;
	dynamic noSaleMsg;
	dynamic specialPriceActivity;
	dynamic activityPrice;
	int? sellPrice;
	int? standardPrice;
	String? skuName;
	String? skuShowName;
	dynamic memberLimitNum;
	dynamic shopLimitNum;
  
  ProductDetailSkuList();

  factory ProductDetailSkuList.fromJson(Map<String, dynamic> json) => $ProductDetailSkuListFromJson(json);

  Map<String, dynamic> toJson() => $ProductDetailSkuListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductDetailRecommendations {

	String? itemScore;
	dynamic topChefName;
	dynamic topChefTitle;
	dynamic topChefPost;
	dynamic topChefHeadshot;
	dynamic topChefContent;
  
  ProductDetailRecommendations();

  factory ProductDetailRecommendations.fromJson(Map<String, dynamic> json) => $ProductDetailRecommendationsFromJson(json);

  Map<String, dynamic> toJson() => $ProductDetailRecommendationsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductDetailIntroMedias {

	int? mediaType;
	String? mediaUrl;
	int? sort;
	dynamic videoCoverUrl;
	dynamic fid;
  
  ProductDetailIntroMedias();

  factory ProductDetailIntroMedias.fromJson(Map<String, dynamic> json) => $ProductDetailIntroMediasFromJson(json);

  Map<String, dynamic> toJson() => $ProductDetailIntroMediasToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductDetailFirstSku {

	int? quantity;
	int? haltSale;
	int? noSale;
	dynamic noSaleType;
	dynamic noSaleMsg;
	dynamic skuId;
	String? skuNo;
	String? skuBarcode;
	List<ProductDetailFirstSkuSkusSpecs>? skusSpecs;
	String? skuName;
	String? skuShowName;
	dynamic activityPrice;
	int? sellPrice;
	int? standardPrice;
	dynamic specialPriceActivity;
	int? defaultSku;
	String? qrCodeUrl;
	List<ProductDetailFirstSkuBusinessTypes>? businessTypes;
	int? tagPrintStatus;
	int? lowestPrice;
	bool? saleOut;
	dynamic activityPriceStr;
	String? sellPriceStr;
	String? standardPriceStr;
	String? lowestPriceStr;
	dynamic specialActivityLimitDTO;
	dynamic tempSortId;
	dynamic memberLimitNum;
	dynamic shopLimitNum;
	dynamic oncePrice;
	dynamic oncePriceStr;
	dynamic oncePriceDetailStr;
	bool? displayOncePrice;
	dynamic spuShowName;
  
  ProductDetailFirstSku();

  factory ProductDetailFirstSku.fromJson(Map<String, dynamic> json) => $ProductDetailFirstSkuFromJson(json);

  Map<String, dynamic> toJson() => $ProductDetailFirstSkuToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductDetailFirstSkuSkusSpecs {

	String? specItemValue;
	String? specItemValueName;
	String? specItemNo;
	String? specItemName;
  
  ProductDetailFirstSkuSkusSpecs();

  factory ProductDetailFirstSkuSkusSpecs.fromJson(Map<String, dynamic> json) => $ProductDetailFirstSkuSkusSpecsFromJson(json);

  Map<String, dynamic> toJson() => $ProductDetailFirstSkuSkusSpecsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductDetailFirstSkuBusinessTypes {

	String? name;
	int? value;
  
  ProductDetailFirstSkuBusinessTypes();

  factory ProductDetailFirstSkuBusinessTypes.fromJson(Map<String, dynamic> json) => $ProductDetailFirstSkuBusinessTypesFromJson(json);

  Map<String, dynamic> toJson() => $ProductDetailFirstSkuBusinessTypesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductDetailMarketingLabel {

	String? name;
	String? value;
  
  ProductDetailMarketingLabel();

  factory ProductDetailMarketingLabel.fromJson(Map<String, dynamic> json) => $ProductDetailMarketingLabelFromJson(json);

  Map<String, dynamic> toJson() => $ProductDetailMarketingLabelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductDetailCustomMarketingLabel {

	List<String>? labelList;
  
  ProductDetailCustomMarketingLabel();

  factory ProductDetailCustomMarketingLabel.fromJson(Map<String, dynamic> json) => $ProductDetailCustomMarketingLabelFromJson(json);

  Map<String, dynamic> toJson() => $ProductDetailCustomMarketingLabelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductDetailProductDesc {

	String? descName;
	String? descContent;
  
  ProductDetailProductDesc();

  factory ProductDetailProductDesc.fromJson(Map<String, dynamic> json) => $ProductDetailProductDescFromJson(json);

  Map<String, dynamic> toJson() => $ProductDetailProductDescToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProductDetailProductTipsInfo {

	String? content;
  
  ProductDetailProductTipsInfo();

  factory ProductDetailProductTipsInfo.fromJson(Map<String, dynamic> json) => $ProductDetailProductTipsInfoFromJson(json);

  Map<String, dynamic> toJson() => $ProductDetailProductTipsInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}