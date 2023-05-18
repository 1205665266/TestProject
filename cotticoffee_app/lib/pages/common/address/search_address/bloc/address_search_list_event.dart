part of 'address_search_list_bloc.dart';

abstract class AddressSearchListEvent {}

class InitEvent extends AddressSearchListEvent {}

class RequestSearchAddressListEvent extends AddressSearchListEvent {
  final String text;
  RequestSearchAddressListEvent(this.text);
}

class SelectedPoiAddressEvent extends AddressSearchListEvent {
  final PoiAddressData poi;
  final BuildContext context;
  SelectedPoiAddressEvent(this.poi,this.context);
}