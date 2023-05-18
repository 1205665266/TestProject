part of 'city_search_bloc.dart';

@immutable
abstract class CitySearchState {}

class CitySearchStateUpdate extends CitySearchState {
  CitySearchStateUpdate(
      {this.searchContent = '', this.isClearShow = false, this.isCancelShow = false});

  final String searchContent;

  final bool isClearShow;

  final bool isCancelShow;

  @override
  List<Object> get props => [searchContent, isClearShow, isCancelShow];
}
