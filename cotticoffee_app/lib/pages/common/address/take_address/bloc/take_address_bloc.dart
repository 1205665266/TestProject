import 'package:bloc/bloc.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/pages/common/store/api/store_api.dart';
import 'package:cotticommon/cotticommon.dart';

import '../api/take_address_api.dart';
import 'take_address_event.dart';
import 'take_address_state.dart';

class TakeAddressBloc extends Bloc<TakeAddressEvent, TakeAddressState> {
  TakeAddressBloc() : super(TakeAddressState()) {
    on<TakeAddressListEvent>(_takeAddressList);
    on<DeleteAddressEvent>(_deleteAddress);
    on<SelectAddressEvent>(_selectAddress);
  }

  _takeAddressList(_, emit) async {
    state.showLoading = true;
    emit(state.copy());
    await TakeAddressApi.getTakeAddress().then((value) {
      state.takeAddressEntity = value;
    }).catchError((onError) => logI("获取地址列表失败"));
    state.showLoading = false;
    emit(state.copy());
  }

  _deleteAddress(DeleteAddressEvent event, emit) async {
    await TakeAddressApi.delTakeAddress(event.addressId).then((value) {
      if (value) {
        ToastUtil.show("删除成功");
        add(TakeAddressListEvent());
        if (event.callBack != null) {
          event.callBack!(true);
        }
      } else {
        ToastUtil.show("删除失败");
      }
    });
  }

  _selectAddress(SelectAddressEvent event, emit) async {
    state.showLoading = true;
    emit(state.copy());
    await StoreApi.getShopInfoDetail(
      Constant.takeOutModeCode,
      addressId: event.memberAddress.id,
      longitude: double.tryParse(event.memberAddress.lng ?? ''),
      latitude: double.tryParse(event.memberAddress.lat ?? ''),
    ).then((value) {
      emit(state.copy(
        getShopInfoTimeStamp: DateTime.now().millisecondsSinceEpoch,
        shopInfoEntity: value,
        showLoading: false,
        curSelectMemberAddress: event.memberAddress,
      ));
    }).catchError((onError) {
      emit(state.copy(showLoading: false));
    });
  }
}
