import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/pages/tabs/menu/search/bloc/search_event.dart';
import 'package:cotti_client/pages/tabs/menu/search/bloc/search_state.dart';
import 'package:cotti_client/pages/tabs/menu/search/entity/search_label.dart';
import 'package:cotti_client/pages/tabs/menu/search/api/search_api.dart';
import 'package:cotti_client/pages/tabs/menu/search/entity/search_param.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState()) {
    on<InitHistorySearchEvent>(_initHistorySearch);
    on<SaveHistoryEvent>(_saveSearch);
    on<DeleteHistoryEvent>(_deleteHistory);

    on<SearchLabelEvent>(_searchLabel);
    on<LoadingMoreEvent>(_onLoadMore);
    on<ClearSearchDataEvent>(_clearSearchData);
  }

  _clearSearchData(ClearSearchDataEvent event, emit) {

    emit(state.copy()..itemData = []);
  }



  _saveSearch(SaveHistoryEvent event, emit) async {
    SearchLabel newLabel = event.searchLabel;
    state.historyList.removeWhere((element) => element.labelText == newLabel.labelText);
    state.historyList.insert(0, event.searchLabel);
    if (state.historyList.length > 8) {
      state.historyList = state.historyList.sublist(0, 8);
    }
    await SearchApi.saveHistory(state.historyList);
    emit(state.copy());
  }

  _initHistorySearch(event, emit) async {
    List<SearchLabel> list = await SearchApi.getHistory();
    state.historyList = list;
    emit(state.copy());
    await SearchApi.getSearchPageContent(event.shopMdCode, event.takeFoodMode).then((value) {
      state.itemLabelModel = value;
      emit(state.copy());
    });
  }

  _deleteHistory(event, emit) async {
    bool isSuccess = await SearchApi.clearHistory();
    if (isSuccess) {
      state.historyList = [];
      emit(state.copy());
    }
  }

  void _searchLabel(SearchLabelEvent event, emit) async {
    state.pageNum = 0;
    state.itemData.clear();
    state.requestTimeStamp = event.requestTimeStamp;
    await _search(event.shopMdCode, event.takeFoodMode, event.label, emit, event.requestTimeStamp);
  }

  void _onLoadMore(LoadingMoreEvent event, emit) async {
    state.requestTimeStamp = event.requestTimeStamp;
    await _search(event.shopMdCode, event.takeFoodMode, event.label, emit, event.requestTimeStamp);
  }

  _search(int shopMdCode, int takeFoodMode, SearchLabel label, emit, int requestTimeStamp) async {
    SearchParam param = SearchParam(
      shopMdCode: shopMdCode,
      pageNum: state.pageNum + 1,
      pageSize: state.pageSize,
      itemName: label.labelText,
      takeFoodMode: takeFoodMode,
    );
    state.loadStatus = LoadStatus.loading;
    emit(state.copy());
    await SearchApi.getItemPageSearch(param).then((value) {
      if (value.isNotEmpty ) {
        if(requestTimeStamp == state.requestTimeStamp) {
          state.pageNum++;
          state.itemData.addAll(value);
          state.loadStatus = value.length < 20 ? LoadStatus.noMore : LoadStatus.idle;
        }
      } else {
        state.loadStatus = LoadStatus.noMore;
      }
    }).onError((error, stackTrace) {
      state.loadStatus = LoadStatus.failed;
    });
    emit(state.copy());
  }
}
