part of 'store_bloc.dart';

abstract class StoreEvent {}

class CurrShopEvent extends StoreEvent {
  int? shopMdCode;

  CurrShopEvent(this.shopMdCode);
}

class InitFromPageEvent extends StoreEvent {
  bool isFromConfirm;

  InitFromPageEvent(this.isFromConfirm);
}

class StoreListEvent extends StoreEvent {
  final BuildContext context;

  StoreListEvent(this.context);
}

class StoreListMapMoveEvent extends StoreEvent {
  double? latitude;
  double? longitude;

  StoreListMapMoveEvent(this.latitude, this.longitude);
}

class StoreListChangeCityEvent extends StoreEvent {

  final BuildContext context;

  CityListDataData? cityModel;

  StoreListChangeCityEvent(this.cityModel, {required this.context});
}

class StoreListFocusCodeChagneEvent extends StoreEvent {
  bool hasFocus;

  StoreListFocusCodeChagneEvent(this.hasFocus);
}

class StoreListSearchShopEvent extends StoreEvent {
  String? shopMdName;
  bool? isClearShopMdName;

  StoreListSearchShopEvent(this.shopMdName, {this.isClearShopMdName = false});
}

class StoreListChangeTopDistanceEvent extends StoreEvent {
  double topDistance;

  StoreListChangeTopDistanceEvent(this.topDistance);
}

class StoreArrowChangeEvent extends StoreEvent {}
