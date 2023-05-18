part of 'address_search_bloc.dart';

class AddressSearchState {

  late CityListDataData selectedCityModel; //选择城市信息
  late List<PoiAddressData> addresses; //搜索地址列表
  late PoiAddressData selectedAddress; //选中地址
  late double selectedLatitude;
  late double selectedLongitude;
  late double? lat;
  late double? lng;
  late bool hasLocationCityCenter;

  /// 用于标记为移动到选中项
  bool moveToSelected = false;

  ///定位到的信息
  LocationResult? locationResult;

  AddressSearchState init() {
    return AddressSearchState()
      ..selectedCityModel = CityListDataData()
      ..selectedLatitude = 39.909187
      ..selectedLongitude = 116.397451
      ..selectedAddress = PoiAddressData()
      ..addresses = []
      ..lat = null
      ..lng = null
      ..locationResult = null
    ..moveToSelected = false
      ..hasLocationCityCenter = false;
  }

  AddressSearchState copy() {
    return AddressSearchState()
      ..selectedLatitude = selectedLatitude
      ..selectedLongitude = selectedLongitude
      ..selectedAddress = selectedAddress
      ..selectedCityModel = selectedCityModel
      ..addresses = addresses
      ..lat = lat
      ..lng = lng
      ..locationResult = locationResult
      ..moveToSelected = moveToSelected
      ..hasLocationCityCenter = hasLocationCityCenter;
  }
}
