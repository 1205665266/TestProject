import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/cart_params.g.dart';
import 'package:cotti_client/pages/shopping_cart/entity/cart_goods_item.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/22 09:58
@JsonSerializable()
class CartParams {
  int? shopId;
  int? shopMdCode;
  List<CartGoodsItem?>? cartGoodsItemList;
  int? operateType;
  List<int>? tookFoodModes;

  CartParams();

  factory CartParams.fromJson(Map<String, dynamic> json) => $CartParamsFromJson(json);

  Map<String, dynamic> toJson() => $CartParamsToJson(this);
}
