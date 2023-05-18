part of 'city_list_bloc.dart';


abstract class CityListEvent {

}


class InitEvent extends CityListEvent {
  BuildContext context;
  InitEvent(this.context);
}

class RequestCurrentLocationCityInfoEvent extends CityListEvent {
   Function? cityInfoCallBack;
  RequestCurrentLocationCityInfoEvent({this.cityInfoCallBack});
}

/// 请求城市列表
class RequestCityListEvent extends CityListEvent {
   bool isAll;
   bool fromConfirm;
  RequestCityListEvent(this.isAll,this.fromConfirm);
}


/// 重新定位
class RelocationEvent extends CityListEvent {

  BuildContext context;
  RelocationEvent(this.context);
}

class RequestLocationPermissionEvent extends CityListEvent {
  RequestLocationPermissionEvent();
}

class PopStoreListPageEvent extends CityListEvent {
 final BuildContext context;
  CityListDataData cityModel;
  PopStoreListPageEvent(this.context,{required this.cityModel});
}

class CityListSearchEvent extends CityListEvent {
  final String searchCode;

  CityListSearchEvent({required this.searchCode});
}
