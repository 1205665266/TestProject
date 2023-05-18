part of 'address_search_bloc.dart';

@immutable
abstract class AddressSearchEvent {}


class InitEvent extends AddressSearchEvent {
  final BuildContext context;

  InitEvent({required this.context});
}

class RequestCityInfoEvent extends AddressSearchEvent {
  Function? cityInfoCallBack;
  RequestCityInfoEvent({this.cityInfoCallBack});
}

class SwitchCityEvent extends AddressSearchEvent {
  final CityListDataData city;
  SwitchCityEvent(this.city);
}

class RequestSearchAddressList extends AddressSearchEvent {
  final double? lat;
  final double? lng;
  RequestSearchAddressList({this.lat,this.lng});
}

class SelectedPoiAddressEvent extends AddressSearchEvent {
  final PoiAddressData poi;
  SelectedPoiAddressEvent(this.poi);
}

class ConfirmPoiAddressEvent extends AddressSearchEvent {
  final BuildContext context;
  ConfirmPoiAddressEvent(this.context);
}