abstract class MenuEvent {}

class MenuListEvent extends MenuEvent {
  final List<int>? takeFoodModes;
  final int? shopMdCode;
  final bool showLoading;

  MenuListEvent(this.takeFoodModes, this.shopMdCode, {this.showLoading = false});
}

class ShowLoadingEvent extends MenuEvent {
  final bool showLoading;
  final bool firstGetShopInfo;

  ShowLoadingEvent(this.showLoading, this.firstGetShopInfo);
}

class SaleOutOpenStateEvent extends MenuEvent {
  //一级标题key
  final String id;

  //是否展开 true展开，false 收起
  final bool isOpen;

  SaleOutOpenStateEvent(this.id, this.isOpen);
}
