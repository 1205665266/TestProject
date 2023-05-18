import 'package:bloc/bloc.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/pages/common/store/api/store_api.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';
import 'package:cotti_client/pages/common/store/entity/shop_list_param.dart';
import 'package:cotti_client/pages/common/store/entity/store_list_data_entity.dart';
import 'package:cotti_client/sensors/store_sensors_constant.dart';
import 'package:cotti_client/service/location/location_result.dart';
import 'package:cotti_client/service/location/location_service.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import '../../city/entity/city_list_data_entity.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreState()) {
    on<StoreListEvent>(_storeList);
    on<StoreListMapMoveEvent>(_getMapMoveStoreList);
    on<StoreListChangeCityEvent>(_changeCityData);
    on<StoreListFocusCodeChagneEvent>(_focusCodeHasFocus);
    on<StoreListSearchShopEvent>(_searchShop);
    on<StoreListChangeTopDistanceEvent>(_changeStoreListTopDistance);
    on<StoreArrowChangeEvent>(_arrowChange);
    on<InitFromPageEvent>(_initFromPageEvent);
    on<CurrShopEvent>(_setCurrShopMDCode);
  }

  _setCurrShopMDCode(CurrShopEvent event, emit) {
    emit(state.copy()..shopMdCode = event.shopMdCode);
  }

  _initFromPageEvent(InitFromPageEvent event, emit) {
    emit(state.copy()..isFromConfirm = event.isFromConfirm);
  }

  _arrowChange(StoreArrowChangeEvent event, emit) {
    logI('in _arrowChange ==== atBottom -- > ${state.atBottom}');
    SensorsAnalyticsFlutterPlugin.track(StoreSensorsConstant.storeListWindowSwitchClick, {
      'store_window_state': state.atBottom ? 'small_window' : 'big_window',
    });

    emit(state.copy());
  }

  _storeList(StoreListEvent event, emit) async {
    state.showLoading = true;
    emit(state.copy());
    logI('定位信息开始了');

    await _locationShopList(event.context, emit);

    state.showLoading = false;
    emit(state.copy());
  }

  _locationShopList(BuildContext context, emit) async {
    await LocationService().startLocation(context).then((value) {
      state.locationResult = value;
    }).catchError((onError) => logI("定位失败$onError"));
    var status = await Permission.location.status;
    state.locationStatus = status == PermissionStatus.granted;

    if (state.locationResult?.errorCode == 0 || Constant.cityDataEntity.cityMdCode != null) {
      state.centerLongitude = null;
      state.centerLatitude = null;

      CityListDataData? cityData;
      try {
        cityData = await StoreApi.getCity(
            latitude: state.locationResult?.positionInfoEntity?.latitude,
            longitude: state.locationResult?.positionInfoEntity?.longitude);

        /// 只有返回正确的城市信息时才继续赋值，
        if (cityData.cityMdCode != null) {
          Constant.cityDataEntity = cityData;
        } else {
          /// 没有查到对应城市赋值StoreListDataEntity() 为了地图显示附近无门店；
          emit(state.copy()..storeListEntity = StoreListDataEntity());
          ShopInfoEntity? current = context.read<ShopMatchBloc>().state.selfTakeShopInfo;
          if (Constant.cityDataEntity.cityMdCode == null && current == null) {
            /// 如果有选中的门店可以继续请求门店列表；
            return;
          }
        }
      } catch (error) {
        // logW('msg');
      }
      ShopListParam parm = ShopListParam();

      /// 未请求到正确的城市信息时如果有选中城市则使用选中的城市编码
      parm.cityMdCode = cityData?.cityMdCode ?? Constant.cityDataEntity.cityMdCode;
      parm.latitude = state.locationResult?.positionInfoEntity?.latitude;
      parm.longitude = state.locationResult?.positionInfoEntity?.longitude;
      parm.isChangeCity = true;

      ShopInfoEntity? current = context.read<ShopMatchBloc>().state.selfTakeShopInfo;

      state.storeListEntity = StoreListDataEntity();
      emit(state.copy());

      await _getStoreList(parm, emit, currentShop: current);
    }
  }

  _getMapMoveStoreList(StoreListMapMoveEvent event, emit) async {
    state.showLoading = true;
    emit(state.copy());
    await _cityAndStoreList(event, emit);
    state.moveMapEventTimeStamp = DateTime.now().millisecondsSinceEpoch;
    state.showLoading = false;
    emit(state.copy());
  }

  _cityAndStoreList(StoreListMapMoveEvent event, emit) async {
    if (event.latitude != null && event.latitude != 0) {
      state.centerLatitude = event.latitude;
      state.centerLongitude = event.longitude;
      CityListDataData cityData =
          await StoreApi.getCity(latitude: event.latitude, longitude: event.longitude);

      if (cityData.cityMdCode != null) {
        Constant.cityDataEntity = cityData;
      } else {
        /// 没有查到对应城市赋值StoreListDataEntity() 为了地图显示附近无门店；
        emit(state.copy()..storeListEntity = StoreListDataEntity());
        return;
      }

      logI('emit开始请求shopList');
      ShopListParam parm = ShopListParam();
      parm.cityMdCode = cityData.cityMdCode;
      parm.latitude = event.latitude;
      parm.longitude = event.longitude;

      await _getStoreList(parm, emit);
      logI('emit结束请求shopList');
    }
  }

  _changeCityData(StoreListChangeCityEvent event, emit) async {
    Constant.cityDataEntity = event.cityModel!;
    emit(state.copy());

    ShopListParam parm = ShopListParam();
    parm.cityMdCode = event.cityModel?.cityMdCode;
    parm.isChangeCity = true;
    state.isChangeCity = true;
    state.storeListEntity = null;

    ShopInfoEntity? current = event.context.read<ShopMatchBloc>().state.selfTakeShopInfo;

    bool hasCurrentShop = int.tryParse(current?.shopDetail?.cityMdCode??"") == event.cityModel!.cityMdCode;

    await _getStoreList(parm, emit,currentShop: hasCurrentShop ? current:null);
  }

  _getStoreList(ShopListParam param, emit, {ShopInfoEntity? currentShop}) async {
    if (param.cityMdCode == null) {
      emit(state.copy());
      return;
    }

    emit(state.copy()..shopListLoading = true);
    await StoreApi.getShopList(param.cityMdCode!,
            latitude: param.latitude,
            longitude: param.longitude,
            shopMdName: param.shopMdName,
            takeFoodMode: 100,
            userLatitude: state.locationResult?.positionInfoEntity?.latitude,
            userLongitude: state.locationResult?.positionInfoEntity?.longitude,
            needToBeOpenShop: !state.isFromConfirm)
        .then((value) {
      bool hasStore = value.nearbyShopList != null && value.nearbyShopList!.isNotEmpty;
      SensorsAnalyticsFlutterPlugin.track(
          StoreSensorsConstant.storeMapMove, {'map_center_store': hasStore ? '是' : '否'});

      if (currentShop != null) {
        /// 将选中的门店放到第一位
        if (value.oftenUsedShopList != null) {
          StoreListDataModel? temp;
          for (StoreListDataModel val in value.oftenUsedShopList!) {
            if (val.shopMdCode == currentShop.shopDetail?.shopMdCode) {
              val.selected = true;
              temp = val;
            }
          }

          if (temp != null) {
            value.oftenUsedShopList!.remove(temp);
            List<StoreListDataModel> list = [temp, ...value.oftenUsedShopList ?? []];
            value.oftenUsedShopList = list;
          }
        }

        if (value.nearbyShopList != null) {
          StoreListDataModel? temp;

          for (StoreListDataModel val in value.nearbyShopList!) {
            if (val.shopMdCode == currentShop.shopDetail?.shopMdCode) {
              val.selected = true;
              temp = val;
            }
          }

          if (temp != null) {
            value.nearbyShopList!.remove(temp);
            List<StoreListDataModel> list = [temp, ...value.nearbyShopList ?? []];
            value.nearbyShopList = list;
          }
        }
      }

      state.storeListEntity = value;

      /// 如果有选中门店则将门店位置信息保存，在无定位权限时地图显示该位置
      if (param.isChangeCity) {
        List<StoreListDataModel>? oftenUsedShopList = value.oftenUsedShopList;
        List<StoreListDataModel>? nearbyShopList = value.nearbyShopList;
        StoreListDataModel? centerModel;

        if (nearbyShopList != null && nearbyShopList.isNotEmpty) {
          for (StoreListDataModel m in nearbyShopList) {
            if (currentShop == null) {
              if (m.isCenterCity ?? false) {
                centerModel = m;
              }
              if (m.shopMdCode == state.shopMdCode) {
                centerModel = m;
              }
            }
          }
        }

        if (oftenUsedShopList != null && oftenUsedShopList.isNotEmpty) {
          for (StoreListDataModel m in oftenUsedShopList) {
            if (currentShop == null) {
              if (m.isCenterCity ?? false) {
                centerModel = m;
              }
              if (m.shopMdCode == state.shopMdCode) {
                centerModel = m;
              }
            }
          }
        }

        if (nearbyShopList != null && nearbyShopList.isNotEmpty) {
          for (StoreListDataModel m in nearbyShopList) {
            if (currentShop == null) {
              if (m.shopMdCode == state.shopMdCode) {
                centerModel = m;
              }
            }
          }
        }

        if (oftenUsedShopList != null && oftenUsedShopList.isNotEmpty) {
          for (StoreListDataModel m in oftenUsedShopList) {
            if (currentShop == null) {
              if (m.shopMdCode == state.shopMdCode) {
                centerModel = m;
              }
            }
          }
        }

        if (centerModel != null) {
          centerModel.selected = true;
        }
      }
      // logI('请求的数据：${state.storeListEntity?.toJson()}');
      emit(state.copy()..shopListLoading = false);

      logI('shopList的emit已发出');
    }).catchError((_){
      logI("in StoreApi.getShopList action !!!");
    });
  }

  _focusCodeHasFocus(StoreListFocusCodeChagneEvent event, emit) {
    if (event.hasFocus) {
      state.shopListTop = 88.h;
    } else {
      state.shopListTop = 812.h / 2.0;
    }

    emit(state.copy());
  }

  _searchShop(StoreListSearchShopEvent event, emit) async {
    logI('准备搜索:${event.shopMdName}');
    if (event.shopMdName != null) {
      logI('开始搜索:${event.shopMdName}');
      if (event.isClearShopMdName!) {
        state.shopListTop = 812.h / 2.0;
        emit(state.copy());
      }
      state.shopMdName = event.shopMdName;
      ShopListParam param = ShopListParam();
      param.shopMdName = state.shopMdName;
      param.cityMdCode = Constant.cityDataEntity.cityMdCode;
      if (event.shopMdName == '') {
        if (state.centerLatitude != null && state.centerLatitude != 0) {
          param.latitude = state.centerLatitude;
          param.longitude = state.centerLongitude;
        } else if (state.locationResult?.positionInfoEntity?.latitude != null &&
            state.locationResult?.positionInfoEntity?.latitude != 0) {
          param.latitude = state.locationResult?.positionInfoEntity?.latitude;
          param.longitude = state.locationResult?.positionInfoEntity?.longitude;
        }
      }

      await _getStoreList(param, emit);
    }
  }

  _changeStoreListTopDistance(StoreListChangeTopDistanceEvent event, emit) {
    state.shopListTop += event.topDistance;
    emit(state.copy());
  }
}
