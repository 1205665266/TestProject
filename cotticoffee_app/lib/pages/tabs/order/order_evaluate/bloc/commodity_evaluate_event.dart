part of 'commodity_evaluate_bloc.dart';

abstract class CommodityEvaluateEvent {}

class CommodityInitEvent extends CommodityEvaluateEvent {
  final EvaluateConfigOrderItemList data;
  final List<String> satisfiedOptions;
  final List<String> unsatisfiedOptions;
  final int goodsSatisfiedMinStarCount;
  CommodityInitEvent(this.data, this.satisfiedOptions, this.unsatisfiedOptions,
      this.goodsSatisfiedMinStarCount);
}

class CommodityRantingSelectedEvent extends CommodityEvaluateEvent {
  final int ranting;
  CommodityRantingSelectedEvent(this.ranting);
}

class CommoditySatisfiedOptionsSelectedEvent extends CommodityEvaluateEvent {
  final List<String> selectedOptions;
  CommoditySatisfiedOptionsSelectedEvent(this.selectedOptions);
}

class CommodityEditEvaluateMessageEvent extends CommodityEvaluateEvent {
  final String evaluateMessage;
  CommodityEditEvaluateMessageEvent(this.evaluateMessage);
}

class CommodityEditAssetsEvent extends CommodityEvaluateEvent {
  final List<AssetEntity> selectAssets;
  CommodityEditAssetsEvent(this.selectAssets);
}