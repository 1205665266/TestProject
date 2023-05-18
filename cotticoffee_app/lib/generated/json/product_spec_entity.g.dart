import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/product/entity/product_spec_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';

import 'package:cotti_client/pages/tabs/menu/entity/special_activity_limit.dart';

import 'package:cotti_client/pages/tabs/menu/entity/special_price_activity.dart';


ProductSpecEntity $ProductSpecEntityFromJson(Map<String, dynamic> json) {
	final ProductSpecEntity productSpecEntity = ProductSpecEntity();
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		productSpecEntity.title = title;
	}
	final int? itemId = jsonConvert.convert<int>(json['itemId']);
	if (itemId != null) {
		productSpecEntity.itemId = itemId;
	}
	final String? itemNo = jsonConvert.convert<String>(json['itemNo']);
	if (itemNo != null) {
		productSpecEntity.itemNo = itemNo;
	}
	final String? itemShowName = jsonConvert.convert<String>(json['itemShowName']);
	if (itemShowName != null) {
		productSpecEntity.itemShowName = itemShowName;
	}
	final int? skuOnlineCount = jsonConvert.convert<int>(json['skuOnlineCount']);
	if (skuOnlineCount != null) {
		productSpecEntity.skuOnlineCount = skuOnlineCount;
	}
	final dynamic skuList = jsonConvert.convert<dynamic>(json['skuList']);
	if (skuList != null) {
		productSpecEntity.skuList = skuList;
	}
	final List<ProductSpecSpecItems>? specItems = jsonConvert.convertListNotNull<ProductSpecSpecItems>(json['specItems']);
	if (specItems != null) {
		productSpecEntity.specItems = specItems;
	}
	final String? litimgUrl = jsonConvert.convert<String>(json['litimgUrl']);
	if (litimgUrl != null) {
		productSpecEntity.litimgUrl = litimgUrl;
	}
	final String? detailImgUrl = jsonConvert.convert<String>(json['detailImgUrl']);
	if (detailImgUrl != null) {
		productSpecEntity.detailImgUrl = detailImgUrl;
	}
	final dynamic itemNetWeight = jsonConvert.convert<dynamic>(json['itemNetWeight']);
	if (itemNetWeight != null) {
		productSpecEntity.itemNetWeight = itemNetWeight;
	}
	final dynamic capacity = jsonConvert.convert<dynamic>(json['capacity']);
	if (capacity != null) {
		productSpecEntity.capacity = capacity;
	}
	final String? itemScore = jsonConvert.convert<String>(json['itemScore']);
	if (itemScore != null) {
		productSpecEntity.itemScore = itemScore;
	}
	final dynamic itemSpicyValue = jsonConvert.convert<dynamic>(json['itemSpicyValue']);
	if (itemSpicyValue != null) {
		productSpecEntity.itemSpicyValue = itemSpicyValue;
	}
	final dynamic itemLabel = jsonConvert.convert<dynamic>(json['itemLabel']);
	if (itemLabel != null) {
		productSpecEntity.itemLabel = itemLabel;
	}
	final dynamic methodName = jsonConvert.convert<dynamic>(json['methodName']);
	if (methodName != null) {
		productSpecEntity.methodName = methodName;
	}
	final dynamic itemCateName = jsonConvert.convert<dynamic>(json['itemCateName']);
	if (itemCateName != null) {
		productSpecEntity.itemCateName = itemCateName;
	}
	final dynamic itemCateValue = jsonConvert.convert<dynamic>(json['itemCateValue']);
	if (itemCateValue != null) {
		productSpecEntity.itemCateValue = itemCateValue;
	}
	final dynamic businessTypes = jsonConvert.convert<dynamic>(json['businessTypes']);
	if (businessTypes != null) {
		productSpecEntity.businessTypes = businessTypes;
	}
	final String? prodCategoryCode = jsonConvert.convert<String>(json['prodCategoryCode']);
	if (prodCategoryCode != null) {
		productSpecEntity.prodCategoryCode = prodCategoryCode;
	}
	final dynamic placeOfOrigin = jsonConvert.convert<dynamic>(json['placeOfOrigin']);
	if (placeOfOrigin != null) {
		productSpecEntity.placeOfOrigin = placeOfOrigin;
	}
	final dynamic workmanship = jsonConvert.convert<dynamic>(json['workmanship']);
	if (workmanship != null) {
		productSpecEntity.workmanship = workmanship;
	}
	final dynamic flavor = jsonConvert.convert<dynamic>(json['flavor']);
	if (flavor != null) {
		productSpecEntity.flavor = flavor;
	}
	final dynamic packageTypeCodes = jsonConvert.convert<dynamic>(json['packageTypeCodes']);
	if (packageTypeCodes != null) {
		productSpecEntity.packageTypeCodes = packageTypeCodes;
	}
	final dynamic productSort = jsonConvert.convert<dynamic>(json['productSort']);
	if (productSort != null) {
		productSpecEntity.productSort = productSort;
	}
	final int? taxClassId = jsonConvert.convert<int>(json['taxClassId']);
	if (taxClassId != null) {
		productSpecEntity.taxClassId = taxClassId;
	}
	final String? essentials = jsonConvert.convert<String>(json['essentials']);
	if (essentials != null) {
		productSpecEntity.essentials = essentials;
	}
	final dynamic rank = jsonConvert.convert<dynamic>(json['rank']);
	if (rank != null) {
		productSpecEntity.rank = rank;
	}
	final String? sellingPoints = jsonConvert.convert<String>(json['sellingPoints']);
	if (sellingPoints != null) {
		productSpecEntity.sellingPoints = sellingPoints;
	}
	final dynamic marketingLabel = jsonConvert.convert<dynamic>(json['marketingLabel']);
	if (marketingLabel != null) {
		productSpecEntity.marketingLabel = marketingLabel;
	}
	final int? makeType = jsonConvert.convert<int>(json['makeType']);
	if (makeType != null) {
		productSpecEntity.makeType = makeType;
	}
	final List<ProductSpecProductDesc>? productDesc = jsonConvert.convertListNotNull<ProductSpecProductDesc>(json['productDesc']);
	if (productDesc != null) {
		productSpecEntity.productDesc = productDesc;
	}
	final ProductSpecProductTipsInfo? productTipsInfo = jsonConvert.convert<ProductSpecProductTipsInfo>(json['productTipsInfo']);
	if (productTipsInfo != null) {
		productSpecEntity.productTipsInfo = productTipsInfo;
	}
	final int? quantityCount = jsonConvert.convert<int>(json['quantityCount']);
	if (quantityCount != null) {
		productSpecEntity.quantityCount = quantityCount;
	}
	final int? skuNum = jsonConvert.convert<int>(json['skuNum']);
	if (skuNum != null) {
		productSpecEntity.skuNum = skuNum;
	}
	final bool? skuSamePrice = jsonConvert.convert<bool>(json['skuSamePrice']);
	if (skuSamePrice != null) {
		productSpecEntity.skuSamePrice = skuSamePrice;
	}
	final List<ProductSpecSkuCombinList>? skuCombinList = jsonConvert.convertListNotNull<ProductSpecSkuCombinList>(json['skuCombinList']);
	if (skuCombinList != null) {
		productSpecEntity.skuCombinList = skuCombinList;
	}
	final int? skuAllSaleOut = jsonConvert.convert<int>(json['skuAllSaleOut']);
	if (skuAllSaleOut != null) {
		productSpecEntity.skuAllSaleOut = skuAllSaleOut;
	}
	final SkuEntity? firstSku = jsonConvert.convert<SkuEntity>(json['firstSku']);
	if (firstSku != null) {
		productSpecEntity.firstSku = firstSku;
	}
	final int? lowestPrice = jsonConvert.convert<int>(json['lowestPrice']);
	if (lowestPrice != null) {
		productSpecEntity.lowestPrice = lowestPrice;
	}
	final dynamic firstActivitySku = jsonConvert.convert<dynamic>(json['firstActivitySku']);
	if (firstActivitySku != null) {
		productSpecEntity.firstActivitySku = firstActivitySku;
	}
	final int? nowTime = jsonConvert.convert<int>(json['nowTime']);
	if (nowTime != null) {
		productSpecEntity.nowTime = nowTime;
	}
	final int? skuNumNew = jsonConvert.convert<int>(json['skuNumNew']);
	if (skuNumNew != null) {
		productSpecEntity.skuNumNew = skuNumNew;
	}
	final dynamic firstSkuFlag = jsonConvert.convert<dynamic>(json['firstSkuFlag']);
	if (firstSkuFlag != null) {
		productSpecEntity.firstSkuFlag = firstSkuFlag;
	}
	final ProductSpecCustomMarketingLabel? customMarketingLabel = jsonConvert.convert<ProductSpecCustomMarketingLabel>(json['customMarketingLabel']);
	if (customMarketingLabel != null) {
		productSpecEntity.customMarketingLabel = customMarketingLabel;
	}
	return productSpecEntity;
}

Map<String, dynamic> $ProductSpecEntityToJson(ProductSpecEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['title'] = entity.title;
	data['itemId'] = entity.itemId;
	data['itemNo'] = entity.itemNo;
	data['itemShowName'] = entity.itemShowName;
	data['skuOnlineCount'] = entity.skuOnlineCount;
	data['skuList'] = entity.skuList;
	data['specItems'] =  entity.specItems?.map((v) => v.toJson()).toList();
	data['litimgUrl'] = entity.litimgUrl;
	data['detailImgUrl'] = entity.detailImgUrl;
	data['itemNetWeight'] = entity.itemNetWeight;
	data['capacity'] = entity.capacity;
	data['itemScore'] = entity.itemScore;
	data['itemSpicyValue'] = entity.itemSpicyValue;
	data['itemLabel'] = entity.itemLabel;
	data['methodName'] = entity.methodName;
	data['itemCateName'] = entity.itemCateName;
	data['itemCateValue'] = entity.itemCateValue;
	data['businessTypes'] = entity.businessTypes;
	data['prodCategoryCode'] = entity.prodCategoryCode;
	data['placeOfOrigin'] = entity.placeOfOrigin;
	data['workmanship'] = entity.workmanship;
	data['flavor'] = entity.flavor;
	data['packageTypeCodes'] = entity.packageTypeCodes;
	data['productSort'] = entity.productSort;
	data['taxClassId'] = entity.taxClassId;
	data['essentials'] = entity.essentials;
	data['rank'] = entity.rank;
	data['sellingPoints'] = entity.sellingPoints;
	data['marketingLabel'] = entity.marketingLabel;
	data['makeType'] = entity.makeType;
	data['productDesc'] =  entity.productDesc?.map((v) => v.toJson()).toList();
	data['productTipsInfo'] = entity.productTipsInfo?.toJson();
	data['quantityCount'] = entity.quantityCount;
	data['skuNum'] = entity.skuNum;
	data['skuSamePrice'] = entity.skuSamePrice;
	data['skuCombinList'] =  entity.skuCombinList?.map((v) => v.toJson()).toList();
	data['skuAllSaleOut'] = entity.skuAllSaleOut;
	data['firstSku'] = entity.firstSku?.toJson();
	data['lowestPrice'] = entity.lowestPrice;
	data['firstActivitySku'] = entity.firstActivitySku;
	data['nowTime'] = entity.nowTime;
	data['skuNumNew'] = entity.skuNumNew;
	data['firstSkuFlag'] = entity.firstSkuFlag;
	data['customMarketingLabel'] = entity.customMarketingLabel?.toJson();
	return data;
}

ProductSpecSpecItems $ProductSpecSpecItemsFromJson(Map<String, dynamic> json) {
	final ProductSpecSpecItems productSpecSpecItems = ProductSpecSpecItems();
	final String? specItemNo = jsonConvert.convert<String>(json['specItemNo']);
	if (specItemNo != null) {
		productSpecSpecItems.specItemNo = specItemNo;
	}
	final String? specItemName = jsonConvert.convert<String>(json['specItemName']);
	if (specItemName != null) {
		productSpecSpecItems.specItemName = specItemName;
	}
	final List<ProductSpecSpecItemsSpecValueList>? specValueList = jsonConvert.convertListNotNull<ProductSpecSpecItemsSpecValueList>(json['specValueList']);
	if (specValueList != null) {
		productSpecSpecItems.specValueList = specValueList;
	}
	return productSpecSpecItems;
}

Map<String, dynamic> $ProductSpecSpecItemsToJson(ProductSpecSpecItems entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['specItemNo'] = entity.specItemNo;
	data['specItemName'] = entity.specItemName;
	data['specValueList'] =  entity.specValueList?.map((v) => v.toJson()).toList();
	return data;
}

ProductSpecSpecItemsSpecValueList $ProductSpecSpecItemsSpecValueListFromJson(Map<String, dynamic> json) {
	final ProductSpecSpecItemsSpecValueList productSpecSpecItemsSpecValueList = ProductSpecSpecItemsSpecValueList();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		productSpecSpecItemsSpecValueList.name = name;
	}
	final String? value = jsonConvert.convert<String>(json['value']);
	if (value != null) {
		productSpecSpecItemsSpecValueList.value = value;
	}
	final bool? selected = jsonConvert.convert<bool>(json['selected']);
	if (selected != null) {
		productSpecSpecItemsSpecValueList.selected = selected;
	}
	final int? recommendFlag = jsonConvert.convert<int>(json['recommendFlag']);
	if (recommendFlag != null) {
		productSpecSpecItemsSpecValueList.recommendFlag = recommendFlag;
	}
	return productSpecSpecItemsSpecValueList;
}

Map<String, dynamic> $ProductSpecSpecItemsSpecValueListToJson(ProductSpecSpecItemsSpecValueList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['value'] = entity.value;
	data['selected'] = entity.selected;
	data['recommendFlag'] = entity.recommendFlag;
	return data;
}

ProductSpecProductDesc $ProductSpecProductDescFromJson(Map<String, dynamic> json) {
	final ProductSpecProductDesc productSpecProductDesc = ProductSpecProductDesc();
	final String? descName = jsonConvert.convert<String>(json['descName']);
	if (descName != null) {
		productSpecProductDesc.descName = descName;
	}
	final String? descContent = jsonConvert.convert<String>(json['descContent']);
	if (descContent != null) {
		productSpecProductDesc.descContent = descContent;
	}
	return productSpecProductDesc;
}

Map<String, dynamic> $ProductSpecProductDescToJson(ProductSpecProductDesc entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['descName'] = entity.descName;
	data['descContent'] = entity.descContent;
	return data;
}

ProductSpecProductTipsInfo $ProductSpecProductTipsInfoFromJson(Map<String, dynamic> json) {
	final ProductSpecProductTipsInfo productSpecProductTipsInfo = ProductSpecProductTipsInfo();
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		productSpecProductTipsInfo.content = content;
	}
	return productSpecProductTipsInfo;
}

Map<String, dynamic> $ProductSpecProductTipsInfoToJson(ProductSpecProductTipsInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['content'] = entity.content;
	return data;
}

ProductSpecSkuCombinList $ProductSpecSkuCombinListFromJson(Map<String, dynamic> json) {
	final ProductSpecSkuCombinList productSpecSkuCombinList = ProductSpecSkuCombinList();
	final int? quantity = jsonConvert.convert<int>(json['quantity']);
	if (quantity != null) {
		productSpecSkuCombinList.quantity = quantity;
	}
	final int? haltSale = jsonConvert.convert<int>(json['haltSale']);
	if (haltSale != null) {
		productSpecSkuCombinList.haltSale = haltSale;
	}
	final int? noSale = jsonConvert.convert<int>(json['noSale']);
	if (noSale != null) {
		productSpecSkuCombinList.noSale = noSale;
	}
	final int? noSaleType = jsonConvert.convert<int>(json['noSaleType']);
	if (noSaleType != null) {
		productSpecSkuCombinList.noSaleType = noSaleType;
	}
	final String? noSaleMsg = jsonConvert.convert<String>(json['noSaleMsg']);
	if (noSaleMsg != null) {
		productSpecSkuCombinList.noSaleMsg = noSaleMsg;
	}
	final dynamic skuId = jsonConvert.convert<dynamic>(json['skuId']);
	if (skuId != null) {
		productSpecSkuCombinList.skuId = skuId;
	}
	final String? skuNo = jsonConvert.convert<String>(json['skuNo']);
	if (skuNo != null) {
		productSpecSkuCombinList.skuNo = skuNo;
	}
	final String? skuBarcode = jsonConvert.convert<String>(json['skuBarcode']);
	if (skuBarcode != null) {
		productSpecSkuCombinList.skuBarcode = skuBarcode;
	}
	final List<ProductSpecSkuCombinListSkusSpecs>? skusSpecs = jsonConvert.convertListNotNull<ProductSpecSkuCombinListSkusSpecs>(json['skusSpecs']);
	if (skusSpecs != null) {
		productSpecSkuCombinList.skusSpecs = skusSpecs;
	}
	final String? skuName = jsonConvert.convert<String>(json['skuName']);
	if (skuName != null) {
		productSpecSkuCombinList.skuName = skuName;
	}
	final String? skuShowName = jsonConvert.convert<String>(json['skuShowName']);
	if (skuShowName != null) {
		productSpecSkuCombinList.skuShowName = skuShowName;
	}
	final dynamic activityPrice = jsonConvert.convert<dynamic>(json['activityPrice']);
	if (activityPrice != null) {
		productSpecSkuCombinList.activityPrice = activityPrice;
	}
	final int? sellPrice = jsonConvert.convert<int>(json['sellPrice']);
	if (sellPrice != null) {
		productSpecSkuCombinList.sellPrice = sellPrice;
	}
	final int? standardPrice = jsonConvert.convert<int>(json['standardPrice']);
	if (standardPrice != null) {
		productSpecSkuCombinList.standardPrice = standardPrice;
	}
	final SpecialPriceActivity? specialPriceActivity = jsonConvert.convert<SpecialPriceActivity>(json['specialPriceActivity']);
	if (specialPriceActivity != null) {
		productSpecSkuCombinList.specialPriceActivity = specialPriceActivity;
	}
	final int? defaultSku = jsonConvert.convert<int>(json['defaultSku']);
	if (defaultSku != null) {
		productSpecSkuCombinList.defaultSku = defaultSku;
	}
	final String? qrCodeUrl = jsonConvert.convert<String>(json['qrCodeUrl']);
	if (qrCodeUrl != null) {
		productSpecSkuCombinList.qrCodeUrl = qrCodeUrl;
	}
	final List<ProductSpecSkuCombinListBusinessTypes>? businessTypes = jsonConvert.convertListNotNull<ProductSpecSkuCombinListBusinessTypes>(json['businessTypes']);
	if (businessTypes != null) {
		productSpecSkuCombinList.businessTypes = businessTypes;
	}
	final int? tagPrintStatus = jsonConvert.convert<int>(json['tagPrintStatus']);
	if (tagPrintStatus != null) {
		productSpecSkuCombinList.tagPrintStatus = tagPrintStatus;
	}
	final int? lowestPrice = jsonConvert.convert<int>(json['lowestPrice']);
	if (lowestPrice != null) {
		productSpecSkuCombinList.lowestPrice = lowestPrice;
	}
	final bool? saleOut = jsonConvert.convert<bool>(json['saleOut']);
	if (saleOut != null) {
		productSpecSkuCombinList.saleOut = saleOut;
	}
	final dynamic activityPriceStr = jsonConvert.convert<dynamic>(json['activityPriceStr']);
	if (activityPriceStr != null) {
		productSpecSkuCombinList.activityPriceStr = activityPriceStr;
	}
	final String? sellPriceStr = jsonConvert.convert<String>(json['sellPriceStr']);
	if (sellPriceStr != null) {
		productSpecSkuCombinList.sellPriceStr = sellPriceStr;
	}
	final String? standardPriceStr = jsonConvert.convert<String>(json['standardPriceStr']);
	if (standardPriceStr != null) {
		productSpecSkuCombinList.standardPriceStr = standardPriceStr;
	}
	final String? lowestPriceStr = jsonConvert.convert<String>(json['lowestPriceStr']);
	if (lowestPriceStr != null) {
		productSpecSkuCombinList.lowestPriceStr = lowestPriceStr;
	}
	final SpecialActivityLimit? specialActivityLimitDTO = jsonConvert.convert<SpecialActivityLimit>(json['specialActivityLimitDTO']);
	if (specialActivityLimitDTO != null) {
		productSpecSkuCombinList.specialActivityLimitDTO = specialActivityLimitDTO;
	}
	final int? tempSortId = jsonConvert.convert<int>(json['tempSortId']);
	if (tempSortId != null) {
		productSpecSkuCombinList.tempSortId = tempSortId;
	}
	final dynamic memberLimitNum = jsonConvert.convert<dynamic>(json['memberLimitNum']);
	if (memberLimitNum != null) {
		productSpecSkuCombinList.memberLimitNum = memberLimitNum;
	}
	final dynamic shopLimitNum = jsonConvert.convert<dynamic>(json['shopLimitNum']);
	if (shopLimitNum != null) {
		productSpecSkuCombinList.shopLimitNum = shopLimitNum;
	}
	final dynamic oncePrice = jsonConvert.convert<dynamic>(json['oncePrice']);
	if (oncePrice != null) {
		productSpecSkuCombinList.oncePrice = oncePrice;
	}
	final dynamic oncePriceStr = jsonConvert.convert<dynamic>(json['oncePriceStr']);
	if (oncePriceStr != null) {
		productSpecSkuCombinList.oncePriceStr = oncePriceStr;
	}
	final dynamic oncePriceDetailStr = jsonConvert.convert<dynamic>(json['oncePriceDetailStr']);
	if (oncePriceDetailStr != null) {
		productSpecSkuCombinList.oncePriceDetailStr = oncePriceDetailStr;
	}
	final bool? displayOncePrice = jsonConvert.convert<bool>(json['displayOncePrice']);
	if (displayOncePrice != null) {
		productSpecSkuCombinList.displayOncePrice = displayOncePrice;
	}
	final String? spuShowName = jsonConvert.convert<String>(json['spuShowName']);
	if (spuShowName != null) {
		productSpecSkuCombinList.spuShowName = spuShowName;
	}
	return productSpecSkuCombinList;
}

Map<String, dynamic> $ProductSpecSkuCombinListToJson(ProductSpecSkuCombinList entity) {
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
	data['specialPriceActivity'] = entity.specialPriceActivity?.toJson();
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
	data['specialActivityLimitDTO'] = entity.specialActivityLimitDTO?.toJson();
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

ProductSpecSkuCombinListSkusSpecs $ProductSpecSkuCombinListSkusSpecsFromJson(Map<String, dynamic> json) {
	final ProductSpecSkuCombinListSkusSpecs productSpecSkuCombinListSkusSpecs = ProductSpecSkuCombinListSkusSpecs();
	final String? specItemValue = jsonConvert.convert<String>(json['specItemValue']);
	if (specItemValue != null) {
		productSpecSkuCombinListSkusSpecs.specItemValue = specItemValue;
	}
	final String? specItemValueName = jsonConvert.convert<String>(json['specItemValueName']);
	if (specItemValueName != null) {
		productSpecSkuCombinListSkusSpecs.specItemValueName = specItemValueName;
	}
	final String? specItemNo = jsonConvert.convert<String>(json['specItemNo']);
	if (specItemNo != null) {
		productSpecSkuCombinListSkusSpecs.specItemNo = specItemNo;
	}
	final String? specItemName = jsonConvert.convert<String>(json['specItemName']);
	if (specItemName != null) {
		productSpecSkuCombinListSkusSpecs.specItemName = specItemName;
	}
	return productSpecSkuCombinListSkusSpecs;
}

Map<String, dynamic> $ProductSpecSkuCombinListSkusSpecsToJson(ProductSpecSkuCombinListSkusSpecs entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['specItemValue'] = entity.specItemValue;
	data['specItemValueName'] = entity.specItemValueName;
	data['specItemNo'] = entity.specItemNo;
	data['specItemName'] = entity.specItemName;
	return data;
}

ProductSpecSkuCombinListBusinessTypes $ProductSpecSkuCombinListBusinessTypesFromJson(Map<String, dynamic> json) {
	final ProductSpecSkuCombinListBusinessTypes productSpecSkuCombinListBusinessTypes = ProductSpecSkuCombinListBusinessTypes();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		productSpecSkuCombinListBusinessTypes.name = name;
	}
	final int? value = jsonConvert.convert<int>(json['value']);
	if (value != null) {
		productSpecSkuCombinListBusinessTypes.value = value;
	}
	return productSpecSkuCombinListBusinessTypes;
}

Map<String, dynamic> $ProductSpecSkuCombinListBusinessTypesToJson(ProductSpecSkuCombinListBusinessTypes entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['value'] = entity.value;
	return data;
}

ProductSpecFirstSku $ProductSpecFirstSkuFromJson(Map<String, dynamic> json) {
	final ProductSpecFirstSku productSpecFirstSku = ProductSpecFirstSku();
	final int? quantity = jsonConvert.convert<int>(json['quantity']);
	if (quantity != null) {
		productSpecFirstSku.quantity = quantity;
	}
	final int? haltSale = jsonConvert.convert<int>(json['haltSale']);
	if (haltSale != null) {
		productSpecFirstSku.haltSale = haltSale;
	}
	final int? noSale = jsonConvert.convert<int>(json['noSale']);
	if (noSale != null) {
		productSpecFirstSku.noSale = noSale;
	}
	final dynamic noSaleType = jsonConvert.convert<dynamic>(json['noSaleType']);
	if (noSaleType != null) {
		productSpecFirstSku.noSaleType = noSaleType;
	}
	final dynamic noSaleMsg = jsonConvert.convert<dynamic>(json['noSaleMsg']);
	if (noSaleMsg != null) {
		productSpecFirstSku.noSaleMsg = noSaleMsg;
	}
	final dynamic skuId = jsonConvert.convert<dynamic>(json['skuId']);
	if (skuId != null) {
		productSpecFirstSku.skuId = skuId;
	}
	final String? skuNo = jsonConvert.convert<String>(json['skuNo']);
	if (skuNo != null) {
		productSpecFirstSku.skuNo = skuNo;
	}
	final String? skuBarcode = jsonConvert.convert<String>(json['skuBarcode']);
	if (skuBarcode != null) {
		productSpecFirstSku.skuBarcode = skuBarcode;
	}
	final List<ProductSpecFirstSkuSkusSpecs>? skusSpecs = jsonConvert.convertListNotNull<ProductSpecFirstSkuSkusSpecs>(json['skusSpecs']);
	if (skusSpecs != null) {
		productSpecFirstSku.skusSpecs = skusSpecs;
	}
	final String? skuName = jsonConvert.convert<String>(json['skuName']);
	if (skuName != null) {
		productSpecFirstSku.skuName = skuName;
	}
	final String? skuShowName = jsonConvert.convert<String>(json['skuShowName']);
	if (skuShowName != null) {
		productSpecFirstSku.skuShowName = skuShowName;
	}
	final dynamic activityPrice = jsonConvert.convert<dynamic>(json['activityPrice']);
	if (activityPrice != null) {
		productSpecFirstSku.activityPrice = activityPrice;
	}
	final int? sellPrice = jsonConvert.convert<int>(json['sellPrice']);
	if (sellPrice != null) {
		productSpecFirstSku.sellPrice = sellPrice;
	}
	final int? standardPrice = jsonConvert.convert<int>(json['standardPrice']);
	if (standardPrice != null) {
		productSpecFirstSku.standardPrice = standardPrice;
	}
	final dynamic specialPriceActivity = jsonConvert.convert<dynamic>(json['specialPriceActivity']);
	if (specialPriceActivity != null) {
		productSpecFirstSku.specialPriceActivity = specialPriceActivity;
	}
	final int? defaultSku = jsonConvert.convert<int>(json['defaultSku']);
	if (defaultSku != null) {
		productSpecFirstSku.defaultSku = defaultSku;
	}
	final String? qrCodeUrl = jsonConvert.convert<String>(json['qrCodeUrl']);
	if (qrCodeUrl != null) {
		productSpecFirstSku.qrCodeUrl = qrCodeUrl;
	}
	final List<ProductSpecFirstSkuBusinessTypes>? businessTypes = jsonConvert.convertListNotNull<ProductSpecFirstSkuBusinessTypes>(json['businessTypes']);
	if (businessTypes != null) {
		productSpecFirstSku.businessTypes = businessTypes;
	}
	final int? tagPrintStatus = jsonConvert.convert<int>(json['tagPrintStatus']);
	if (tagPrintStatus != null) {
		productSpecFirstSku.tagPrintStatus = tagPrintStatus;
	}
	final int? lowestPrice = jsonConvert.convert<int>(json['lowestPrice']);
	if (lowestPrice != null) {
		productSpecFirstSku.lowestPrice = lowestPrice;
	}
	final bool? saleOut = jsonConvert.convert<bool>(json['saleOut']);
	if (saleOut != null) {
		productSpecFirstSku.saleOut = saleOut;
	}
	final dynamic activityPriceStr = jsonConvert.convert<dynamic>(json['activityPriceStr']);
	if (activityPriceStr != null) {
		productSpecFirstSku.activityPriceStr = activityPriceStr;
	}
	final String? sellPriceStr = jsonConvert.convert<String>(json['sellPriceStr']);
	if (sellPriceStr != null) {
		productSpecFirstSku.sellPriceStr = sellPriceStr;
	}
	final String? standardPriceStr = jsonConvert.convert<String>(json['standardPriceStr']);
	if (standardPriceStr != null) {
		productSpecFirstSku.standardPriceStr = standardPriceStr;
	}
	final String? lowestPriceStr = jsonConvert.convert<String>(json['lowestPriceStr']);
	if (lowestPriceStr != null) {
		productSpecFirstSku.lowestPriceStr = lowestPriceStr;
	}
	final dynamic specialActivityLimitDTO = jsonConvert.convert<dynamic>(json['specialActivityLimitDTO']);
	if (specialActivityLimitDTO != null) {
		productSpecFirstSku.specialActivityLimitDTO = specialActivityLimitDTO;
	}
	final int? tempSortId = jsonConvert.convert<int>(json['tempSortId']);
	if (tempSortId != null) {
		productSpecFirstSku.tempSortId = tempSortId;
	}
	final dynamic memberLimitNum = jsonConvert.convert<dynamic>(json['memberLimitNum']);
	if (memberLimitNum != null) {
		productSpecFirstSku.memberLimitNum = memberLimitNum;
	}
	final dynamic shopLimitNum = jsonConvert.convert<dynamic>(json['shopLimitNum']);
	if (shopLimitNum != null) {
		productSpecFirstSku.shopLimitNum = shopLimitNum;
	}
	final dynamic oncePrice = jsonConvert.convert<dynamic>(json['oncePrice']);
	if (oncePrice != null) {
		productSpecFirstSku.oncePrice = oncePrice;
	}
	final dynamic oncePriceStr = jsonConvert.convert<dynamic>(json['oncePriceStr']);
	if (oncePriceStr != null) {
		productSpecFirstSku.oncePriceStr = oncePriceStr;
	}
	final dynamic oncePriceDetailStr = jsonConvert.convert<dynamic>(json['oncePriceDetailStr']);
	if (oncePriceDetailStr != null) {
		productSpecFirstSku.oncePriceDetailStr = oncePriceDetailStr;
	}
	final bool? displayOncePrice = jsonConvert.convert<bool>(json['displayOncePrice']);
	if (displayOncePrice != null) {
		productSpecFirstSku.displayOncePrice = displayOncePrice;
	}
	final String? spuShowName = jsonConvert.convert<String>(json['spuShowName']);
	if (spuShowName != null) {
		productSpecFirstSku.spuShowName = spuShowName;
	}
	return productSpecFirstSku;
}

Map<String, dynamic> $ProductSpecFirstSkuToJson(ProductSpecFirstSku entity) {
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

ProductSpecFirstSkuSkusSpecs $ProductSpecFirstSkuSkusSpecsFromJson(Map<String, dynamic> json) {
	final ProductSpecFirstSkuSkusSpecs productSpecFirstSkuSkusSpecs = ProductSpecFirstSkuSkusSpecs();
	final String? specItemValue = jsonConvert.convert<String>(json['specItemValue']);
	if (specItemValue != null) {
		productSpecFirstSkuSkusSpecs.specItemValue = specItemValue;
	}
	final String? specItemValueName = jsonConvert.convert<String>(json['specItemValueName']);
	if (specItemValueName != null) {
		productSpecFirstSkuSkusSpecs.specItemValueName = specItemValueName;
	}
	final String? specItemNo = jsonConvert.convert<String>(json['specItemNo']);
	if (specItemNo != null) {
		productSpecFirstSkuSkusSpecs.specItemNo = specItemNo;
	}
	final String? specItemName = jsonConvert.convert<String>(json['specItemName']);
	if (specItemName != null) {
		productSpecFirstSkuSkusSpecs.specItemName = specItemName;
	}
	return productSpecFirstSkuSkusSpecs;
}

Map<String, dynamic> $ProductSpecFirstSkuSkusSpecsToJson(ProductSpecFirstSkuSkusSpecs entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['specItemValue'] = entity.specItemValue;
	data['specItemValueName'] = entity.specItemValueName;
	data['specItemNo'] = entity.specItemNo;
	data['specItemName'] = entity.specItemName;
	return data;
}

ProductSpecFirstSkuBusinessTypes $ProductSpecFirstSkuBusinessTypesFromJson(Map<String, dynamic> json) {
	final ProductSpecFirstSkuBusinessTypes productSpecFirstSkuBusinessTypes = ProductSpecFirstSkuBusinessTypes();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		productSpecFirstSkuBusinessTypes.name = name;
	}
	final int? value = jsonConvert.convert<int>(json['value']);
	if (value != null) {
		productSpecFirstSkuBusinessTypes.value = value;
	}
	return productSpecFirstSkuBusinessTypes;
}

Map<String, dynamic> $ProductSpecFirstSkuBusinessTypesToJson(ProductSpecFirstSkuBusinessTypes entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['value'] = entity.value;
	return data;
}

ProductSpecCustomMarketingLabel $ProductSpecCustomMarketingLabelFromJson(Map<String, dynamic> json) {
	final ProductSpecCustomMarketingLabel productSpecCustomMarketingLabel = ProductSpecCustomMarketingLabel();
	final List<String>? labelList = jsonConvert.convertListNotNull<String>(json['labelList']);
	if (labelList != null) {
		productSpecCustomMarketingLabel.labelList = labelList;
	}
	return productSpecCustomMarketingLabel;
}

Map<String, dynamic> $ProductSpecCustomMarketingLabelToJson(ProductSpecCustomMarketingLabel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['labelList'] =  entity.labelList;
	return data;
}