import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/widget/banner/model/banner_model.dart';

BannerModel $BannerModelFromJson(Map<String, dynamic> json) {
	final BannerModel bannerModel = BannerModel();
	final int? type = jsonConvert.convert<int>(json['type']);
	if (type != null) {
		bannerModel.type = type;
	}
	final int? positionType = jsonConvert.convert<int>(json['positionType']);
	if (positionType != null) {
		bannerModel.positionType = positionType;
	}
	final int? bannerType = jsonConvert.convert<int>(json['bannerType']);
	if (bannerType != null) {
		bannerModel.bannerType = bannerType;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		bannerModel.title = title;
	}
	final String? subTitle1 = jsonConvert.convert<String>(json['subTitle1']);
	if (subTitle1 != null) {
		bannerModel.subTitle1 = subTitle1;
	}
	final String? url = jsonConvert.convert<String>(json['url']);
	if (url != null) {
		bannerModel.url = url;
	}
	final String? redirectUrl = jsonConvert.convert<String>(json['redirectUrl']);
	if (redirectUrl != null) {
		bannerModel.redirectUrl = redirectUrl;
	}
	final int? sort = jsonConvert.convert<int>(json['sort']);
	if (sort != null) {
		bannerModel.sort = sort;
	}
	final String? positionCode = jsonConvert.convert<String>(json['positionCode']);
	if (positionCode != null) {
		bannerModel.positionCode = positionCode;
	}
	final String? positionName = jsonConvert.convert<String>(json['positionName']);
	if (positionName != null) {
		bannerModel.positionName = positionName;
	}
	final String? templateCode = jsonConvert.convert<String>(json['templateCode']);
	if (templateCode != null) {
		bannerModel.templateCode = templateCode;
	}
	final String? templateName = jsonConvert.convert<String>(json['templateName']);
	if (templateName != null) {
		bannerModel.templateName = templateName;
	}
	final BannerPopup? popup = jsonConvert.convert<BannerPopup>(json['popup']);
	if (popup != null) {
		bannerModel.popup = popup;
	}
	final BannerFloatWindow? floatWindow = jsonConvert.convert<BannerFloatWindow>(json['floatWindow']);
	if (floatWindow != null) {
		bannerModel.floatWindow = floatWindow;
	}
	final bool? updateFrequency = jsonConvert.convert<bool>(json['updateFrequency']);
	if (updateFrequency != null) {
		bannerModel.updateFrequency = updateFrequency;
	}
	final String? videoUrl = jsonConvert.convert<String>(json['videoUrl']);
	if (videoUrl != null) {
		bannerModel.videoUrl = videoUrl;
	}
	return bannerModel;
}

Map<String, dynamic> $BannerModelToJson(BannerModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['type'] = entity.type;
	data['positionType'] = entity.positionType;
	data['bannerType'] = entity.bannerType;
	data['title'] = entity.title;
	data['subTitle1'] = entity.subTitle1;
	data['url'] = entity.url;
	data['redirectUrl'] = entity.redirectUrl;
	data['sort'] = entity.sort;
	data['positionCode'] = entity.positionCode;
	data['positionName'] = entity.positionName;
	data['templateCode'] = entity.templateCode;
	data['templateName'] = entity.templateName;
	data['popup'] = entity.popup?.toJson();
	data['floatWindow'] = entity.floatWindow?.toJson();
	data['updateFrequency'] = entity.updateFrequency;
	data['videoUrl'] = entity.videoUrl;
	return data;
}

BannerPopup $BannerPopupFromJson(Map<String, dynamic> json) {
	final BannerPopup bannerPopup = BannerPopup();
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		bannerPopup.type = type;
	}
	final String? couponWay = jsonConvert.convert<String>(json['couponWay']);
	if (couponWay != null) {
		bannerPopup.couponWay = couponWay;
	}
	final String? activityId = jsonConvert.convert<String>(json['activityId']);
	if (activityId != null) {
		bannerPopup.activityId = activityId;
	}
	final String? activityNumber = jsonConvert.convert<String>(json['activityNumber']);
	if (activityNumber != null) {
		bannerPopup.activityNumber = activityNumber;
	}
	final bool? loginRequired = jsonConvert.convert<bool>(json['loginRequired']);
	if (loginRequired != null) {
		bannerPopup.loginRequired = loginRequired;
	}
	return bannerPopup;
}

Map<String, dynamic> $BannerPopupToJson(BannerPopup entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['type'] = entity.type;
	data['couponWay'] = entity.couponWay;
	data['activityId'] = entity.activityId;
	data['activityNumber'] = entity.activityNumber;
	data['loginRequired'] = entity.loginRequired;
	return data;
}

BannerFloatWindow $BannerFloatWindowFromJson(Map<String, dynamic> json) {
	final BannerFloatWindow bannerFloatWindow = BannerFloatWindow();
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		bannerFloatWindow.type = type;
	}
	final String? couponWay = jsonConvert.convert<String>(json['couponWay']);
	if (couponWay != null) {
		bannerFloatWindow.couponWay = couponWay;
	}
	final String? activityId = jsonConvert.convert<String>(json['activityId']);
	if (activityId != null) {
		bannerFloatWindow.activityId = activityId;
	}
	final String? activityNumber = jsonConvert.convert<String>(json['activityNumber']);
	if (activityNumber != null) {
		bannerFloatWindow.activityNumber = activityNumber;
	}
	final bool? loginRequired = jsonConvert.convert<bool>(json['loginRequired']);
	if (loginRequired != null) {
		bannerFloatWindow.loginRequired = loginRequired;
	}
	return bannerFloatWindow;
}

Map<String, dynamic> $BannerFloatWindowToJson(BannerFloatWindow entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['type'] = entity.type;
	data['couponWay'] = entity.couponWay;
	data['activityId'] = entity.activityId;
	data['activityNumber'] = entity.activityNumber;
	data['loginRequired'] = entity.loginRequired;
	return data;
}