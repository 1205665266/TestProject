import 'package:cotti_client/widget/banner/model/banner_model.dart';

abstract class GeneralActivityEvent {}

class ActivityInitEvent extends GeneralActivityEvent {
  late String activityId;
  ActivityInitEvent({required this.activityId});
}

/// 刷新banner
class RefreshBannerEvent extends GeneralActivityEvent {
  bool loginState;
  RefreshBannerEvent({required this.loginState});
}

///点击banner处理
class ClickBannerEvent extends GeneralActivityEvent {
  late Map<String, dynamic>? params;
  late Function(BannerModel) callback;
  ClickBannerEvent({required this.params, required this.callback});
}

///点击领券
class ClickReceiveCouponEvent extends GeneralActivityEvent {
  bool isAuto;
  BannerModel model;
  String viewPage;
  final Function(bool)? callback;
  final Function onTapCallback;
  ClickReceiveCouponEvent({
    required this.isAuto,
    this.callback,
    required this.viewPage,
    required this.onTapCallback,
    required this.model,
  });
}

/// 领取资格校验
class CheckQualificationEvent extends GeneralActivityEvent {
  final BannerModel model;
  final Function(bool) callback;
  CheckQualificationEvent({required this.model, required this.callback});
}

/// 弹窗
class ShowActivityPopUpsEvent extends GeneralActivityEvent {
  late BannerModel bannerModel;
  ShowActivityPopUpsEvent({required this.bannerModel});
}
