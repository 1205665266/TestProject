import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/menu/entity/spec_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';


SpecEntity $SpecEntityFromJson(Map<String, dynamic> json) {
	final SpecEntity specEntity = SpecEntity();
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		specEntity.title = title;
	}
	final int? quantityCount = jsonConvert.convert<int>(json['quantityCount']);
	if (quantityCount != null) {
		specEntity.quantityCount = quantityCount;
	}
	final int? lowestPrice = jsonConvert.convert<int>(json['lowestPrice']);
	if (lowestPrice != null) {
		specEntity.lowestPrice = lowestPrice;
	}
	final int? skuNum = jsonConvert.convert<int>(json['skuNum']);
	if (skuNum != null) {
		specEntity.skuNum = skuNum;
	}
	final int? skuAllSaleOut = jsonConvert.convert<int>(json['skuAllSaleOut']);
	if (skuAllSaleOut != null) {
		specEntity.skuAllSaleOut = skuAllSaleOut;
	}
	final String? itemNo = jsonConvert.convert<String>(json['itemNo']);
	if (itemNo != null) {
		specEntity.itemNo = itemNo;
	}
	final String? litimgUrl = jsonConvert.convert<String>(json['litimgUrl']);
	if (litimgUrl != null) {
		specEntity.litimgUrl = litimgUrl;
	}
	final String? itemNetWeight = jsonConvert.convert<String>(json['itemNetWeight']);
	if (itemNetWeight != null) {
		specEntity.itemNetWeight = itemNetWeight;
	}
	final String? minPrice = jsonConvert.convert<String>(json['minPrice']);
	if (minPrice != null) {
		specEntity.minPrice = minPrice;
	}
	final String? lineThroughPrice = jsonConvert.convert<String>(json['lineThroughPrice']);
	if (lineThroughPrice != null) {
		specEntity.lineThroughPrice = lineThroughPrice;
	}
	final int? isDisplay = jsonConvert.convert<int>(json['isDisplay']);
	if (isDisplay != null) {
		specEntity.isDisplay = isDisplay;
	}
	final int? nowTime = jsonConvert.convert<int>(json['nowTime']);
	if (nowTime != null) {
		specEntity.nowTime = nowTime;
	}
	final List<SpecItem>? specItems = jsonConvert.convertListNotNull<SpecItem>(json['specItems']);
	if (specItems != null) {
		specEntity.specItems = specItems;
	}
	final List<SkuEntity>? skuCombinList = jsonConvert.convertListNotNull<SkuEntity>(json['skuCombinList']);
	if (skuCombinList != null) {
		specEntity.skuCombinList = skuCombinList;
	}
	final SkuEntity? firstSku = jsonConvert.convert<SkuEntity>(json['firstSku']);
	if (firstSku != null) {
		specEntity.firstSku = firstSku;
	}
	return specEntity;
}

Map<String, dynamic> $SpecEntityToJson(SpecEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['title'] = entity.title;
	data['quantityCount'] = entity.quantityCount;
	data['lowestPrice'] = entity.lowestPrice;
	data['skuNum'] = entity.skuNum;
	data['skuAllSaleOut'] = entity.skuAllSaleOut;
	data['itemNo'] = entity.itemNo;
	data['litimgUrl'] = entity.litimgUrl;
	data['itemNetWeight'] = entity.itemNetWeight;
	data['minPrice'] = entity.minPrice;
	data['lineThroughPrice'] = entity.lineThroughPrice;
	data['isDisplay'] = entity.isDisplay;
	data['nowTime'] = entity.nowTime;
	data['specItems'] =  entity.specItems?.map((v) => v.toJson()).toList();
	data['skuCombinList'] =  entity.skuCombinList?.map((v) => v.toJson()).toList();
	data['firstSku'] = entity.firstSku?.toJson();
	return data;
}

SpecItem $SpecItemFromJson(Map<String, dynamic> json) {
	final SpecItem specItem = SpecItem();
	final String? specItemNo = jsonConvert.convert<String>(json['specItemNo']);
	if (specItemNo != null) {
		specItem.specItemNo = specItemNo;
	}
	final String? specItemName = jsonConvert.convert<String>(json['specItemName']);
	if (specItemName != null) {
		specItem.specItemName = specItemName;
	}
	final List<SpecValue>? specValueList = jsonConvert.convertListNotNull<SpecValue>(json['specValueList']);
	if (specValueList != null) {
		specItem.specValueList = specValueList;
	}
	return specItem;
}

Map<String, dynamic> $SpecItemToJson(SpecItem entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['specItemNo'] = entity.specItemNo;
	data['specItemName'] = entity.specItemName;
	data['specValueList'] =  entity.specValueList?.map((v) => v.toJson()).toList();
	return data;
}

SpecValue $SpecValueFromJson(Map<String, dynamic> json) {
	final SpecValue specValue = SpecValue();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		specValue.name = name;
	}
	final String? value = jsonConvert.convert<String>(json['value']);
	if (value != null) {
		specValue.value = value;
	}
	return specValue;
}

Map<String, dynamic> $SpecValueToJson(SpecValue entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['value'] = entity.value;
	return data;
}