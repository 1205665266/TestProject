import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/common/activity/api/activity_api.dart';
import 'package:cotti_client/pages/common/activity/model/activity_results_model.dart';
import 'package:cotti_client/pages/common/activity/model/check_qualification_result_model.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'general_activity_event.dart';
import 'general_activity_state.dart';

class GeneralActivityBloc extends Bloc<GeneralActivityEvent, GeneralActivityState> {
  GeneralActivityBloc() : super(GeneralActivityState().init()) {
    on<ActivityInitEvent>(_init);
    on<ClickBannerEvent>(_clickBannerEventToState);
    on<ClickReceiveCouponEvent>(_clickReceiveCouponEventToState);
    on<ShowActivityPopUpsEvent>(_showActivityPopUpsEventToState);
    on<CheckQualificationEvent>(_checkQualificationEventToState);
    on<RefreshBannerEvent>(_refreshEventToState);
  }

  void _init(ActivityInitEvent event, Emitter<GeneralActivityState> emit) async {
    state.activityId = event.activityId;
    emit(state.clone());
  }

  void _refreshEventToState(RefreshBannerEvent event, Emitter<GeneralActivityState> emit) async {
    state.isShowNewMember = !event.loginState;
    state.isLogin = event.loginState;
    state.popBannerController.reload();
    emit(state.clone());
  }

  /// 发券接口
  void _clickBannerEventToState(ClickBannerEvent event, Emitter<GeneralActivityState> emit) async {
    emit(state.clone());
  }

  /// 领取资格接口
  void _checkQualificationEventToState(
      CheckQualificationEvent event, Emitter<GeneralActivityState> emit) async {
    Map<String, dynamic>? params = {'activityNo': event.model.popup!.activityId};
    CheckQualificationResultModel model = await ActivityApi.checkQualification(params).catchError((error) {
      logE('checkQualification  ===> $error');
    });
    if (model.status != null) {
      state.checkQualificationStatus = model.status!;
    }
    if (event.model.popup != null && event.model.popup!.couponWay == '2') {
      /// 自动触发领券
      add(ClickReceiveCouponEvent(
          isAuto: true, model: event.model,viewPage: "sjgf-app-home", callback: event.callback, onTapCallback: () {}));
    } else if (event.model.popup != null && event.model.popup!.couponWay == '1') {
      ///手动发券 直接弹窗提示

      event.callback(state.checkQualificationStatus == 1);
    }

    emit(state.clone());
  }

  /// 发券接口
  void _clickReceiveCouponEventToState(
      ClickReceiveCouponEvent event, Emitter<GeneralActivityState> emit) async {
    String activityId = '';
    if (event.model.popup != null && event.model.popup!.activityId != null) {
      activityId = event.model.popup!.activityId!;
    }
    ActivityResultsModel activityResultModel = await ActivityApi.getReceiveReward({'activityNo': activityId}).catchError((error) {
      logE("getReceiveReward ===> $error");
    });

    if (!event.isAuto) {
      if (activityResultModel.status == 1) {
        ///埋点 通用广告弹窗-手动领券结果
        var sensorProperties = {
          'activityId': event.model.popup != null ? event.model.popup!.activityId : '',
          'activityNumber': event.model.popup != null ? event.model.popup!.activityNumber : '',
          "positionCode": event.model.positionCode,
          "viewPage": event.viewPage,
          "positionName": event.model.positionName,
          "banner_sort": event.model.sort,
          'isSuccess': true,
          'message': '成功'
        };
        // SensorsAnalyticsFlutterPlugin.track(
        //     SensorsConstant.genericAdPopupManualCouponResult, sensorProperties);
        ToastUtil.show('领取成功');
        event.onTapCallback();
        //点击跳转
        // SchemeDispatcher.dispatchPath(event.context, event.model.redirectUrl!);
      } else {
        ///埋点 通用广告弹窗-手动领券结果
        var sensorProperties = {
          'activityId': event.model.popup != null ? event.model.popup!.activityId : '',
          'activityNumber': event.model.popup != null ? event.model.popup!.activityNumber : '',
          "positionCode": event.model.positionCode,
          "viewPage": event.viewPage,
          "positionName": event.model.positionName,
          "banner_sort": event.model.sort,
          'isSuccess': false,
          'message': activityResultModel.message
        };
        // SensorsAnalyticsFlutterPlugin.track(
        //     SensorsConstant.genericAdPopupManualCouponResult, sensorProperties);
        ToastUtil.show(activityResultModel.message);
      }
    } else {
      ///自动发券，弹窗提示
      if (activityResultModel.status == 1) {
        ///埋点 通用广告弹窗-自动领券结果
        var sensorProperties = {
          'activityId': event.model.popup != null ? event.model.popup!.activityId : '',
          'activityNumber': event.model.popup != null ? event.model.popup!.activityNumber : '',
          "positionCode": event.model.positionCode,
          "viewPage": event.viewPage,
          "positionName": event.model.positionName,
          "banner_sort": event.model.sort,
          'isSuccess': true,
          'message': '成功'
        };

        // SensorsAnalyticsFlutterPlugin.track(
        //     SensorsConstant.genericAdPopupAutoCouponResult, sensorProperties);
        state.receiveRewardStatus = 1;
        if (event.callback != null) {
          event.callback!(true);
        }
      } else {
        ///埋点 通用广告弹窗-自动领券结果
        var sensorProperties = {
          'activityId': event.model.popup != null ? event.model.popup!.activityId : '',
          'activityNumber': event.model.popup != null ? event.model.popup!.activityNumber : '',
          "positionCode": event.model.positionCode,
          "viewPage": event.viewPage,
          "positionName": event.model.positionName,
          "banner_sort": event.model.sort,
          'isSuccess': false,
          'message': activityResultModel.message
        };

        // SensorsAnalyticsFlutterPlugin.track(
        //     SensorsConstant.genericAdPopupAutoCouponResult, sensorProperties);
        event.callback!(false);
      }
    }
    emit(state.clone());
  }

  void _showActivityPopUpsEventToState(
      ShowActivityPopUpsEvent event, Emitter<GeneralActivityState> emit) async {
    emit(state.clone());
  }
}
