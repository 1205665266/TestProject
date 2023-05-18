import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';

VoucherSkuModelEntity $VoucherSkuModelEntityFromJson(Map<String, dynamic> json) {
	final VoucherSkuModelEntity voucherSkuModelEntity = VoucherSkuModelEntity();
	final String? itemNo = jsonConvert.convert<String>(json['itemNo']);
	if (itemNo != null) {
		voucherSkuModelEntity.itemNo = itemNo;
	}
	final int? itemId = jsonConvert.convert<int>(json['itemId']);
	if (itemId != null) {
		voucherSkuModelEntity.itemId = itemId;
	}
	final int? skuId = jsonConvert.convert<int>(json['skuId']);
	if (skuId != null) {
		voucherSkuModelEntity.skuId = skuId;
	}
	final String? skuNo = jsonConvert.convert<String>(json['skuNo']);
	if (skuNo != null) {
		voucherSkuModelEntity.skuNo = skuNo;
	}
	final String? skuName = jsonConvert.convert<String>(json['skuName']);
	if (skuName != null) {
		voucherSkuModelEntity.skuName = skuName;
	}
	final String? skuShowName = jsonConvert.convert<String>(json['skuShowName']);
	if (skuShowName != null) {
		voucherSkuModelEntity.skuShowName = skuShowName;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		voucherSkuModelEntity.title = title;
	}
	final String? image = jsonConvert.convert<String>(json['image']);
	if (image != null) {
		voucherSkuModelEntity.image = image;
	}
	final String? facePrice = jsonConvert.convert<String>(json['facePrice']);
	if (facePrice != null) {
		voucherSkuModelEntity.facePrice = facePrice;
	}
	final double? couponDiscountMoney = jsonConvert.convert<double>(json['couponDiscountMoney']);
	if (couponDiscountMoney != null) {
		voucherSkuModelEntity.couponDiscountMoney = couponDiscountMoney;
	}
	final double? voucherDiscountMoney = jsonConvert.convert<double>(json['voucherDiscountMoney']);
	if (voucherDiscountMoney != null) {
		voucherSkuModelEntity.voucherDiscountMoney = voucherDiscountMoney;
	}
	final String? lineThroughPrice = jsonConvert.convert<String>(json['lineThroughPrice']);
	if (lineThroughPrice != null) {
		voucherSkuModelEntity.lineThroughPrice = lineThroughPrice;
	}
	final String? specialPrice = jsonConvert.convert<String>(json['specialPrice']);
	if (specialPrice != null) {
		voucherSkuModelEntity.specialPrice = specialPrice;
	}
	final int? specialAvaNum = jsonConvert.convert<int>(json['specialAvaNum']);
	if (specialAvaNum != null) {
		voucherSkuModelEntity.specialAvaNum = specialAvaNum;
	}
	final int? buyNum = jsonConvert.convert<int>(json['buyNum']);
	if (buyNum != null) {
		voucherSkuModelEntity.buyNum = buyNum;
	}
	final String? categoryCode = jsonConvert.convert<String>(json['categoryCode']);
	if (categoryCode != null) {
		voucherSkuModelEntity.categoryCode = categoryCode;
	}
	final String? preferenceType = jsonConvert.convert<String>(json['preferenceType']);
	if (preferenceType != null) {
		voucherSkuModelEntity.preferenceType = preferenceType;
	}
	final String? preferenceTypeDesc = jsonConvert.convert<String>(json['preferenceTypeDesc']);
	if (preferenceTypeDesc != null) {
		voucherSkuModelEntity.preferenceTypeDesc = preferenceTypeDesc;
	}
	final String? voucherNo = jsonConvert.convert<String>(json['voucherNo']);
	if (voucherNo != null) {
		voucherSkuModelEntity.voucherNo = voucherNo;
	}
	final String? voucherName = jsonConvert.convert<String>(json['voucherName']);
	if (voucherName != null) {
		voucherSkuModelEntity.voucherName = voucherName;
	}
	final bool? chooseNotUseCashCoupon = jsonConvert.convert<bool>(json['chooseNotUseCashCoupon']);
	if (chooseNotUseCashCoupon != null) {
		voucherSkuModelEntity.chooseNotUseCashCoupon = chooseNotUseCashCoupon;
	}
	final double? saleUnitPrice = jsonConvert.convert<double>(json['saleUnitPrice']);
	if (saleUnitPrice != null) {
		voucherSkuModelEntity.saleUnitPrice = saleUnitPrice;
	}
	final double? baseUnitPrice = jsonConvert.convert<double>(json['baseUnitPrice']);
	if (baseUnitPrice != null) {
		voucherSkuModelEntity.baseUnitPrice = baseUnitPrice;
	}
	final String? spuCode = jsonConvert.convert<String>(json['itemNo']);
	if (spuCode != null) {
		voucherSkuModelEntity.spuCode = spuCode;
	}
	final bool? show = jsonConvert.convert<bool>(json['show']);
	if (show != null) {
		voucherSkuModelEntity.show = show;
	}
	return voucherSkuModelEntity;
}

Map<String, dynamic> $VoucherSkuModelEntityToJson(VoucherSkuModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['itemNo'] = entity.itemNo;
	data['itemId'] = entity.itemId;
	data['skuId'] = entity.skuId;
	data['skuNo'] = entity.skuNo;
	data['skuName'] = entity.skuName;
	data['skuShowName'] = entity.skuShowName;
	data['title'] = entity.title;
	data['image'] = entity.image;
	data['facePrice'] = entity.facePrice;
	data['couponDiscountMoney'] = entity.couponDiscountMoney;
	data['voucherDiscountMoney'] = entity.voucherDiscountMoney;
	data['lineThroughPrice'] = entity.lineThroughPrice;
	data['specialPrice'] = entity.specialPrice;
	data['specialAvaNum'] = entity.specialAvaNum;
	data['buyNum'] = entity.buyNum;
	data['categoryCode'] = entity.categoryCode;
	data['preferenceType'] = entity.preferenceType;
	data['preferenceTypeDesc'] = entity.preferenceTypeDesc;
	data['voucherNo'] = entity.voucherNo;
	data['voucherName'] = entity.voucherName;
	data['chooseNotUseCashCoupon'] = entity.chooseNotUseCashCoupon;
	data['saleUnitPrice'] = entity.saleUnitPrice;
	data['baseUnitPrice'] = entity.baseUnitPrice;
	data['show'] = entity.show;
	return data;
}