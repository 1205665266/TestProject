
import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_count_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_count_request_model.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_list_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_list_request_model.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/api/order_confirm_api.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'order_coupon_event.dart';
part 'order_coupon_state.dart';

class OrderCouponBloc extends Bloc<OrderCouponEvent, OrderCouponState> {
  OrderCouponBloc() : super(OrderCouponState()) {
    on<OrderFetchCouponListEvent>(_fetchCouponList);
    on<OrderFetchCouponCountEvent>(_fetchCouponCount);
    on<OrderFetchCouponListLoadMoreEvent>(_fetchCouponLoadMore);
    on<OrderFetchCouponListRefreshEvent>(_fetchCouponRefresh);
  }

  _fetchCouponList(OrderFetchCouponListEvent event, Emitter<OrderCouponState> emit) async {
    state.pageNo = 1;
    // state.tabIndex = event.tabIndex;

    state.showLoading = true;
    state.loadStatus = LoadStatus.loading;
    emit(state.copy());
    event.orderCouponListRequestModel?.pageNo = 1;

    await OrderConfirmApi.fetchCouponList(event.orderCouponListRequestModel?.toMap())
        .then((value) {
          state.loadStatus = LoadStatus.idle;
          state.couponList = value.confirmOrderCouponDtoList??[];
        })
        .catchError((error) {
          state.couponList = [];
          state.loadStatus = LoadStatus.failed;
        });
    state.tabIndex = event.tabIndex;
    state.showLoading = false;
    emit(state.copy());

  }

  _fetchCouponCount(OrderFetchCouponCountEvent event, Emitter<OrderCouponState> emit) async {

    logI('请求优惠券数量');

    await OrderConfirmApi.fetchCouponCount(event.orderCouponCountRequestModel?.toMap())
        .then((value){
          logI('请求优惠券数量结果  $value');
          state.orderCouponCountModelEntity = value;

        })
        .catchError(onError);

    emit(state.copy());
  }

  _fetchCouponLoadMore(OrderFetchCouponListLoadMoreEvent event, Emitter<OrderCouponState> emit) async {
    logI('加载更多');
    state.loadStatus = LoadStatus.loading;
    state.pageNo++;
    event.orderCouponListRequestModel?.pageNo = state.pageNo;

    await OrderConfirmApi.fetchCouponList(event.orderCouponListRequestModel?.toMap())
        .then((value)  {
          state.loadStatus = LoadStatus.idle;
          var list = value.confirmOrderCouponDtoList??[];

          if (list.isNotEmpty) {
            state.couponList.addAll(list);
          } else {
            state.loadStatus = LoadStatus.noMore;
          }
        })
        .catchError((error) {
          state.loadStatus = LoadStatus.failed;
        });

    emit(state.copy());
  }

  _fetchCouponRefresh(OrderFetchCouponListRefreshEvent event, Emitter<OrderCouponState> emit) async {

    state.pageNo = 1;
    event.orderCouponListRequestModel?.pageNo = state.pageNo;

    state.refreshStatus = RefreshStatus.refreshing;

    await OrderConfirmApi.fetchCouponList(event.orderCouponListRequestModel?.toMap())
        .then((value) {
          state.couponList.clear();
          state.couponList.addAll(value.confirmOrderCouponDtoList??[]);
          state.refreshStatus = RefreshStatus.refreshing;
        })
        .catchError(onError);

    state.refreshStatus = RefreshStatus.completed;

    emit(state.copy());
  }
}
