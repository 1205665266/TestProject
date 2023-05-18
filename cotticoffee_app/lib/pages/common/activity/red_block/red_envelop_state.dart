part of 'red_envelop_bloc.dart';

class RedEnvelopState {
  ShareGetCouponModelEntity? shareModel;

  List<BannerModel> bannerList = [];

  List<BannerModel> get banners => bannerList
      .where((element) =>
          (element.type == 0 && (element.positionType == 1 || element.positionType == 3)))
      .toList();

  RedEnvelopState copy() {
    RedEnvelopState bannerState = RedEnvelopState()..shareModel = shareModel;

    return bannerState;
  }
}
