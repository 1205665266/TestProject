part of 'city_list_bloc.dart';

class CityListState {
  ///定位到的信息
  LocationResult? locationResult;

  LocationStatusEnum locationStatus = LocationStatusEnum.positioning;

  bool? isLocationPermission;
  List<CityListDataData> cityList = [];

  CityListDataData? currentLocationCityModel;

  /// 搜索结果列表
  List<CityListDataData> searchList = [];

  CityListState init() {
    return CityListState()
      ..locationResult = null
      ..locationStatus = LocationStatusEnum.positioning
      ..isLocationPermission = null
      ..currentLocationCityModel = null
      ..cityList = []
      ..searchList = [];
  }

  CityListState copy() {
    return CityListState()
      ..locationResult = locationResult
      ..locationStatus = locationStatus
      ..isLocationPermission = isLocationPermission
      ..currentLocationCityModel = currentLocationCityModel
      ..cityList = cityList
      ..searchList = searchList;
  }
}
