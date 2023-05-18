import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';

import '../entity/take_address_entity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/9 16:41
class TakeAddressApi {
  static const String _listForOrder = "/address/listForOrder";
  static const String _delAddress = "/address/del";
  static const String _filterUsefulAddress = "/address/filterUsefulAddress";

  static const String _addAddress = "/address/add";
  static const String _updateAddress = "/address/update";

  static Future<void> updateAddress({required MemberAddressEntity address}) {
    return CottiNetWork().post(_updateAddress, data: address.toJson());
  }

  static Future<Map<String, dynamic>> addAddress({required MemberAddressEntity address}) {
    return CottiNetWork()
        .post(_addAddress, data: address.toJson())
        .then((value) => value);
    // .then((value) => MemberAddressEntity.fromJson(value));
  }

  static Future<TakeAddressEntity> getTakeAddress() {
    return CottiNetWork()
        .post(_listForOrder, data: {})
        .then((value) => TakeAddressEntity.fromJson(value))
        .catchError((onError) => TakeAddressEntity());
  }

  static Future<bool> delTakeAddress(num addressId) {
    return CottiNetWork().post(_delAddress, data: {"addressId": addressId}).then((value) => value);
  }

  static Future<MemberAddressEntity> getFilterUsefulAddress(
      {int? addressId, double? customerLongitude, double? customerLatitude}) {
    return CottiNetWork().post(_filterUsefulAddress, data: {
      "addressId": addressId,
      "customerLongitude": customerLongitude,
      "customerLatitude": customerLatitude,
    }).then((value) => MemberAddressEntity.fromJson(value));
  }
}
