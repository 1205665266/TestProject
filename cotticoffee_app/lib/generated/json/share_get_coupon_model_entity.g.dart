import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/common/activity/red_model/share_get_coupon_model_entity.dart';

ShareGetCouponModelEntity $ShareGetCouponModelEntityFromJson(Map<String, dynamic> json) {
	final ShareGetCouponModelEntity shareGetCouponModelEntity = ShareGetCouponModelEntity();
	final bool? canSharing = jsonConvert.convert<bool>(json['canSharing']);
	if (canSharing != null) {
		shareGetCouponModelEntity.canSharing = canSharing;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		shareGetCouponModelEntity.status = status;
	}
	final String? message = jsonConvert.convert<String>(json['message']);
	if (message != null) {
		shareGetCouponModelEntity.message = message;
	}
	final ShareGetCouponModelWeChatSharingCard? weChatSharingCard = jsonConvert.convert<ShareGetCouponModelWeChatSharingCard>(json['weChatSharingCard']);
	if (weChatSharingCard != null) {
		shareGetCouponModelEntity.weChatSharingCard = weChatSharingCard;
	}
	final ShareGetCouponModelH5SharingCard? h5SharingCard = jsonConvert.convert<ShareGetCouponModelH5SharingCard>(json['h5SharingCard']);
	if (h5SharingCard != null) {
		shareGetCouponModelEntity.h5SharingCard = h5SharingCard;
	}
	final String? fissionCode = jsonConvert.convert<String>(json['fissionCode']);
	if (fissionCode != null) {
		shareGetCouponModelEntity.fissionCode = fissionCode;
	}
	final String? activityNo = jsonConvert.convert<String>(json['activityNo']);
	if (activityNo != null) {
		shareGetCouponModelEntity.activityNo = activityNo;
	}
	final List<ShareGetCouponModelPosterBaseImgList>? posterBaseImgList = jsonConvert.convertListNotNull<ShareGetCouponModelPosterBaseImgList>(json['posterBaseImgList']);
	if (posterBaseImgList != null) {
		shareGetCouponModelEntity.posterBaseImgList = posterBaseImgList;
	}
	return shareGetCouponModelEntity;
}

Map<String, dynamic> $ShareGetCouponModelEntityToJson(ShareGetCouponModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['canSharing'] = entity.canSharing;
	data['status'] = entity.status;
	data['message'] = entity.message;
	data['weChatSharingCard'] = entity.weChatSharingCard?.toJson();
	data['h5SharingCard'] = entity.h5SharingCard?.toJson();
	data['fissionCode'] = entity.fissionCode;
	data['activityNo'] = entity.activityNo;
	data['posterBaseImgList'] =  entity.posterBaseImgList?.map((v) => v.toJson()).toList();
	return data;
}

ShareGetCouponModelWeChatSharingCard $ShareGetCouponModelWeChatSharingCardFromJson(Map<String, dynamic> json) {
	final ShareGetCouponModelWeChatSharingCard shareGetCouponModelWeChatSharingCard = ShareGetCouponModelWeChatSharingCard();
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		shareGetCouponModelWeChatSharingCard.title = title;
	}
	final String? bannerimgUrl = jsonConvert.convert<String>(json['bannerimgUrl']);
	if (bannerimgUrl != null) {
		shareGetCouponModelWeChatSharingCard.bannerimgUrl = bannerimgUrl;
	}
	final dynamic cardUrl = jsonConvert.convert<dynamic>(json['cardUrl']);
	if (cardUrl != null) {
		shareGetCouponModelWeChatSharingCard.cardUrl = cardUrl;
	}
	return shareGetCouponModelWeChatSharingCard;
}

Map<String, dynamic> $ShareGetCouponModelWeChatSharingCardToJson(ShareGetCouponModelWeChatSharingCard entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['title'] = entity.title;
	data['bannerimgUrl'] = entity.bannerimgUrl;
	data['cardUrl'] = entity.cardUrl;
	return data;
}

ShareGetCouponModelH5SharingCard $ShareGetCouponModelH5SharingCardFromJson(Map<String, dynamic> json) {
	final ShareGetCouponModelH5SharingCard shareGetCouponModelH5SharingCard = ShareGetCouponModelH5SharingCard();
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		shareGetCouponModelH5SharingCard.title = title;
	}
	final String? desc = jsonConvert.convert<String>(json['desc']);
	if (desc != null) {
		shareGetCouponModelH5SharingCard.desc = desc;
	}
	final String? iconUrl = jsonConvert.convert<String>(json['iconUrl']);
	if (iconUrl != null) {
		shareGetCouponModelH5SharingCard.iconUrl = iconUrl;
	}
	return shareGetCouponModelH5SharingCard;
}

Map<String, dynamic> $ShareGetCouponModelH5SharingCardToJson(ShareGetCouponModelH5SharingCard entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['title'] = entity.title;
	data['desc'] = entity.desc;
	data['iconUrl'] = entity.iconUrl;
	return data;
}

ShareGetCouponModelPosterBaseImgList $ShareGetCouponModelPosterBaseImgListFromJson(Map<String, dynamic> json) {
	final ShareGetCouponModelPosterBaseImgList shareGetCouponModelPosterBaseImgList = ShareGetCouponModelPosterBaseImgList();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		shareGetCouponModelPosterBaseImgList.name = name;
	}
	final String? url = jsonConvert.convert<String>(json['url']);
	if (url != null) {
		shareGetCouponModelPosterBaseImgList.url = url;
	}
	return shareGetCouponModelPosterBaseImgList;
}

Map<String, dynamic> $ShareGetCouponModelPosterBaseImgListToJson(ShareGetCouponModelPosterBaseImgList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['url'] = entity.url;
	return data;
}