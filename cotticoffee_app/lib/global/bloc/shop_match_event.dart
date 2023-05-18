import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';
import 'package:flutter/cupertino.dart';

abstract class ShopMatchEvent {}

///通过自提的方式匹配门店
class SelfTakeMatchShopEvent extends ShopMatchEvent {
  BuildContext? context;

  ///是否需要重新定位
  final bool isReLocation;

  ///是否需要待开业门店
  final bool needToBeOpenShop;

  SelfTakeMatchShopEvent({
    this.context,
    this.isReLocation = false,
    this.needToBeOpenShop = true,
  });
}

/// 根据收货地址，匹配自提门店（确认订单特殊case: 当进入确认订单页面时，如果是外卖方式，则每次切换自提时，要根据当前外卖地址，匹配附近的自提门店）
class ShopInfoBySwitchAddressEvent extends ShopMatchEvent {
  final MemberAddressEntity address;

  ShopInfoBySwitchAddressEvent(this.address);
}

///通过门店code匹配门店
class ShopInfoByShopMdCodeEvent extends ShopMatchEvent {
  final int shopMdCode;

  ShopInfoByShopMdCodeEvent(this.shopMdCode);
}

///根据收货地址，获取门店信息
class ShopInfoByAddressEvent extends ShopMatchEvent {
  final MemberAddressEntity address;

  ///是否是自动匹配的地址
  bool? isAutoMatchShop;

  ShopInfoByAddressEvent(this.address, {this.isAutoMatchShop = false});
}

class TakeOutAdapterEvent extends ShopMatchEvent {
  ///发起请求来源页
  final String fromTag;

  TakeOutAdapterEvent(this.fromTag);
}

class DeleteTakeAddressEvent extends ShopMatchEvent {}
