import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';
import 'package:cotti_client/global/entity/config_entity.dart';


ShopInfoEntity $ShopInfoEntityFromJson(Map<String, dynamic> json) {
	final ShopInfoEntity shopInfoEntity = ShopInfoEntity();
	final int? shopState = jsonConvert.convert<int>(json['shopState']);
	if (shopState != null) {
		shopInfoEntity.shopState = shopState;
	}
	final ShopDetail? shopDetail = jsonConvert.convert<ShopDetail>(json['shopDetailVO']);
	if (shopDetail != null) {
		shopInfoEntity.shopDetail = shopDetail;
	}
	final ShopMatchFailConfig? shopMatchFailConfig = jsonConvert.convert<ShopMatchFailConfig>(json['shopMatchFailConfigDto']);
	if (shopMatchFailConfig != null) {
		shopInfoEntity.shopMatchFailConfig = shopMatchFailConfig;
	}
	final bool? takeFoodModeChangeFlag = jsonConvert.convert<bool>(json['takeFoodModeChangeFlag']);
	if (takeFoodModeChangeFlag != null) {
		shopInfoEntity.takeFoodModeChangeFlag = takeFoodModeChangeFlag;
	}
	final double? distance = jsonConvert.convert<double>(json['distance']);
	if (distance != null) {
		shopInfoEntity.distance = distance;
	}
	final bool? distanceFlag = jsonConvert.convert<bool>(json['distanceFlag']);
	if (distanceFlag != null) {
		shopInfoEntity.distanceFlag = distanceFlag;
	}
	final bool? addressFlag = jsonConvert.convert<bool>(json['addressFlag']);
	if (addressFlag != null) {
		shopInfoEntity.addressFlag = addressFlag;
	}
	final bool? deliveryDistanceFlag = jsonConvert.convert<bool>(json['deliveryDistanceFlag']);
	if (deliveryDistanceFlag != null) {
		shopInfoEntity.deliveryDistanceFlag = deliveryDistanceFlag;
	}
	final List<CurrentPositionTakeFoodMode>? currentPositionTakeFoodMode = jsonConvert.convertListNotNull<CurrentPositionTakeFoodMode>(json['currentPositionTakeFoodMode']);
	if (currentPositionTakeFoodMode != null) {
		shopInfoEntity.currentPositionTakeFoodMode = currentPositionTakeFoodMode;
	}
	final String? expressMessage = jsonConvert.convert<String>(json['expressMessage']);
	if (expressMessage != null) {
		shopInfoEntity.expressMessage = expressMessage;
	}
	final int? takeOutShopResultType = jsonConvert.convert<int>(json['takeOutShopResultType']);
	if (takeOutShopResultType != null) {
		shopInfoEntity.takeOutShopResultType = takeOutShopResultType;
	}
	return shopInfoEntity;
}

Map<String, dynamic> $ShopInfoEntityToJson(ShopInfoEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['shopState'] = entity.shopState;
	data['shopDetailVO'] = entity.shopDetail?.toJson();
	data['shopMatchFailConfigDto'] = entity.shopMatchFailConfig?.toJson();
	data['takeFoodModeChangeFlag'] = entity.takeFoodModeChangeFlag;
	data['distance'] = entity.distance;
	data['distanceFlag'] = entity.distanceFlag;
	data['addressFlag'] = entity.addressFlag;
	data['deliveryDistanceFlag'] = entity.deliveryDistanceFlag;
	data['currentPositionTakeFoodMode'] =  entity.currentPositionTakeFoodMode?.map((v) => v.toJson()).toList();
	data['expressMessage'] = entity.expressMessage;
	data['takeOutShopResultType'] = entity.takeOutShopResultType;
	return data;
}

ShopDetail $ShopDetailFromJson(Map<String, dynamic> json) {
	final ShopDetail shopDetail = ShopDetail();
	final int? shopMdCode = jsonConvert.convert<int>(json['shopMdCode']);
	if (shopMdCode != null) {
		shopDetail.shopMdCode = shopMdCode;
	}
	final String? shopName = jsonConvert.convert<String>(json['shopName']);
	if (shopName != null) {
		shopDetail.shopName = shopName;
	}
	final String? cityMdCode = jsonConvert.convert<String>(json['cityMdCode']);
	if (cityMdCode != null) {
		shopDetail.cityMdCode = cityMdCode;
	}
	final String? cityMdName = jsonConvert.convert<String>(json['cityMdName']);
	if (cityMdName != null) {
		shopDetail.cityMdName = cityMdName;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		shopDetail.address = address;
	}
	final String? addressPrompt = jsonConvert.convert<String>(json['addressPrompt']);
	if (addressPrompt != null) {
		shopDetail.addressPrompt = addressPrompt;
	}
	final String? canteenCardName = jsonConvert.convert<String>(json['canteenCardName']);
	if (canteenCardName != null) {
		shopDetail.canteenCardName = canteenCardName;
	}
	final String? canteenCardNameDesc = jsonConvert.convert<String>(json['canteenCardNameDesc']);
	if (canteenCardNameDesc != null) {
		shopDetail.canteenCardNameDesc = canteenCardNameDesc;
	}
	final String? planSetUpTimeStr = jsonConvert.convert<String>(json['planSetUpTimeStr']);
	if (planSetUpTimeStr != null) {
		shopDetail.planSetUpTimeStr = planSetUpTimeStr;
	}
	final String? planSetUpTimeDesc = jsonConvert.convert<String>(json['planSetUpTimeDesc']);
	if (planSetUpTimeDesc != null) {
		shopDetail.planSetUpTimeDesc = planSetUpTimeDesc;
	}
	final List<String>? images = jsonConvert.convertListNotNull<String>(json['images']);
	if (images != null) {
		shopDetail.images = images;
	}
	final String? currentSaleTime = jsonConvert.convert<String>(json['currentSaleTime']);
	if (currentSaleTime != null) {
		shopDetail.currentSaleTime = currentSaleTime;
	}
	final int? distance = jsonConvert.convert<int>(json['distance']);
	if (distance != null) {
		shopDetail.distance = distance;
	}
	final double? latitude = jsonConvert.convert<double>(json['latitude']);
	if (latitude != null) {
		shopDetail.latitude = latitude;
	}
	final double? longitude = jsonConvert.convert<double>(json['longitude']);
	if (longitude != null) {
		shopDetail.longitude = longitude;
	}
	final List<String>? mealTakeMode = jsonConvert.convertListNotNull<String>(json['mealTakeMode']);
	if (mealTakeMode != null) {
		shopDetail.mealTakeMode = mealTakeMode;
	}
	final List<int>? mealTakeModeCodes = jsonConvert.convertListNotNull<int>(json['mealTakeModeCodes']);
	if (mealTakeModeCodes != null) {
		shopDetail.mealTakeModeCodes = mealTakeModeCodes;
	}
	final List<String>? regularTimeList = jsonConvert.convertListNotNull<String>(json['regularTimeList']);
	if (regularTimeList != null) {
		shopDetail.regularTimeList = regularTimeList;
	}
	final List<String>? holidayTimeList = jsonConvert.convertListNotNull<String>(json['holidayTimeList']);
	if (holidayTimeList != null) {
		shopDetail.holidayTimeList = holidayTimeList;
	}
	final List<String>? specialTimeList = jsonConvert.convertListNotNull<String>(json['specialTimeList']);
	if (specialTimeList != null) {
		shopDetail.specialTimeList = specialTimeList;
	}
	final String? setUpTime = jsonConvert.convert<String>(json['setUpTime']);
	if (setUpTime != null) {
		shopDetail.setUpTime = setUpTime;
	}
	final String? planSetUpTime = jsonConvert.convert<String>(json['planSetUpTime']);
	if (planSetUpTime != null) {
		shopDetail.planSetUpTime = planSetUpTime;
	}
	final int? customerSubscribeShopOpeningNotice = jsonConvert.convert<int>(json['customerSubscribeShopOpeningNotice']);
	if (customerSubscribeShopOpeningNotice != null) {
		shopDetail.customerSubscribeShopOpeningNotice = customerSubscribeShopOpeningNotice;
	}
	final bool? closed = jsonConvert.convert<bool>(json['closed']);
	if (closed != null) {
		shopDetail.closed = closed;
	}
	final bool? dispatched = jsonConvert.convert<bool>(json['dispatched']);
	if (dispatched != null) {
		shopDetail.dispatched = dispatched;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		shopDetail.status = status;
	}
	final List<String>? dispatchStatus = jsonConvert.convertListNotNull<String>(json['dispatchStatus']);
	if (dispatchStatus != null) {
		shopDetail.dispatchStatus = dispatchStatus;
	}
	final List<String>? deliveryChannel = jsonConvert.convertListNotNull<String>(json['deliveryChannel']);
	if (deliveryChannel != null) {
		shopDetail.deliveryChannel = deliveryChannel;
	}
	final int? selffetchpointId = jsonConvert.convert<int>(json['selffetchpointId']);
	if (selffetchpointId != null) {
		shopDetail.selffetchpointId = selffetchpointId;
	}
	final int? trial = jsonConvert.convert<int>(json['trial']);
	if (trial != null) {
		shopDetail.trial = trial;
	}
	final int? matchMealTakeMode = jsonConvert.convert<int>(json['matchMealTakeMode']);
	if (matchMealTakeMode != null) {
		shopDetail.matchMealTakeMode = matchMealTakeMode;
	}
	final String? empMobile = jsonConvert.convert<String>(json['empMobile']);
	if (empMobile != null) {
		shopDetail.empMobile = empMobile;
	}
	final String? statusReminder = jsonConvert.convert<String>(json['statusReminder']);
	if (statusReminder != null) {
		shopDetail.statusReminder = statusReminder;
	}
	final String? shopOperateStr = jsonConvert.convert<String>(json['shopOperateStr']);
	if (shopOperateStr != null) {
		shopDetail.shopOperateStr = shopOperateStr;
	}
	final int? forceClosed = jsonConvert.convert<int>(json['forceClosed']);
	if (forceClosed != null) {
		shopDetail.forceClosed = forceClosed;
	}
	final String? dispatchFeeStr = jsonConvert.convert<String>(json['dispatchFeeStr']);
	if (dispatchFeeStr != null) {
		shopDetail.dispatchFeeStr = dispatchFeeStr;
	}
	final ConfigEntity? apiConfig = jsonConvert.convert<ConfigEntity>(json['apiConfig']);
	if (apiConfig != null) {
		shopDetail.apiConfig = apiConfig;
	}
	final ShopTypeFrBO? shopTypeFrBO = jsonConvert.convert<ShopTypeFrBO>(json['shopTypeFrBO']);
	if (shopTypeFrBO != null) {
		shopDetail.shopTypeFrBO = shopTypeFrBO;
	}
	final GuidanceToBeOpenedContext? guidanceToBeOpenedContext = jsonConvert.convert<GuidanceToBeOpenedContext>(json['guidanceToBeOpenedContext']);
	if (guidanceToBeOpenedContext != null) {
		shopDetail.guidanceToBeOpenedContext = guidanceToBeOpenedContext;
	}
	return shopDetail;
}

Map<String, dynamic> $ShopDetailToJson(ShopDetail entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['shopMdCode'] = entity.shopMdCode;
	data['shopName'] = entity.shopName;
	data['cityMdCode'] = entity.cityMdCode;
	data['cityMdName'] = entity.cityMdName;
	data['address'] = entity.address;
	data['addressPrompt'] = entity.addressPrompt;
	data['canteenCardName'] = entity.canteenCardName;
	data['canteenCardNameDesc'] = entity.canteenCardNameDesc;
	data['planSetUpTimeStr'] = entity.planSetUpTimeStr;
	data['planSetUpTimeDesc'] = entity.planSetUpTimeDesc;
	data['images'] =  entity.images;
	data['currentSaleTime'] = entity.currentSaleTime;
	data['distance'] = entity.distance;
	data['latitude'] = entity.latitude;
	data['longitude'] = entity.longitude;
	data['mealTakeMode'] =  entity.mealTakeMode;
	data['mealTakeModeCodes'] =  entity.mealTakeModeCodes;
	data['regularTimeList'] =  entity.regularTimeList;
	data['holidayTimeList'] =  entity.holidayTimeList;
	data['specialTimeList'] =  entity.specialTimeList;
	data['setUpTime'] = entity.setUpTime;
	data['planSetUpTime'] = entity.planSetUpTime;
	data['customerSubscribeShopOpeningNotice'] = entity.customerSubscribeShopOpeningNotice;
	data['closed'] = entity.closed;
	data['dispatched'] = entity.dispatched;
	data['status'] = entity.status;
	data['dispatchStatus'] =  entity.dispatchStatus;
	data['deliveryChannel'] =  entity.deliveryChannel;
	data['selffetchpointId'] = entity.selffetchpointId;
	data['trial'] = entity.trial;
	data['matchMealTakeMode'] = entity.matchMealTakeMode;
	data['empMobile'] = entity.empMobile;
	data['statusReminder'] = entity.statusReminder;
	data['shopOperateStr'] = entity.shopOperateStr;
	data['forceClosed'] = entity.forceClosed;
	data['dispatchFeeStr'] = entity.dispatchFeeStr;
	data['apiConfig'] = entity.apiConfig?.toJson();
	data['shopTypeFrBO'] = entity.shopTypeFrBO?.toJson();
	data['guidanceToBeOpenedContext'] = entity.guidanceToBeOpenedContext?.toJson();
	return data;
}

CurrentPositionTakeFoodMode $CurrentPositionTakeFoodModeFromJson(Map<String, dynamic> json) {
	final CurrentPositionTakeFoodMode currentPositionTakeFoodMode = CurrentPositionTakeFoodMode();
	final int? code = jsonConvert.convert<int>(json['code']);
	if (code != null) {
		currentPositionTakeFoodMode.code = code;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		currentPositionTakeFoodMode.name = name;
	}
	final bool? selected = jsonConvert.convert<bool>(json['selected']);
	if (selected != null) {
		currentPositionTakeFoodMode.selected = selected;
	}
	return currentPositionTakeFoodMode;
}

Map<String, dynamic> $CurrentPositionTakeFoodModeToJson(CurrentPositionTakeFoodMode entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['code'] = entity.code;
	data['name'] = entity.name;
	data['selected'] = entity.selected;
	return data;
}

ShopMatchFailConfig $ShopMatchFailConfigFromJson(Map<String, dynamic> json) {
	final ShopMatchFailConfig shopMatchFailConfig = ShopMatchFailConfig();
	final String? shopMatchFailMsg = jsonConvert.convert<String>(json['shopMatchFailMsg']);
	if (shopMatchFailMsg != null) {
		shopMatchFailConfig.shopMatchFailMsg = shopMatchFailMsg;
	}
	final String? buttonMsg = jsonConvert.convert<String>(json['buttonMsg']);
	if (buttonMsg != null) {
		shopMatchFailConfig.buttonMsg = buttonMsg;
	}
	final String? shopMatchFailTitle = jsonConvert.convert<String>(json['shopMatchFailTitle']);
	if (shopMatchFailTitle != null) {
		shopMatchFailConfig.shopMatchFailTitle = shopMatchFailTitle;
	}
	return shopMatchFailConfig;
}

Map<String, dynamic> $ShopMatchFailConfigToJson(ShopMatchFailConfig entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['shopMatchFailMsg'] = entity.shopMatchFailMsg;
	data['buttonMsg'] = entity.buttonMsg;
	data['shopMatchFailTitle'] = entity.shopMatchFailTitle;
	return data;
}

ShopTypeFrBO $ShopTypeFrBOFromJson(Map<String, dynamic> json) {
	final ShopTypeFrBO shopTypeFrBO = ShopTypeFrBO();
	final int? index = jsonConvert.convert<int>(json['index']);
	if (index != null) {
		shopTypeFrBO.index = index;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		shopTypeFrBO.name = name;
	}
	final String? iconUrl = jsonConvert.convert<String>(json['iconUrl']);
	if (iconUrl != null) {
		shopTypeFrBO.iconUrl = iconUrl;
	}
	final String? color = jsonConvert.convert<String>(json['color']);
	if (color != null) {
		shopTypeFrBO.color = color;
	}
	return shopTypeFrBO;
}

Map<String, dynamic> $ShopTypeFrBOToJson(ShopTypeFrBO entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['index'] = entity.index;
	data['name'] = entity.name;
	data['iconUrl'] = entity.iconUrl;
	data['color'] = entity.color;
	return data;
}

GuidanceToBeOpenedContext $GuidanceToBeOpenedContextFromJson(Map<String, dynamic> json) {
	final GuidanceToBeOpenedContext guidanceToBeOpenedContext = GuidanceToBeOpenedContext();
	final String? toolTip = jsonConvert.convert<String>(json['toolTip']);
	if (toolTip != null) {
		guidanceToBeOpenedContext.toolTip = toolTip;
	}
	final String? openDateContext = jsonConvert.convert<String>(json['openDateContext']);
	if (openDateContext != null) {
		guidanceToBeOpenedContext.openDateContext = openDateContext;
	}
	final String? openDateDefaultContext = jsonConvert.convert<String>(json['openDateDefaultContext']);
	if (openDateDefaultContext != null) {
		guidanceToBeOpenedContext.openDateDefaultContext = openDateDefaultContext;
	}
	final bool? isExpand = jsonConvert.convert<bool>(json['isExpand']);
	if (isExpand != null) {
		guidanceToBeOpenedContext.isExpand = isExpand;
	}
	return guidanceToBeOpenedContext;
}

Map<String, dynamic> $GuidanceToBeOpenedContextToJson(GuidanceToBeOpenedContext entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['toolTip'] = entity.toolTip;
	data['openDateContext'] = entity.openDateContext;
	data['openDateDefaultContext'] = entity.openDateDefaultContext;
	data['isExpand'] = entity.isExpand;
	return data;
}