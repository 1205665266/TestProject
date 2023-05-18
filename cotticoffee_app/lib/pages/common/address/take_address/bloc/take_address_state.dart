import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';

import '../entity/take_address_entity.dart';

class TakeAddressState {
  TakeAddressEntity? takeAddressEntity;
  int getShopInfoTimeStamp = 0;
  ShopInfoEntity? shopInfoEntity;
  MemberAddressEntity? curSelectMemberAddress;
  bool showLoading = false;

  TakeAddressState copy({
    int? getShopInfoTimeStamp,
    ShopInfoEntity? shopInfoEntity,
    MemberAddressEntity? curSelectMemberAddress,
    bool? showLoading,
  }) {
    return TakeAddressState()
      ..takeAddressEntity = takeAddressEntity
      ..showLoading = showLoading ?? this.showLoading
      ..curSelectMemberAddress = curSelectMemberAddress ?? this.curSelectMemberAddress
      ..shopInfoEntity = shopInfoEntity ?? this.shopInfoEntity
      ..getShopInfoTimeStamp = getShopInfoTimeStamp ?? this.getShopInfoTimeStamp;
  }

  bool get showEmpty =>
      takeAddressEntity != null &&
      (takeAddressEntity!.address?.isEmpty ?? true) &&
      (takeAddressEntity!.addressOutOfRange?.isEmpty ?? true);
}
