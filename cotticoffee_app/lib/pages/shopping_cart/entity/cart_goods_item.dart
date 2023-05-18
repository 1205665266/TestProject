import 'package:cotti_client/generated/json/cart_goods_item.g.dart';

import '../../../generated/json/base/json_field.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/22 09:52
@JsonSerializable()
class CartGoodsItem {
  ///spuCode
  late String itemNo;

  ///skuCode
  late String skuCode;

  ///购买数量
  late int buyNum;

  ///选中状态
  int? selectedStatus;

  ///加入购物车时间戳
  num? addCartTime;

  CartGoodsItem();

  factory CartGoodsItem.fromJson(Map<String, dynamic> json) => $CartGoodsItemFromJson(json);

  Map<String, dynamic> toJson() => $CartGoodsItemToJson(this);
}
