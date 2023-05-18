import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_event.dart';
import 'package:cotti_client/pages/shopping_cart/entity/cart_goods_item.dart';
import 'package:cotti_client/pages/tabs/mine/help/bloc/help_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/order_confirm_page.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/cancel_order_first_delivery_dialog.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_cancel_reason_model.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_event.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_state.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_event.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_state.dart';
import 'package:cotti_client/pages/tabs/order/order_list/view/cancel_order_dialog.dart';
import 'package:cotti_client/pages/tabs/order/order_list/view/to_pay_dialog.dart';
import 'package:cotti_client/pages/tabs/tab_page.dart';
import 'package:cotti_client/routers/order_router.dart';
import 'package:cotti_client/routers/tab_router.dart';
import 'package:cotti_client/utils/abite_pay_util.dart';
import 'package:cotti_client/widget/dialog/common_dialog.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/19 9:32 PM
class BottomActionBar extends StatefulWidget {
  Function(bool)? payResult;
  Function(bool)? cancelResult;
  Function(bool)? evaluatedResult;

  BottomActionBar({this.payResult, Key? key, this.cancelResult, this.evaluatedResult})
      : super(key: key);

  @override
  State<BottomActionBar> createState() => _BottomActionBarState();
}

class _BottomActionBarState extends State<BottomActionBar> {
  final HelpBloc _helpBloc = HelpBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailBloc, OrderDetailState>(
      builder: (context, state) {
        return BlocConsumer<OrderBloc, OrderState>(
          listenWhen: (previous, current) {
            return previous.getCancelReasonTimeStampInDetail !=
                current.getCancelReasonTimeStampInDetail;
          },
          listener: (context, orderState) {
            if (orderState.cancelReason.isNotEmpty) {
              CancelOrderDialog.show(
                context,
                orderState.cancelReason,
                (OrderCancelReasonModel p0, String? otherReasons) {
                  context.read<OrderBloc>().add(CancelOrderEvent(
                        state.orderDetail?.id,
                        p0.id,
                        otherReasons,
                        state.orderDetail?.status,
                        callBack: (status) {
                          context.read<OrderDetailBloc>().add(UpdateOrderEvent());
                          if (status) {
                            if (widget.cancelResult != null) {
                              widget.cancelResult!(true);
                            }
                          } else {
                            _showFailDialog(state.orderDetail);
                          }

                          SensorsAnalyticsFlutterPlugin.track(
                              OrderSensorsConstant.confirmReasonOfCancelOrderDetailClick, {
                            "order_state": state.orderDetail?.orderStatusStr?.statusStr,
                            "cancel_order_reason": p0.orderCancelReason,
                            "cancel_result_new": status ? '是' : '否'
                          });
                        },
                      ));
                },
              );
            } else {
              CommonDialog.show(context,
                      content: '确定取消订单吗？', mainButtonName: "确定", subButtonName: "我再想想")
                  .then((value) {
                if (value == 1) {
                  logI('确定');
                  context.read<OrderBloc>().add(CancelOrderEvent(
                        state.orderDetail?.id,
                        -1,
                        null,
                        state.orderDetail?.status,
                        callBack: (status) {
                          context.read<OrderDetailBloc>().add(UpdateOrderEvent());
                          if (status) {
                            if (widget.cancelResult != null) {
                              widget.cancelResult!(true);
                            }
                          } else {
                            _showFailDialog(state.orderDetail);
                          }
                        },
                      ));
                } else if (value == 0) {
                  logI('我再想想');
                }
              });
            }
          },
          builder: (context, orderState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(10, 58, 59, 60),
                    offset: Offset(0, -2.w),
                    blurRadius: 1,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: SafeArea(
                top: false,
                child: Container(
                  height: 56.h,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible:
                            state.orderDetail?.canteenCardHiddenCancelContext?.isNotEmpty ?? false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 28.w),
                          child: Text(
                            "${state.orderDetail?.canteenCardHiddenCancelContext}",
                            style: TextStyle(fontSize: 12.sp, color: CottiColor.textGray),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: _actions(state.orderDetail),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _actions(OrderDetailModel? orderDetail) {
    if (orderDetail == null) {
      return [const SizedBox()];
    }
    List<Map<String, Function>> list = [];
    if (orderDetail.hiddenCancel == 0) {
      list.add({"取消订单": _beforeCancelOrder});
    }
    if (orderDetail.status == 10 &&
        orderDetail.orderQueryPay?.payFrom != PayForm.canteenCard.index) {
      list.add({"去支付": _toPay});
    }
    if (orderDetail.allowEvaluate == 1) {
      list.add({"去评价": _toEvaluate});
    }
    if (orderDetail.status != 10 ||
        orderDetail.orderQueryPay?.payFrom == PayForm.canteenCard.index) {
      list.add({"再来一单": _againOrder});
    }
    return List.generate(list.length, (index) {
      Map<String, Function> map = list[index];
      return _buildItem(map.keys.first, map.values.first, list.length - 1 == index, orderDetail);
    });
  }

  _showFailDialog(OrderDetailModel? orderDetail) {
    CommonDialog.show(context,
            contentChild: Container(
              height: 88.h,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "订单已不能取消，如有问题请联系客服",
                    style: TextStyle(fontSize: 14.sp, color: CottiColor.textBlack),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    "点击确定，联系客服",
                    style: TextStyle(fontSize: 12.sp, color: CottiColor.textGray),
                  ),
                ],
              ),
            ),
            mainButtonName: "确定",
            subButtonName: "取消")
        .then((value) {
      if (value == 1) {
        logI('确定');
        _helpBloc.add(OnlineServiceEvent(context: context, orderDetailModel: orderDetail));
      }
    });
  }

  Widget _buildItem(
      String title, Function function, bool lastChild, OrderDetailModel? orderDetailModel) {
    return GestureDetector(
      onTap: () => function(orderDetailModel),
      child: Container(
        width: 92.w,
        height: 32.h,
        margin: EdgeInsets.only(right: 14.w),
        decoration: BoxDecoration(
          color: lastChild ? CottiColor.primeColor : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3.r)),
          border: Border.all(width: lastChild ? 0 : 0.5.w, color: CottiColor.primeColor),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: lastChild ? Colors.white : CottiColor.primeColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _cancelOrder(OrderDetailModel? orderDetailModel) {
    context.read<OrderBloc>().add(OrderDetailCancelReasonListEvent(
        orderDetailModel?.id ?? 0, DateTime.now().microsecondsSinceEpoch));

    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.cancelOrderOrderDetailClick,
        {"order_state": orderDetailModel?.orderStatusStr?.statusStr});
  }

  void _beforeCancelOrder(OrderDetailModel? orderDetailModel) {
    if (orderDetailModel?.orderQueryFinance?.deliveryDiscountType == 1) {
      CancelOrderFirstDeliveryDialog.show(context, orderDetailModel?.cancleOrderConfigDTO, (index) {
        if (index == 0) {
          _cancelOrder(orderDetailModel);
        }
      });
    } else {
      _cancelOrder(orderDetailModel);
    }
  }

  void _toPay(OrderDetailModel? orderDetailModel) {
    ToPayDialog.show(
      context,
      orderDetailModel?.orderQueryFinance?.totalPayableMoney ?? 0,
      "${orderDetailModel?.id}",
      orderDetailModel?.orderNo ?? '',
      orderDetailModel?.takeType,
      orderDetailModel?.shopId,
      (ABitePayResult payResult) {
        if (payResult.state == ABitPayState.succeed) {
          context.read<OrderBloc>().add(OnRefreshEvent(1));
          if (widget.payResult != null) {
            widget.payResult!(true);
          }
          Navigator.of(context).pop();
        } else {
          logD(payResult.msg);
        }
      },
    );

    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.toPayOrderDetailClick,
        {"order_state": orderDetailModel?.orderStatusStr?.statusStr});
  }

  void _toEvaluate(OrderDetailModel? orderDetailModel) {
    NavigatorUtils.push(
      context,
      OrderRouter.orderEvaluatePage,
      params: {"orderNo": orderDetailModel?.orderNo ?? ""},
    ).then((value) {
      logI('_toEvaluate====>$value');
      if (value != null && value) {
        if (widget.evaluatedResult != null) {
          context.read<OrderDetailBloc>().add(UpdateOrderEvent());
          widget.evaluatedResult!(true);
        }
      }
    });
    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.toCommentOrderDetailClick,
        {"order_state": orderDetailModel?.orderStatusStr?.statusStr});
  }

  void _againOrder(OrderDetailModel? orderDetailModel) {
    var list = orderDetailModel?.orderQueryProducts
        ?.map((e) => CartGoodsItem()
          ..itemNo = e.productCode!
          ..skuCode = e.skuCode!
          ..buyNum = e.quantity!)
        .toList();
    context.read<ShoppingCartBloc>().add(AddCartListSkuEvent(list ?? [], cleanCart: true));
    ShopMatchState shopMatchState = context.read<ShopMatchBloc>().state;
    GlobalBloc globalBloc = GlobalBlocs.get<GlobalBloc>(GlobalBloc.blocName);
    if (globalBloc.state.tabIndex == TabEnum.menu.index) {
      //避免当前在点餐页，打不开购物车
      globalBloc.add(SwitchTabEvent(-1));
    }
    globalBloc.add(
      SwitchTabEvent(TabEnum.menu.index, arguments: {"openCart": true}),
    );
    Navigator.popUntil(context, ModalRoute.withName(TabRouter.tabPage));

    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.reOrderOrderDetailClick,
        {"order_state": orderDetailModel?.orderStatusStr?.statusStr});
  }
}
