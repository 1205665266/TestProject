import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/product/entity/product_detail_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';


ProductDetailEntity $ProductDetailEntityFromJson(Map<String, dynamic> json) {
	final ProductDetailEntity productDetailEntity = ProductDetailEntity();
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		productDetailEntity.title = title;
	}
	final dynamic itemId = jsonConvert.convert<dynamic>(json['itemId']);
	if (itemId != null) {
		productDetailEntity.itemId = itemId;
	}
	final String? itemNo = jsonConvert.convert<String>(json['itemNo']);
	if (itemNo != null) {
		productDetailEntity.itemNo = itemNo;
	}
	final dynamic methodName = jsonConvert.convert<dynamic>(json['methodName']);
	if (methodName != null) {
		productDetailEntity.methodName = methodName;
	}
	final dynamic itemSpicyValue = jsonConvert.convert<dynamic>(json['itemSpicyValue']);
	if (itemSpicyValue != null) {
		productDetailEntity.itemSpicyValue = itemSpicyValue;
	}
	final dynamic itemStyle = jsonConvert.convert<dynamic>(json['itemStyle']);
	if (itemStyle != null) {
		productDetailEntity.itemStyle = itemStyle;
	}
	final String? itemLabel = jsonConvert.convert<String>(json['itemLabel']);
	if (itemLabel != null) {
		productDetailEntity.itemLabel = itemLabel;
	}
	final dynamic minPrice = jsonConvert.convert<dynamic>(json['minPrice']);
	if (minPrice != null) {
		productDetailEntity.minPrice = minPrice;
	}
	final dynamic lineThroughPrice = jsonConvert.convert<dynamic>(json['lineThroughPrice']);
	if (lineThroughPrice != null) {
		productDetailEntity.lineThroughPrice = lineThroughPrice;
	}
	final String? unit = jsonConvert.convert<String>(json['unit']);
	if (unit != null) {
		productDetailEntity.unit = unit;
	}
	final String? sellPoint = jsonConvert.convert<String>(json['sellPoint']);
	if (sellPoint != null) {
		productDetailEntity.sellPoint = sellPoint;
	}
	final dynamic itemNetWeight = jsonConvert.convert<dynamic>(json['itemNetWeight']);
	if (itemNetWeight != null) {
		productDetailEntity.itemNetWeight = itemNetWeight;
	}
	final dynamic displaySpecList = jsonConvert.convert<dynamic>(json['displaySpecList']);
	if (displaySpecList != null) {
		productDetailEntity.displaySpecList = displaySpecList;
	}
	final dynamic safetyPicUrls = jsonConvert.convert<dynamic>(json['safetyPicUrls']);
	if (safetyPicUrls != null) {
		productDetailEntity.safetyPicUrls = safetyPicUrls;
	}
	final dynamic quantity = jsonConvert.convert<dynamic>(json['quantity']);
	if (quantity != null) {
		productDetailEntity.quantity = quantity;
	}
	final dynamic isDisplay = jsonConvert.convert<dynamic>(json['isDisplay']);
	if (isDisplay != null) {
		productDetailEntity.isDisplay = isDisplay;
	}
	final List<ProductDetailTopMedias>? topMedias = jsonConvert.convertListNotNull<ProductDetailTopMedias>(json['topMedias']);
	if (topMedias != null) {
		productDetailEntity.topMedias = topMedias;
	}
	final List<ProductDetailSkuList>? skuList = jsonConvert.convertListNotNull<ProductDetailSkuList>(json['skuList']);
	if (skuList != null) {
		productDetailEntity.skuList = skuList;
	}
	final ProductDetailRecommendations? recommendations = jsonConvert.convert<ProductDetailRecommendations>(json['recommendations']);
	if (recommendations != null) {
		productDetailEntity.recommendations = recommendations;
	}
	final String? litimgUrl = jsonConvert.convert<String>(json['litimgUrl']);
	if (litimgUrl != null) {
		productDetailEntity.litimgUrl = litimgUrl;
	}
	final List<dynamic>? batchingNutrients = jsonConvert.convertListNotNull<dynamic>(json['batchingNutrients']);
	if (batchingNutrients != null) {
		productDetailEntity.batchingNutrients = batchingNutrients;
	}
	final dynamic cookStorage = jsonConvert.convert<dynamic>(json['cookStorage']);
	if (cookStorage != null) {
		productDetailEntity.cookStorage = cookStorage;
	}
	final dynamic cookThaw = jsonConvert.convert<dynamic>(json['cookThaw']);
	if (cookThaw != null) {
		productDetailEntity.cookThaw = cookThaw;
	}
	final dynamic freezingShelfLife = jsonConvert.convert<dynamic>(json['freezingShelfLife']);
	if (freezingShelfLife != null) {
		productDetailEntity.freezingShelfLife = freezingShelfLife;
	}
	final dynamic refrigerationShelfLife = jsonConvert.convert<dynamic>(json['refrigerationShelfLife']);
	if (refrigerationShelfLife != null) {
		productDetailEntity.refrigerationShelfLife = refrigerationShelfLife;
	}
	final dynamic commonShelfLife = jsonConvert.convert<dynamic>(json['commonShelfLife']);
	if (commonShelfLife != null) {
		productDetailEntity.commonShelfLife = commonShelfLife;
	}
	final dynamic capacity = jsonConvert.convert<dynamic>(json['capacity']);
	if (capacity != null) {
		productDetailEntity.capacity = capacity;
	}
	final dynamic feature = jsonConvert.convert<dynamic>(json['feature']);
	if (feature != null) {
		productDetailEntity.feature = feature;
	}
	final List<ProductDetailIntroMedias>? introMedias = jsonConvert.convertListNotNull<ProductDetailIntroMedias>(json['introMedias']);
	if (introMedias != null) {
		productDetailEntity.introMedias = introMedias;
	}
	final dynamic placeOfOrigin = jsonConvert.convert<dynamic>(json['placeOfOrigin']);
	if (placeOfOrigin != null) {
		productDetailEntity.placeOfOrigin = placeOfOrigin;
	}
	final dynamic workmanship = jsonConvert.convert<dynamic>(json['workmanship']);
	if (workmanship != null) {
		productDetailEntity.workmanship = workmanship;
	}
	final dynamic flavor = jsonConvert.convert<dynamic>(json['flavor']);
	if (flavor != null) {
		productDetailEntity.flavor = flavor;
	}
	final String? processMethods = jsonConvert.convert<String>(json['processMethods']);
	if (processMethods != null) {
		productDetailEntity.processMethods = processMethods;
	}
	final dynamic characteristicPicUrls = jsonConvert.convert<dynamic>(json['characteristicPicUrls']);
	if (characteristicPicUrls != null) {
		productDetailEntity.characteristicPicUrls = characteristicPicUrls;
	}
	final SkuEntity? firstSku = jsonConvert.convert<SkuEntity>(json['firstSku']);
	if (firstSku != null) {
		productDetailEntity.firstSku = firstSku;
	}
	final List<ProductDetailMarketingLabel>? marketingLabel = jsonConvert.convertListNotNull<ProductDetailMarketingLabel>(json['marketingLabel']);
	if (marketingLabel != null) {
		productDetailEntity.marketingLabel = marketingLabel;
	}
	final ProductDetailCustomMarketingLabel? customMarketingLabel = jsonConvert.convert<ProductDetailCustomMarketingLabel>(json['customMarketingLabel']);
	if (customMarketingLabel != null) {
		productDetailEntity.customMarketingLabel = customMarketingLabel;
	}
	final dynamic taste = jsonConvert.convert<dynamic>(json['taste']);
	if (taste != null) {
		productDetailEntity.taste = taste;
	}
	final List<dynamic>? methods = jsonConvert.convertListNotNull<dynamic>(json['methods']);
	if (methods != null) {
		productDetailEntity.methods = methods;
	}
	final dynamic cookMethod = jsonConvert.convert<dynamic>(json['cookMethod']);
	if (cookMethod != null) {
		productDetailEntity.cookMethod = cookMethod;
	}
	final int? sales = jsonConvert.convert<int>(json['sales']);
	if (sales != null) {
		productDetailEntity.sales = sales;
	}
	final int? configShowLimitNum = jsonConvert.convert<int>(json['configShowLimitNum']);
	if (configShowLimitNum != null) {
		productDetailEntity.configShowLimitNum = configShowLimitNum;
	}
	final int? configShowLimitTime = jsonConvert.convert<int>(json['configShowLimitTime']);
	if (configShowLimitTime != null) {
		productDetailEntity.configShowLimitTime = configShowLimitTime;
	}
	final int? memberLimitShow = jsonConvert.convert<int>(json['memberLimitShow']);
	if (memberLimitShow != null) {
		productDetailEntity.memberLimitShow = memberLimitShow;
	}
	final String? deliveryTimeStr = jsonConvert.convert<String>(json['deliveryTimeStr']);
	if (deliveryTimeStr != null) {
		productDetailEntity.deliveryTimeStr = deliveryTimeStr;
	}
	final String? deliveryInfoStr = jsonConvert.convert<String>(json['deliveryInfoStr']);
	if (deliveryInfoStr != null) {
		productDetailEntity.deliveryInfoStr = deliveryInfoStr;
	}
	final dynamic customerServiceAddress = jsonConvert.convert<dynamic>(json['customerServiceAddress']);
	if (customerServiceAddress != null) {
		productDetailEntity.customerServiceAddress = customerServiceAddress;
	}
	final bool? shareSwitch = jsonConvert.convert<bool>(json['shareSwitch']);
	if (shareSwitch != null) {
		productDetailEntity.shareSwitch = shareSwitch;
	}
	final List<String>? brandPicList = jsonConvert.convertListNotNull<String>(json['brandPicList']);
	if (brandPicList != null) {
		productDetailEntity.brandPicList = brandPicList;
	}
	final List<ProductDetailProductDesc>? productDesc = jsonConvert.convertListNotNull<ProductDetailProductDesc>(json['productDesc']);
	if (productDesc != null) {
		productDetailEntity.productDesc = productDesc;
	}
	final ProductDetailProductTipsInfo? productTipsInfo = jsonConvert.convert<ProductDetailProductTipsInfo>(json['productTipsInfo']);
	if (productTipsInfo != null) {
		productDetailEntity.productTipsInfo = productTipsInfo;
	}
	final int? nowTime = jsonConvert.convert<int>(json['nowTime']);
	if (nowTime != null) {
		productDetailEntity.nowTime = nowTime;
	}
	final int? skuNumNew = jsonConvert.convert<int>(json['skuNumNew']);
	if (skuNumNew != null) {
		productDetailEntity.skuNumNew = skuNumNew;
	}
	final String? appletShareTitle = jsonConvert.convert<String>(json['appletShareTitle']);
	if (appletShareTitle != null) {
		productDetailEntity.appletShareTitle = appletShareTitle;
	}
	final String? appletShareUrl = jsonConvert.convert<String>(json['appletShareUrl']);
	if (appletShareUrl != null) {
		productDetailEntity.appletShareUrl = appletShareUrl;
	}
	final String? appletLitimgUrl = jsonConvert.convert<String>(json['appletLitimgUrl']);
	if (appletLitimgUrl != null) {
		productDetailEntity.appletLitimgUrl = appletLitimgUrl;
	}
	final String? appletPageimgUrl = jsonConvert.convert<String>(json['appletPageimgUrl']);
	if (appletPageimgUrl != null) {
		productDetailEntity.appletPageimgUrl = appletPageimgUrl;
	}
	final dynamic activityShareTitle = jsonConvert.convert<dynamic>(json['activityShareTitle']);
	if (activityShareTitle != null) {
		productDetailEntity.activityShareTitle = activityShareTitle;
	}
	return productDetailEntity;
}

Map<String, dynamic> $ProductDetailEntityToJson(ProductDetailEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['title'] = entity.title;
	data['itemId'] = entity.itemId;
	data['itemNo'] = entity.itemNo;
	data['methodName'] = entity.methodName;
	data['itemSpicyValue'] = entity.itemSpicyValue;
	data['itemStyle'] = entity.itemStyle;
	data['itemLabel'] = entity.itemLabel;
	data['minPrice'] = entity.minPrice;
	data['lineThroughPrice'] = entity.lineThroughPrice;
	data['unit'] = entity.unit;
	data['sellPoint'] = entity.sellPoint;
	data['itemNetWeight'] = entity.itemNetWeight;
	data['displaySpecList'] = entity.displaySpecList;
	data['safetyPicUrls'] = entity.safetyPicUrls;
	data['quantity'] = entity.quantity;
	data['isDisplay'] = entity.isDisplay;
	data['topMedias'] =  entity.topMedias?.map((v) => v.toJson()).toList();
	data['skuList'] =  entity.skuList?.map((v) => v.toJson()).toList();
	data['recommendations'] = entity.recommendations?.toJson();
	data['litimgUrl'] = entity.litimgUrl;
	data['batchingNutrients'] =  entity.batchingNutrients;
	data['cookStorage'] = entity.cookStorage;
	data['cookThaw'] = entity.cookThaw;
	data['freezingShelfLife'] = entity.freezingShelfLife;
	data['refrigerationShelfLife'] = entity.refrigerationShelfLife;
	data['commonShelfLife'] = entity.commonShelfLife;
	data['capacity'] = entity.capacity;
	data['feature'] = entity.feature;
	data['introMedias'] =  entity.introMedias?.map((v) => v.toJson()).toList();
	data['placeOfOrigin'] = entity.placeOfOrigin;
	data['workmanship'] = entity.workmanship;
	data['flavor'] = entity.flavor;
	data['processMethods'] = entity.processMethods;
	data['characteristicPicUrls'] = entity.characteristicPicUrls;
	data['firstSku'] = entity.firstSku?.toJson();
	data['marketingLabel'] =  entity.marketingLabel?.map((v) => v.toJson()).toList();
	data['customMarketingLabel'] = entity.customMarketingLabel?.toJson();
	data['taste'] = entity.taste;
	data['methods'] =  entity.methods;
	data['cookMethod'] = entity.cookMethod;
	data['sales'] = entity.sales;
	data['configShowLimitNum'] = entity.configShowLimitNum;
	data['configShowLimitTime'] = entity.configShowLimitTime;
	data['memberLimitShow'] = entity.memberLimitShow;
	data['deliveryTimeStr'] = entity.deliveryTimeStr;
	data['deliveryInfoStr'] = entity.deliveryInfoStr;
	data['customerServiceAddress'] = entity.customerServiceAddress;
	data['shareSwitch'] = entity.shareSwitch;
	data['brandPicList'] =  entity.brandPicList;
	data['productDesc'] =  entity.productDesc?.map((v) => v.toJson()).toList();
	data['productTipsInfo'] = entity.productTipsInfo?.toJson();
	data['nowTime'] = entity.nowTime;
	data['skuNumNew'] = entity.skuNumNew;
	data['appletShareTitle'] = entity.appletShareTitle;
	data['appletShareUrl'] = entity.appletShareUrl;
	data['appletLitimgUrl'] = entity.appletLitimgUrl;
	data['appletPageimgUrl'] = entity.appletPageimgUrl;
	data['activityShareTitle'] = entity.activityShareTitle;
	return data;
}

ProductDetailTopMedias $ProductDetailTopMediasFromJson(Map<String, dynamic> json) {
	final ProductDetailTopMedias productDetailTopMedias = ProductDetailTopMedias();
	final int? mediaType = jsonConvert.convert<int>(json['mediaType']);
	if (mediaType != null) {
		productDetailTopMedias.mediaType = mediaType;
	}
	final String? mediaUrl = jsonConvert.convert<String>(json['mediaUrl']);
	if (mediaUrl != null) {
		productDetailTopMedias.mediaUrl = mediaUrl;
	}
	final dynamic targetUrl = jsonConvert.convert<dynamic>(json['targetUrl']);
	if (targetUrl != null) {
		productDetailTopMedias.targetUrl = targetUrl;
	}
	final int? sort = jsonConvert.convert<int>(json['sort']);
	if (sort != null) {
		productDetailTopMedias.sort = sort;
	}
	final dynamic videoCoverUrl = jsonConvert.convert<dynamic>(json['videoCoverUrl']);
	if (videoCoverUrl != null) {
		productDetailTopMedias.videoCoverUrl = videoCoverUrl;
	}
	final dynamic fid = jsonConvert.convert<dynamic>(json['fid']);
	if (fid != null) {
		productDetailTopMedias.fid = fid;
	}
	return productDetailTopMedias;
}

Map<String, dynamic> $ProductDetailTopMediasToJson(ProductDetailTopMedias entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['mediaType'] = entity.mediaType;
	data['mediaUrl'] = entity.mediaUrl;
	data['targetUrl'] = entity.targetUrl;
	data['sort'] = entity.sort;
	data['videoCoverUrl'] = entity.videoCoverUrl;
	data['fid'] = entity.fid;
	return data;
}

ProductDetailSkuList $ProductDetailSkuListFromJson(Map<String, dynamic> json) {
	final ProductDetailSkuList productDetailSkuList = ProductDetailSkuList();
	final String? skuNo = jsonConvert.convert<String>(json['skuNo']);
	if (skuNo != null) {
		productDetailSkuList.skuNo = skuNo;
	}
	final dynamic skuId = jsonConvert.convert<dynamic>(json['skuId']);
	if (skuId != null) {
		productDetailSkuList.skuId = skuId;
	}
	final int? lowestPrice = jsonConvert.convert<int>(json['lowestPrice']);
	if (lowestPrice != null) {
		productDetailSkuList.lowestPrice = lowestPrice;
	}
	final bool? saleOut = jsonConvert.convert<bool>(json['saleOut']);
	if (saleOut != null) {
		productDetailSkuList.saleOut = saleOut;
	}
	final int? quantity = jsonConvert.convert<int>(json['quantity']);
	if (quantity != null) {
		productDetailSkuList.quantity = quantity;
	}
	final int? haltSale = jsonConvert.convert<int>(json['haltSale']);
	if (haltSale != null) {
		productDetailSkuList.haltSale = haltSale;
	}
	final int? noSale = jsonConvert.convert<int>(json['noSale']);
	if (noSale != null) {
		productDetailSkuList.noSale = noSale;
	}
	final dynamic noSaleMsg = jsonConvert.convert<dynamic>(json['noSaleMsg']);
	if (noSaleMsg != null) {
		productDetailSkuList.noSaleMsg = noSaleMsg;
	}
	final dynamic specialPriceActivity = jsonConvert.convert<dynamic>(json['specialPriceActivity']);
	if (specialPriceActivity != null) {
		productDetailSkuList.specialPriceActivity = specialPriceActivity;
	}
	final dynamic activityPrice = jsonConvert.convert<dynamic>(json['activityPrice']);
	if (activityPrice != null) {
		productDetailSkuList.activityPrice = activityPrice;
	}
	final int? sellPrice = jsonConvert.convert<int>(json['sellPrice']);
	if (sellPrice != null) {
		productDetailSkuList.sellPrice = sellPrice;
	}
	final int? standardPrice = jsonConvert.convert<int>(json['standardPrice']);
	if (standardPrice != null) {
		productDetailSkuList.standardPrice = standardPrice;
	}
	final String? skuName = jsonConvert.convert<String>(json['skuName']);
	if (skuName != null) {
		productDetailSkuList.skuName = skuName;
	}
	final String? skuShowName = jsonConvert.convert<String>(json['skuShowName']);
	if (skuShowName != null) {
		productDetailSkuList.skuShowName = skuShowName;
	}
	final dynamic memberLimitNum = jsonConvert.convert<dynamic>(json['memberLimitNum']);
	if (memberLimitNum != null) {
		productDetailSkuList.memberLimitNum = memberLimitNum;
	}
	final dynamic shopLimitNum = jsonConvert.convert<dynamic>(json['shopLimitNum']);
	if (shopLimitNum != null) {
		productDetailSkuList.shopLimitNum = shopLimitNum;
	}
	return productDetailSkuList;
}

Map<String, dynamic> $ProductDetailSkuListToJson(ProductDetailSkuList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['skuNo'] = entity.skuNo;
	data['skuId'] = entity.skuId;
	data['lowestPrice'] = entity.lowestPrice;
	data['saleOut'] = entity.saleOut;
	data['quantity'] = entity.quantity;
	data['haltSale'] = entity.haltSale;
	data['noSale'] = entity.noSale;
	data['noSaleMsg'] = entity.noSaleMsg;
	data['specialPriceActivity'] = entity.specialPriceActivity;
	data['activityPrice'] = entity.activityPrice;
	data['sellPrice'] = entity.sellPrice;
	data['standardPrice'] = entity.standardPrice;
	data['skuName'] = entity.skuName;
	data['skuShowName'] = entity.skuShowName;
	data['memberLimitNum'] = entity.memberLimitNum;
	data['shopLimitNum'] = entity.shopLimitNum;
	return data;
}

ProductDetailRecommendations $ProductDetailRecommendationsFromJson(Map<String, dynamic> json) {
	final ProductDetailRecommendations productDetailRecommendations = ProductDetailRecommendations();
	final String? itemScore = jsonConvert.convert<String>(json['itemScore']);
	if (itemScore != null) {
		productDetailRecommendations.itemScore = itemScore;
	}
	final dynamic topChefName = jsonConvert.convert<dynamic>(json['topChefName']);
	if (topChefName != null) {
		productDetailRecommendations.topChefName = topChefName;
	}
	final dynamic topChefTitle = jsonConvert.convert<dynamic>(json['topChefTitle']);
	if (topChefTitle != null) {
		productDetailRecommendations.topChefTitle = topChefTitle;
	}
	final dynamic topChefPost = jsonConvert.convert<dynamic>(json['topChefPost']);
	if (topChefPost != null) {
		productDetailRecommendations.topChefPost = topChefPost;
	}
	final dynamic topChefHeadshot = jsonConvert.convert<dynamic>(json['topChefHeadshot']);
	if (topChefHeadshot != null) {
		productDetailRecommendations.topChefHeadshot = topChefHeadshot;
	}
	final dynamic topChefContent = jsonConvert.convert<dynamic>(json['topChefContent']);
	if (topChefContent != null) {
		productDetailRecommendations.topChefContent = topChefContent;
	}
	return productDetailRecommendations;
}

Map<String, dynamic> $ProductDetailRecommendationsToJson(ProductDetailRecommendations entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['itemScore'] = entity.itemScore;
	data['topChefName'] = entity.topChefName;
	data['topChefTitle'] = entity.topChefTitle;
	data['topChefPost'] = entity.topChefPost;
	data['topChefHeadshot'] = entity.topChefHeadshot;
	data['topChefContent'] = entity.topChefContent;
	return data;
}

ProductDetailIntroMedias $ProductDetailIntroMediasFromJson(Map<String, dynamic> json) {
	final ProductDetailIntroMedias productDetailIntroMedias = ProductDetailIntroMedias();
	final int? mediaType = jsonConvert.convert<int>(json['mediaType']);
	if (mediaType != null) {
		productDetailIntroMedias.mediaType = mediaType;
	}
	final String? mediaUrl = jsonConvert.convert<String>(json['mediaUrl']);
	if (mediaUrl != null) {
		productDetailIntroMedias.mediaUrl = mediaUrl;
	}
	final int? sort = jsonConvert.convert<int>(json['sort']);
	if (sort != null) {
		productDetailIntroMedias.sort = sort;
	}
	final dynamic videoCoverUrl = jsonConvert.convert<dynamic>(json['videoCoverUrl']);
	if (videoCoverUrl != null) {
		productDetailIntroMedias.videoCoverUrl = videoCoverUrl;
	}
	final dynamic fid = jsonConvert.convert<dynamic>(json['fid']);
	if (fid != null) {
		productDetailIntroMedias.fid = fid;
	}
	return productDetailIntroMedias;
}

Map<String, dynamic> $ProductDetailIntroMediasToJson(ProductDetailIntroMedias entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['mediaType'] = entity.mediaType;
	data['mediaUrl'] = entity.mediaUrl;
	data['sort'] = entity.sort;
	data['videoCoverUrl'] = entity.videoCoverUrl;
	data['fid'] = entity.fid;
	return data;
}

ProductDetailFirstSku $ProductDetailFirstSkuFromJson(Map<String, dynamic> json) {
	final ProductDetailFirstSku productDetailFirstSku = ProductDetailFirstSku();
	final int? quantity = jsonConvert.convert<int>(json['quantity']);
	if (quantity != null) {
		productDetailFirstSku.quantity = quantity;
	}
	final int? haltSale = jsonConvert.convert<int>(json['haltSale']);
	if (haltSale != null) {
		productDetailFirstSku.haltSale = haltSale;
	}
	final int? noSale = jsonConvert.convert<int>(json['noSale']);
	if (noSale != null) {
		productDetailFirstSku.noSale = noSale;
	}
	final dynamic noSaleType = jsonConvert.convert<dynamic>(json['noSaleType']);
	if (noSaleType != null) {
		productDetailFirstSku.noSaleType = noSaleType;
	}
	final dynamic noSaleMsg = jsonConvert.convert<dynamic>(json['noSaleMsg']);
	if (noSaleMsg != null) {
		productDetailFirstSku.noSaleMsg = noSaleMsg;
	}
	final dynamic skuId = jsonConvert.convert<dynamic>(json['skuId']);
	if (skuId != null) {
		productDetailFirstSku.skuId = skuId;
	}
	final String? skuNo = jsonConvert.convert<String>(json['skuNo']);
	if (skuNo != null) {
		productDetailFirstSku.skuNo = skuNo;
	}
	final String? skuBarcode = jsonConvert.convert<String>(json['skuBarcode']);
	if (skuBarcode != null) {
		productDetailFirstSku.skuBarcode = skuBarcode;
	}
	final List<ProductDetailFirstSkuSkusSpecs>? skusSpecs = jsonConvert.convertListNotNull<ProductDetailFirstSkuSkusSpecs>(json['skusSpecs']);
	if (skusSpecs != null) {
		productDetailFirstSku.skusSpecs = skusSpecs;
	}
	final String? skuName = jsonConvert.convert<String>(json['skuName']);
	if (skuName != null) {
		productDetailFirstSku.skuName = skuName;
	}
	final String? skuShowName = jsonConvert.convert<String>(json['skuShowName']);
	if (skuShowName != null) {
		productDetailFirstSku.skuShowName = skuShowName;
	}
	final dynamic activityPrice = jsonConvert.convert<dynamic>(json['activityPrice']);
	if (activityPrice != null) {
		productDetailFirstSku.activityPrice = activityPrice;
	}
	final int? sellPrice = jsonConvert.convert<int>(json['sellPrice']);
	if (sellPrice != null) {
		productDetailFirstSku.sellPrice = sellPrice;
	}
	final int? standardPrice = jsonConvert.convert<int>(json['standardPrice']);
	if (standardPrice != null) {
		productDetailFirstSku.standardPrice = standardPrice;
	}
	final dynamic specialPriceActivity = jsonConvert.convert<dynamic>(json['specialPriceActivity']);
	if (specialPriceActivity != null) {
		productDetailFirstSku.specialPriceActivity = specialPriceActivity;
	}
	final int? defaultSku = jsonConvert.convert<int>(json['defaultSku']);
	if (defaultSku != null) {
		productDetailFirstSku.defaultSku = defaultSku;
	}
	final String? qrCodeUrl = jsonConvert.convert<String>(json['qrCodeUrl']);
	if (qrCodeUrl != null) {
		productDetailFirstSku.qrCodeUrl = qrCodeUrl;
	}
	final List<ProductDetailFirstSkuBusinessTypes>? businessTypes = jsonConvert.convertListNotNull<ProductDetailFirstSkuBusinessTypes>(json['businessTypes']);
	if (businessTypes != null) {
		productDetailFirstSku.businessTypes = businessTypes;
	}
	final int? tagPrintStatus = jsonConvert.convert<int>(json['tagPrintStatus']);
	if (tagPrintStatus != null) {
		productDetailFirstSku.tagPrintStatus = tagPrintStatus;
	}
	final int? lowestPrice = jsonConvert.convert<int>(json['lowestPrice']);
	if (lowestPrice != null) {
		productDetailFirstSku.lowestPrice = lowestPrice;
	}
	final bool? saleOut = jsonConvert.convert<bool>(json['saleOut']);
	if (saleOut != null) {
		productDetailFirstSku.saleOut = saleOut;
	}
	final dynamic activityPriceStr = jsonConvert.convert<dynamic>(json['activityPriceStr']);
	if (activityPriceStr != null) {
		productDetailFirstSku.activityPriceStr = activityPriceStr;
	}
	final String? sellPriceStr = jsonConvert.convert<String>(json['sellPriceStr']);
	if (sellPriceStr != null) {
		productDetailFirstSku.sellPriceStr = sellPriceStr;
	}
	final String? standardPriceStr = jsonConvert.convert<String>(json['standardPriceStr']);
	if (standardPriceStr != null) {
		productDetailFirstSku.standardPriceStr = standardPriceStr;
	}
	final String? lowestPriceStr = jsonConvert.convert<String>(json['lowestPriceStr']);
	if (lowestPriceStr != null) {
		productDetailFirstSku.lowestPriceStr = lowestPriceStr;
	}
	final dynamic specialActivityLimitDTO = jsonConvert.convert<dynamic>(json['specialActivityLimitDTO']);
	if (specialActivityLimitDTO != null) {
		productDetailFirstSku.specialActivityLimitDTO = specialActivityLimitDTO;
	}
	final dynamic tempSortId = jsonConvert.convert<dynamic>(json['tempSortId']);
	if (tempSortId != null) {
		productDetailFirstSku.tempSortId = tempSortId;
	}
	final dynamic memberLimitNum = jsonConvert.convert<dynamic>(json['memberLimitNum']);
	if (memberLimitNum != null) {
		productDetailFirstSku.memberLimitNum = memberLimitNum;
	}
	final dynamic shopLimitNum = jsonConvert.convert<dynamic>(json['shopLimitNum']);
	if (shopLimitNum != null) {
		productDetailFirstSku.shopLimitNum = shopLimitNum;
	}
	final dynamic oncePrice = jsonConvert.convert<dynamic>(json['oncePrice']);
	if (oncePrice != null) {
		productDetailFirstSku.oncePrice = oncePrice;
	}
	final dynamic oncePriceStr = jsonConvert.convert<dynamic>(json['oncePriceStr']);
	if (oncePriceStr != null) {
		productDetailFirstSku.oncePriceStr = oncePriceStr;
	}
	final dynamic oncePriceDetailStr = jsonConvert.convert<dynamic>(json['oncePriceDetailStr']);
	if (oncePriceDetailStr != null) {
		productDetailFirstSku.oncePriceDetailStr = oncePriceDetailStr;
	}
	final bool? displayOncePrice = jsonConvert.convert<bool>(json['displayOncePrice']);
	if (displayOncePrice != null) {
		productDetailFirstSku.displayOncePrice = displayOncePrice;
	}
	final dynamic spuShowName = jsonConvert.convert<dynamic>(json['spuShowName']);
	if (spuShowName != null) {
		productDetailFirstSku.spuShowName = spuShowName;
	}
	return productDetailFirstSku;
}

Map<String, dynamic> $ProductDetailFirstSkuToJson(ProductDetailFirstSku entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['quantity'] = entity.quantity;
	data['haltSale'] = entity.haltSale;
	data['noSale'] = entity.noSale;
	data['noSaleType'] = entity.noSaleType;
	data['noSaleMsg'] = entity.noSaleMsg;
	data['skuId'] = entity.skuId;
	data['skuNo'] = entity.skuNo;
	data['skuBarcode'] = entity.skuBarcode;
	data['skusSpecs'] =  entity.skusSpecs?.map((v) => v.toJson()).toList();
	data['skuName'] = entity.skuName;
	data['skuShowName'] = entity.skuShowName;
	data['activityPrice'] = entity.activityPrice;
	data['sellPrice'] = entity.sellPrice;
	data['standardPrice'] = entity.standardPrice;
	data['specialPriceActivity'] = entity.specialPriceActivity;
	data['defaultSku'] = entity.defaultSku;
	data['qrCodeUrl'] = entity.qrCodeUrl;
	data['businessTypes'] =  entity.businessTypes?.map((v) => v.toJson()).toList();
	data['tagPrintStatus'] = entity.tagPrintStatus;
	data['lowestPrice'] = entity.lowestPrice;
	data['saleOut'] = entity.saleOut;
	data['activityPriceStr'] = entity.activityPriceStr;
	data['sellPriceStr'] = entity.sellPriceStr;
	data['standardPriceStr'] = entity.standardPriceStr;
	data['lowestPriceStr'] = entity.lowestPriceStr;
	data['specialActivityLimitDTO'] = entity.specialActivityLimitDTO;
	data['tempSortId'] = entity.tempSortId;
	data['memberLimitNum'] = entity.memberLimitNum;
	data['shopLimitNum'] = entity.shopLimitNum;
	data['oncePrice'] = entity.oncePrice;
	data['oncePriceStr'] = entity.oncePriceStr;
	data['oncePriceDetailStr'] = entity.oncePriceDetailStr;
	data['displayOncePrice'] = entity.displayOncePrice;
	data['spuShowName'] = entity.spuShowName;
	return data;
}

ProductDetailFirstSkuSkusSpecs $ProductDetailFirstSkuSkusSpecsFromJson(Map<String, dynamic> json) {
	final ProductDetailFirstSkuSkusSpecs productDetailFirstSkuSkusSpecs = ProductDetailFirstSkuSkusSpecs();
	final String? specItemValue = jsonConvert.convert<String>(json['specItemValue']);
	if (specItemValue != null) {
		productDetailFirstSkuSkusSpecs.specItemValue = specItemValue;
	}
	final String? specItemValueName = jsonConvert.convert<String>(json['specItemValueName']);
	if (specItemValueName != null) {
		productDetailFirstSkuSkusSpecs.specItemValueName = specItemValueName;
	}
	final String? specItemNo = jsonConvert.convert<String>(json['specItemNo']);
	if (specItemNo != null) {
		productDetailFirstSkuSkusSpecs.specItemNo = specItemNo;
	}
	final String? specItemName = jsonConvert.convert<String>(json['specItemName']);
	if (specItemName != null) {
		productDetailFirstSkuSkusSpecs.specItemName = specItemName;
	}
	return productDetailFirstSkuSkusSpecs;
}

Map<String, dynamic> $ProductDetailFirstSkuSkusSpecsToJson(ProductDetailFirstSkuSkusSpecs entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['specItemValue'] = entity.specItemValue;
	data['specItemValueName'] = entity.specItemValueName;
	data['specItemNo'] = entity.specItemNo;
	data['specItemName'] = entity.specItemName;
	return data;
}

ProductDetailFirstSkuBusinessTypes $ProductDetailFirstSkuBusinessTypesFromJson(Map<String, dynamic> json) {
	final ProductDetailFirstSkuBusinessTypes productDetailFirstSkuBusinessTypes = ProductDetailFirstSkuBusinessTypes();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		productDetailFirstSkuBusinessTypes.name = name;
	}
	final int? value = jsonConvert.convert<int>(json['value']);
	if (value != null) {
		productDetailFirstSkuBusinessTypes.value = value;
	}
	return productDetailFirstSkuBusinessTypes;
}

Map<String, dynamic> $ProductDetailFirstSkuBusinessTypesToJson(ProductDetailFirstSkuBusinessTypes entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['value'] = entity.value;
	return data;
}

ProductDetailMarketingLabel $ProductDetailMarketingLabelFromJson(Map<String, dynamic> json) {
	final ProductDetailMarketingLabel productDetailMarketingLabel = ProductDetailMarketingLabel();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		productDetailMarketingLabel.name = name;
	}
	final String? value = jsonConvert.convert<String>(json['value']);
	if (value != null) {
		productDetailMarketingLabel.value = value;
	}
	return productDetailMarketingLabel;
}

Map<String, dynamic> $ProductDetailMarketingLabelToJson(ProductDetailMarketingLabel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['value'] = entity.value;
	return data;
}

ProductDetailCustomMarketingLabel $ProductDetailCustomMarketingLabelFromJson(Map<String, dynamic> json) {
	final ProductDetailCustomMarketingLabel productDetailCustomMarketingLabel = ProductDetailCustomMarketingLabel();
	final List<String>? labelList = jsonConvert.convertListNotNull<String>(json['labelList']);
	if (labelList != null) {
		productDetailCustomMarketingLabel.labelList = labelList;
	}
	return productDetailCustomMarketingLabel;
}

Map<String, dynamic> $ProductDetailCustomMarketingLabelToJson(ProductDetailCustomMarketingLabel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['labelList'] =  entity.labelList;
	return data;
}

ProductDetailProductDesc $ProductDetailProductDescFromJson(Map<String, dynamic> json) {
	final ProductDetailProductDesc productDetailProductDesc = ProductDetailProductDesc();
	final String? descName = jsonConvert.convert<String>(json['descName']);
	if (descName != null) {
		productDetailProductDesc.descName = descName;
	}
	final String? descContent = jsonConvert.convert<String>(json['descContent']);
	if (descContent != null) {
		productDetailProductDesc.descContent = descContent;
	}
	return productDetailProductDesc;
}

Map<String, dynamic> $ProductDetailProductDescToJson(ProductDetailProductDesc entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['descName'] = entity.descName;
	data['descContent'] = entity.descContent;
	return data;
}

ProductDetailProductTipsInfo $ProductDetailProductTipsInfoFromJson(Map<String, dynamic> json) {
	final ProductDetailProductTipsInfo productDetailProductTipsInfo = ProductDetailProductTipsInfo();
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		productDetailProductTipsInfo.content = content;
	}
	return productDetailProductTipsInfo;
}

Map<String, dynamic> $ProductDetailProductTipsInfoToJson(ProductDetailProductTipsInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['content'] = entity.content;
	return data;
}