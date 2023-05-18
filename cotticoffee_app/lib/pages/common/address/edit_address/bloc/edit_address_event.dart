part of 'edit_address_bloc.dart';

class EditAddressEvent {}

class EditAddressIngEvent extends EditAddressEvent {
  final MemberAddressEntity address;

  EditAddressIngEvent({required this.address});
}

class AddressPhoneEditingEvent extends EditAddressEvent {
  final String phone;
  bool atEnd;

  AddressPhoneEditingEvent({required this.phone, this.atEnd=false});

}

class AddressPhoneChickEvent extends EditAddressEvent {
  final String phone;

  AddressPhoneChickEvent({required this.phone});
}

class EditAddressSaveEvent extends EditAddressEvent {
  final bool isEdit;
  final ValueChanged<bool> callBack;

  EditAddressSaveEvent({required this.isEdit,required this.callBack});
}