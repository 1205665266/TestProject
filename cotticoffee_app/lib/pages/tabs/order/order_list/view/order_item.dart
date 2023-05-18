import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_event.dart';
import 'package:cotti_client/pages/shopping_cart/entity/cart_goods_item.dart';
import 'package:cotti_client/pages/tabs/mine/help/bloc/help_bloc.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_cancel_reason_model.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_model.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/order_confirm_page.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/order_detail_page.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/cancel_order_first_delivery_dialog.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_event.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_state.dart';
import 'package:cotti_client/pages/tabs/order/order_list/view/cancel_order_dialog.dart';
import 'package:cotti_client/pages/tabs/order/order_list/view/to_pay_dialog.dart';
import 'package:cotti_client/pages/tabs/tab_page.dart';
import 'package:cotti_client/routers/order_router.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/utils/abite_pay_util.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/countdown_timer.dart';
import 'package:cotti_client/widget/dialog/common_dialog.dart';
import 'package:cotti_client/widget/mini_label_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'order_product_item.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/3/16 2:20 下午
class OrderItem extends StatefulWidget {
  const OrderItem(
      {Key? key,
      required this.orderModel,
      required this.pageIndex,
      required this.cancelOrderConfigDTO,
      required this.helpBloc})
      : super(key: key);
  final OrderModel orderModel;
  final int pageIndex;
  final OrderDetailModelCancleOrderConfigDTO? cancelOrderConfigDTO;
  final HelpBloc helpBloc;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  final ValueNotifier<int> _countNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if ((widget.orderModel.deadlineSeconds ?? 0) > 0) {
        _countNotifier.value = widget.orderModel.deadlineSeconds!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildItem();
  }

  Widget _buildItem() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (cx) => BlocProvider<OrderBloc>.value(
                value: context.read<OrderBloc>(),
                child: OrderDetailPage(
                  orderNo: widget.orderModel.orderNo ?? '',
                  fromList: true,
                ),
              ),
            ));
        SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.toDetailPageOrderListClick, {});
      },
      child: Container(
        padding: EdgeInsets.only(top: 16.h, bottom: 16.h, left: 12.w, right: 7.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
        ),
        child: BlocConsumer<OrderBloc, OrderState>(
          listenWhen: (previous, current) {
            if ((widget.orderModel.deadlineSeconds ?? 0) > 0) {
              _countNotifier.value = widget.orderModel.deadlineSeconds!;
            }
            return previous.getCancelReasonTimeStamp != current.getCancelReasonTimeStamp &&
                current.cancelOrderId == widget.orderModel.id;
          },
          listener: (context, state) {
            if (state.cancelReason.isNotEmpty) {
              CancelOrderDialog.show(
                context,
                state.cancelReason,
                (OrderCancelReasonModel p0, String? otherReasons) {
                  OrderBloc orderBloc = context.read<OrderBloc>();
                  orderBloc.add(
                    CancelOrderEvent(
                      widget.orderModel.id,
                      p0.id,
                      otherReasons,
                      widget.orderModel.status,
                      callBack: (status) {
                        orderBloc.add(OnRefreshEvent(1));
                        if (!status) {
                          _showFailDialog();
                        }
                        SensorsAnalyticsFlutterPlugin.track(
                            OrderSensorsConstant.confirmReasonOfCancelOrderListClick, {
                          "cancel_order_reason": p0.orderCancelReason,
                          "cancel_result_new": status ? '是' : '否'
                        });
                      },
                    ),
                  );
                },
              );
            } else {
              CommonDialog.show(context,
                      content: '确定取消订单吗？', mainButtonName: "确定", subButtonName: "我再想想")
                  .then((value) {
                if (value == 1) {
                  logI('确定');
                  OrderBloc orderBloc = context.read<OrderBloc>();
                  orderBloc.add(CancelOrderEvent(
                    widget.orderModel.id,
                    -1,
                    null,
                    widget.orderModel.status,
                    callBack: (status) {
                      orderBloc.add(OnRefreshEvent(1));
                    },
                  ));
                } else if (value == 0) {
                  logI('我再想想');
                }
              });
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitle(),
                SizedBox(height: 6.h),
                _buildCreateTime(),
                SizedBox(height: 14.h),
                _buildProducts(),
                _buildBottom(),
              ],
            );
          },
        ),
      ),
    );
  }

  _showFailDialog() {
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
        OrderDetailModel orderDetailModel = OrderDetailModel()
          ..orderNo = widget.orderModel.orderNo
          ..orderQueryProducts = widget.orderModel.products
              ?.map((e) => OrderQueryProduct()..productNameShow = e.title)
              .toList()
          ..orderQueryFinance = (OrderQueryFinance()
            ..totalProductMoney = double.tryParse(widget.orderModel.orderActuallyPayMoney ?? ''))
          ..createTime = widget.orderModel.createTime
          ..orderQueryExtend = (OrderQueryExtend()..memberNickName = '')
          ..status = widget.orderModel.status;
        widget.helpBloc
            .add(OnlineServiceEvent(context: context, orderDetailModel: orderDetailModel));
        // HelpSheet.show(context,shopPhone: shopPhone,orderDetailModel: _bloc.state.orderDetail);
      }
    });
  }

  _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLabel(widget.orderModel.eatTypeStr ?? ''),
        SizedBox(width: 8.w),
        Expanded(
          child: _address(),
        ),
        SizedBox(width: 8.w),
        _buildStatusStr(),
      ],
    );
  }

  _buildLabel(String takeTypeName) {
    return Offstage(
      offstage: takeTypeName.isEmpty,
      child: MiniLabelWidget(
        label: takeTypeName,
        radius: 2.r,
        textPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        textSize: 12.sp,
      ),
    );
  }

  _takeAddress() {
    OrderModel orderModel = widget.orderModel;
    if (orderModel.poiWithHouseNumber?.isNotEmpty ?? false) {
      return orderModel.poiWithHouseNumber;
    }
    if (orderModel.takeAddress?.isNotEmpty ?? false) {
      return orderModel.takeAddress;
    }
    return '';
  }

  Widget _address() {
    OrderModel orderModel = widget.orderModel;
    return Text(
      (orderModel.eatType == 2 ? _takeAddress() : orderModel.shopName) ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: CottiColor.textBlack, fontSize: 14.sp, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildStatusStr() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.orderModel.statusStr ?? '',
          style: TextStyle(
            fontSize: 12.sp,
            color: CottiColor.textBlack,
          ),
          strutStyle: const StrutStyle(forceStrutHeight: true),
        ),
        SvgPicture.asset(
          'assets/images/icon_more.svg',
          color: CottiColor.textBlack,
          width: 16.w,
          height: 16.w,
        )
      ],
    );
  }

  _buildCreateTime() {
    return Padding(
      padding: EdgeInsets.only(right: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.orderModel.createTime ?? '',
            style: TextStyle(
                fontSize: 12.sp, color: CottiColor.textGray, fontFamily: 'DDP4', height: 1),
          ),
          Visibility(
            visible:
                widget.orderModel.status == 10 && ((widget.orderModel.deadlineSeconds ?? 0) > 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CountDownTimer(
                  callback: () => context.read<OrderBloc>().add(OnRefreshEvent(1)),
                  notifier: _countNotifier,
                  format: 'mm:ss',
                  textStyle: TextStyle(
                      color: CottiColor.primeColor, fontSize: 12.sp, fontFamily: 'DDP4', height: 1),
                ),
                SizedBox(width: 2.w),
                Text(
                  '后将自动取消',
                  style: TextStyle(
                    color: CottiColor.textGray,
                    fontSize: 11.sp,
                    fontFamily: 'DDP4',
                    height: 1,
                    // leadingDistribution: TextLeadingDistribution.even
                  ),
                ),
              ],
            ),
            replacement: Visibility(
              visible: widget.orderModel.expectContext?.isNotEmpty ?? false,
              child: Text(
                '${widget.orderModel.expectContext?.replaceAll('X', widget.orderModel.expectTimeStr ?? '')}',
                style: TextStyle(
                    fontSize: 12.sp,
                    color: widget.orderModel.overTime ?? false
                        ? CottiColor.primeColor
                        : CottiColor.textGray,
                    fontFamily: 'DDP4',
                    height: 1,
                    leadingDistribution: TextLeadingDistribution.even),
              ),
              replacement: Container(),
            ),
          ),
        ],
      ),
    );
  }

  _buildProducts() {
    return SizedBox(
      height: 83.h,
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView.separated(
                  padding: EdgeInsets.only(right: 57.w),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return OrderProductItem(productModel: widget.orderModel.products![index]);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 8.w);
                  },
                  itemCount: widget.orderModel.products?.length ?? 0,
                ),
                Positioned(
                  right: -2.w,
                  top: -1,
                  child: Container(
                    color: Colors.white,
                    width: 56.w,
                    height: 83.h,
                  ),
                ),
                Positioned(
                    right: 0.w,
                    top: -2,
                    bottom: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "assets/images/order/order_list/icon_list_product_shadow.svg",
                          width: 39.w,
                          height: 83.h,
                        ),
                        Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "¥ ${StringUtil.decimalParse(widget.orderModel.orderActuallyPayMoney)}",
                                    style: TextStyle(
                                      color: CottiColor.textBlack,
                                      fontFamily: 'DDP5',
                                      fontSize: 16.sp,
                                    ),
                                    strutStyle: const StrutStyle(forceStrutHeight: true),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Text(
                                "共${widget.orderModel.productQuantity ?? 0}件",
                                style: TextStyle(
                                  fontFamily: 'DDP4',
                                  color: CottiColor.textBlack,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildBottom() {
    List<Widget> btns = listBtn();
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.only(right: 5.w),
      child: Row(
        children: [
          _buildPaySerialNumber(),
          _buildTakeCode(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: btns,
            ),
          ),
        ],
      ),
    );
  }

  _buildPaySerialNumber() {
    return Visibility(
      visible: _showSerialNumber(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.orderModel.canteenPaySerialNumber ?? '',
                style: TextStyle(
                    color: CottiColor.textBlack,
                    fontSize: 18.sp,
                    fontFamily: 'DDP5',
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '支付序号',
                style: TextStyle(color: CottiColor.textGray, fontSize: 11.sp),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 18.w, right: 18.w),
            color: CottiColor.dividerGray,
            width: 0.5.w,
            height: 22.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '待生成',
                style: TextStyle(
                    color: CottiColor.textBlack, fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                '取餐码',
                style: TextStyle(color: CottiColor.textGray, fontSize: 11.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildTakeCode() {
    return Visibility(
      visible: _showTakeCode(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.orderModel.takeCode ?? '',
            style: TextStyle(color: CottiColor.textBlack, fontSize: 18.sp, fontFamily: 'DDP5'),
          ),
          Text(
            '取餐码',
            style: TextStyle(color: CottiColor.textGray, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }

  bool _showTakeCode() {
    if (widget.orderModel.takeCode?.isEmpty ?? true) {
      return false;
    }
    if (widget.orderModel.eatType == 2) {
      return false;
    }
    if (widget.orderModel.status == 20) {
      return true;
    }
    if (widget.orderModel.status == 30 || widget.orderModel.status == 50) {
      return (DateTime.now().millisecondsSinceEpoch - (widget.orderModel.finishTime ?? 0)) <=
          (24 * 60 * 60 * 1000);
    }
    return false;
  }

  bool _showSerialNumber() {
    // 如果取餐码有值，则不显示支付序号
    if (widget.orderModel.takeCode?.isNotEmpty ?? false) {
      return false;
    }
    if (widget.orderModel.canteenPaySerialNumber?.isEmpty ?? true) {
      return false;
    }
    // 如果订单已取消， 不显示支付序号
    if (widget.orderModel.status == 40) {
      return false;
    }

    if (widget.orderModel.eatType == 2) {
      return false;
    }

    return true;
  }

  List<Widget> listBtn() {
    List<Map<String, Function>> list = [];
    if (widget.orderModel.hiddenCancel == 0) {
      list.add({'取消订单': _beforeCancelOrder});
    }
    // 如果支付方式是食堂刷卡,则不显示立即支付
    if (widget.orderModel.status == 10 && widget.orderModel.payFrom != PayForm.canteenCard.index) {
      list.add({'立即支付': _toPay});
    }
    if (widget.orderModel.allowEvaluate == 1) {
      list.add({'去评价': _toEvaluate});
    }
    if (widget.orderModel.status != 10) {
      list.add({'再来一单': clickAnotherOrder});
    }

    return List.generate(list.length, (index) {
      Map<String, Function> map = list[index];
      return _buildButton(map.keys.first, map.values.first, list.length - 1 == index);
    });
  }

  Widget _buildButton(String title, Function function, bool lastChild) {
    return GestureDetector(
      onTap: () => function(),
      child: Container(
        width: 92.w,
        height: 32.h,
        margin: lastChild ? EdgeInsets.zero : EdgeInsets.only(right: 14.w),
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
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _cancelOrder() {
    context
        .read<OrderBloc>()
        .add(CancelReasonListEvent(widget.orderModel.id, DateTime.now().microsecondsSinceEpoch));

    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.cancelOrderOrderListClick, {});
  }

  void _beforeCancelOrder() {
    if (widget.orderModel.deliveryDiscountType == 1) {
      CancelOrderFirstDeliveryDialog.show(context, widget.cancelOrderConfigDTO, (index) {
        if (index == 0) {
          _cancelOrder();
        }
      });
    } else {
      _cancelOrder();
    }
  }

  void _toPay() {
    ToPayDialog.show(
      context,
      double.tryParse(widget.orderModel.orderActuallyPayMoney ?? "0") ?? 0,
      "${widget.orderModel.id}",
      widget.orderModel.orderNo ?? '',
      widget.orderModel.eatType,
      widget.orderModel.shopMdCode,
      (ABitePayResult payResult) {
        if (payResult.state == ABitPayState.succeed) {
          context.read<OrderBloc>().add(OnRefreshEvent(1));

          // 跳转到订单详情
          NavigatorUtils.push(context, OrderRouter.orderDetailPage,
              params: {"orderNo": widget.orderModel.orderNo, 'delay': true}, replace: true);
        } else {
          logD(payResult.msg);
        }
      },
    );

    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.toPayOrderListClick, {});
  }

  void _toEvaluate() {
    NavigatorUtils.push(
      context,
      OrderRouter.orderEvaluatePage,
      params: {"orderNo": widget.orderModel.orderNo},
    ).then((value) {
      if (value != null && value) {
        context.read<OrderBloc>().add(OnRefreshEvent(0));
      }
    });
    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.toCommentOrderListClick, {});
  }

  void clickAnotherOrder() {
    var list = widget.orderModel.products
        ?.map((e) => CartGoodsItem()
          ..itemNo = e.spuCode!
          ..skuCode = e.skuCode!
          ..buyNum = e.count!)
        .toList();
    context.read<ShoppingCartBloc>().add(AddCartListSkuEvent(list ?? [], cleanCart: true));
    GlobalBlocs.get<GlobalBloc>(GlobalBloc.blocName).add(
      SwitchTabEvent(TabEnum.menu.index, arguments: {"openCart": true}),
    );

    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.reorderOrderListClick, {});
  }

  bool expressMode() {
    if (widget.orderModel.orderExpress?.expressOrderNo?.isEmpty ?? true) {
      return false;
    }
    if (widget.orderModel.expressMode == 1) {
      return widget.orderModel.orderExpress?.expressInfoList?.isNotEmpty ?? false;
    }
    return widget.orderModel.expressMode == 2;
  }
}
