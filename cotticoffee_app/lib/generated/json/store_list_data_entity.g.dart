import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/common/store/entity/store_list_data_entity.dart';

StoreListDataEntity $StoreListDataEntityFromJson(Map<String, dynamic> json) {
	final StoreListDataEntity storeListDataEntity = StoreListDataEntity();
	final List<StoreListDataModel>? oftenUsedShopList = jsonConvert.convertListNotNull<StoreListDataModel>(json['oftenUsedShopList']);
	if (oftenUsedShopList != null) {
		storeListDataEntity.oftenUsedShopList = oftenUsedShopList;
	}
	final List<StoreListDataModel>? nearbyShopList = jsonConvert.convertListNotNull<StoreListDataModel>(json['nearbyShopList']);
	if (nearbyShopList != null) {
		storeListDataEntity.nearbyShopList = nearbyShopList;
	}
	final int? shopCountLimitNum = jsonConvert.convert<int>(json['shopCountLimitNum']);
	if (shopCountLimitNum != null) {
		storeListDataEntity.shopCountLimitNum = shopCountLimitNum;
	}
	final List<StoreListDataShopTypeFrBos>? shopTypeFrBos = jsonConvert.convertListNotNull<StoreListDataShopTypeFrBos>(json['shopTypeFrBos']);
	if (shopTypeFrBos != null) {
		storeListDataEntity.shopTypeFrBos = shopTypeFrBos;
	}
	return storeListDataEntity;
}

Map<String, dynamic> $StoreListDataEntityToJson(StoreListDataEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['oftenUsedShopList'] =  entity.oftenUsedShopList?.map((v) => v.toJson()).toList();
	data['nearbyShopList'] =  entity.nearbyShopList?.map((v) => v.toJson()).toList();
	data['shopCountLimitNum'] = entity.shopCountLimitNum;
	data['shopTypeFrBos'] =  entity.shopTypeFrBos?.map((v) => v.toJson()).toList();
	return data;
}

StoreListDataModel $StoreListDataModelFromJson(Map<String, dynamic> json) {
	final StoreListDataModel storeListDataModel = StoreListDataModel();
	final int? shopMdCode = jsonConvert.convert<int>(json['shopMdCode']);
	if (shopMdCode != null) {
		storeListDataModel.shopMdCode = shopMdCode;
	}
	final dynamic youZanShopCode = jsonConvert.convert<dynamic>(json['youZanShopCode']);
	if (youZanShopCode != null) {
		storeListDataModel.youZanShopCode = youZanShopCode;
	}
	final dynamic onlineYouZanShopCode = jsonConvert.convert<dynamic>(json['onlineYouZanShopCode']);
	if (onlineYouZanShopCode != null) {
		storeListDataModel.onlineYouZanShopCode = onlineYouZanShopCode;
	}
	final String? shopName = jsonConvert.convert<String>(json['shopName']);
	if (shopName != null) {
		storeListDataModel.shopName = shopName;
	}
	final int? cityMdCode = jsonConvert.convert<int>(json['cityMdCode']);
	if (cityMdCode != null) {
		storeListDataModel.cityMdCode = cityMdCode;
	}
	final String? cityMdName = jsonConvert.convert<String>(json['cityMdName']);
	if (cityMdName != null) {
		storeListDataModel.cityMdName = cityMdName;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		storeListDataModel.address = address;
	}
	final dynamic images = jsonConvert.convert<dynamic>(json['images']);
	if (images != null) {
		storeListDataModel.images = images;
	}
	final String? currentSaleTime = jsonConvert.convert<String>(json['currentSaleTime']);
	if (currentSaleTime != null) {
		storeListDataModel.currentSaleTime = currentSaleTime;
	}
	final int? distance = jsonConvert.convert<int>(json['distance']);
	if (distance != null) {
		storeListDataModel.distance = distance;
	}
	final double? latitude = jsonConvert.convert<double>(json['latitude']);
	if (latitude != null) {
		storeListDataModel.latitude = latitude;
	}
	final double? longitude = jsonConvert.convert<double>(json['longitude']);
	if (longitude != null) {
		storeListDataModel.longitude = longitude;
	}
	final List<String>? mealTakeMode = jsonConvert.convertListNotNull<String>(json['mealTakeMode']);
	if (mealTakeMode != null) {
		storeListDataModel.mealTakeMode = mealTakeMode;
	}
	final List<int>? mealTakeModeCodes = jsonConvert.convertListNotNull<int>(json['mealTakeModeCodes']);
	if (mealTakeModeCodes != null) {
		storeListDataModel.mealTakeModeCodes = mealTakeModeCodes;
	}
	final dynamic regularTimeList = jsonConvert.convert<dynamic>(json['regularTimeList']);
	if (regularTimeList != null) {
		storeListDataModel.regularTimeList = regularTimeList;
	}
	final dynamic holidayTimeList = jsonConvert.convert<dynamic>(json['holidayTimeList']);
	if (holidayTimeList != null) {
		storeListDataModel.holidayTimeList = holidayTimeList;
	}
	final dynamic specialTimeList = jsonConvert.convert<dynamic>(json['specialTimeList']);
	if (specialTimeList != null) {
		storeListDataModel.specialTimeList = specialTimeList;
	}
	final dynamic setUpTime = jsonConvert.convert<dynamic>(json['setUpTime']);
	if (setUpTime != null) {
		storeListDataModel.setUpTime = setUpTime;
	}
	final String? planSetUpTime = jsonConvert.convert<String>(json['planSetUpTime']);
	if (planSetUpTime != null) {
		storeListDataModel.planSetUpTime = planSetUpTime;
	}
	final dynamic customerSubscribeShopOpeningNotice = jsonConvert.convert<dynamic>(json['customerSubscribeShopOpeningNotice']);
	if (customerSubscribeShopOpeningNotice != null) {
		storeListDataModel.customerSubscribeShopOpeningNotice = customerSubscribeShopOpeningNotice;
	}
	final bool? closed = jsonConvert.convert<bool>(json['closed']);
	if (closed != null) {
		storeListDataModel.closed = closed;
	}
	final dynamic dispatched = jsonConvert.convert<dynamic>(json['dispatched']);
	if (dispatched != null) {
		storeListDataModel.dispatched = dispatched;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		storeListDataModel.status = status;
	}
	final dynamic dispatchStatus = jsonConvert.convert<dynamic>(json['dispatchStatus']);
	if (dispatchStatus != null) {
		storeListDataModel.dispatchStatus = dispatchStatus;
	}
	final List<String>? deliveryChannel = jsonConvert.convertListNotNull<String>(json['deliveryChannel']);
	if (deliveryChannel != null) {
		storeListDataModel.deliveryChannel = deliveryChannel;
	}
	final dynamic selffetchpointId = jsonConvert.convert<dynamic>(json['selffetchpointId']);
	if (selffetchpointId != null) {
		storeListDataModel.selffetchpointId = selffetchpointId;
	}
	final int? trial = jsonConvert.convert<int>(json['trial']);
	if (trial != null) {
		storeListDataModel.trial = trial;
	}
	final dynamic matchMealTakeMode = jsonConvert.convert<dynamic>(json['matchMealTakeMode']);
	if (matchMealTakeMode != null) {
		storeListDataModel.matchMealTakeMode = matchMealTakeMode;
	}
	final String? empMobile = jsonConvert.convert<String>(json['empMobile']);
	if (empMobile != null) {
		storeListDataModel.empMobile = empMobile;
	}
	final String? statusReminder = jsonConvert.convert<String>(json['statusReminder']);
	if (statusReminder != null) {
		storeListDataModel.statusReminder = statusReminder;
	}
	final dynamic shopOperateStr = jsonConvert.convert<dynamic>(json['shopOperateStr']);
	if (shopOperateStr != null) {
		storeListDataModel.shopOperateStr = shopOperateStr;
	}
	final int? forceClosed = jsonConvert.convert<int>(json['forceClosed']);
	if (forceClosed != null) {
		storeListDataModel.forceClosed = forceClosed;
	}
	final StoreListDataModelApiConfig? apiConfig = jsonConvert.convert<StoreListDataModelApiConfig>(json['apiConfig']);
	if (apiConfig != null) {
		storeListDataModel.apiConfig = apiConfig;
	}
	final dynamic dispatchFeeStr = jsonConvert.convert<dynamic>(json['dispatchFeeStr']);
	if (dispatchFeeStr != null) {
		storeListDataModel.dispatchFeeStr = dispatchFeeStr;
	}
	final int? stepDistance = jsonConvert.convert<int>(json['stepDistance']);
	if (stepDistance != null) {
		storeListDataModel.stepDistance = stepDistance;
	}
	final int? shopType = jsonConvert.convert<int>(json['shopType']);
	if (shopType != null) {
		storeListDataModel.shopType = shopType;
	}
	final int? showSaleType = jsonConvert.convert<int>(json['showSaleType']);
	if (showSaleType != null) {
		storeListDataModel.showSaleType = showSaleType;
	}
	final String? canteenCardNameDesc = jsonConvert.convert<String>(json['canteenCardNameDesc']);
	if (canteenCardNameDesc != null) {
		storeListDataModel.canteenCardNameDesc = canteenCardNameDesc;
	}
	final String? planSetUpTimeStr = jsonConvert.convert<String>(json['planSetUpTimeStr']);
	if (planSetUpTimeStr != null) {
		storeListDataModel.planSetUpTimeStr = planSetUpTimeStr;
	}
	final bool? isCenterCity = jsonConvert.convert<bool>(json['isCenterCity']);
	if (isCenterCity != null) {
		storeListDataModel.isCenterCity = isCenterCity;
	}
	final bool? selected = jsonConvert.convert<bool>(json['selected']);
	if (selected != null) {
		storeListDataModel.selected = selected;
	}
	return storeListDataModel;
}

Map<String, dynamic> $StoreListDataModelToJson(StoreListDataModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['shopMdCode'] = entity.shopMdCode;
	data['youZanShopCode'] = entity.youZanShopCode;
	data['onlineYouZanShopCode'] = entity.onlineYouZanShopCode;
	data['shopName'] = entity.shopName;
	data['cityMdCode'] = entity.cityMdCode;
	data['cityMdName'] = entity.cityMdName;
	data['address'] = entity.address;
	data['images'] = entity.images;
	data['currentSaleTime'] = entity.currentSaleTime;
	data['distance'] = entity.distance;
	data['latitude'] = entity.latitude;
	data['longitude'] = entity.longitude;
	data['mealTakeMode'] =  entity.mealTakeMode;
	data['mealTakeModeCodes'] =  entity.mealTakeModeCodes;
	data['regularTimeList'] = entity.regularTimeList;
	data['holidayTimeList'] = entity.holidayTimeList;
	data['specialTimeList'] = entity.specialTimeList;
	data['setUpTime'] = entity.setUpTime;
	data['planSetUpTime'] = entity.planSetUpTime;
	data['customerSubscribeShopOpeningNotice'] = entity.customerSubscribeShopOpeningNotice;
	data['closed'] = entity.closed;
	data['dispatched'] = entity.dispatched;
	data['status'] = entity.status;
	data['dispatchStatus'] = entity.dispatchStatus;
	data['deliveryChannel'] =  entity.deliveryChannel;
	data['selffetchpointId'] = entity.selffetchpointId;
	data['trial'] = entity.trial;
	data['matchMealTakeMode'] = entity.matchMealTakeMode;
	data['empMobile'] = entity.empMobile;
	data['statusReminder'] = entity.statusReminder;
	data['shopOperateStr'] = entity.shopOperateStr;
	data['forceClosed'] = entity.forceClosed;
	data['apiConfig'] = entity.apiConfig?.toJson();
	data['dispatchFeeStr'] = entity.dispatchFeeStr;
	data['stepDistance'] = entity.stepDistance;
	data['shopType'] = entity.shopType;
	data['showSaleType'] = entity.showSaleType;
	data['canteenCardNameDesc'] = entity.canteenCardNameDesc;
	data['planSetUpTimeStr'] = entity.planSetUpTimeStr;
	data['isCenterCity'] = entity.isCenterCity;
	data['selected'] = entity.selected;
	return data;
}

StoreListDataModelApiConfig $StoreListDataModelApiConfigFromJson(Map<String, dynamic> json) {
	final StoreListDataModelApiConfig storeListDataModelApiConfig = StoreListDataModelApiConfig();
	final String? customerServiceHotline = jsonConvert.convert<String>(json['customerServiceHotline']);
	if (customerServiceHotline != null) {
		storeListDataModelApiConfig.customerServiceHotline = customerServiceHotline;
	}
	final String? customerServiceWorkingTime = jsonConvert.convert<String>(json['customerServiceWorkingTime']);
	if (customerServiceWorkingTime != null) {
		storeListDataModelApiConfig.customerServiceWorkingTime = customerServiceWorkingTime;
	}
	final String? customerServiceCase = jsonConvert.convert<String>(json['customerServiceCase']);
	if (customerServiceCase != null) {
		storeListDataModelApiConfig.customerServiceCase = customerServiceCase;
	}
	final String? customerServiceOrderUrl = jsonConvert.convert<String>(json['customerServiceOrderUrl']);
	if (customerServiceOrderUrl != null) {
		storeListDataModelApiConfig.customerServiceOrderUrl = customerServiceOrderUrl;
	}
	final String? afterTimeAppOpenPopUps = jsonConvert.convert<String>(json['afterTimeAppOpenPopUps']);
	if (afterTimeAppOpenPopUps != null) {
		storeListDataModelApiConfig.afterTimeAppOpenPopUps = afterTimeAppOpenPopUps;
	}
	final dynamic h5StyleJsCode = jsonConvert.convert<dynamic>(json['h5StyleJsCode']);
	if (h5StyleJsCode != null) {
		storeListDataModelApiConfig.h5StyleJsCode = h5StyleJsCode;
	}
	final bool? environment = jsonConvert.convert<bool>(json['environment']);
	if (environment != null) {
		storeListDataModelApiConfig.environment = environment;
	}
	final dynamic scanTipText = jsonConvert.convert<dynamic>(json['scanTipText']);
	if (scanTipText != null) {
		storeListDataModelApiConfig.scanTipText = scanTipText;
	}
	final String? miniProgramSharingSwitch = jsonConvert.convert<String>(json['miniProgramSharingSwitch']);
	if (miniProgramSharingSwitch != null) {
		storeListDataModelApiConfig.miniProgramSharingSwitch = miniProgramSharingSwitch;
	}
	final String? sharingToWechatMomentsSwitch = jsonConvert.convert<String>(json['sharingToWechatMomentsSwitch']);
	if (sharingToWechatMomentsSwitch != null) {
		storeListDataModelApiConfig.sharingToWechatMomentsSwitch = sharingToWechatMomentsSwitch;
	}
	final String? specialZoneSharingSwitch = jsonConvert.convert<String>(json['specialZoneSharingSwitch']);
	if (specialZoneSharingSwitch != null) {
		storeListDataModelApiConfig.specialZoneSharingSwitch = specialZoneSharingSwitch;
	}
	final int? shopMdCode = jsonConvert.convert<int>(json['shopMdCode']);
	if (shopMdCode != null) {
		storeListDataModelApiConfig.shopMdCode = shopMdCode;
	}
	final int? takeFoodMode = jsonConvert.convert<int>(json['takeFoodMode']);
	if (takeFoodMode != null) {
		storeListDataModelApiConfig.takeFoodMode = takeFoodMode;
	}
	final bool? exitButtonDisplay = jsonConvert.convert<bool>(json['exitButtonDisplay']);
	if (exitButtonDisplay != null) {
		storeListDataModelApiConfig.exitButtonDisplay = exitButtonDisplay;
	}
	final bool? showMyBounty = jsonConvert.convert<bool>(json['showMyBounty']);
	if (showMyBounty != null) {
		storeListDataModelApiConfig.showMyBounty = showMyBounty;
	}
	final List<StoreListDataModelApiConfigServiceModeList>? serviceModeList = jsonConvert.convertListNotNull<StoreListDataModelApiConfigServiceModeList>(json['serviceModeList']);
	if (serviceModeList != null) {
		storeListDataModelApiConfig.serviceModeList = serviceModeList;
	}
	final String? confirmOrderTakeFoodModeImg = jsonConvert.convert<String>(json['confirmOrderTakeFoodModeImg']);
	if (confirmOrderTakeFoodModeImg != null) {
		storeListDataModelApiConfig.confirmOrderTakeFoodModeImg = confirmOrderTakeFoodModeImg;
	}
	final int? openingScreenCountdown = jsonConvert.convert<int>(json['openingScreenCountdown']);
	if (openingScreenCountdown != null) {
		storeListDataModelApiConfig.openingScreenCountdown = openingScreenCountdown;
	}
	final String? orderListEmptyContext = jsonConvert.convert<String>(json['orderListEmptyContext']);
	if (orderListEmptyContext != null) {
		storeListDataModelApiConfig.orderListEmptyContext = orderListEmptyContext;
	}
	final dynamic communityWelfareTitle = jsonConvert.convert<dynamic>(json['communityWelfareTitle']);
	if (communityWelfareTitle != null) {
		storeListDataModelApiConfig.communityWelfareTitle = communityWelfareTitle;
	}
	final int? currentTime = jsonConvert.convert<int>(json['currentTime']);
	if (currentTime != null) {
		storeListDataModelApiConfig.currentTime = currentTime;
	}
	final String? arriveOnTime = jsonConvert.convert<String>(json['arriveOnTime']);
	if (arriveOnTime != null) {
		storeListDataModelApiConfig.arriveOnTime = arriveOnTime;
	}
	final String? arriveOnTimeTips = jsonConvert.convert<String>(json['arriveOnTimeTips']);
	if (arriveOnTimeTips != null) {
		storeListDataModelApiConfig.arriveOnTimeTips = arriveOnTimeTips;
	}
	final bool? showEstimatePrice = jsonConvert.convert<bool>(json['showEstimatePrice']);
	if (showEstimatePrice != null) {
		storeListDataModelApiConfig.showEstimatePrice = showEstimatePrice;
	}
	final int? maxCount = jsonConvert.convert<int>(json['maxCount']);
	if (maxCount != null) {
		storeListDataModelApiConfig.maxCount = maxCount;
	}
	return storeListDataModelApiConfig;
}

Map<String, dynamic> $StoreListDataModelApiConfigToJson(StoreListDataModelApiConfig entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['customerServiceHotline'] = entity.customerServiceHotline;
	data['customerServiceWorkingTime'] = entity.customerServiceWorkingTime;
	data['customerServiceCase'] = entity.customerServiceCase;
	data['customerServiceOrderUrl'] = entity.customerServiceOrderUrl;
	data['afterTimeAppOpenPopUps'] = entity.afterTimeAppOpenPopUps;
	data['h5StyleJsCode'] = entity.h5StyleJsCode;
	data['environment'] = entity.environment;
	data['scanTipText'] = entity.scanTipText;
	data['miniProgramSharingSwitch'] = entity.miniProgramSharingSwitch;
	data['sharingToWechatMomentsSwitch'] = entity.sharingToWechatMomentsSwitch;
	data['specialZoneSharingSwitch'] = entity.specialZoneSharingSwitch;
	data['shopMdCode'] = entity.shopMdCode;
	data['takeFoodMode'] = entity.takeFoodMode;
	data['exitButtonDisplay'] = entity.exitButtonDisplay;
	data['showMyBounty'] = entity.showMyBounty;
	data['serviceModeList'] =  entity.serviceModeList?.map((v) => v.toJson()).toList();
	data['confirmOrderTakeFoodModeImg'] = entity.confirmOrderTakeFoodModeImg;
	data['openingScreenCountdown'] = entity.openingScreenCountdown;
	data['orderListEmptyContext'] = entity.orderListEmptyContext;
	data['communityWelfareTitle'] = entity.communityWelfareTitle;
	data['currentTime'] = entity.currentTime;
	data['arriveOnTime'] = entity.arriveOnTime;
	data['arriveOnTimeTips'] = entity.arriveOnTimeTips;
	data['showEstimatePrice'] = entity.showEstimatePrice;
	data['maxCount'] = entity.maxCount;
	return data;
}

StoreListDataModelApiConfigServiceModeList $StoreListDataModelApiConfigServiceModeListFromJson(Map<String, dynamic> json) {
	final StoreListDataModelApiConfigServiceModeList storeListDataModelApiConfigServiceModeList = StoreListDataModelApiConfigServiceModeList();
	final int? index = jsonConvert.convert<int>(json['index']);
	if (index != null) {
		storeListDataModelApiConfigServiceModeList.index = index;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		storeListDataModelApiConfigServiceModeList.name = name;
	}
	return storeListDataModelApiConfigServiceModeList;
}

Map<String, dynamic> $StoreListDataModelApiConfigServiceModeListToJson(StoreListDataModelApiConfigServiceModeList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['index'] = entity.index;
	data['name'] = entity.name;
	return data;
}

StoreListDataShopTypeFrBos $StoreListDataShopTypeFrBosFromJson(Map<String, dynamic> json) {
	final StoreListDataShopTypeFrBos storeListDataShopTypeFrBos = StoreListDataShopTypeFrBos();
	final int? index = jsonConvert.convert<int>(json['index']);
	if (index != null) {
		storeListDataShopTypeFrBos.index = index;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		storeListDataShopTypeFrBos.name = name;
	}
	final String? iconUrl = jsonConvert.convert<String>(json['iconUrl']);
	if (iconUrl != null) {
		storeListDataShopTypeFrBos.iconUrl = iconUrl;
	}
	final String? color = jsonConvert.convert<String>(json['color']);
	if (color != null) {
		storeListDataShopTypeFrBos.color = color;
	}
	return storeListDataShopTypeFrBos;
}

Map<String, dynamic> $StoreListDataShopTypeFrBosToJson(StoreListDataShopTypeFrBos entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['index'] = entity.index;
	data['name'] = entity.name;
	data['iconUrl'] = entity.iconUrl;
	data['color'] = entity.color;
	return data;
}