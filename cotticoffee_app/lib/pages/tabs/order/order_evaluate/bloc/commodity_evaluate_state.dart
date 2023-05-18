part of 'commodity_evaluate_bloc.dart';

class CommodityEvaluateState {
  CommodityEvaluateState();

  static CommodityEvaluateState init() {
    return CommodityEvaluateState()
      ..data = null
      ..satisfiedOptions = []
      ..unsatisfiedOptions = []
      ..goodsSatisfiedMinStarCount = 4
      ..ranting = 0
      ..selectedSatisfiedOptions = []
      ..evaluateMessage = ''
      ..selectAssets = [];
  }

  late EvaluateConfigOrderItemList? data;
  late List<String> satisfiedOptions;
  late List<String> unsatisfiedOptions;
  late int goodsSatisfiedMinStarCount;

  late int ranting;
  late List<String> selectedSatisfiedOptions;
  late String evaluateMessage;
  late List<AssetEntity> selectAssets;
  late bool showDottedLine;

  CommodityEvaluateState copy() {
    return CommodityEvaluateState()
      ..data = data
      ..satisfiedOptions = satisfiedOptions
      ..unsatisfiedOptions = unsatisfiedOptions
      ..goodsSatisfiedMinStarCount = goodsSatisfiedMinStarCount
      ..ranting = ranting
      ..selectedSatisfiedOptions = selectedSatisfiedOptions
      ..evaluateMessage = evaluateMessage
      ..selectAssets = selectAssets;
  }

}

class CommodityEvaluateInitial extends CommodityEvaluateState {
  @override
  List<Object> get props => [];
}
