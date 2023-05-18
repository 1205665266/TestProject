import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/common/address/take_address/api/take_address_api.dart';
import 'package:cotti_client/pages/common/address/take_address/bloc/take_address_bloc.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';
import 'package:cotti_client/pages/common/city/api/city_api.dart';
import 'package:cotti_client/pages/common/city/entity/city_list_data_entity.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotticommon/bloc/user_state.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'edit_address_event.dart';

part 'edit_address_state.dart';

class EditAddressBloc extends Bloc<EditAddressEvent, EditAddressState> {
  EditAddressBloc({required MemberAddressEntity address, required TakeAddressBloc takeAddressBloc})
      : super(EditAddressState(address: address)) {
    on<EditAddressIngEvent>(_addressEditIng);
    on<AddressPhoneEditingEvent>(_addressPhoneEditIng);
    on<AddressPhoneChickEvent>(_addressPhoneChick);
    on<EditAddressSaveEvent>(_saveEvent);

    state.phoneList = _getPhoneList(takeAddressBloc);
    logW("_phoneList == ${state.phoneList}");
  }

  List<String> _getPhoneList(TakeAddressBloc takeAddressBloc) {
    List<String> _phoneList = <String>[];
    List<MemberAddressEntity> addressList = takeAddressBloc.state.takeAddressEntity?.address ?? [];
    // addressOutOfRange
    addressList.addAll(takeAddressBloc.state.takeAddressEntity?.addressOutOfRange ?? []);

    logI("addressList === $addressList");

    UserState userState = GlobalBlocs.get(UserBloc.blocName).state;
    String? userPhone = userState.userModel?.mobile;

    if (userPhone != null) {
      _phoneList.add(userPhone);
    }

    for (MemberAddressEntity entity in addressList) {
      String? contactPhone = entity.contactPhone;
      logI("contactPhone === $contactPhone");
      if (contactPhone != null && !_phoneList.contains(contactPhone)) {
        _phoneList.add(contactPhone);
      }
    }
    return _phoneList;
  }

  _saveEvent(EditAddressSaveEvent event, emit) async {
    if (state.address.lat != null && state.address.lng != null) {
      try {
        CityListDataData city = await CityApi.getCity(
            latitude: double.tryParse(state.address.lat!),
            longitude: double.tryParse(state.address.lng!));
        state.address.city = city.cityName;
        state.address.cityMdCode = city.cityMdCode;
        state.address.county = city.county;
        state.address.province = city.provinceName;
      } catch (error) {
        logI("查询城市失败 $error");
      }
    }
    state.isSubmit = true;
    state.address.coordinatesType = 1;
    bool val = false;
    if (event.isEdit) {
      state.address.addressId = state.address.id;

      await TakeAddressApi.updateAddress(address: state.address).then((value) {
        logI("updateAddress value = !!!!");
        val = true;
      }).catchError((error) {
        logI("updateAddress error == $error");
      });
    } else {
      await TakeAddressApi.addAddress(address: state.address).then((value) {
        logI("addAddress value = !!!! value = $value");

        int status = value['status'];

        if (status == 0) {
          ToastUtil.show('保存成功');
          val = true;
        } else {
          String msg = value['msg'];
          ToastUtil.show(msg);
        }
      }).catchError((error) {
        logI("addAddress error == $error");
      });
    }
    state.isSubmit = false;
    event.callBack(val);
  }

  _addressPhoneChick(AddressPhoneChickEvent event, emit) {
    emit(state.copy()..address.contactPhone = event.phone);
  }

  _addressEditIng(EditAddressIngEvent event, emit) {
    emit(state.copy());
  }

  _addressPhoneEditIng(AddressPhoneEditingEvent event, emit) {
    String input = event.phone;

    state.address.contactPhone = input;

    List<String> list = <String>[];

    if (input.length == 11 || event.atEnd) {
      state.showTipList = list;

      emit(state.copy());
      return;
    }

    for (String phone in state.phoneList) {
      String subPhone = phone.substring(0, input.length);

      if (subPhone == input) {
        list.add(phone);
      }
    }
    logW("list = $list");

    state.showTipList = list;

    emit(state.copy());
  }
}
