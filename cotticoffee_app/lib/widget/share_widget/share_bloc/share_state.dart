part of 'share_bloc.dart';

class ShareState {
  bool isShowShare = true;
  bool isShowLoading = false;

  List<BannerModel> bannerList = [];

  List<BannerModel> get banners => bannerList
      .where((element) =>
          (element.type == 0 && (element.positionType == 1 || element.positionType == 3)))
      .toList();

  ShareState copy() {
    ShareState bannerState = ShareState()
      ..bannerList = bannerList
      ..isShowShare = isShowShare
      ..isShowLoading = isShowLoading;

    return bannerState;
  }
}
