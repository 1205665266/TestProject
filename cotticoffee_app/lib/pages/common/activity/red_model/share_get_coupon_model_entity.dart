import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/share_get_coupon_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class ShareGetCouponModelEntity {

	bool? canSharing;
	int? status;
	String? message;
	ShareGetCouponModelWeChatSharingCard? weChatSharingCard;
	ShareGetCouponModelH5SharingCard? h5SharingCard;
  String? fissionCode;
  String? activityNo;
	List<ShareGetCouponModelPosterBaseImgList>? posterBaseImgList;
  
  ShareGetCouponModelEntity();

  factory ShareGetCouponModelEntity.fromJson(Map<String, dynamic> json) => $ShareGetCouponModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $ShareGetCouponModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ShareGetCouponModelWeChatSharingCard {

	String? title;
	String? bannerimgUrl;
	dynamic cardUrl;
  
  ShareGetCouponModelWeChatSharingCard();

  factory ShareGetCouponModelWeChatSharingCard.fromJson(Map<String, dynamic> json) => $ShareGetCouponModelWeChatSharingCardFromJson(json);

  Map<String, dynamic> toJson() => $ShareGetCouponModelWeChatSharingCardToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ShareGetCouponModelH5SharingCard {

	String? title;
	String? desc;
	String? iconUrl;
  
  ShareGetCouponModelH5SharingCard();

  factory ShareGetCouponModelH5SharingCard.fromJson(Map<String, dynamic> json) => $ShareGetCouponModelH5SharingCardFromJson(json);

  Map<String, dynamic> toJson() => $ShareGetCouponModelH5SharingCardToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ShareGetCouponModelPosterBaseImgList {

	String? name;
	String? url;
  
  ShareGetCouponModelPosterBaseImgList();

  factory ShareGetCouponModelPosterBaseImgList.fromJson(Map<String, dynamic> json) => $ShareGetCouponModelPosterBaseImgListFromJson(json);

  Map<String, dynamic> toJson() => $ShareGetCouponModelPosterBaseImgListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}