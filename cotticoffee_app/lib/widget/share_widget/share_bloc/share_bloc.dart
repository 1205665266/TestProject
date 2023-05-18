import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotti_client/widget/banner/api/banner_api.dart';
import 'package:cotti_client/widget/banner/model/banner_model.dart';
import 'package:cotti_client/widget/banner/model/banner_param.dart';
import 'package:cotti_client/widget/share_widget/api/share_api.dart';
import 'package:cotti_client/widget/share_widget/model/share_param.dart';
import 'package:cotticommon/cotticommon.dart';

part 'share_event.dart';

part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc() : super(ShareState()) {
    on<ShareInitEvent>(_getSharePoster);
    on<ShareProductEvent>(_getProductPoster);
    on<HidePosterEvent>(_hidePoster);
    on<RecordShareGetCouponEvent>(_recordShareGetCoupon);
  }

  void _getSharePoster(ShareInitEvent event, emit) async {
    var bannerCode = 'Ad-sjgf-order-detail-poster-V2-2';
    if (event.shareParam.fromPage == 1) {
    } else if (event.shareParam.fromPage == 2) {
      bannerCode = 'Ad-sjgf-off-price-poster-V2-2';
    } else if (event.shareParam.fromPage == 3) {
      bannerCode = 'Ad-sjgf-invitee-gift-poster-V2-2';
    } else if (event.shareParam.fromPage == 4) {
      bannerCode = 'Ad-sjgf-order-detail-poster-V2-2';
    } else if (event.shareParam.fromPage == 5) {
      bannerCode = 'Ad-sjgf-theme-area-poster-V2-2';
    }
    var share = BannerParam(bannerCode);
    state.isShowLoading = true;
    emit(state.copy());
    await BannerApi.getBannerList(share).then((value) {
      state.bannerList = value;
      logE('进入value+${value.toString()}');
      state.isShowShare = false;
      state.isShowLoading = false;
      // logE('进入value+${value.toString()}');
      emit(state.copy());
    }).catchError((onError) {
      state.isShowShare = true;
      state.isShowLoading = false;
      // logE('进入value+${value.toString()}');
      emit(state.copy());
    });
  }

  void _recordShareGetCoupon(RecordShareGetCouponEvent event, emit) {
    ShareApi.addShareRecord(event.shareParam.orderId ?? '', event.shareParam.activityNo ?? '');
  }

  void _getProductPoster(ShareProductEvent event, emit) async {
    state.isShowShare = false;

    emit(state.copy());
  }

  void _hidePoster(HidePosterEvent event, emit) async {
    state.isShowShare = true;

    emit(state.copy());
  }
}
