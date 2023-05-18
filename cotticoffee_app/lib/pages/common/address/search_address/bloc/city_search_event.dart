part of 'city_search_bloc.dart';

@immutable
abstract class CitySearchEvent {
  const CitySearchEvent();

  @override
  List<Object> get props => [];
}


class SearchEventUpdate extends CitySearchEvent {
  const SearchEventUpdate(
      {this.searchContent = '', this.isClearShow = false, this.isCancelShow = false});

  final String searchContent;
  final bool isClearShow;
  final bool isCancelShow;

  @override
  List<Object> get props => [searchContent, isClearShow, isCancelShow];
}