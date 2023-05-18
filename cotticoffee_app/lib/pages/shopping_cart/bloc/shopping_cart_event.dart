import 'package:cotti_client/pages/shopping_cart/entity/cart_goods_item.dart';

abstract class ShoppingCartEvent {}

class CleanConfirmEvent extends ShoppingCartEvent {
  bool isCleanConfirm;

  CleanConfirmEvent(this.isCleanConfirm);
}

///门店切换事件
class ShopChangeEvent extends ShoppingCartEvent {
  int shopMdCode;
  List<int> takeFoodModes;

  ShopChangeEvent(this.shopMdCode, this.takeFoodModes);
}

class SyncCartEvent extends ShoppingCartEvent {}

class AddSkuCartEvent extends ShoppingCartEvent {
  ///商品spuCode
  String itemNo;

  ///sku
  String skuCode;

  ///购买数量,默认购买数1
  int buyNum;

  ///活动编号,如果是活动商品，需要传入活动编号
  String? activityNo;

  AddSkuCartEvent(
    this.itemNo,
    this.skuCode, {
    this.buyNum = 1,
    this.activityNo,
  });
}

class SubSkuCartEvent extends ShoppingCartEvent {
  ///商品spuCode
  String itemNo;

  ///sku
  String skuCode;

  ///购买数量,默认购买数1
  int buyNum;

  ///是否删除商品,默认不删除
  bool isDelete;

  /// 删除时是否同步服务器数据，默认同步
  bool isSync;

  SubSkuCartEvent(
    this.itemNo,
    this.skuCode, {
    this.buyNum = 1,
    this.isDelete = false,
    this.isSync = true,
  });
}

class ClearCartEvent extends ShoppingCartEvent {}

class EditSkuCartEvent extends ShoppingCartEvent {
  final CartGoodsItem newItem;

  final CartGoodsItem oldItem;

  ///如果商品是特价商品，则需要传入活动编号
  final String? activityNo;

  EditSkuCartEvent(this.newItem, this.oldItem, this.activityNo);
}

class ClearSelloutCartEvent extends ShoppingCartEvent {}

class SelectCartEvent extends ShoppingCartEvent {
  ///需要修改的数据下标
  final int index;

  SelectCartEvent(this.index);
}

class SelectAllCartEvent extends ShoppingCartEvent {
  ///true 选中，false 取消选中
  final bool isSelect;

  SelectAllCartEvent(this.isSelect);
}

///售罄商品收起/展开状态切换
class ShowSellOutChangeEvent extends ShoppingCartEvent {}

///批量加入购物车中商品
class AddCartListSkuEvent extends ShoppingCartEvent {
  ///批量加入的商品item
  final List<CartGoodsItem> goodsList;

  ///加入前是否清空购物车,默认不清空
  final bool cleanCart;

  AddCartListSkuEvent(this.goodsList, {this.cleanCart = false});
}

///批量删除购物车中商品
class SubCartListSkuEvent extends ShoppingCartEvent {
  ///批量加入的商品item
  final List<CartGoodsItem> goodsList;

  SubCartListSkuEvent(this.goodsList);
}
