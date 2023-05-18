import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/config_entity.g.dart';

@JsonSerializable()
class ConfigEntity {
  ///客服电话
  String? customerServiceHotline;

  ///客服工作时间
  String? customerServiceWorkingTime;

  ///客服文案
  String? customerServiceCase;

  ///客服订单URL
  String? customerServiceOrderUrl;
  String? afterTimeAppOpenPopUps;
  String? h5StyleJsCode;
  bool? environment;
  String? miniProgramSharingSwitch;
  String? sharingToWechatMomentsSwitch;
  String? specialZoneSharingSwitch;

  /// 默认取餐方式
  int? takeFoodMode;

  /// 个人中心是否显示退出按钮（true: 显示；false：不显示）
  bool? exitButtonDisplay;

  ///个人中心是否显示奖励金（true: 显示；false：不显示）
  bool? showMyBounty;

  ///送达时间文案信息
  String? arriveOnTime;

  ///送达时间文案信息Tips
  String? arriveOnTimeTips;

  ///首页显示取餐方式
  List<ServiceMode>? serviceModeList;

  ///开屏页倒计时（单位秒）
  int? openingScreenCountdown;

  ///订单列表引导文案
  String? orderListEmptyContext;

  ///社群福利标题（为空时前端不展示）
  String? communityWelfareTitle;
  int? currentTime;

  int? showEstimatePrice;

  ///购物车最大值
  int? maxCount;

  ///优惠券兑换入口菜单文案
  String? couponExchangeMenuConfig;

  ///历史优惠券兑换入口菜单文案
  String? couponExchangeMenuConfigForHis;

  ///历史代金券兑换入口菜单文案
  String? voucherExchangeMenuConfigForHis;

  String? installationActivityNo;

  int? installationActivityTimes;

  @JSONField(name: "installationActivityDtoList")
  List<InstallationActivity>? installationActivityList;

  FirstOrderFreeShippingGlobal? firstOrderFreeShippingGlobalResult;

  ShopTypeFilter? shopTypeFilter;

  /// 开关：是否展示代金券
  bool? showVoucher;

  ConfigEntity();

  factory ConfigEntity.fromJson(Map<String, dynamic> json) => $ConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => $ConfigEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ServiceMode {
  int? index;
  String? name;

  ServiceMode();

  factory ServiceMode.fromJson(Map<String, dynamic> json) => $ServiceModeFromJson(json);

  Map<String, dynamic> toJson() => $ServiceModeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class FirstOrderFreeShippingGlobal {
  String? firstOrderFreeShippingMsg;
  bool? freeSwitch;

  FirstOrderFreeShippingGlobal();

  factory FirstOrderFreeShippingGlobal.fromJson(Map<String, dynamic> json) =>
      $FirstOrderFreeShippingGlobalFromJson(json);

  Map<String, dynamic> toJson() => $FirstOrderFreeShippingGlobalToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ShopTypeFilter {
  bool? filterFlag;
  List<int>? codes;

  ShopTypeFilter();

  factory ShopTypeFilter.fromJson(Map<String, dynamic> json) => $ShopTypeFilterFromJson(json);

  Map<String, dynamic> toJson() => $ShopTypeFilterToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class InstallationActivity {
  String? installationActivityNo;
  int? installationActivityTimes;
  String? installationActivityAdId;

  InstallationActivity();

  factory InstallationActivity.fromJson(Map<String, dynamic> json) =>
      $InstallationActivityFromJson(json);

  Map<String, dynamic> toJson() => $InstallationActivityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}