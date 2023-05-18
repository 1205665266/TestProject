part of 'address_search_list_bloc.dart';

class AddressSearchListState {
  late List<PoiAddressData> addresses;
  late CityListDataData selectedCityModel; //选择城市信息
  AddressSearchListState init() {
    return AddressSearchListState()
      ..addresses = []
      ..selectedCityModel = CityListDataData();
  }

  AddressSearchListState clone() {
    return AddressSearchListState()
      ..addresses = addresses
      ..selectedCityModel = selectedCityModel;
  }
}