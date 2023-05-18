import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'city_search_event.dart';
part 'city_search_state.dart';

class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState> {
  CitySearchBloc() : super(CitySearchStateUpdate()) {
    on<SearchEventUpdate>(_searchEventUpdate);
  }

  _searchEventUpdate(SearchEventUpdate event, Emitter<CitySearchState> emit) async {
    if (state is CitySearchStateUpdate) {
      emit(CitySearchStateUpdate(
          searchContent: event.searchContent,
          isClearShow: event.isClearShow,
          isCancelShow: event.isCancelShow));
    }
  }
}
