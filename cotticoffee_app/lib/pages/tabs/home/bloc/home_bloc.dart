import 'package:bloc/bloc.dart';
import 'package:cotti_client/service/location/location_service.dart';
import 'package:cotti_client/widget/banner/api/banner_api.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<InitHomeEvent>(_initHome);
    on<CheckBannerDataEvent>(_checkBannerData);
  }

  _initHome(_, emit) async {
    await Future.wait([
      BannerApi.getBannerList(BannerParam('cotti-index-header-banner'))
          .then((value) => state.headerBanner = value),
      BannerApi.getBannerList(BannerParam('cotti-index-top-banner'))
          .then((value) => state.topBannerList = value),
      BannerApi.getBannerList(BannerParam('cotti-index-diningType-banner'))
          .then((value) => state.takeModeAdvertList = value),
      BannerApi.getBannerSortList(BannerParam('cotti-index-activity-banner'))
          .then((value) => state.adSortList = value),
    ]);
    var status = await Permission.location.status;
    if (PermissionStatus.granted == status) {
      ///预先请求一下定位，获取一下位置信息
      LocationService().startLocation(null);
    }
    state.isInit = true;
    emit(state.copy());
  }

  _checkBannerData(_, emit) async {
    bool isUpdate = false;
    if (state.topBannerList.isEmpty) {
      await BannerApi.getBannerList(BannerParam('cotti-index-top-banner'))
          .then((value) => state.topBannerList = value);
      isUpdate = true;
    }
    if (state.takeModeAdvertList.isEmpty) {
      await BannerApi.getBannerList(BannerParam('cotti-index-diningType-banner'))
          .then((value) => state.takeModeAdvertList = value);
      isUpdate = true;
    }
    if (state.adSortList.isEmpty) {
      await BannerApi.getBannerSortList(BannerParam('cotti-index-activity-banner'))
          .then((value) => state.adSortList = value);
      isUpdate = true;
    }
    if (isUpdate) {
      emit(state.copy());
    }
  }
}
