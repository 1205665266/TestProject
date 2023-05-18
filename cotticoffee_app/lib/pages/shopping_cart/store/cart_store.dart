import 'dart:convert' as convert;

import 'package:cotti_client/config/env.dart';
import 'package:cotti_client/generated/json/cart_goods_item.g.dart';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/shopping_cart/entity/cart_goods_item.dart';
import 'package:cotti_client/pages/shopping_cart/entity/shopping_cart_entity.dart';
import 'package:cotti_client/pages/shopping_cart/entity/specials_daily_limit_check_entity.dart';
import 'package:cotticommon/cotticommon.dart';

import '../entity/cart_params.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/18 19:09
class CartStore {
  static const String _getShoppingCart = "/cart/getShoppingCart";
  static const String _specialsDailyLimitCheck = "/cart/specialsDailyLimitCheck";
  static final String _keyCart = "key_${Env.currentEnvConfig.envName}_carts";
  static final String _keyUnSelect = "key_${Env.currentEnvConfig.envName}_unselect";

  static Future<ShoppingCartEntity> getShoppingCart(CartParams cartParams) {
    return CottiNetWork()
        .post(_getShoppingCart, data: cartParams.toJson(), showToast: false)
        .then((value) => ShoppingCartEntity.fromJson(value));
  }

  static Future<SpecialsDailyLimitCheckEntity> specialsDailyLimitCheck(
      int shopMdCode, String skuCode, String? activityNo, int buyNum) {
    return CottiNetWork().post(_specialsDailyLimitCheck, data: {
      "shopMdCode": shopMdCode,
      "skuCode": skuCode,
      "activityNo": activityNo,
      "buyNum": buyNum
    }).then((value) => SpecialsDailyLimitCheckEntity.fromJson(value));
  }

  static List<CartGoodsItem> getLocalCart() {
    String data = SpUtil.getString(_keyCart, defValue: "[]");
    List catchLis = convert.jsonDecode(data);
    List<CartGoodsItem> carts = catchLis.map((e) => $CartGoodsItemFromJson(e)).toList();
    return carts;
  }

  static updateCart(List<GoodsItem> goodsItems) {
    List<CartGoodsItem> carts = goodsItems.map((e) {
      return CartGoodsItem()
        ..itemNo = e.itemNo!
        ..skuCode = e.skuCode
        ..selectedStatus = e.selectedStatus
        ..buyNum = e.buyNum!
        ..addCartTime = e.addCartTime;
    }).toList();
    SpUtil.putString(_keyCart, convert.jsonEncode(carts));
  }

  static List<String> readUserUnSelect() {
    String data = SpUtil.getString(_keyUnSelect, defValue: "[]");
    List catchLis = convert.jsonDecode(data);
    return catchLis.map((e) => "$e").toList();
  }

  static addUserUnSelect(String skuCode) {
    String data = SpUtil.getString(_keyUnSelect, defValue: "[]");
    List catchLis = convert.jsonDecode(data);
    bool isExist = catchLis.any((element) => element == skuCode);
    if (!isExist) {
      catchLis.add(skuCode);
      SpUtil.putString(_keyUnSelect, convert.jsonEncode(catchLis));
    }
  }

  static deleteUserUnSelect(String skuCode) {
    String data = SpUtil.getString(_keyUnSelect, defValue: "[]");
    List catchLis = convert.jsonDecode(data);
    bool isExist = catchLis.any((element) => element == skuCode);
    if (isExist) {
      catchLis.remove(skuCode);
      SpUtil.putString(_keyUnSelect, convert.jsonEncode(catchLis));
    }
  }

  static clearUserUnSelect() {
    SpUtil.remove(_keyUnSelect);
  }
}
