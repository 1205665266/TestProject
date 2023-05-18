import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/global/entity/config_entity.dart';

ConfigEntity $ConfigEntityFromJson(Map<String, dynamic> json) {
	final ConfigEntity configEntity = ConfigEntity();
	final String? customerServiceHotline = jsonConvert.convert<String>(json['customerServiceHotline']);
	if (customerServiceHotline != null) {
		configEntity.customerServiceHotline = customerServiceHotline;
	}
	final String? customerServiceWorkingTime = jsonConvert.convert<String>(json['customerServiceWorkingTime']);
	if (customerServiceWorkingTime != null) {
		configEntity.customerServiceWorkingTime = customerServiceWorkingTime;
	}
	final String? customerServiceCase = jsonConvert.convert<String>(json['customerServiceCase']);
	if (customerServiceCase != null) {
		configEntity.customerServiceCase = customerServiceCase;
	}
	final String? customerServiceOrderUrl = jsonConvert.convert<String>(json['customerServiceOrderUrl']);
	if (customerServiceOrderUrl != null) {
		configEntity.customerServiceOrderUrl = customerServiceOrderUrl;
	}
	final String? afterTimeAppOpenPopUps = jsonConvert.convert<String>(json['afterTimeAppOpenPopUps']);
	if (afterTimeAppOpenPopUps != null) {
		configEntity.afterTimeAppOpenPopUps = afterTimeAppOpenPopUps;
	}
	final String? h5StyleJsCode = jsonConvert.convert<String>(json['h5StyleJsCode']);
	if (h5StyleJsCode != null) {
		configEntity.h5StyleJsCode = h5StyleJsCode;
	}
	final bool? environment = jsonConvert.convert<bool>(json['environment']);
	if (environment != null) {
		configEntity.environment = environment;
	}
	final String? miniProgramSharingSwitch = jsonConvert.convert<String>(json['miniProgramSharingSwitch']);
	if (miniProgramSharingSwitch != null) {
		configEntity.miniProgramSharingSwitch = miniProgramSharingSwitch;
	}
	final String? sharingToWechatMomentsSwitch = jsonConvert.convert<String>(json['sharingToWechatMomentsSwitch']);
	if (sharingToWechatMomentsSwitch != null) {
		configEntity.sharingToWechatMomentsSwitch = sharingToWechatMomentsSwitch;
	}
	final String? specialZoneSharingSwitch = jsonConvert.convert<String>(json['specialZoneSharingSwitch']);
	if (specialZoneSharingSwitch != null) {
		configEntity.specialZoneSharingSwitch = specialZoneSharingSwitch;
	}
	final int? takeFoodMode = jsonConvert.convert<int>(json['takeFoodMode']);
	if (takeFoodMode != null) {
		configEntity.takeFoodMode = takeFoodMode;
	}
	final bool? exitButtonDisplay = jsonConvert.convert<bool>(json['exitButtonDisplay']);
	if (exitButtonDisplay != null) {
		configEntity.exitButtonDisplay = exitButtonDisplay;
	}
	final bool? showMyBounty = jsonConvert.convert<bool>(json['showMyBounty']);
	if (showMyBounty != null) {
		configEntity.showMyBounty = showMyBounty;
	}
	final String? arriveOnTime = jsonConvert.convert<String>(json['arriveOnTime']);
	if (arriveOnTime != null) {
		configEntity.arriveOnTime = arriveOnTime;
	}
	final String? arriveOnTimeTips = jsonConvert.convert<String>(json['arriveOnTimeTips']);
	if (arriveOnTimeTips != null) {
		configEntity.arriveOnTimeTips = arriveOnTimeTips;
	}
	final List<ServiceMode>? serviceModeList = jsonConvert.convertListNotNull<ServiceMode>(json['serviceModeList']);
	if (serviceModeList != null) {
		configEntity.serviceModeList = serviceModeList;
	}
	final int? openingScreenCountdown = jsonConvert.convert<int>(json['openingScreenCountdown']);
	if (openingScreenCountdown != null) {
		configEntity.openingScreenCountdown = openingScreenCountdown;
	}
	final String? orderListEmptyContext = jsonConvert.convert<String>(json['orderListEmptyContext']);
	if (orderListEmptyContext != null) {
		configEntity.orderListEmptyContext = orderListEmptyContext;
	}
	final String? communityWelfareTitle = jsonConvert.convert<String>(json['communityWelfareTitle']);
	if (communityWelfareTitle != null) {
		configEntity.communityWelfareTitle = communityWelfareTitle;
	}
	final int? currentTime = jsonConvert.convert<int>(json['currentTime']);
	if (currentTime != null) {
		configEntity.currentTime = currentTime;
	}
	final int? showEstimatePrice = jsonConvert.convert<int>(json['showEstimatePrice']);
	if (showEstimatePrice != null) {
		configEntity.showEstimatePrice = showEstimatePrice;
	}
	final int? maxCount = jsonConvert.convert<int>(json['maxCount']);
	if (maxCount != null) {
		configEntity.maxCount = maxCount;
	}
	final String? couponExchangeMenuConfig = jsonConvert.convert<String>(json['couponExchangeMenuConfig']);
	if (couponExchangeMenuConfig != null) {
		configEntity.couponExchangeMenuConfig = couponExchangeMenuConfig;
	}
	final String? couponExchangeMenuConfigForHis = jsonConvert.convert<String>(json['couponExchangeMenuConfigForHis']);
	if (couponExchangeMenuConfigForHis != null) {
		configEntity.couponExchangeMenuConfigForHis = couponExchangeMenuConfigForHis;
	}
	final String? voucherExchangeMenuConfigForHis = jsonConvert.convert<String>(json['voucherExchangeMenuConfigForHis']);
	if (voucherExchangeMenuConfigForHis != null) {
		configEntity.voucherExchangeMenuConfigForHis = voucherExchangeMenuConfigForHis;
	}
	final String? installationActivityNo = jsonConvert.convert<String>(json['installationActivityNo']);
	if (installationActivityNo != null) {
		configEntity.installationActivityNo = installationActivityNo;
	}
	final int? installationActivityTimes = jsonConvert.convert<int>(json['installationActivityTimes']);
	if (installationActivityTimes != null) {
		configEntity.installationActivityTimes = installationActivityTimes;
	}
	final List<InstallationActivity>? installationActivityList = jsonConvert.convertListNotNull<InstallationActivity>(json['installationActivityDtoList']);
	if (installationActivityList != null) {
		configEntity.installationActivityList = installationActivityList;
	}
	final FirstOrderFreeShippingGlobal? firstOrderFreeShippingGlobalResult = jsonConvert.convert<FirstOrderFreeShippingGlobal>(json['firstOrderFreeShippingGlobalResult']);
	if (firstOrderFreeShippingGlobalResult != null) {
		configEntity.firstOrderFreeShippingGlobalResult = firstOrderFreeShippingGlobalResult;
	}
	final ShopTypeFilter? shopTypeFilter = jsonConvert.convert<ShopTypeFilter>(json['shopTypeFilter']);
	if (shopTypeFilter != null) {
		configEntity.shopTypeFilter = shopTypeFilter;
	}
	final bool? showVoucher = jsonConvert.convert<bool>(json['showVoucher']);
	if (showVoucher != null) {
		configEntity.showVoucher = showVoucher;
	}
	return configEntity;
}

Map<String, dynamic> $ConfigEntityToJson(ConfigEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['customerServiceHotline'] = entity.customerServiceHotline;
	data['customerServiceWorkingTime'] = entity.customerServiceWorkingTime;
	data['customerServiceCase'] = entity.customerServiceCase;
	data['customerServiceOrderUrl'] = entity.customerServiceOrderUrl;
	data['afterTimeAppOpenPopUps'] = entity.afterTimeAppOpenPopUps;
	data['h5StyleJsCode'] = entity.h5StyleJsCode;
	data['environment'] = entity.environment;
	data['miniProgramSharingSwitch'] = entity.miniProgramSharingSwitch;
	data['sharingToWechatMomentsSwitch'] = entity.sharingToWechatMomentsSwitch;
	data['specialZoneSharingSwitch'] = entity.specialZoneSharingSwitch;
	data['takeFoodMode'] = entity.takeFoodMode;
	data['exitButtonDisplay'] = entity.exitButtonDisplay;
	data['showMyBounty'] = entity.showMyBounty;
	data['arriveOnTime'] = entity.arriveOnTime;
	data['arriveOnTimeTips'] = entity.arriveOnTimeTips;
	data['serviceModeList'] =  entity.serviceModeList?.map((v) => v.toJson()).toList();
	data['openingScreenCountdown'] = entity.openingScreenCountdown;
	data['orderListEmptyContext'] = entity.orderListEmptyContext;
	data['communityWelfareTitle'] = entity.communityWelfareTitle;
	data['currentTime'] = entity.currentTime;
	data['showEstimatePrice'] = entity.showEstimatePrice;
	data['maxCount'] = entity.maxCount;
	data['couponExchangeMenuConfig'] = entity.couponExchangeMenuConfig;
	data['couponExchangeMenuConfigForHis'] = entity.couponExchangeMenuConfigForHis;
	data['voucherExchangeMenuConfigForHis'] = entity.voucherExchangeMenuConfigForHis;
	data['installationActivityNo'] = entity.installationActivityNo;
	data['installationActivityTimes'] = entity.installationActivityTimes;
	data['installationActivityDtoList'] =  entity.installationActivityList?.map((v) => v.toJson()).toList();
	data['firstOrderFreeShippingGlobalResult'] = entity.firstOrderFreeShippingGlobalResult?.toJson();
	data['shopTypeFilter'] = entity.shopTypeFilter?.toJson();
	data['showVoucher'] = entity.showVoucher;
	return data;
}

ServiceMode $ServiceModeFromJson(Map<String, dynamic> json) {
	final ServiceMode serviceMode = ServiceMode();
	final int? index = jsonConvert.convert<int>(json['index']);
	if (index != null) {
		serviceMode.index = index;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		serviceMode.name = name;
	}
	return serviceMode;
}

Map<String, dynamic> $ServiceModeToJson(ServiceMode entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['index'] = entity.index;
	data['name'] = entity.name;
	return data;
}

FirstOrderFreeShippingGlobal $FirstOrderFreeShippingGlobalFromJson(Map<String, dynamic> json) {
	final FirstOrderFreeShippingGlobal firstOrderFreeShippingGlobal = FirstOrderFreeShippingGlobal();
	final String? firstOrderFreeShippingMsg = jsonConvert.convert<String>(json['firstOrderFreeShippingMsg']);
	if (firstOrderFreeShippingMsg != null) {
		firstOrderFreeShippingGlobal.firstOrderFreeShippingMsg = firstOrderFreeShippingMsg;
	}
	final bool? freeSwitch = jsonConvert.convert<bool>(json['freeSwitch']);
	if (freeSwitch != null) {
		firstOrderFreeShippingGlobal.freeSwitch = freeSwitch;
	}
	return firstOrderFreeShippingGlobal;
}

Map<String, dynamic> $FirstOrderFreeShippingGlobalToJson(FirstOrderFreeShippingGlobal entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['firstOrderFreeShippingMsg'] = entity.firstOrderFreeShippingMsg;
	data['freeSwitch'] = entity.freeSwitch;
	return data;
}

ShopTypeFilter $ShopTypeFilterFromJson(Map<String, dynamic> json) {
	final ShopTypeFilter shopTypeFilter = ShopTypeFilter();
	final bool? filterFlag = jsonConvert.convert<bool>(json['filterFlag']);
	if (filterFlag != null) {
		shopTypeFilter.filterFlag = filterFlag;
	}
	final List<int>? codes = jsonConvert.convertListNotNull<int>(json['codes']);
	if (codes != null) {
		shopTypeFilter.codes = codes;
	}
	return shopTypeFilter;
}

Map<String, dynamic> $ShopTypeFilterToJson(ShopTypeFilter entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['filterFlag'] = entity.filterFlag;
	data['codes'] =  entity.codes;
	return data;
}

InstallationActivity $InstallationActivityFromJson(Map<String, dynamic> json) {
	final InstallationActivity installationActivity = InstallationActivity();
	final String? installationActivityNo = jsonConvert.convert<String>(json['installationActivityNo']);
	if (installationActivityNo != null) {
		installationActivity.installationActivityNo = installationActivityNo;
	}
	final int? installationActivityTimes = jsonConvert.convert<int>(json['installationActivityTimes']);
	if (installationActivityTimes != null) {
		installationActivity.installationActivityTimes = installationActivityTimes;
	}
	final String? installationActivityAdId = jsonConvert.convert<String>(json['installationActivityAdId']);
	if (installationActivityAdId != null) {
		installationActivity.installationActivityAdId = installationActivityAdId;
	}
	return installationActivity;
}

Map<String, dynamic> $InstallationActivityToJson(InstallationActivity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['installationActivityNo'] = entity.installationActivityNo;
	data['installationActivityTimes'] = entity.installationActivityTimes;
	data['installationActivityAdId'] = entity.installationActivityAdId;
	return data;
}