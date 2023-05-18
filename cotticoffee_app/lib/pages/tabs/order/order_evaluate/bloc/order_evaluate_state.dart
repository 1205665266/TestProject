part of 'order_evaluate_bloc.dart';

class OrderEvaluateState {
  late String? orderId;
  late bool canComment;
  late bool isEvaluateSuccess;
  bool showLoading = false;

  EvaluateConfigEntity? configEntity;

  /// order
  /// hasBeenOperating 标记用户是否选择了满意 or 不满意
  bool hasBeenOperating = false;
  bool isSelectedSatisfied = false;

  /// 用户选中评价标签项列表
  List<String> selectedSatisfiedOptions = [];
  String evaluateMessage = '';

  List<AssetEntity> selectAssets = [];

  /// Commodity
  late List<CommodityEvaluateBloc> commodityBlocs;

  static OrderEvaluateState init() {
    return OrderEvaluateState()
      ..showLoading = true
      ..canComment = true
      ..isEvaluateSuccess = false
      ..orderId = null
      ..configEntity = null
      ..hasBeenOperating = false
      ..isSelectedSatisfied = false
      ..selectedSatisfiedOptions = []
      ..evaluateMessage = ''
      ..selectAssets = []
      ..commodityBlocs = [];
  }

  OrderEvaluateState copy() {
    return OrderEvaluateState()
      ..orderId = orderId
      ..showLoading = showLoading
      ..canComment = canComment
      ..isEvaluateSuccess = canComment
      ..configEntity = configEntity
      ..showLoading = showLoading
      ..hasBeenOperating = hasBeenOperating
      ..isSelectedSatisfied = isSelectedSatisfied
      ..selectedSatisfiedOptions = selectedSatisfiedOptions
      ..evaluateMessage = evaluateMessage
      ..selectAssets = selectAssets
      ..commodityBlocs = commodityBlocs;
  }
}
