import 'dart:async';
import 'dart:io';

import 'package:azlistview/azlistview.dart';
import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/common/city/api/city_api.dart';
import 'package:cotti_client/sensors/store_sensors_constant.dart';
import 'package:cotti_client/service/location/location_result.dart';
import 'package:cotti_client/service/location/location_service.dart';
import 'package:cotticommon/router/fluro_navigator.dart';
import 'package:cotticommon/utils/log_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import '../../../../config/constant.dart';
import '../../../../utils/location_utils.dart';
import '../entity/city_list_data_entity.dart';
import '../enum/location_status_enum.dart';

part 'city_list_event.dart';

part 'city_list_state.dart';

class CityListBloc extends Bloc<CityListEvent, CityListState> {
  CityListBloc() : super(CityListState()) {
    on<InitEvent>(_init);
    on<PopStoreListPageEvent>(_popStoreListPage);
    on<RequestLocationPermissionEvent>(_onRequestLocationPermission);
    on<RequestCurrentLocationCityInfoEvent>(_onRequestCurrentLocationCityInfo);
    on<RequestCityListEvent>(_onRequestCityList);
    on<RelocationEvent>(_onRelocation);
    on<CityListSearchEvent>(_onSearch);
  }

  void _init(InitEvent event, emit) async {
    await LocationService()
        .startLocation(event.context)
        .then((value) => state.locationResult = value)
        .catchError((onError) => logI("定位失败$onError"));
    var status = await Permission.location.status;
    // if(status == PermissionStatus.granted){
    //   state.locationStatus = LocationStatusEnum.success;
    // }
    if (state.locationResult?.errorCode == 0) {
      await CityApi.getCity(
              latitude: state.locationResult?.positionInfoEntity?.latitude,
              longitude: state.locationResult?.positionInfoEntity?.longitude)
          .then((value) {
        // logI("_onRequestCurrentLocationCityInfo---> $value");
        // logI("_onRequestCurrentLocationCityInfo---> ${value?.toJson()}");
        state.locationStatus = value == null ? LocationStatusEnum.fail : LocationStatusEnum.success;
        emit(state.copy()..currentLocationCityModel = value);
      }, onError: (error) {
        state.locationStatus = LocationStatusEnum.fail;
        emit(state.copy());
        logI("_onRequestCurrentLocationCityInfoError---> $error");
        // logI("$error _onRequestCurrentLocationCityInfo---> - error');
      });
    }else {
      SensorsAnalyticsFlutterPlugin.track(
          StoreSensorsConstant.cityListlocationAlertShow, {});
    }
  }

  void _onRequestCurrentLocationCityInfo(
      RequestCurrentLocationCityInfoEvent event, Emitter<CityListState> emit) async {
    await CityApi.getCity(
            latitude: state.locationResult?.positionInfoEntity?.latitude,
            longitude: state.locationResult?.positionInfoEntity?.longitude)
        .then((value) {
      // logI("_onRequestCurrentLocationCityInfo---> $value");
      // logI("_onRequestCurrentLocationCityInfo---> ${value?.toJson()}");
      state.locationStatus = value == null ? LocationStatusEnum.fail : LocationStatusEnum.success;
      emit(state.copy()..currentLocationCityModel = value);
    }, onError: (error) {
      state.locationStatus = LocationStatusEnum.fail;
      emit(state.copy());
      logI("_onRequestCurrentLocationCityInfoError---> $error");
      // logI("$error _onRequestCurrentLocationCityInfo---> - error');
    });
  }

  void _onRequestCityList(RequestCityListEvent event, Emitter<CityListState> emit) async {
    List<CityListDataData> cityList = [];

    await CityApi.cityList(isAll: event.isAll,fromConfirm: event.fromConfirm).then((value) {
      cityList = value.data ?? [];
      _handleList(cityList);
      emit(state.copy()..cityList = cityList);
    });
  }

  void _handleList(List<CityListDataData> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = list[i].cityPinyin!;
      String tag = pinyin.substring(0, 1).toUpperCase();
      if (RegExp('[A-Z]').hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = '#';
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(list);

    /// 根据 cityPinyin 字段tagIndex内部排序；
    list.sort((a, b) {
      if (a.tagIndex == b.tagIndex) {
        return (a.cityPinyin??'').compareTo(b.cityPinyin??'');
      } else {
        return a.tagIndex!.compareTo(b.tagIndex!);
      }
    });

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(list);
  }

  void _onRelocation(RelocationEvent event, Emitter<CityListState> emit) async {
    logI("locationMap");

    bool hasLocationPermission = await LocationUtils.requestLocationPermission();
    if (hasLocationPermission) {
      await LocationService()
          .startLocation(event.context)
          .then((value) => state.locationResult = value)
          .catchError((onError) => logI("定位失败$onError"));
      var status = await Permission.location.status;
      // if(status == PermissionStatus.granted){
      //   state.locationStatus = LocationStatusEnum.success;
      // }
      if (state.locationResult?.errorCode == 0) {
        await CityApi.getCity(
                latitude: state.locationResult?.positionInfoEntity?.latitude,
                longitude: state.locationResult?.positionInfoEntity?.longitude)
            .then((value) {
          // logI("_onRequestCurrentLocationCityInfo---> $value");
          // logI("_onRequestCurrentLocationCityInfo---> ${value?.toJson()}");
          state.locationStatus =
              value == null ? LocationStatusEnum.fail : LocationStatusEnum.success;
          emit(state.copy()..currentLocationCityModel = value);
        }, onError: (error) {
          state.locationStatus = LocationStatusEnum.fail;
          emit(state.copy());
          logI("_onRequestCurrentLocationCityInfoError---> $error");
          // logI("$error _onRequestCurrentLocationCityInfo---> - error');
        });
      }
    } else {
      showCupertinoDialog(
          context: event.context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('定位服务未开启'),
              content: const Text('请在系统设置->隐私->定位服务中打开开关，并允许库迪咖啡使用定位服务'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('取消'),
                  onPressed: () {
                    NavigatorUtils.pop(context);
                    state.locationStatus = LocationStatusEnum.fail;
                    emit(state.copy());
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('去开启'),
                  onPressed: () async {
                    if (Platform.isIOS) {
                      if (await Permission.location.isPermanentlyDenied) {
                        openAppSettings();
                      }
                    } else {
                      if (await Permission.location.isDenied) {
                        openAppSettings();
                      }
                    }
                    NavigatorUtils.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  void _onRequestLocationPermission(
      RequestLocationPermissionEvent event, Emitter<CityListState> emit) async {
    bool isLocationPermission = await LocationUtils.requestLocationPermission();
    // ABiteLog.w('$isLocationPermission', tag: '_onRequestLocationPermission');
    emit(state.copy()..isLocationPermission = isLocationPermission);
  }

  ///回到门店列表页面
  void _popStoreListPage(PopStoreListPageEvent event, Emitter<CityListState> emit) {
    // ABiteLog.w(event.context, tag: 'popStoreListPage');
    NavigatorUtils.pop(event.context, result: event.cityModel);
  }

  _onSearch(CityListSearchEvent event, emit) {
    if(event.searchCode.isEmpty) {
      emit(state.copy()..searchList = []);
      return;
    }
    List<CityListDataData> list = [];

    for (CityListDataData city in state.cityList) {
      String cityName = city.cityName ?? "";

      if (cityName.contains(event.searchCode)) {
        list.add(city);
      }
    }

    state.searchList = list;

    emit(state.copy());
  }
}
