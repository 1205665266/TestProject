import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/entity/evaluate_config_entity.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part 'commodity_evaluate_event.dart';
part 'commodity_evaluate_state.dart';

class CommodityEvaluateBloc extends Bloc<CommodityEvaluateEvent, CommodityEvaluateState> {
  CommodityEvaluateBloc() : super(CommodityEvaluateState.init()) {
    on<CommodityInitEvent>(_initCommodityEvaluate);
    on<CommodityRantingSelectedEvent>(_selectedRanting);
    on<CommoditySatisfiedOptionsSelectedEvent>(_optionsSelected);
    on<CommodityEditEvaluateMessageEvent>(_editEvaluateMessage);
    on<CommodityEditAssetsEvent>(_editAssets);
  }


  /// 初始化商品评价数据
  ///
  /// [event]发起bloc的event
  /// [emit] 触发状态改变的发射器
  void _initCommodityEvaluate(CommodityInitEvent event, emit) async {
    emit(state.copy()
      ..data = event.data
      ..satisfiedOptions = event.satisfiedOptions
      ..unsatisfiedOptions = event.unsatisfiedOptions);
  }

  /// 选择星级评价
  ///
  /// [event]发起bloc的event
  /// [emit] 触发状态改变的发射器
  void _selectedRanting(CommodityRantingSelectedEvent event, emit) async {
    // SensorsAnalyticsFlutterPlugin.track(
    //     SensorsConstant.commodityEvaluateStarClick, {
    //   'name': state.data?.name,
    //   'skuCode': state.data?.skuCode,
    //   'starCount': event.ranting,
    // });
    if ((state.ranting == 0) ||
        (state.ranting < state.goodsSatisfiedMinStarCount &&
            event.ranting >= state.goodsSatisfiedMinStarCount) ||
        (state.ranting >= state.goodsSatisfiedMinStarCount &&
            event.ranting < state.goodsSatisfiedMinStarCount)) {
      emit(state.copy()
        ..ranting = event.ranting
        ..selectedSatisfiedOptions = []);
    } else {
      emit(state.copy()..ranting = event.ranting);
    }
  }

  /// 选择商品满意度标签
  ///
  /// [event]发起bloc的event
  /// [emit] 触发状态改变的发射器
  void _optionsSelected(CommoditySatisfiedOptionsSelectedEvent event, emit) {
    // SensorsAnalyticsFlutterPlugin.track(
    //     SensorsConstant.commodityEvaluateLabelClick, {
    //   'name': state.data?.name,
    //   'skuCode': state.data?.skuCode,
    //   'starCount': state.ranting,
    //   'label': currentClickLabel(
    //     state.selectedSatisfiedOptions,
    //     event.selectedOptions,
    //   ),
    // });
    emit(state.copy()..selectedSatisfiedOptions = event.selectedOptions);
  }

  /// 编辑商品评价信息
  ///
  /// [event]发起bloc的event
  /// [emit] 触发状态改变的发射器
  void _editEvaluateMessage(CommodityEditEvaluateMessageEvent event, emit) {
    // SensorsAnalyticsFlutterPlugin.track(
    //     SensorsConstant.commodityEvaluateInputClick, {
    //   'name': state.data?.name,
    //   'skuCode': state.data?.skuCode,
    //   'starCount': state.ranting,
    // });
    emit(state.copy()..evaluateMessage = event.evaluateMessage);
  }

  /// 商品评价添加编辑图片
  ///
  /// [event]发起bloc的event
  /// [emit] 触发状态改变的发射器
  void _editAssets(CommodityEditAssetsEvent event, emit) {
    emit(state.copy()..selectAssets = event.selectAssets);
  }

  ///获取当前点击的标签(过滤标签)
  String? currentClickLabel(List<String> before, List<String> now) {
    List<String> filterOptions = [];
    for (var element in before) {
      if (!now.contains(element)) {
        filterOptions.add(element);
      }
    }
    for (var element in now) {
      if (!before.contains(element)) {
        filterOptions.add(element);
      }
    }
    if (filterOptions.isNotEmpty) {
      return filterOptions.first;
    }
    return null;
  }
}
