import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cotti_client/global/entity/config_entity.dart';
import 'package:cotti_client/global/entity/static_text_entity.dart';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/utils/service_time_util.dart';
import 'package:cotticommon/cotticommon.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  static const String blocName = "configBloc";

  ConfigBloc() : super(ConfigState()) {
    on<GetConfigEvent>(_getConfig);
  }

  _getConfig(_, emit) async {
    await Future.doWhile(() async {
      ConfigEntity? entity;
      await _config().then((value) {
        entity = value;
      }).catchError((onError) => logI("获取config 接口失败"));
      if (entity == null) {
        String configString = SpUtil.getString('app_config');
        if (configString.isNotEmpty) {
          entity = ConfigEntity.fromJson(jsonDecode(configString));
        }
      }
      if (entity == null) {
        await Future.delayed(const Duration(seconds: 3));
        return true;
      }
      state.configEntity = entity;
      return false;
    });
    await _getStaticText().then((value) {
      state.staticTextEntity = value;
    }).catchError((onError) => logE(onError));
    emit(state.copy());
  }

  Future<ConfigEntity> _config() async {
    return CottiNetWork().post('/config/getConfig', showToast: false).then((value) {
      ConfigEntity configEntity = ConfigEntity.fromJson(value);
      String jsonConfig = configEntity.toString();
      SpUtil.putString('app_config', jsonConfig);
      return ConfigEntity.fromJson(value);
    });
  }

  Future<StaticTextEntity> _getStaticText() {
    return CottiNetWork()
        .post('/config/getStaticContext', showToast: false)
        .then((value) => StaticTextEntity.fromJson(value));
  }
}

class ConfigState {
  ConfigEntity? configEntity;
  StaticTextEntity? staticTextEntity;

  ConfigState copy() {
    return ConfigState()
      ..configEntity = configEntity
      ..staticTextEntity = staticTextEntity;
  }

  int get maxCount => configEntity?.maxCount ?? 100;

  int get takeFoodMode => configEntity?.takeFoodMode ?? 100;

  /// 是否在客服时间
  bool get judgeInsideServiceTime =>
      ServiceTimeUtil.judgeInsideServiceTime(configEntity?.customerServiceWorkingTime ?? "");

  List<ServiceMode> get serviceMode =>
      configEntity?.serviceModeList ??
      [
        ServiceMode()
          ..index = 100
          ..name = "到店自取",
        ServiceMode()
          ..index = 2
          ..name = "外卖配送",
      ];

  String? getShopModeText(int modeCode) {
    int index = serviceMode.indexWhere((element) => element.index == modeCode);
    if (index != -1) {
      return serviceMode[index].name;
    }
    return null;
  }

  bool get voucherExchangeForHisDisplay =>
      configEntity?.voucherExchangeMenuConfigForHis?.isNotEmpty ?? false;

  bool get couponExchangeMineDisplay => configEntity?.couponExchangeMenuConfig?.isNotEmpty ?? false;

  bool get couponExchangeForHisDisplay =>
      configEntity?.couponExchangeMenuConfigForHis?.isNotEmpty ?? false;

  ///首单免配送费开关
  bool get freeSwitch => configEntity?.firstOrderFreeShippingGlobalResult?.freeSwitch ?? false;

  String get firstOrderFreeShippingMsg =>
      configEntity?.firstOrderFreeShippingGlobalResult?.firstOrderFreeShippingMsg ?? "";

  String get specialActivityLabelForOrder =>
      staticTextEntity?.commonContext?.specialActivityLabelForOrder ?? '限时特价';

  String get specialActivityLabel => staticTextEntity?.commonContext?.specialActivityLabel ?? '特价';

  String get buyNow => staticTextEntity?.commonContext?.buyNow ?? '尝鲜抢购';

  String get firstOrderFreeDispatchRuleTitle =>
      staticTextEntity?.confirmOrderPage?.firstOrderFreeDispatchRuleTitle ?? '新人首单外卖免配送费：';

  String get guidanceToBeOpened => staticTextEntity?.commonContext?.guidanceToBeOpened ?? '即将开业';
}

abstract class ConfigEvent {}

class GetConfigEvent extends ConfigEvent {}
