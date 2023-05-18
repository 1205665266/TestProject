
import 'package:cotti_client/generated/json/banner_model.g.dart';
import 'package:cotti_client/generated/json/base/json_field.dart';

@JsonSerializable()
class BannerModel {

	BannerModel();

	factory BannerModel.fromJson(Map<String, dynamic> json) => $BannerModelFromJson(json);

	Map<String, dynamic> toJson() => $BannerModelToJson(this);

  ///type : 1 - picture, 2 - video
  int? type;

  /// 广告位类型 1 banner 2 弹窗 3 浮窗
  int? positionType;
  int? bannerType;
  String? title;
  String? subTitle1;
  String? url;
  String? redirectUrl;
  int? sort;
  String? positionCode;
  String? positionName;
  String? templateCode;
  String? templateName;
  BannerPopup? popup;
  BannerFloatWindow? floatWindow;
  bool? updateFrequency;
  String? videoUrl;
  @JSONField(deserialize: false, serialize: false)
  Map<String, dynamic>? param;
}

@JsonSerializable()
class BannerPopup {

	BannerPopup();

	factory BannerPopup.fromJson(Map<String, dynamic> json) => $BannerPopupFromJson(json);

	Map<String, dynamic> toJson() => $BannerPopupToJson(this);

  String? type;
  String? couponWay;
  String? activityId;
  String? activityNumber;
  bool? loginRequired;
}

@JsonSerializable()
class BannerFloatWindow {

	BannerFloatWindow();

	factory BannerFloatWindow.fromJson(Map<String, dynamic> json) => $BannerFloatWindowFromJson(json);

	Map<String, dynamic> toJson() => $BannerFloatWindowToJson(this);

  String? type;
  String? couponWay;
  String? activityId;
  String? activityNumber;
  bool? loginRequired;
}
