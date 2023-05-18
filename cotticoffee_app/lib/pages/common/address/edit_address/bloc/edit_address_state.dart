part of 'edit_address_bloc.dart';

class EditAddressState {
  final MemberAddressEntity address;

  List<String> phoneList = <String>[];

  List<String>? showTipList;

  /// 判断是否可以提交的标记
  bool canSubmit = false;

  /// 提交时的错误提示
  String? subMsg;

  bool isSubmit = false;

  EditAddressState({required this.address}) {
    logI("in EditAddressState init !!!");

    logI("sex = ${address.sex}");
    /// 判断是否可以提交

    subMsg = null;

    if (address.contact == null || address.contact!.isEmpty) {
      canSubmit = false;
      subMsg = '请输入联系人名称';
      return;
    }

    if (address.sex == null || !(address.sex == 1 || address.sex == 2)) {
      canSubmit = false;
      subMsg = '请选择联系人称谓';
      return;
    }

    if (address.contactPhone == null || address.contactPhone!.isEmpty) {
      canSubmit = false;
      subMsg = '请输入手机号';
      return;
    }

    if(address.contactPhone!.length != 11){
      canSubmit = false;
      subMsg = '请输入手机号不正确';
      return;
    }

    if (address.location == null || address.location!.isEmpty) {
      canSubmit = false;
      subMsg = '请选择收货地址';
      return;
    }

    if (address.address == null || address.address!.isEmpty) {
      canSubmit = false;
      subMsg = '请输入门牌号';
      return;
    }

    canSubmit = true;
  }

  EditAddressState copy() {
    return EditAddressState(address: address)
      ..phoneList = phoneList
      ..isSubmit = isSubmit
      ..showTipList = showTipList;
  }
}
