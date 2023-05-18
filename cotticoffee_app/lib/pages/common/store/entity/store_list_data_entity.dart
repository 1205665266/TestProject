import 'dart:convert';
import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/store_list_data_entity.g.dart';

@JsonSerializable()
class StoreListDataEntity {

	List<StoreListDataModel>? oftenUsedShopList;
	List<StoreListDataModel>? nearbyShopList;
	int? shopCountLimitNum;
	List<StoreListDataShopTypeFrBos>? shopTypeFrBos;
  
  StoreListDataEntity();

  factory StoreListDataEntity.fromJson(Map<String, dynamic> json) => $StoreListDataEntityFromJson(json);

  Map<String, dynamic> toJson() => $StoreListDataEntityToJson(this);

	@override
	bool operator ==(Object other){
		if (identical(this, other)) return true;
		if (other.runtimeType != runtimeType) return false;

		final StoreListDataEntity typedOther = other as StoreListDataEntity;

		return typedOther.toString() == toString();

	}


  @override
  String toString() {
    return jsonEncode(this);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

}

@JsonSerializable()
class StoreListDataModel {

	int? shopMdCode;
	dynamic youZanShopCode;
	dynamic onlineYouZanShopCode;
	String? shopName;
	int? cityMdCode;
	String? cityMdName;
	String? address;
	dynamic images;
	String? currentSaleTime;
	int? distance;
	double? latitude;
	double? longitude;
	List<String>? mealTakeMode;
	List<int>? mealTakeModeCodes;
	dynamic regularTimeList;
	dynamic holidayTimeList;
	dynamic specialTimeList;
	dynamic setUpTime;
	String? planSetUpTime;
	dynamic customerSubscribeShopOpeningNotice;
	bool? closed;
	dynamic dispatched;
	/*
	 * 门店状态 0 待开业 1 已开业  2 待停业  3 已停业  4 未开业已取消
	 */
	int? status;
	dynamic dispatchStatus;
	List<String>? deliveryChannel;
	dynamic selffetchpointId;
	int? trial;
	dynamic matchMealTakeMode;
	String? empMobile;
	String? statusReminder;
	dynamic shopOperateStr;
	int? forceClosed;
	StoreListDataModelApiConfig? apiConfig;
	dynamic dispatchFeeStr;
	int? stepDistance;
	int? shopType;
	int? showSaleType;
	String? canteenCardNameDesc;
	/*
	 * 门店计划开业时间
	 */
	String? planSetUpTimeStr;

	/// 切换城市时标记中心点的标记
	bool? isCenterCity;

	/// 列表和地图中选中的标记
	bool selected = false;

  StoreListDataModel();

  factory StoreListDataModel.fromJson(Map<String, dynamic> json) => $StoreListDataModelFromJson(json);

  Map<String, dynamic> toJson() => $StoreListDataModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StoreListDataModelApiConfig {

	String? customerServiceHotline;
	String? customerServiceWorkingTime;
	String? customerServiceCase;
	String? customerServiceOrderUrl;
	String? afterTimeAppOpenPopUps;
	dynamic h5StyleJsCode;
	bool? environment;
	dynamic scanTipText;
	String? miniProgramSharingSwitch;
	String? sharingToWechatMomentsSwitch;
	String? specialZoneSharingSwitch;
	int? shopMdCode;
	int? takeFoodMode;
	bool? exitButtonDisplay;
	bool? showMyBounty;
	List<StoreListDataModelApiConfigServiceModeList>? serviceModeList;
	String? confirmOrderTakeFoodModeImg;
	int? openingScreenCountdown;
	String? orderListEmptyContext;
	dynamic communityWelfareTitle;
	int? currentTime;
	String? arriveOnTime;
	String? arriveOnTimeTips;
	bool? showEstimatePrice;
	int? maxCount;
  
  StoreListDataModelApiConfig();

  factory StoreListDataModelApiConfig.fromJson(Map<String, dynamic> json) => $StoreListDataModelApiConfigFromJson(json);

  Map<String, dynamic> toJson() => $StoreListDataModelApiConfigToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class StoreListDataModelApiConfigServiceModeList {

	int? index;
	String? name;
  
  StoreListDataModelApiConfigServiceModeList();

  factory StoreListDataModelApiConfigServiceModeList.fromJson(Map<String, dynamic> json) => $StoreListDataModelApiConfigServiceModeListFromJson(json);

  Map<String, dynamic> toJson() => $StoreListDataModelApiConfigServiceModeListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}


@JsonSerializable()
class StoreListDataShopTypeFrBos {

	int? index;
	String? name;
	String? iconUrl;
	String? color;
  
  StoreListDataShopTypeFrBos();

  factory StoreListDataShopTypeFrBos.fromJson(Map<String, dynamic> json) => $StoreListDataShopTypeFrBosFromJson(json);

  Map<String, dynamic> toJson() => $StoreListDataShopTypeFrBosToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}