import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/common/activity/red_block/red_api/red_api.dart';
import 'package:cotti_client/pages/common/activity/red_model/share_get_coupon_model_entity.dart';
import 'package:cotti_client/widget/banner/api/banner_api.dart';
import 'package:cotti_client/widget/banner/model/banner_model.dart';
import 'package:cotti_client/widget/banner/model/banner_param.dart';
import 'package:cotticommon/cotticommon.dart';

part 'red_envelop_event.dart';

part 'red_envelop_state.dart';

class RedEnvelopBloc extends Bloc<RedEnvelopEvent, RedEnvelopState> {
  RedEnvelopBloc() : super(RedEnvelopState()) {
    on<SharingShareEvent>(_getShareDate);
  }

  void _getShareDate(SharingShareEvent event, emit) async {
    var parm = BannerParam("cotti-order-detail-float", viewPage: 'cotti-app-orderdetail');

    await BannerApi.getBannerList(parm).then((value) async {
      state.bannerList = value;

      if (state.bannerList.isNotEmpty && event.orderId != null) {
        var activityNo = state.bannerList[0].floatWindow?.activityId?.toString();

        await RedApi.sharingShare(event.orderId ?? '', activityNo ?? '').then((value) {
          logE('进入value+${value.toString()}');
          if (value != null) {
            logE('进入value2');
            state.shareModel = ShareGetCouponModelEntity.fromJson(value);
            if (state.shareModel != null) {
              if (state.shareModel?.canSharing != null) {
                // logE('state.isShowFloat:${state.isShowFloat}');
                state.shareModel?.activityNo = activityNo ?? '';
              }
            }
            emit(state.copy());
          }
        });
      } else {
        emit(state.copy());
      }
    });
  }
}
