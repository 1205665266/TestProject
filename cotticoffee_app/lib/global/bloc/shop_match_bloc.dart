import 'package:bloc/bloc.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/pages/common/address/take_address/api/take_address_api.dart';
import 'package:cotti_client/pages/common/store/api/store_api.dart';
import 'package:cotti_client/service/location/location_service.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

import 'shop_match_event.dart';
import 'shop_match_state.dart';

class ShopMatchBloc extends Bloc<ShopMatchEvent, ShopMatchState> {
  ShopMatchBloc() : super(ShopMatchState()) {
    on<SelfTakeMatchShopEvent>(_selfTake);
    on<ShopInfoByAddressEvent>(_shopInfoByAddress);
    on<TakeOutAdapterEvent>(_takeAdapter);
    on<ShopInfoByShopMdCodeEvent>(_shopInfoByShopMdCode);
    on<ShopInfoBySwitchAddressEvent>(_shopInfoBySwitchAddress);
    on<DeleteTakeAddressEvent>(_deleteTakeAddress);
  }

  _selfTake(SelfTakeMatchShopEvent event, emit) async {
    if (state.selfTakeShopInfo?.shopDetail == null) {
      emit(state.copy(showLoading: true, firstGetShopInfo: true));
    }

    ///当前是否有缓存门店
    if (state.selfTakeShopInfo == null) {
      await _locationShopInfo(emit,
          context: event.context, isAutoMatchShop: true, needToBeOpenShop: event.needToBeOpenShop);
    } else {
      var status = await Permission.location.status;
      if (status == PermissionStatus.granted && _shopInfoTimeOut(5) && event.isReLocation) {
        await _locationShopInfo(emit,
            context: event.context,
            isAutoMatchShop: true,
            needToBeOpenShop: event.needToBeOpenShop);
      } else {
        state.locationResult ??= await LocationService().startLocation(event.context);
        await StoreApi.getShopInfoDetail(
          Constant.selfTakeModeCode,
          latitude: state.locationResult?.positionInfoEntity?.latitude,
          longitude: state.locationResult?.positionInfoEntity?.longitude,
          shopCode: state.selfTakeShopInfo?.shopDetail?.shopMdCode,
          needToBeOpenShop: event.needToBeOpenShop,
        ).then((value) {
          emit(state.copy(
            curTakeFoodMode: Constant.selfTakeModeCode,
            selfTakeShopInfo: value,
            currentTime: DateTime.now().microsecondsSinceEpoch,
          ));
        }).catchError((onError) => logE(onError));
      }
    }
    if (state.showLoading = true) {
      emit(state.copy(showLoading: false, firstGetShopInfo: false));
    }
  }

  _locationShopInfo(
    emit, {
    BuildContext? context,
    int? shopMdCode,
    bool? isAutoMatchShop,
    bool? needToBeOpenShop,
  }) async {
    await LocationService().startLocation(context).then((value) {
      state.locationResult = value;
      if (value.errorCode == 0) {
        state.locationCurrentTime = DateTime.now().millisecondsSinceEpoch;
      }
    }).catchError((onError) => logI("定位失败$onError"));
    if (state.locationResult?.errorCode == 0 || shopMdCode != null) {
      await StoreApi.getShopInfoDetail(
        Constant.selfTakeModeCode,
        latitude: state.locationResult?.positionInfoEntity?.latitude,
        longitude: state.locationResult?.positionInfoEntity?.longitude,
        shopCode: shopMdCode,
        needToBeOpenShop: needToBeOpenShop,
      ).then((value) {
        if (isAutoMatchShop == true) {
          isAutoMatchShop = value.shopDetail?.shopMdCode != null &&
              value.shopDetail?.shopMdCode != state.shopMdCode;
        }
        emit(state.copy(
          autoMatchShopTimeStamp: isAutoMatchShop == true
              ? DateTime.now().microsecondsSinceEpoch
              : state.autoMatchShopTimeStamp,
          curTakeFoodMode: Constant.selfTakeModeCode,
          selfTakeShopInfo: value,
          currentTime: DateTime.now().microsecondsSinceEpoch,
        ));
      }).catchError((onError) => logE(onError));
    } else {
      emit(state.copy(
        curTakeFoodMode: Constant.selfTakeModeCode,
      ));
    }
  }

  _shopInfoByAddress(ShopInfoByAddressEvent event, emit) async {
    if ((event.address.id != state.address?.id) || state.address?.id == null) {
      emit(state.copy(
        showLoading: true,
        address: event.address,
        firstGetShopInfo: state.takeOutShopInfo?.shopDetail == null,
      ));
    }
    await StoreApi.getShopInfoDetail(
      Constant.takeOutModeCode,
      addressId: event.address.id,
    ).then((value) {
      emit(state.copy(
        autoMatchShopTimeStamp: event.isAutoMatchShop == true
            ? DateTime.now().microsecondsSinceEpoch
            : state.autoMatchShopTimeStamp,
        curTakeFoodMode: Constant.takeOutModeCode,
        takeOutShopInfo: value,
        address: event.address,
        currentTime: DateTime.now().microsecondsSinceEpoch,
      ));
    }).catchError((onError) => logE(onError));
    if (state.showLoading = true) {
      emit(state.copy(showLoading: false, firstGetShopInfo: false));
    }
  }

  _takeAdapter(TakeOutAdapterEvent event, emit) async {
    if (state.isGetFilterUsefulAddress) {
      return;
    }
    emit(state.copy(
      showLoading: true,
      isGetFilterUsefulAddress: true,
      firstGetShopInfo: state.takeOutShopInfo?.shopDetail == null,
    ));
    await TakeAddressApi.getFilterUsefulAddress(
      customerLongitude: LocationService().getLastPositionInfo?.longitude,
      customerLatitude: LocationService().getLastPositionInfo?.latitude,
    ).then((value) {
      state.address = value;
    }).catchError((onError) {
      logE(onError);
    });
    emit(state.copy(
      showLoading: false,
      isGetFilterUsefulAddress: false,
      firstGetShopInfo: false,
      takeOutTimeStamp: DateTime.now().millisecondsSinceEpoch,
      adapterAddressFromTag: event.fromTag,
    ));
  }

  _shopInfoByShopMdCode(ShopInfoByShopMdCodeEvent event, emit) async {
    if (event.shopMdCode != state.selfTakeShopInfo?.shopDetail?.shopMdCode) {
      emit(state.copy(
        showLoading: true,
        firstGetShopInfo: state.selfTakeShopInfo?.shopDetail == null,
      ));
    }
    await _locationShopInfo(emit, shopMdCode: event.shopMdCode);
    if (state.shopMdCode == event.shopMdCode) {
      state.isUserSelectShopCode = true;
    }
    if (state.showLoading = true) {
      emit(state.copy(showLoading: false, firstGetShopInfo: false));
    }
  }

  _shopInfoBySwitchAddress(ShopInfoBySwitchAddressEvent event, emit) async {
    await StoreApi.getShopInfoDetail(Constant.selfTakeModeCode,
            addressId: event.address.id,
            latitude: double.tryParse(event.address.lat ?? ""),
            longitude: double.tryParse(event.address.lng ?? ""),
            filterNonoperating: true)
        .then((value) {
      state.address = event.address;
      if (value.shopDetail != null) {
        emit(state.copy(
            curTakeFoodMode: Constant.selfTakeModeCode,
            selfTakeShopInfo: value,
            currentTime: DateTime.now().microsecondsSinceEpoch,
            switchSelfTakeFromTakeOutTimeStamp: DateTime.now().microsecondsSinceEpoch,
            switchSelfTakeFromTakeOut: true));
      } else {
        emit(state.copy(
            switchSelfTakeFromTakeOutTimeStamp: DateTime.now().microsecondsSinceEpoch,
            switchSelfTakeFromTakeOut: false));
      }
    }).catchError((onError) {
      emit(state.copy()
        ..switchSelfTakeFromTakeOutTimeStamp = DateTime.now().microsecondsSinceEpoch
        ..switchSelfTakeFromTakeOut = false);
    });
  }

  _deleteTakeAddress(_, emit) {
    state.address = null;
    state.takeOutShopInfo = null;
    emit(state.copy());
  }

  ///请求到门店数据时，距离当前时间超否超过X分钟
  bool _shopInfoTimeOut(int min) {
    int currentTime = state.locationCurrentTime;
    return currentTime == 0 ||
        (DateTime.now().millisecondsSinceEpoch - currentTime) ~/ 1000 > min * 60;
  }
}
