import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';
import 'package:flutter/cupertino.dart';

abstract class TakeAddressEvent {}

class TakeAddressListEvent extends TakeAddressEvent {}

class DeleteAddressEvent extends TakeAddressEvent {
  final num addressId;

  ValueChanged<bool>? callBack;

  DeleteAddressEvent(this.addressId,{this.callBack});
}

class SelectAddressEvent extends TakeAddressEvent {
  MemberAddressEntity memberAddress;

  SelectAddressEvent(this.memberAddress);
}

// class EditAddressEvent extends TakeAddressEvent {
//   final MemberAddressEntity address;
//
//   EditAddressEvent({required this.address});
// }
