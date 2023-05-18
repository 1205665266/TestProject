import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/shop_detail_entity.g.dart';
import 'package:cotti_client/global/entity/config_entity.dart';

@JsonSerializable()
class ShopInfoEntity {
  ///门店类型 1：已开业门店 2：计划开业门店 3：无门店无开业计划
  int? shopState;

  ///门店信息
  @JSONField(name: "shopDetailVO")
  ShopDetail? shopDetail;

  @JSONField(name: "shopMatchFailConfigDto")
  ShopMatchFailConfig? shopMatchFailConfig;

  ///取餐模式
  bool? takeFoodModeChangeFlag;

  /// 用户与收货地址之间的距离 如果为空无法计算距离
  double? distance;

  ///用户与收货地址之间的距离标识 如果为空无法计算标识 false : 范围内 true 太远
  bool? distanceFlag;

  ///用户是否无收货地址 false: 未登录或者有收货地址 true: 无收货地址
  bool? addressFlag;

  ///用户定位信息与外送门店之间距离标识 false:用户定位地址在外送门店配送范围内 true：用户定位地址在外送门店配送范围外
  bool? deliveryDistanceFlag;

  ///当前定位支持的取餐方式
  List<CurrentPositionTakeFoodMode>? currentPositionTakeFoodMode;

  ///快递提示信息
  String? expressMessage;

  ///外卖门店匹配状态类型 0 有可用的外卖门店 1 降级为自提门店 2 没有匹配到门店
  int? takeOutShopResultType;

  ShopInfoEntity();

  factory ShopInfoEntity.fromJson(Map<String, dynamic> json) => $ShopInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $ShopInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ShopDetail {
  ///门店主数据编号
  int? shopMdCode;

  /// 门店名称
  String? shopName;

  ///城市编号
  String? cityMdCode;

  ///城市名称
  String? cityMdName;

  ///地址
  String? address;

  String? addressPrompt;
  String? canteenCardName;
  String? canteenCardNameDesc;
  String? planSetUpTimeStr;
  String? planSetUpTimeDesc;

  /// 图片列表
  List<String>? images;

  /// 营业时间
  String? currentSaleTime;

  ///距离
  int? distance;

  ///纬度
  double? latitude;

  ///经度
  double? longitude;

  ///取餐模式
  List<String>? mealTakeMode;

  ///取餐模code集合
  List<int>? mealTakeModeCodes;

  ///常规时间方案
  List<String>? regularTimeList;

  ///节假日时间方案
  List<String>? holidayTimeList;

  ///常规时间方案
  List<String>? specialTimeList;

  ///门店实际开业时间
  String? setUpTime;

  ///门店计划开业时间
  String? planSetUpTime;

  ///用户是否订阅门店开业通知 0:否 1：是
  int? customerSubscribeShopOpeningNotice;

  ///是否已打烊 true:已打烊，false:营业中
  bool? closed;

  ///是否可配送 true:可以，false:不可以
  bool? dispatched;

  ///门店状态 0 待开业 1 已开业 2 待停业 3 已停业 4 未开业已取消
  int? status;

  ///配送状态
  List<String>? dispatchStatus;

  ///外送渠道
  List<String>? deliveryChannel;

  ///自提点id
  int? selffetchpointId;

  ///是否试运营
  int? trial;

  ///取货方式 外卖可能会自动降级成快递
  int? matchMealTakeMode;

  ///门店联系电话
  String? empMobile;

  ///营业状态提示
  String? statusReminder;

  ///门店营业时间文字信息
  String? shopOperateStr;

  ///是否紧急闭店 1 闭店，2 不闭店
  int? forceClosed;

  ///外卖门店配送费信息
  String? dispatchFeeStr;

  ConfigEntity? apiConfig;

  ShopTypeFrBO? shopTypeFrBO;
  GuidanceToBeOpenedContext? guidanceToBeOpenedContext;

  ShopDetail();

  factory ShopDetail.fromJson(Map<String, dynamic> json) => $ShopDetailFromJson(json);

  Map<String, dynamic> toJson() => $ShopDetailToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CurrentPositionTakeFoodMode {
  int? code;
  String? name;
  bool? selected;

  CurrentPositionTakeFoodMode();

  factory CurrentPositionTakeFoodMode.fromJson(Map<String, dynamic> json) =>
      $CurrentPositionTakeFoodModeFromJson(json);

  Map<String, dynamic> toJson() => $CurrentPositionTakeFoodModeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ShopMatchFailConfig {
  ///门店匹配失败文案提示
  String? shopMatchFailMsg;

  ///门店匹配失败按钮名称
  String? buttonMsg;

  ///门店匹配失败title标题
  String? shopMatchFailTitle;

  ShopMatchFailConfig();

  factory ShopMatchFailConfig.fromJson(Map<String, dynamic> json) =>
      $ShopMatchFailConfigFromJson(json);

  Map<String, dynamic> toJson() => $ShopMatchFailConfigToJson(this);
}

@JsonSerializable()
class ShopTypeFrBO {
  int? index;
  String? name;
  String? iconUrl;
  String? color;

  ShopTypeFrBO();

  factory ShopTypeFrBO.fromJson(Map<String, dynamic> json) => $ShopTypeFrBOFromJson(json);

  Map<String, dynamic> toJson() => $ShopTypeFrBOToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class GuidanceToBeOpenedContext {
  String? toolTip;
  String? openDateContext;
  String? openDateDefaultContext;
  bool? isExpand;

  GuidanceToBeOpenedContext();

  factory GuidanceToBeOpenedContext.fromJson(Map<String, dynamic> json) =>
      $GuidanceToBeOpenedContextFromJson(json);

  Map<String, dynamic> toJson() => $GuidanceToBeOpenedContextToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
