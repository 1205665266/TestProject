import 'dart:io';

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';
import 'package:cotti_client/service/location/location_result.dart';

class ShopMatchState {
  ///当前就餐方式,默认自提
  int curTakeFoodMode = Constant.selfTakeModeCode;

  ///自提匹配到的门店信息
  ShopInfoEntity? selfTakeShopInfo;

  ///外卖的门店信息
  ShopInfoEntity? takeOutShopInfo;

  ///定位到的信息
  LocationResult? locationResult;

  bool showLoading = false;

  ///是否首次获取 自提/外卖 门店
  bool firstGetShopInfo = false;

  ///配送地址
  MemberAddressEntity? address;

  ///记录当前门店数据更新时间戳
  num? currentTime;

  ///记录匹配门店的时间戳
  int takeOutTimeStamp = 0;

  /// 记录确认订单 外卖切自提时 匹配门店的时间戳
  int switchSelfTakeFromTakeOutTimeStamp = 0;

  ///记录自动匹配门店时间
  int autoMatchShopTimeStamp = 0;

  /// 记录确认订单 外卖切自提时 匹配门店  是否成功
  bool switchSelfTakeFromTakeOut = false;

  ///是否正在获取外卖地址
  bool isGetFilterUsefulAddress = false;

  String? adapterAddressFromTag;

  ///获取都定位的时间
  int locationCurrentTime = 0;

  ///用户是否选择过门店
  bool isUserSelectShopCode = false;

  ShopMatchState copy({
    int? curTakeFoodMode,
    ShopInfoEntity? selfTakeShopInfo,
    ShopInfoEntity? takeOutShopInfo,
    LocationResult? locationResult,
    bool? showLoading,
    MemberAddressEntity? address,
    num? currentTime,
    int? takeOutTimeStamp,
    int? switchSelfTakeFromTakeOutTimeStamp,
    int? autoMatchShopTimeStamp,
    bool? switchSelfTakeFromTakeOut,
    bool? isGetFilterUsefulAddress,
    bool? firstGetShopInfo,
    String? adapterAddressFromTag,
    int? locationCurrentTime,
    bool? isUserSelectShopCode,
  }) {
    return ShopMatchState()
      ..address = address ?? this.address
      ..currentTime = currentTime ?? this.currentTime
      ..showLoading = showLoading ?? this.showLoading
      ..curTakeFoodMode = curTakeFoodMode ?? this.curTakeFoodMode
      ..locationResult = locationResult ?? this.locationResult
      ..takeOutShopInfo = takeOutShopInfo ?? this.takeOutShopInfo
      ..takeOutTimeStamp = takeOutTimeStamp ?? this.takeOutTimeStamp
      ..autoMatchShopTimeStamp = autoMatchShopTimeStamp ?? this.autoMatchShopTimeStamp
      ..firstGetShopInfo = firstGetShopInfo ?? this.firstGetShopInfo
      ..switchSelfTakeFromTakeOutTimeStamp =
          switchSelfTakeFromTakeOutTimeStamp ?? this.switchSelfTakeFromTakeOutTimeStamp
      ..switchSelfTakeFromTakeOut = switchSelfTakeFromTakeOut ?? this.switchSelfTakeFromTakeOut
      ..selfTakeShopInfo = selfTakeShopInfo ?? this.selfTakeShopInfo
      ..adapterAddressFromTag = adapterAddressFromTag ?? this.adapterAddressFromTag
      ..locationCurrentTime = locationCurrentTime ?? this.locationCurrentTime
      ..isUserSelectShopCode = isUserSelectShopCode ?? this.isUserSelectShopCode
      ..isGetFilterUsefulAddress = isGetFilterUsefulAddress ?? this.isGetFilterUsefulAddress;
  }

  ///当前匹配到的门店code
  int? get shopMdCode {
    if (curTakeFoodMode == Constant.selfTakeModeCode) {
      return selfTakeShopInfo?.shopDetail?.shopMdCode;
    } else {
      return takeOutShopInfo?.shopDetail?.shopMdCode;
    }
  }

  ///当前匹配到的门店信息
  ShopDetail? get currentShopDetail {
    if (curTakeFoodMode == Constant.selfTakeModeCode) {
      return selfTakeShopInfo?.shopDetail;
    } else {
      return takeOutShopInfo?.shopDetail;
    }
  }

  ///当前取餐方式下的取餐模code集合
  List<int> get getTakeFoodModes {
    if (curTakeFoodMode == Constant.selfTakeModeCode) {
      return currentShopDetail?.mealTakeModeCodes?.where((element) => element <= 1).toList() ?? [];
    }
    if (curTakeFoodMode == Constant.takeOutModeCode) {
      List<int> modeCodes =
          currentShopDetail?.mealTakeModeCodes?.where((element) => element > 1).toList() ?? [];
      if (modeCodes.isEmpty) {
        modeCodes.add(2);
      }
      return modeCodes;
    }
    return [];
  }

  ///当前取餐模式下门店是否在休息中
  bool get shopClosed {
    if (currentShopDetail == null) {
      return false;
    }
    if (currentShopDetail!.status != 1) {
      return false;
    }
    if (currentShopDetail!.forceClosed == 1) {
      return false;
    }
    if (curTakeFoodMode == Constant.selfTakeModeCode) {
      return currentShopDetail!.closed == true;
    } else {
      return currentShopDetail!.closed == true || currentShopDetail!.dispatched == false;
    }
  }

  ///当前取餐模式下门店是否强制闭店
  bool get shopForceClosed {
    if (currentShopDetail == null) {
      return false;
    }
    if (currentShopDetail?.status != 1) {
      return false;
    }
    return currentShopDetail?.forceClosed == 1;
  }

  ///当前门店待开业
  bool get shopToBeOpened {
    if (currentShopDetail == null) {
      return false;
    }
    return currentShopDetail?.status == 0;
  }

  String get openDateContext {
    String openDateDefaultContext =
        currentShopDetail?.guidanceToBeOpenedContext?.openDateDefaultContext ?? '';
    String openDateContext1 = currentShopDetail?.guidanceToBeOpenedContext?.openDateContext ?? '';
    String planSetUpTimeDesc = currentShopDetail?.planSetUpTimeDesc ?? '';
    if (planSetUpTimeDesc.isEmpty) {
      return openDateDefaultContext;
    }
    return openDateContext1.replaceAll("#", planSetUpTimeDesc);
  }

  bool get noLocationPermission =>
      (locationResult?.errorCode == 12 || (Platform.isIOS && locationResult?.errorCode == 2));
}
