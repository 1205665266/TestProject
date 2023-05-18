import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/shopping_cart/entity/cart_goods_item.dart';

CartGoodsItem $CartGoodsItemFromJson(Map<String, dynamic> json) {
	final CartGoodsItem cartGoodsItem = CartGoodsItem();
	final String? itemNo = jsonConvert.convert<String>(json['itemNo']);
	if (itemNo != null) {
		cartGoodsItem.itemNo = itemNo;
	}
	final String? skuCode = jsonConvert.convert<String>(json['skuCode']);
	if (skuCode != null) {
		cartGoodsItem.skuCode = skuCode;
	}
	final int? buyNum = jsonConvert.convert<int>(json['buyNum']);
	if (buyNum != null) {
		cartGoodsItem.buyNum = buyNum;
	}
	final int? selectedStatus = jsonConvert.convert<int>(json['selectedStatus']);
	if (selectedStatus != null) {
		cartGoodsItem.selectedStatus = selectedStatus;
	}
	final num? addCartTime = jsonConvert.convert<num>(json['addCartTime']);
	if (addCartTime != null) {
		cartGoodsItem.addCartTime = addCartTime;
	}
	return cartGoodsItem;
}

Map<String, dynamic> $CartGoodsItemToJson(CartGoodsItem entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['itemNo'] = entity.itemNo;
	data['skuCode'] = entity.skuCode;
	data['buyNum'] = entity.buyNum;
	data['selectedStatus'] = entity.selectedStatus;
	data['addCartTime'] = entity.addCartTime;
	return data;
}