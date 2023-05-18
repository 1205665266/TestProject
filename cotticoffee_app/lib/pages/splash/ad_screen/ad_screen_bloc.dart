import 'dart:convert' as convert;

import 'package:bloc/bloc.dart';
import 'package:cotti_client/widget/banner/api/banner_api.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotticommon/cotticommon.dart';

class AdScreenBloc extends Bloc<AdScreenEvent, AdScreenState> {
  final String keyFirstOpen = 'key_first_open';

  AdScreenBloc() : super((AdScreenState())) {
    on<AdScreenEvent>(_getAdScreen);
  }

  _getAdScreen(AdScreenEvent event, emit) async {
    BannerModel? bannerModel;
    if (SpUtil.getBool(keyFirstOpen, defValue: true)) {
      SpUtil.putBool(keyFirstOpen, false);
      bannerModel = BannerModel()
        ..positionType = 1
        ..type = 0
        ..url = 'https://cdn-product-prod.yummy.tech/wechat/cotti/images/cotti_open_1.jpg';
    } else {
      String catchData = SpUtil.getString(event.code, defValue: '[]');
      List catchList = convert.jsonDecode(catchData);
      List<BannerModel> banners = catchList.map((e) => BannerModel.fromJson(e)).toList();
      if (banners.isNotEmpty) {
        bannerModel = banners.first;
      }
    }
    //更新广告位缓存
    BannerApi.getBannerList(BannerParam(event.code));
    //延迟通知，避免没拿到ConfigState信息
    await Future.delayed(const Duration(milliseconds: 100));
    if (bannerModel != null) {
      state.isSkip = false;
      state.banners = [bannerModel];
    } else {
      state.isSkip = true;
    }
    emit(state.copy());
  }
}

class AdScreenEvent {
  final String code;

  AdScreenEvent(this.code);
}

class AdScreenState {
  List<BannerModel> banners = [];
  bool isSkip = false;

  AdScreenState copy() {
    return AdScreenState()
      ..banners = banners
      ..isSkip = isSkip;
  }
}
