import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/shopping_cart/entity/cart_params.dart';
import 'package:cotti_client/pages/shopping_cart/entity/cart_goods_item.dart';


CartParams $CartParamsFromJson(Map<String, dynamic> json) {
	final CartParams cartParams = CartParams();
	final int? shopId = jsonConvert.convert<int>(json['shopId']);
	if (shopId != null) {
		cartParams.shopId = shopId;
	}
	final int? shopMdCode = jsonConvert.convert<int>(json['shopMdCode']);
	if (shopMdCode != null) {
		cartParams.shopMdCode = shopMdCode;
	}
	final List<CartGoodsItem?>? cartGoodsItemList = jsonConvert.convertList<CartGoodsItem>(json['cartGoodsItemList']);
	if (cartGoodsItemList != null) {
		cartParams.cartGoodsItemList = cartGoodsItemList;
	}
	final int? operateType = jsonConvert.convert<int>(json['operateType']);
	if (operateType != null) {
		cartParams.operateType = operateType;
	}
	final List<int>? tookFoodModes = jsonConvert.convertListNotNull<int>(json['tookFoodModes']);
	if (tookFoodModes != null) {
		cartParams.tookFoodModes = tookFoodModes;
	}
	return cartParams;
}

Map<String, dynamic> $CartParamsToJson(CartParams entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['shopId'] = entity.shopId;
	data['shopMdCode'] = entity.shopMdCode;
	data['cartGoodsItemList'] =  entity.cartGoodsItemList?.map((v) => v?.toJson()).toList();
	data['operateType'] = entity.operateType;
	data['tookFoodModes'] =  entity.tookFoodModes;
	return data;
}