import 'package:cotti_client/pages/tabs/menu/entity/menu_classify.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_config_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_head.dart';

class MenuState {
  List<MenuHead> menuHeads = [];
  MenuConfigEntity? menuConfig;
  List<MenuClassify>? test;

  //记录售罄的标题下的id，展开就添加，收起就移除
  List<String> saleOutOpenStateList = [];
  bool showLoading = true;
  bool goodsEmpty = false;
  bool showLoadingBackground = true;
  int menuUpdateTimeStamp = 0;

  MenuState copy({
    bool? showLoading,
    int? menuUpdateTimeStamp,
    bool? showLoadingBackground,
  }) {
    return MenuState()
      ..menuHeads = menuHeads
      ..goodsEmpty = goodsEmpty
      ..menuConfig = menuConfig
      ..showLoadingBackground = showLoadingBackground ?? this.showLoadingBackground
      ..showLoading = showLoading ?? this.showLoading
      ..menuUpdateTimeStamp = menuUpdateTimeStamp ?? this.menuUpdateTimeStamp
      ..saleOutOpenStateList = saleOutOpenStateList;
  }
}
