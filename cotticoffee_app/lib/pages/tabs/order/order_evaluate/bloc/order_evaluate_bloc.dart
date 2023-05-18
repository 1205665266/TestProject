import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/api/order_evaluate_api.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/bloc/commodity_evaluate_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/entity/evaluate_config_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/order_evaluate_detail_page.dart';
import 'package:cotti_client/routers/order_router.dart';
import 'package:cotti_client/utils/image_upload_util.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part 'order_evaluate_event.dart';

part 'order_evaluate_state.dart';

class OrderEvaluateBloc extends Bloc<OrderEvaluateEvent, OrderEvaluateState> {
  OrderEvaluateBloc() : super(OrderEvaluateState.init()) {
    // on<InitEvent>(_initOrderEvaluate);
    on<SatisfiedSelectedEvent>(_selectedSatisfied);
    on<OrderEvaluateGetConfigEvent>(_getOrderCommentConfig);
    on<SatisfiedOptionsSelectedEvent>(_optionsSelected);
    on<EditEvaluateMessageEvent>(_editEvaluateMessage);
    on<EditAssetsEvent>(_editAssets);
    on<SubmitEvaluateEvent>(_submitOrderEvaluate);
  }

  /// 初始化订单评价数据
  ///
  /// [event]发起bloc的event
  /// [emit] 触发状态改变的发射器
  // void _initOrderEvaluate(InitEvent event, emit) async {
  //   await HttpClient.get(
  //     EvaluateAPI.orderEvaluate,
  //     params: {"orderId": event.orderId},
  //   ).then((response) {
  //     if (response.data != null) {
  //       OrderCommentConfigResultModel data =
  //       OrderCommentConfigResultModel.fromJson(response.data);
  //       if (data.canComment != null && data.canComment!) {
  //         List<CommodityEvaluateBloc> commodityBlocs = [];
  //         if (data.orderItemList != null) {
  //           commodityBlocs = data.orderItemList!.map((e) {
  //             return CommodityEvaluateBloc()
  //               ..add(CommodityInitEvent(
  //                   e,
  //                   data.goodsSatisfiedLabels ?? [],
  //                   data.goodsDissatisfiedLabels ?? [],
  //                   data.goodsSatisfiedMinStarCount ?? 4));
  //           }).toList();
  //         }
  //         emit(state.clone()
  //           ..orderId = event.orderId
  //           ..data = data
  //           ..commodityBlocs = commodityBlocs
  //           ..isLoading = false);
  //       } else {
  //         emit(state.copy()
  //           ..orderId = event.orderId
  //           ..canComment = false
  //           ..isLoading = false);
  //         ToastUtil.show(data.canNotCommentCauseStr ?? "请求失败");
  //       }
  //     } else {
  //       emit(state.copy()
  //         ..orderId = event.orderId
  //         ..isLoading = false);
  //       ToastUtil.show("请求失败");
  //     }
  //   }).catchError((e) {
  //     emit(state.copy()
  //       ..orderId = event.orderId
  //       ..isLoading = false);
  //   });
  // }

  _getOrderCommentConfig(OrderEvaluateGetConfigEvent event, emit) async {
    var configEntity =
        await OrderEvaluateApi.getOrderCommentConfig(orderId: event.orderId).then((value) {
      // value.orderSatisfiedLabels = ['manyi1', 'manyi2'];
      // value.orderDissatisfiedLabels = ["bumanyi1", "bumanyi2"];
      debugPrint('var configEntity = $value');
      List<CommodityEvaluateBloc> commodityBlocs = [];
      if (value.orderItemList != null) {
        commodityBlocs = value.orderItemList!.map((e) {
          return CommodityEvaluateBloc()
            ..add(CommodityInitEvent(e, value.goodsSatisfiedLabels ?? [],
                value.goodsDissatisfiedLabels ?? [], value.goodsSatisfiedMinStarCount ?? 4));
        }).toList();
      }

      emit(state.copy()
        ..showLoading = false
        ..orderId = event.orderId
        ..configEntity = value
        ..commodityBlocs = commodityBlocs);
    }).catchError((_) {
      // EvaluateConfigEntity test = EvaluateConfigEntity.testExp();
      // List<CommodityEvaluateBloc> commodityBlocs = [];
      // if (test.orderItemList != null) {
      //   commodityBlocs = test.orderItemList!.map((e) {
      //     return CommodityEvaluateBloc()
      //       ..add(CommodityInitEvent(e, test.goodsSatisfiedLabels ?? [],
      //           test.goodsDissatisfiedLabels ?? [], test.goodsSatisfiedMinStarCount ?? 4));
      //   }).toList();
      // }
      //
      // debugPrint("commodityBlocs == $commodityBlocs");

      emit(state.copy()
        ..showLoading = false
        ..orderId = event.orderId);
    });
    // state.showLoading = false;
  }

  /// 选择满意度
  ///
  /// [event]发起bloc的event
  /// [emit] 触发状态改变的发射器
  void _selectedSatisfied(SatisfiedSelectedEvent event, emit) async {
    emit(state.copy()
      ..hasBeenOperating = true
      ..selectedSatisfiedOptions = []
      ..isSelectedSatisfied = event.isSatisfied);
  }

  /// 选择评价标签
  ///
  /// [event]发起bloc的event
  /// [emit] 触发状态改变的发射器
  void _optionsSelected(SatisfiedOptionsSelectedEvent event, emit) {
    debugPrint('event.selectedOptions == ${event.selectedOptions}');
    debugPrint('showloading = ${state.showLoading}');
    emit(state.copy()..selectedSatisfiedOptions = event.selectedOptions);
  }

  /// 编辑订单评价信息
  ///
  /// [event]发起bloc的event
  /// [emit] 触发状态改变的发射器
  void _editEvaluateMessage(EditEvaluateMessageEvent event, emit) {
    // SensorsAnalyticsFlutterPlugin.track(
    //     SensorsConstant.orderEvaluateInputClick, {});
    emit(state.copy()..evaluateMessage = event.evaluateMessage);
  }

  /// 订单评价添加编辑图片
  ///
  /// [event]发起bloc的event
  /// [emit] 触发状态改变的发射器
  void _editAssets(EditAssetsEvent event, emit) {
    emit(state.copy()..selectAssets = event.selectAssets);
  }

  /// 提交评价
  ///
  /// [event]发起bloc的event
  /// [emit] 触发状态改变的发射器
  void _submitOrderEvaluate(SubmitEvaluateEvent event, emit) async {
    emit(state.copy()..showLoading = true);
    // SensorsAnalyticsFlutterPlugin.track(
    // SensorsConstant.orderEvaluateSubmitClick,
    // {'orderSatisfaction': state.isSelectedSatisfied ? '满意' : '不满意'});

    final Map<String, dynamic> params = {
      "orderId": state.orderId ?? "",
      "orderSatisfaction": state.isSelectedSatisfied ? 1 : 2,
      "orderEvaluateLabels": state.selectedSatisfiedOptions,
      'content': state.evaluateMessage,
    };
    if (state.selectAssets.isNotEmpty) {
      List<String>? orderEvaluateImageUrls = await ImageUploadUtil.batchUpload(state.selectAssets);
      if (orderEvaluateImageUrls != null &&
          orderEvaluateImageUrls.length == state.selectAssets.length) {
        params['imageUrls'] = orderEvaluateImageUrls;
      } else {
        emit(state.copy()..showLoading = false);
        ToastUtil.show("图片上传失败，请稍后重试");
        return;
      }
    }
    List<Map<String, dynamic>> orderItemCommentList = [];
    for (CommodityEvaluateBloc e in state.commodityBlocs) {
      if (e.state.ranting > 0) {
        final Map<String, dynamic> orderItemCommentParams = {
          'skuCode': e.state.data?.skuCode ?? '',
          'starCount': e.state.ranting,
          'evaluateLabels': e.state.selectedSatisfiedOptions,
          'content': e.state.evaluateMessage,
        };
        if (e.state.selectAssets.isNotEmpty) {
          List<String>? itemEvaluateImageUrls =
              await ImageUploadUtil.batchUpload(e.state.selectAssets);
          if (itemEvaluateImageUrls != null &&
              itemEvaluateImageUrls.length == e.state.selectAssets.length) {
            orderItemCommentParams['imageUrls'] = itemEvaluateImageUrls;
          } else {
            emit(state.copy()..showLoading = false);
            ToastUtil.show("图片上传失败，请稍后重试");
            return;
          }
        }
        orderItemCommentList.add(orderItemCommentParams);
      }
    }
    if (orderItemCommentList.isNotEmpty) {
      params['orderItemCommentList'] = orderItemCommentList;
    }

    debugPrint('params == $params');

    await OrderEvaluateApi.submitOrderComment(params: params).then((value) {
      logI('value = $value');
      if (value['errorMsg'] != null) {
        ToastUtil.show(value['errorMsg']);
      }
      if (value['success']) {
        String orderId = state.orderId ?? '';
        NavigatorUtils.pop(event.context, result: true);
        NavigatorUtils.push(
          event.context,
          OrderRouter.orderEvaluateDetailPage,
          params: {"orderNo": orderId,"showPopup":'true'},
        );
      }
      emit(state.copy()..showLoading = false);
    }).catchError((e) {
      emit(state.copy()..showLoading = false);
      ToastUtil.show("提交评价失败，请稍后重试");
    });

    // await CottiNetWork()
    //     .post(
    //   "/orderComment/submitOrderComment",
    //   queryParameters: params,
    //   showToast: false,
    // )
    //     .then((response) {
    //   if (response.data != null) {
    //     ///订单评价状态变更
    //     final Map<String, dynamic> result = response.data;
    //     if (result['success']) {
    //       emit(state.copy()
    //         ..showLoading = false
    //         ..isEvaluateSuccess = true);
    //     } else {
    //       emit(state.copy()
    //         ..showLoading = false
    //         ..canComment = false);
    //       ToastUtil.show(result['errorMsg'] ?? "提交评价失败，请稍后重试");
    //     }
    //   } else {
    //     emit(state.copy()..showLoading = false);
    //     ToastUtil.show("提交评价失败，请稍后重试");
    //   }
    // }).catchError((e) {
    //   emit(state.copy()..showLoading = false);
    //   ToastUtil.show("提交评价失败，请稍后重试");
    // });
  }
}
