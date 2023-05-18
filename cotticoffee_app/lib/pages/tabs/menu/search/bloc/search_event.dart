import 'package:cotti_client/pages/tabs/menu/search/entity/search_label.dart';

abstract class SearchEvent {}

class SaveHistoryEvent extends SearchEvent {
  final SearchLabel searchLabel;

  SaveHistoryEvent(this.searchLabel);
}

class InitHistorySearchEvent extends SearchEvent {
  int shopMdCode;
  int takeFoodMode;

  InitHistorySearchEvent(this.shopMdCode, this.takeFoodMode);
}

class DeleteHistoryEvent extends SearchEvent {}

class SearchLabelEvent extends SearchEvent {
  SearchLabel label;
  int takeFoodMode;
  int shopMdCode;
  int requestTimeStamp;

  SearchLabelEvent(this.label, this.shopMdCode, this.takeFoodMode, this.requestTimeStamp);
}

class LoadingMoreEvent extends SearchEvent {
  SearchLabel label;
  int takeFoodMode;
  int shopMdCode;
  int requestTimeStamp;

  LoadingMoreEvent(this.label, this.shopMdCode, this.takeFoodMode, this.requestTimeStamp);
}

class ClearSearchDataEvent extends SearchEvent {
  ClearSearchDataEvent();
}
