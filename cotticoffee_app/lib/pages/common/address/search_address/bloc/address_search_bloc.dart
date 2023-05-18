import 'package:bloc/bloc.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/common/address/search_address/entity/city_list_model.dart';
import 'package:cotti_client/pages/common/address/search_address/entity/poi_address_model.dart';
import 'package:cotti_client/pages/common/city/api/city_api.dart';
import 'package:cotti_client/pages/common/city/entity/city_list_data_entity.dart';
import 'package:cotti_client/service/location/location_result.dart';
import 'package:cotti_client/service/location/location_service.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

part 'address_search_event.dart';

part 'address_search_state.dart';

class AddressSearchBloc extends Bloc<AddressSearchEvent, AddressSearchState> {
  AddressSearchBloc() : super(AddressSearchState().init()) {
    on<InitEvent>(_init);
    on<RequestCityInfoEvent>(_onRequestCityInfo);
    on<SwitchCityEvent>(_onSwitchCity);
    on<RequestSearchAddressList>(_onRequestSearchAddressList);
    on<SelectedPoiAddressEvent>(_onSelectedPoiAddress);
    on<ConfirmPoiAddressEvent>(_onConfirmPoiAddress);
  }

  void _init(InitEvent event, Emitter<AddressSearchState> emit) async {
    logW("_init");

    /// 开启定位
    await LocationService().startLocation(event.context).then((LocationResult value) {
      state.locationResult = value;
      if (value.errorCode == 0) {
        state.selectedLatitude = value.positionInfoEntity!.latitude!;
        state.selectedLongitude = value.positionInfoEntity!.longitude!;
        state.lat = value.positionInfoEntity!.latitude!;
        state.lng = value.positionInfoEntity!.longitude!;
        state.moveToSelected = true;
      }
      LocationService().stopLocation();
      add(
        RequestCityInfoEvent(cityInfoCallBack: () {
          add(RequestSearchAddressList());
        }),
      );
      emit(state.copy());
    }).catchError((onError) => logI("定位失败$onError"));
  }

  void _onRequestCityInfo(RequestCityInfoEvent event, Emitter<AddressSearchState> emit) async {
    logI("_onRequestCityInfo--->");

    await CityApi.getCity(latitude: state.lat, longitude: state.lng, defaultCity: true).then((
        value) {
      logI("_onRequestCityInfo---> $value");
      logI("_onRequestCityInfo---> ${value.toJson()}");
      // 返回默认城市
      if (value.cityPinyin != null) {
        Map<String, dynamic>? userSelectedCity =
        SpUtil.getObject('userSelectedCity') as Map<String, dynamic>?;
        logI("_onRequestCityInfo---> $value userSelectedCity");
        // 用户没有选择过城市
        logI("_onRequestCityInfo---> $value userSelectedCity-false");
        emit(state.copy()
          ..selectedCityModel = value);
        if (event.cityInfoCallBack != null) {
          event.cityInfoCallBack!();
        }
      } else {
        // 定位点城市中台有城市
        logI("_onRequestCityInfo---> $value userSelectedCity-false");
        emit(state.copy()
          ..selectedCityModel = value);
        if (event.cityInfoCallBack != null) {
          event.cityInfoCallBack!();
        }
      }
    }).catchError((error) {
      logI("_onRequestCityInfo---> -error $error");
    });

    /*
    await CityApi.getCityInfo({
      "longitude": state.lng ?? Constant.longitude,
      "latitude": state.lat ?? Constant.latitude,
      "defaultCity": true
    }).then((value) {
      logI("_onRequestCityInfo---> $value");
      logI("_onRequestCityInfo---> ${value!.toJson()}");
      // 返回默认城市
      if (value.cityPinyin != null) {
        Map<String, dynamic>? userSelectedCity =
        SpUtil.getObject('userSelectedCity') as Map<String, dynamic>?;
        logI("_onRequestCityInfo---> $value userSelectedCity");
        // 用户没有选择过城市
        logI("_onRequestCityInfo---> $value userSelectedCity-false");
        emit(state.clone()..selectedCityModel = value);
        if (event.cityInfoCallBack != null) {
          event.cityInfoCallBack!();
        }
      } else {
        // 定位点城市中台有城市
        logI("_onRequestCityInfo---> $value userSelectedCity-false");
        emit(state.clone()..selectedCityModel = value);
        if (event.cityInfoCallBack != null) {
          event.cityInfoCallBack!();
        }
      }
    }, onError: (error) {
      logI("_onRequestCityInfo---> -error $error");
    });
    */
  }

  void _onSwitchCity(SwitchCityEvent event, Emitter<AddressSearchState> emit) {
    emit(state.copy()..selectedCityModel = event.city);
  }

  ///搜索周边地址
  static const String addressAroundUrl = "/address/around";

  void _onRequestSearchAddressList(RequestSearchAddressList event,
      Emitter<AddressSearchState> emit) async {
    await CottiNetWork().post(addressAroundUrl, data: {
      'hasLocationCityCenter': state.hasLocationCityCenter,
      'lat': state.lat ?? 0,
      'lng': state.lng ?? 0,
      'cityAdName': state.selectedCityModel.cityName
    }).then((value) {
      PoiAddressModel model = PoiAddressModel.fromJson({"data": value});
      emit(state.copy()
        ..addresses = model.data
        ..selectedLongitude = model.data.first.lng
        ..selectedLatitude = model.data.first.lat
        ..selectedAddress = model.data.first);
    }).catchError((error) {
      logW("error -- $error");
    });

    // await HttpClient.post(AddressApi.addressAroundUrl, params: {
    //   'hasLocationCityCenter': state.hasLocationCityCenter,
    //   'lat': state.lat ?? Constant.latitude ?? 0,
    //   'lng': state.lng ?? Constant.longitude ?? 0,
    //   'cityAdName': state.selectedCityModel.cityName
    // }).then((response) {
    //   logI("$response _onRequestSearchAddressList");
    //   if (response != null) {
    //     PoiAddressModel model =
    //     PoiAddressModel.fromJson({"data": response.data});
    //     emit(state.clone()
    //       ..addresses = model.data
    //       ..selectedLongitude = model.data.first.lng
    //       ..selectedLatitude = model.data.first.lat
    //       ..selectedAddress = model.data.first);
    //   }
    // }).catchError((dynamic error) {});
  }

  void _onSelectedPoiAddress(SelectedPoiAddressEvent event, Emitter<AddressSearchState> emit) {
    emit(state.copy()
      ..selectedLongitude = event.poi.lng
      ..selectedLatitude = event.poi.lat
      ..moveToSelected = true
      ..selectedAddress = event.poi);
  }

  void _onConfirmPoiAddress(ConfirmPoiAddressEvent event, Emitter<AddressSearchState> emit) {
    NavigatorUtils.pop(event.context, result: state.selectedAddress);
  }
}
