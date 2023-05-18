abstract class ProductEvent {}

class QueryProductInfoEvent extends ProductEvent {
  final String itemNo;
  final int shopMdCode;
  final int takeFoodMode;
  final List businessTypes;
  final String? defaultSkuCode;

  QueryProductInfoEvent(this.itemNo, this.shopMdCode, this.takeFoodMode, this.businessTypes,
      {this.defaultSkuCode});
}

class SelectSpecItemEvent extends ProductEvent {
  final int specListIdx;
  final String specItemVal;
  final int shopMdCode;
  final int takeFoodMode;
  final List? businessTypes;

  SelectSpecItemEvent(
      this.specListIdx, this.specItemVal, this.shopMdCode, this.takeFoodMode, this.businessTypes);
}

class ResetSpecEvent extends ProductEvent {
  ResetSpecEvent();
}

class InitBuyNumberEvent extends ProductEvent {
  final int num;

  InitBuyNumberEvent(this.num);
}

class ChangeBuyNumberEvent extends ProductEvent {
  final bool isAdd;

  ChangeBuyNumberEvent(this.isAdd);
}
