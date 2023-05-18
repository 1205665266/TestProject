part of 'banner_bloc.dart';

abstract class BannerEvent {
  BannerParam bannerParam;

  BannerEvent(this.bannerParam);
}

///初始化广告位
class BannerInitEvent extends BannerEvent {
  BannerInitEvent(BannerParam bannerParam) : super(bannerParam);
}

///由外部传来数据时，初始化的事件
class LocalBannerEvent extends BannerEvent {
  List<BannerModel> banners;

  LocalBannerEvent(this.banners) : super(BannerParam(""));
}

///重新加载广告位事件
class ReloadEvent extends BannerEvent {
  ReloadEvent(BannerParam bannerParam) : super(bannerParam);
}

class UpdateFrequencyEvent extends BannerEvent {
  String positionCode;

  UpdateFrequencyEvent(this.positionCode, BannerParam bannerParam) : super(bannerParam);
}
