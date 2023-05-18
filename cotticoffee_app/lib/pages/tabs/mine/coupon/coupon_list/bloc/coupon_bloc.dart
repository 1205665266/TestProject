import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/tabs/mine/coupon/coupon_list/api/coupon_api.dart';
import 'package:cotti_client/pages/tabs/mine/my/api/mine_api.dart';
import 'package:cotti_client/pages/tabs/mine/my/entity/coupon_bounty_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_list_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_state.dart';
import 'package:cotti_client/widget/banner/api/banner_api.dart';
import 'package:cotti_client/widget/banner/model/banner_model.dart';
import 'package:cotti_client/widget/banner/model/banner_param.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'coupon_event.dart';

part 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  CouponBloc() : super(CouponState.init()) {
    on<CouponGetDataListEvent>(_getDataList);
    on<CouponGetNumEvent>(_getCouponNum);
    on<CouponLoadingEvent>(_onLoading);
    on<CouponRefreshEvent>(_onRefresh);
    on<CouponTabChangeEvent>(_changeTab);
    on<CouponBannerEvent>(_getBannerData);
  }

  _getBannerData(CouponBannerEvent event, emit) async {
    await Future.wait([
      BannerApi.getBannerList(BannerParam("cotti-my-coupon-banner")).then((value) {
        BannerModel bannerModel = value.first;
        state.bannerModel = bannerModel;
        emit(state.copy());
        logI('bannermodel = ${state.bannerModel}');
      })
    ]);

  }

  _changeTab(CouponTabChangeEvent event, emit) async {
    logW('CouponTabChangeEvent tabCode = ${event.tabCode}');
    // state.tabCode = event.tabCode;
    state.pageNo = 1;
    state.refreshStatus = RefreshStatus.idle;
    state.loadStatus = LoadStatus.loading;
    state.requestTimeStamp = event.requestTimeStamp!;
    state.showLoading = true;
    emit(state.copy());

    try {
      List<OrderCouponListModelConfirmOrderCouponDtoList> list =
          await CouponApi.getDataList(pageNo: state.pageNo, tabCode: event.tabCode);

      emit(state.copy()
        ..couponList = list
        ..refreshStatus = RefreshStatus.completed..showEmpty = list.isEmpty..tabCode=event.tabCode..showLoading=false);
    } catch (error) {
      emit(state.copy()..refreshStatus = RefreshStatus.completed..showEmpty = true..showLoading=false);
    }
  }

  _onRefresh(CouponRefreshEvent event, emit) async {
    state.pageNo = 1;
    state.refreshStatus = RefreshStatus.idle;
    state.loadStatus = LoadStatus.loading;
    state.requestTimeStamp = event.requestTimeStamp!;
    emit(state.copy());
    await Future.delayed(Duration(seconds: event.delayed)).then(
      (value) => CouponApi.getDataList(tabCode: state.tabCode, pageNo: state.pageNo).then((value) {
        if (state.requestTimeStamp == event.requestTimeStamp) {
          state.couponList = value;
          state.showEmpty = value.isEmpty;
        }
      }).catchError((onError) {}),
    );
    state.refreshStatus = RefreshStatus.completed;
    emit(state.copy());
  }

  _onLoading(CouponLoadingEvent event, emit) async {
    state.loadStatus = LoadStatus.loading;
    state.requestTimeStamp = event.requestTimeStamp ?? 0;
    await CouponApi.getDataList(tabCode: state.tabCode, pageNo: state.pageNo + 1).then((value) {
      state.loadStatus = LoadStatus.idle;
      if (state.requestTimeStamp == event.requestTimeStamp) {
        if (value.isNotEmpty) {
          state.pageNo++;
          state.couponList?.addAll(value);
        } else {
          state.loadStatus = LoadStatus.noMore;
        }
      }
    }).catchError((error) {
      state.loadStatus = LoadStatus.failed;
    });
    emit(state.copy());
  }

  /// 请求优惠券列表
  _getDataList(CouponGetDataListEvent event, emit) async {
    try {
      List<OrderCouponListModelConfirmOrderCouponDtoList> list =
          await CouponApi.getDataList(pageNo: state.pageNo, tabCode: state.tabCode);

      emit(state.copy()
        ..couponList = list
        ..showEmpty = list.isEmpty
        ..showLoading = false);
    } catch (error) {
      emit(state.copy()..showLoading = false);
    }
  }

  /// 请求优惠券数量
  _getCouponNum(CouponGetNumEvent event, emit) async {
    try {
      MineApi.getCouponAndBounty();
      CouponBountyEntity entity = await MineApi.getCouponAndBounty();

      logI('CouponBountyEntity totalCouponAmount = ${entity.couponMsg?.totalCouponAmount}');

      List<CouponTab> tabs = [
        CouponTab(
          name: "全部",
          status: 1,
          showCount: true,
          count: entity.couponMsg?.totalCouponAmount ?? 0,
        ),
        CouponTab(
          name: "即将过期",
          status: 2,
          showCount: true,
          count: entity.couponMsg?.expiringSoonCouponAmount ?? 0,
        ),
        CouponTab(
          name: "待生效",
          status: 3,
          showCount: true,
          count: entity.couponMsg?.ineffectiveCount ?? 0,
        ),
      ];

      emit(state.copy()..tabs = tabs);
    } catch (error) {
      logI('catch(error) in _getCouponNum $error');
    }
  }
}
