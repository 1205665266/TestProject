import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/common/address/search_address/entity/poi_address_model.dart';
import 'package:cotti_client/pages/common/city/entity/city_list_data_entity.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';

part 'address_search_list_event.dart';
part 'address_search_list_state.dart';

class AddressSearchListBloc extends Bloc<AddressSearchListEvent, AddressSearchListState> {
  AddressSearchListBloc() : super(AddressSearchListState().init()) {
    on<InitEvent>(_init);
    on<RequestSearchAddressListEvent>(_onRequestSearchAddressList);
    on<SelectedPoiAddressEvent>(_onSelectedPoiAddressEvent);
  }


  void _init(InitEvent event, Emitter<AddressSearchListState> emit) async {
    emit(state.clone());
  }

  ///搜索地址列表
  static const String addressSearchUrl = "/address/search";

  void _onRequestSearchAddressList(RequestSearchAddressListEvent event, emit) async {
    emit(state.clone()..addresses = []);
    if (event.text == "") return;
    await CottiNetWork().post(addressSearchUrl, data: {
      'adCode': state.selectedCityModel.cityName,
      'keyword': event.text,
    }).then((response) {
      logW("_onRequestSearchAddressList then");
      if (response != null) {
        logW("_onRequestSearchAddressList response != $response");
        PoiAddressModel model =
        PoiAddressModel.fromJson({"data": response});
        logW("_onRequestSearchAddressList response PoiAddressModel= ${model.data}");
        state.addresses = model.data;
        // emit(state.clone()..addresses = model.data);
      }
    }).catchError((dynamic error) {});
    emit(state.clone());
  }

  void _onSelectedPoiAddressEvent(
      SelectedPoiAddressEvent event, Emitter<AddressSearchListState> emit) {
    NavigatorUtils.pop(event.context, result: event.poi);
    NavigatorUtils.pop(event.context, result: event.poi);
  }

}
