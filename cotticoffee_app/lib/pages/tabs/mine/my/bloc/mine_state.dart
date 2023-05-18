import 'package:cotti_client/pages/tabs/mine/my/entity/coupon_bounty_entity.dart';
import 'package:cotti_client/pages/tabs/mine/my/entity/coupon_exchange_statement_entity.dart';
import 'package:cotti_client/pages/tabs/mine/my/entity/user_info_entity.dart';
import 'package:cotti_client/widget/banner/model/ad_sort_entity.dart';

class MineState {
  UserInfoEntity? userInfoEntity;
  CouponBountyEntity? couponBountyEntity;
  CouponExchangeStatementEntity? couponExchangeStatement;
  bool isUpdateNickNamed = false;
  String? promptStr;

  List<AdSortEntity> actionList = [];


  MineState copy() {
    MineState newState = MineState()
      ..promptStr = promptStr
      ..isUpdateNickNamed = isUpdateNickNamed
      ..userInfoEntity = userInfoEntity
      ..couponExchangeStatement = couponExchangeStatement
      ..couponBountyEntity = couponBountyEntity
      ..actionList = actionList;
    return newState;
  }
}
