part of 'share_bloc.dart';

abstract class ShareEvent {
  ShareParam shareParam;

  ShareEvent(this.shareParam);
}

///获取海报
class ShareInitEvent extends ShareEvent {
  ShareInitEvent(ShareParam shareParam) : super(shareParam);
}

///获取海报
class ShareProductEvent extends ShareEvent {
  ShareProductEvent(ShareParam shareParam) : super(shareParam);
}

///隐藏海报弹框
class HidePosterEvent extends ShareEvent {
  HidePosterEvent(ShareParam shareParam) : super(shareParam);
}

///记录分享领券的时间
class RecordShareGetCouponEvent extends ShareEvent {
  RecordShareGetCouponEvent(ShareParam shareParam) : super(shareParam);
}
