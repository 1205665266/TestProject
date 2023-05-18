import 'dart:math';

import 'package:cotti_client/pages/tabs/menu/entity/menu_item_entity.dart';
import 'package:cotti_client/pages/tabs/menu/search/entity/item_label_model.dart';
import 'package:cotti_client/pages/tabs/menu/search/entity/search_label.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchState  {
  ItemLabelModel itemLabelModel = ItemLabelModel();

  List<SearchLabel> historyList = [];

  ///热门推荐
  List<SearchLabel> get itemLabelList =>
      itemLabelModel.itemLabelList?.map((e) {
        SearchLabel searchLabel = SearchLabel();
        searchLabel.itemId = "${e.itemId}";
        searchLabel.labelText = e.itemName;
        searchLabel.type = e.itemLabel;
        searchLabel.itemNo = e.itemNo;
        searchLabel.isCuisines = false;
        return searchLabel;
      }).toList() ??
          [];

  SearchLabel get getDefaultLabel {
    if(defaultLabel.labelText?.isEmpty??true) {
      if(itemLabelList.isEmpty) {
        return SearchLabel();
      }
      int index = Random().nextInt(itemLabelList.length);
      defaultLabel = itemLabelList[index];

    }
    return defaultLabel;


  }

  int pageSize = 20;
  int pageNum = 0;
  List<MenuItemEntity> itemData = [];
  LoadStatus loadStatus = LoadStatus.idle;
  SearchLabel defaultLabel = SearchLabel();
  int requestTimeStamp = 0;

  SearchState copy() {
    return SearchState()
      ..itemLabelModel = itemLabelModel
      ..historyList = historyList
      ..itemData = itemData
      ..pageNum = pageNum
      ..pageSize = pageSize
      ..defaultLabel = defaultLabel
      ..loadStatus = loadStatus
      ..requestTimeStamp = requestTimeStamp;

  }

}
