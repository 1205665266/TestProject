import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_item_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/custom_marketing_label_entity.dart';

import 'package:cotti_client/pages/tabs/menu/entity/marketing_label_entity.dart';

import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';


MenuItemEntity $MenuItemEntityFromJson(Map<String, dynamic> json) {
	final MenuItemEntity menuItemEntity = MenuItemEntity();
	final int? key = jsonConvert.convert<int>(json['key']);
	if (key != null) {
		menuItemEntity.key = key;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		menuItemEntity.title = title;
	}
	final String? itemNo = jsonConvert.convert<String>(json['itemNo']);
	if (itemNo != null) {
		menuItemEntity.itemNo = itemNo;
	}
	final List<SkuEntity>? skuCombinList = jsonConvert.convertListNotNull<SkuEntity>(json['skuCombinList']);
	if (skuCombinList != null) {
		menuItemEntity.skuCombinList = skuCombinList;
	}
	final String? litimgUrl = jsonConvert.convert<String>(json['litimgUrl']);
	if (litimgUrl != null) {
		menuItemEntity.litimgUrl = litimgUrl;
	}
	final String? itemNetWeight = jsonConvert.convert<String>(json['itemNetWeight']);
	if (itemNetWeight != null) {
		menuItemEntity.itemNetWeight = itemNetWeight;
	}
	final String? capacity = jsonConvert.convert<String>(json['capacity']);
	if (capacity != null) {
		menuItemEntity.capacity = capacity;
	}
	final int? itemSpicyValue = jsonConvert.convert<int>(json['itemSpicyValue']);
	if (itemSpicyValue != null) {
		menuItemEntity.itemSpicyValue = itemSpicyValue;
	}
	final String? itemLabel = jsonConvert.convert<String>(json['itemLabel']);
	if (itemLabel != null) {
		menuItemEntity.itemLabel = itemLabel;
	}
	final String? placeOfOrigin = jsonConvert.convert<String>(json['placeOfOrigin']);
	if (placeOfOrigin != null) {
		menuItemEntity.placeOfOrigin = placeOfOrigin;
	}
	final String? workmanship = jsonConvert.convert<String>(json['workmanship']);
	if (workmanship != null) {
		menuItemEntity.workmanship = workmanship;
	}
	final String? flavor = jsonConvert.convert<String>(json['flavor']);
	if (flavor != null) {
		menuItemEntity.flavor = flavor;
	}
	final List<MarketingLabelEntity>? marketingLabel = jsonConvert.convertListNotNull<MarketingLabelEntity>(json['marketingLabel']);
	if (marketingLabel != null) {
		menuItemEntity.marketingLabel = marketingLabel;
	}
	final CustomMarketingLabelEntity? customMarketingLabel = jsonConvert.convert<CustomMarketingLabelEntity>(json['customMarketingLabel']);
	if (customMarketingLabel != null) {
		menuItemEntity.customMarketingLabel = customMarketingLabel;
	}
	final int? isDisplay = jsonConvert.convert<int>(json['isDisplay']);
	if (isDisplay != null) {
		menuItemEntity.isDisplay = isDisplay;
	}
	final int? skuAllSaleOut = jsonConvert.convert<int>(json['skuAllSaleOut']);
	if (skuAllSaleOut != null) {
		menuItemEntity.skuAllSaleOut = skuAllSaleOut;
	}
	final int? skuNum = jsonConvert.convert<int>(json['skuNum']);
	if (skuNum != null) {
		menuItemEntity.skuNum = skuNum;
	}
	final int? skuNumNew = jsonConvert.convert<int>(json['skuNumNew']);
	if (skuNumNew != null) {
		menuItemEntity.skuNumNew = skuNumNew;
	}
	final int? quantity = jsonConvert.convert<int>(json['quantity']);
	if (quantity != null) {
		menuItemEntity.quantity = quantity;
	}
	final String? sellingPoints = jsonConvert.convert<String>(json['sellingPoints']);
	if (sellingPoints != null) {
		menuItemEntity.sellingPoints = sellingPoints;
	}
	final String? essentials = jsonConvert.convert<String>(json['essentials']);
	if (essentials != null) {
		menuItemEntity.essentials = essentials;
	}
	final int? quantityCount = jsonConvert.convert<int>(json['quantityCount']);
	if (quantityCount != null) {
		menuItemEntity.quantityCount = quantityCount;
	}
	final int? sales = jsonConvert.convert<int>(json['sales']);
	if (sales != null) {
		menuItemEntity.sales = sales;
	}
	final List<SkuEntity>? skuList = jsonConvert.convertListNotNull<SkuEntity>(json['skuList']);
	if (skuList != null) {
		menuItemEntity.skuList = skuList;
	}
	final SkuEntity? firstSku = jsonConvert.convert<SkuEntity>(json['firstSku']);
	if (firstSku != null) {
		menuItemEntity.firstSku = firstSku;
	}
	return menuItemEntity;
}

Map<String, dynamic> $MenuItemEntityToJson(MenuItemEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['key'] = entity.key;
	data['title'] = entity.title;
	data['itemNo'] = entity.itemNo;
	data['skuCombinList'] =  entity.skuCombinList?.map((v) => v.toJson()).toList();
	data['litimgUrl'] = entity.litimgUrl;
	data['itemNetWeight'] = entity.itemNetWeight;
	data['capacity'] = entity.capacity;
	data['itemSpicyValue'] = entity.itemSpicyValue;
	data['itemLabel'] = entity.itemLabel;
	data['placeOfOrigin'] = entity.placeOfOrigin;
	data['workmanship'] = entity.workmanship;
	data['flavor'] = entity.flavor;
	data['marketingLabel'] =  entity.marketingLabel?.map((v) => v.toJson()).toList();
	data['customMarketingLabel'] = entity.customMarketingLabel?.toJson();
	data['isDisplay'] = entity.isDisplay;
	data['skuAllSaleOut'] = entity.skuAllSaleOut;
	data['skuNum'] = entity.skuNum;
	data['skuNumNew'] = entity.skuNumNew;
	data['quantity'] = entity.quantity;
	data['sellingPoints'] = entity.sellingPoints;
	data['essentials'] = entity.essentials;
	data['quantityCount'] = entity.quantityCount;
	data['sales'] = entity.sales;
	data['skuList'] =  entity.skuList?.map((v) => v.toJson()).toList();
	data['firstSku'] = entity.firstSku?.toJson();
	return data;
}