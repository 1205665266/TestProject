import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/special_activity_limit.dart';

import 'package:cotti_client/pages/tabs/menu/entity/special_price_activity.dart';


SkuEntity $SkuEntityFromJson(Map<String, dynamic> json) {
	final SkuEntity skuEntity = SkuEntity();
	final int? quantity = jsonConvert.convert<int>(json['quantity']);
	if (quantity != null) {
		skuEntity.quantity = quantity;
	}
	final bool? saleOut = jsonConvert.convert<bool>(json['saleOut']);
	if (saleOut != null) {
		skuEntity.saleOut = saleOut;
	}
	final int? noSale = jsonConvert.convert<int>(json['noSale']);
	if (noSale != null) {
		skuEntity.noSale = noSale;
	}
	final String? noSaleMsg = jsonConvert.convert<String>(json['noSaleMsg']);
	if (noSaleMsg != null) {
		skuEntity.noSaleMsg = noSaleMsg;
	}
	final String? skuNo = jsonConvert.convert<String>(json['skuNo']);
	if (skuNo != null) {
		skuEntity.skuNo = skuNo;
	}
	final String? skuName = jsonConvert.convert<String>(json['skuName']);
	if (skuName != null) {
		skuEntity.skuName = skuName;
	}
	final String? skuShowName = jsonConvert.convert<String>(json['skuShowName']);
	if (skuShowName != null) {
		skuEntity.skuShowName = skuShowName;
	}
	final int? activityPrice = jsonConvert.convert<int>(json['activityPrice']);
	if (activityPrice != null) {
		skuEntity.activityPrice = activityPrice;
	}
	final int? sellPrice = jsonConvert.convert<int>(json['sellPrice']);
	if (sellPrice != null) {
		skuEntity.sellPrice = sellPrice;
	}
	final int? standardPrice = jsonConvert.convert<int>(json['standardPrice']);
	if (standardPrice != null) {
		skuEntity.standardPrice = standardPrice;
	}
	final List<SkuSpec>? skusSpecs = jsonConvert.convertListNotNull<SkuSpec>(json['skusSpecs']);
	if (skusSpecs != null) {
		skuEntity.skusSpecs = skusSpecs;
	}
	final SpecialPriceActivity? specialPriceActivity = jsonConvert.convert<SpecialPriceActivity>(json['specialPriceActivity']);
	if (specialPriceActivity != null) {
		skuEntity.specialPriceActivity = specialPriceActivity;
	}
	final String? sellPriceStr = jsonConvert.convert<String>(json['sellPriceStr']);
	if (sellPriceStr != null) {
		skuEntity.sellPriceStr = sellPriceStr;
	}
	final String? standardPriceStr = jsonConvert.convert<String>(json['standardPriceStr']);
	if (standardPriceStr != null) {
		skuEntity.standardPriceStr = standardPriceStr;
	}
	final String? activityPriceStr = jsonConvert.convert<String>(json['activityPriceStr']);
	if (activityPriceStr != null) {
		skuEntity.activityPriceStr = activityPriceStr;
	}
	final int? defaultSku = jsonConvert.convert<int>(json['defaultSku']);
	if (defaultSku != null) {
		skuEntity.defaultSku = defaultSku;
	}
	final int? lowestPrice = jsonConvert.convert<int>(json['lowestPrice']);
	if (lowestPrice != null) {
		skuEntity.lowestPrice = lowestPrice;
	}
	final String? lowestPriceStr = jsonConvert.convert<String>(json['lowestPriceStr']);
	if (lowestPriceStr != null) {
		skuEntity.lowestPriceStr = lowestPriceStr;
	}
	final String? spuShowName = jsonConvert.convert<String>(json['spuShowName']);
	if (spuShowName != null) {
		skuEntity.spuShowName = spuShowName;
	}
	final SpecialActivityLimit? specialActivityLimit = jsonConvert.convert<SpecialActivityLimit>(json['specialActivityLimitDTO']);
	if (specialActivityLimit != null) {
		skuEntity.specialActivityLimit = specialActivityLimit;
	}
	return skuEntity;
}

Map<String, dynamic> $SkuEntityToJson(SkuEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['quantity'] = entity.quantity;
	data['saleOut'] = entity.saleOut;
	data['noSale'] = entity.noSale;
	data['noSaleMsg'] = entity.noSaleMsg;
	data['skuNo'] = entity.skuNo;
	data['skuName'] = entity.skuName;
	data['skuShowName'] = entity.skuShowName;
	data['activityPrice'] = entity.activityPrice;
	data['sellPrice'] = entity.sellPrice;
	data['standardPrice'] = entity.standardPrice;
	data['skusSpecs'] =  entity.skusSpecs?.map((v) => v.toJson()).toList();
	data['specialPriceActivity'] = entity.specialPriceActivity?.toJson();
	data['sellPriceStr'] = entity.sellPriceStr;
	data['standardPriceStr'] = entity.standardPriceStr;
	data['activityPriceStr'] = entity.activityPriceStr;
	data['defaultSku'] = entity.defaultSku;
	data['lowestPrice'] = entity.lowestPrice;
	data['lowestPriceStr'] = entity.lowestPriceStr;
	data['spuShowName'] = entity.spuShowName;
	data['specialActivityLimitDTO'] = entity.specialActivityLimit?.toJson();
	return data;
}

SkuSpec $SkuSpecFromJson(Map<String, dynamic> json) {
	final SkuSpec skuSpec = SkuSpec();
	final String? specItemValue = jsonConvert.convert<String>(json['specItemValue']);
	if (specItemValue != null) {
		skuSpec.specItemValue = specItemValue;
	}
	final String? specItemValueName = jsonConvert.convert<String>(json['specItemValueName']);
	if (specItemValueName != null) {
		skuSpec.specItemValueName = specItemValueName;
	}
	final String? specItemNo = jsonConvert.convert<String>(json['specItemNo']);
	if (specItemNo != null) {
		skuSpec.specItemNo = specItemNo;
	}
	final String? specItemName = jsonConvert.convert<String>(json['specItemName']);
	if (specItemName != null) {
		skuSpec.specItemName = specItemName;
	}
	return skuSpec;
}

Map<String, dynamic> $SkuSpecToJson(SkuSpec entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['specItemValue'] = entity.specItemValue;
	data['specItemValueName'] = entity.specItemValueName;
	data['specItemNo'] = entity.specItemNo;
	data['specItemName'] = entity.specItemName;
	return data;
}