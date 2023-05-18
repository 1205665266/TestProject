import 'package:cotti_client/pages/tabs/mine/my/entity/coupon_bounty_entity.dart';
import 'package:cotti_client/pages/tabs/mine/my/entity/user_info_entity.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/banner/model/ad_sort_entity.dart';

class HomeState {
  List<BannerModel> topBannerList = [];
  List<BannerModel> takeModeAdvertList = [];
  List<BannerModel> headerBanner = [];
  List<AdSortEntity> adSortList = [];
  bool isInit = false;

  HomeState copy() {
    return HomeState()
      ..isInit = isInit
      ..topBannerList = topBannerList
      ..headerBanner = headerBanner
      ..takeModeAdvertList = takeModeAdvertList
      ..adSortList = adSortList;
  }

  List<BannerModel> get getTakeModeList {
    if (takeModeAdvertList.isNotEmpty) {
      return takeModeAdvertList;
    } else {
      return [
        BannerModel()
          ..positionType = 1
          ..type = 0
          ..url = 'https://cdn-product-prod.yummy.tech/wechat/cotti/images/home/daodian.svg',
        BannerModel()
          ..positionType = 1
          ..type = 0
          ..url = 'https://cdn-product-prod.yummy.tech/wechat/cotti/images/home/wausong.svg',
      ];
    }
  }
}
