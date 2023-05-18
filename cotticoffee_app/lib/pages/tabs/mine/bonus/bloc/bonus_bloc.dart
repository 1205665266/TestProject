import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/tabs/mine/bonus/api/bonus_api.dart';
import 'package:cotti_client/pages/tabs/mine/bonus/entity/bonus_detail_entity.dart';
import 'package:cotti_client/pages/tabs/mine/bonus/entity/bonus_log_entity.dart';
import 'package:cotti_client/sensors/bonus_sensors_constant.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

part 'bonus_event.dart';

part 'bonus_state.dart';

class BonusBloc extends Bloc<BonusEvent, BonusState> {
  BonusBloc() : super(BonusState.init()) {
    on<BonusInitEvent>(_onInit);
    on<BonusNoDataTitleDoneEvent>(_noData);
    on<BonusRefreshEvent>(_onRefresh);
    on<BonusLoadingEvent>(_onLoading);
  }

  _onLoading(BonusLoadingEvent event, emit) async {
    state.loadStatus = LoadStatus.loading;
    state.requestTimeStamp = event.requestTimeStamp ?? 0;
    await BonusApi.getLogList(pageNo: state.pageNo + 1).then((value) {
      state.loadStatus = LoadStatus.idle;
      if (state.requestTimeStamp == event.requestTimeStamp) {
        if (value.isNotEmpty) {
          state.pageNo++;
          state.logList?.addAll(value);
        } else {
          state.loadStatus = LoadStatus.noMore;
        }
      }
    }).catchError((error) {
      state.loadStatus = LoadStatus.failed;
    });
    emit(state.copy());
  }

  _onRefresh(BonusRefreshEvent event, emit) async {
    state.pageNo = 1;
    state.refreshStatus = RefreshStatus.refreshing;
    state.loadStatus = LoadStatus.idle;
    state.requestTimeStamp = event.requestTimeStamp!;
    emit(state.copy());
    await BonusApi.getLogList(pageNo: state.pageNo).then((value) {
      if (state.requestTimeStamp == event.requestTimeStamp) {
        state.logList = value;
        state.showEmpty = value.isEmpty;
      }
    }).catchError((onError) {});

    state.refreshStatus = RefreshStatus.completed;
    emit(state.copy());
  }

  _noData(BonusNoDataTitleDoneEvent event, emit) {
    emit(state.copy()..noDataTitle = event.noDataTitle);
  }

  _onInit(BonusInitEvent event, emit) async {
    await Future.wait([
      BonusApi.getDetail().then((value) {
        if (value.expired != null && (value.expired ?? 0) > 0) {
          SensorsAnalyticsFlutterPlugin.track(
              BonusSensorsConstant.overdueTipsView, {'expired': (value.expired ?? 0)});
        }

        emit(state.copy()
          ..detailEntity = value
          ..showLoading = false);
      }).catchError((error) {
        logI('detail error = $error');
      }),
      BonusApi.getLogList(pageNo: 1).then((value) {
        emit(state.copy()..logList = value);
      }).catchError((error) {
        logI('loglist error = $error');
      })
    ]);
  }
}
