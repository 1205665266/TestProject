part of 'banner_bloc.dart';

class BannerState {
  List<BannerModel> bannerList = [];

  List<BannerModel> get banners => bannerList
      .where((element) => ((element.type == 0 || element.type == 2) &&
          (element.positionType == 1 || element.positionType == 3)))
      .toList();

  List<BannerModel> get popups =>
      bannerList.where((element) => (element.type == 0 && element.positionType == 2)).toList();

  List<BannerModel> get videos => bannerList.where((element) => element.type == 1).toList();

  BannerState copy() {
    BannerState bannerState = BannerState()..bannerList = bannerList;
    return bannerState;
  }
}
