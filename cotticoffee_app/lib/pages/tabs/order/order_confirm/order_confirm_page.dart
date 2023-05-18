import 'dart:io';

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_event.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/mixin/order_confirm_dialog.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/order_address_info.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/order_confirm_info.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/order_pay_type.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/order_remark.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/order_shop_info.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/switch_take_mode.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/bloc/order_voucher_bloc.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/routers/order_router.dart';
import 'package:cotti_client/service/pay/model/pay_type_model.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tobias/tobias.dart' as tobias;

enum PayForm { none, aliPay, wechatPay, canteenCard }

class OrderConfirmPage extends StatefulWidget {
  bool fromDetail = false;
  Map<String, dynamic>? productInfo;

  OrderConfirmPage({required this.fromDetail, this.productInfo, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderConfirmPage();
}

class _OrderConfirmPage extends State<OrderConfirmPage>
    with OrderConfirmDialog, WidgetsBindingObserver {
  final OrderConfirmBloc _bloc = OrderConfirmBloc();
  late ShopMatchBloc _shopMatchBloc;
  late ShoppingCartBloc _shoppingCartBloc;

  OrderVoucherBloc _voucherBloc = OrderVoucherBloc();

  final ScrollController _controller = ScrollController();

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);

    _shopMatchBloc = context.read<ShopMatchBloc>();
    _shoppingCartBloc = context.read<ShoppingCartBloc>();
    // 如果是外卖进入确认订单，则默认地址为点餐页面的地址
    if (context.read<ShopMatchBloc>().state.curTakeFoodMode == Constant.takeOutModeCode) {
      _bloc.add(OrderConfirmChangeAddressEvent(context.read<ShopMatchBloc>().state.address));
    }
    _bloc.add(OrderConfirmInitShowConfirmTipEvent());
    _bloc.add(OrderConfirmInitVerifyEvent(
        context: context,
        fromDetail: widget.fromDetail,
        requestModel: _bloc.state.orderConfirmRequestModel.copy(),
        productInfo: widget.productInfo));
    _bloc.add(
        OrderConfirmInitFirstTakeModeEvent(context.read<ShopMatchBloc>().state.curTakeFoodMode));
  }

  bool firstIn = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener<OrderConfirmBloc, OrderConfirmState>(
        listenWhen: (previous, current) {
          if (current.voucherSkusRawList != null && firstIn) {
            firstIn = false;
            return true;
          }
          return false;
        },
        listener: (context, state) {
          logI("in listener OrderVoucherInitEvent !!!!");
          _voucherBloc.add(
              OrderVoucherInitEvent(context: context, goodsItems: state.voucherSkusList ?? []));
        },
        child: BlocProvider(
          create: (context) => _voucherBloc,
          child: _buildContent(),
        ),
      ),
      // child: BlocProvider(
      //   create: (context) => voucherBloc,
      //   child:_buildContent(),
      // ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (_bloc.state.orderSubmitModelEntity?.orderNo != null) {
        // IOS 只要回调Resumed就跳转到详情
        if (Platform.isIOS) {
          NavigatorUtils.push(context, OrderRouter.orderDetailPage,
              params: {'orderNo': _bloc.state.orderSubmitModelEntity?.orderNo, 'delay': true},
              replace: true);
        } else if (Platform.isAndroid) {
          // Android 只有安装支付宝 && 支付宝支付或者微信支付时，onResume才跳转到详情
          bool isAliPayInstalled = await tobias.isAliPayInstalled();
          if ((isAliPayInstalled && _bloc.state.currentPayTypeModel?.payType == "alipay") ||
              _bloc.state.currentPayTypeModel?.payType == "wxpay") {
            NavigatorUtils.push(context, OrderRouter.orderDetailPage,
                params: {'orderNo': _bloc.state.orderSubmitModelEntity?.orderNo, 'delay': true},
                replace: true);
          }
        }
      }
    }
  }

  Widget _buildContent() {
    return BlocListener<ShopMatchBloc, ShopMatchState>(
        listenWhen: (previous, current) {
          if (previous.curTakeFoodMode != current.curTakeFoodMode) {
            return true;
          }
          if (previous.shopMdCode != current.shopMdCode) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          // 更换门店，更换地址，更换取餐方式，都会触发重新请求确认订单
          _bloc.cleanCouponConfig();
          _bloc.add(OrderConfirmVerifyEvent(
              context: context, requestModel: _bloc.state.orderConfirmRequestModel.copy()));
        },
        child: _buildMainView());
  }

  Widget _buildMainView() {
    return BlocBuilder<OrderConfirmBloc, OrderConfirmState>(
      builder: (context, state) {
        return CustomPageWidget(
          title: "确认订单",
          showLoading: state.showLoading || state.showConfirmLoading,
          customLoadingColor: Colors.transparent,
          child: NotificationListener(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollUpdateNotification) {
                _valueNotifier.value = _controller.offset;
              }
              return true;
            },
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: -2.h,
                  left: 0,
                  child: Container(
                    color: Colors.white,
                    width: ScreenUtil().screenWidth,
                    height: 2.h,
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      controller: _controller,
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Column(
                        children: [
                          const SwitchTakeMode(),
                          _buildShopOrAddressInfo(),
                          if (state.orderConfirmModelEntity != null) const OrderConfirmInfo(),
                          if (state.orderConfirmModelEntity != null) const OrderPayType(),
                          if (state.orderConfirmModelEntity != null) const OrderRemark(),
                        ],
                      ),
                    )),
                    _buildSubmitButton()
                  ],
                ),
                _buildStickyBar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStickyBar() {
    return ValueListenableBuilder<double>(
        valueListenable: _valueNotifier,
        builder: (context, value, child) {
          if (value <= 100) {
            return Container();
          }
          return BlocBuilder<ShopMatchBloc, ShopMatchState>(
            builder: (context, state) {
              if (state.curTakeFoodMode == Constant.selfTakeModeCode) {
                return Container(
                  height: 44.h,
                  padding: EdgeInsets.only(left: 28.w, right: 28.w),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: CottiColor.textBlack.withOpacity(0.05),
                      spreadRadius: 2.h,
                      blurRadius: 5,
                      offset: Offset(0, 2.h),
                    ),
                  ]),
                  child: GestureDetector(
                    onTap: () {
                      NavigatorUtils.push(
                        context,
                        CommonPageRouter.storeListPage,
                        params: {"isFromConfirm": true},
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEAE1),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
                          margin: EdgeInsets.only(right: 8.w),
                          child: Text(
                            "到店自取",
                            style: TextStyle(
                                color: CottiColor.primeColor,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            state.currentShopDetail?.shopName ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: CottiColor.textBlack,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/images/icon_more.svg",
                          width: 12.w,
                          height: 14.h,
                          color: CottiColor.textGray,
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  height: 44.h,
                  padding: EdgeInsets.only(left: 28.w, right: 28.w),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: CottiColor.textBlack.withOpacity(0.06),
                      spreadRadius: 1,
                      blurRadius: 0,
                      offset: Offset(0, 0.1.h),
                    ),
                  ]),
                  child: GestureDetector(
                    onTap: () {
                      NavigatorUtils.push(context, CommonPageRouter.takeAddressListPage,
                          params: {"isSelectTakeAddress": true}).then((value) {
                        if (value != null) {
                          _bloc.add(OrderConfirmChangeAddressEvent(value));
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          color: const Color(0xFFFFEAE1),
                          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
                          margin: EdgeInsets.only(right: 8.w),
                          child: Text(
                            "外卖配送",
                            style: TextStyle(color: CottiColor.primeColor, fontSize: 11.sp),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "${state.address?.location ?? ""}${state.address?.address ?? ""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: CottiColor.textBlack, fontSize: 12.sp),
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/images/icon_more.svg",
                          width: 12.w,
                          height: 14.h,
                          color: CottiColor.textGray,
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          );
        });
  }

  Widget _loadingWidget() {
    return Container(
      color: Colors.black.withOpacity(0),
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(top: 250.h),
      alignment: Alignment.topCenter,
      child: Container(
        height: 100.h,
        width: 100.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.w)), color: CottiColor.textGray),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(
              color: Colors.white,
              radius: 15.w,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "提交中",
              style: TextStyle(fontSize: 12.sp, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  /// 门店详情 || 地址
  Widget _buildShopOrAddressInfo() {
    return BlocBuilder<ShopMatchBloc, ShopMatchState>(
      builder: (context, state) {
        if (state.curTakeFoodMode == Constant.selfTakeModeCode) {
          return const OrderShopInfo();
        } else {
          return const OrderAddressInfo();
        }
      },
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<OrderConfirmBloc, OrderConfirmState>(builder: (context, state) {
      if (state.address == null &&
          context.read<ShopMatchBloc>().state.curTakeFoodMode == Constant.takeOutModeCode) {
        return Container(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
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
            child: Container(
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r), color: CottiColor.textHint),
                child: Text(
                  "请选择收货地址",
                  style:
                      TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500),
                )),
          ),
        );
      }

      var orderConfirmModelEntity = state.orderConfirmModelEntity;
      if (orderConfirmModelEntity?.notClickableMsg?.isNotEmpty ?? false) {
        return Container(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
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
            child: Container(
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r), color: CottiColor.textHint),
                child: Text(
                  "${orderConfirmModelEntity?.notClickableMsg}",
                  style:
                      TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500),
                )),
          ),
        );
      }
      return Visibility(
        visible: orderConfirmModelEntity?.totalMoney != null,
        child: InkWell(
          onTap: () {
            _submitOrder(orderConfirmModelEntity, !state.notConfirmShopTip);
          },
          child: Container(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
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
              child: Container(
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r), color: CottiColor.primeColor),
                child: _submitButtonTextView(state),
              ),
            ),
          ),
        ),
        replacement: Container(),
      );
    });
  }

  _submitButtonTextView(OrderConfirmState state) {
    PayTypeModel? currentPayTypeModel = state.currentPayTypeModel;
    OrderConfirmModelEntity? orderConfirmModelEntity = state.orderConfirmModelEntity;
    if (currentPayTypeModel?.payFrom == PayForm.canteenCard.index) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "确认并提交订单",
            style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          Text(
            "到店刷卡",
            style: TextStyle(fontSize: 11.sp, color: Colors.white, fontWeight: FontWeight.w500),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          state.isAliPay
              ? Icon(
                  IconFont.icon_zhifubao,
                  size: 17.w,
                  color: Colors.white,
                )
              : Icon(
                  IconFont.icon_pay,
                  size: 17.w,
                  color: Colors.white,
                ),
          SizedBox(
            width: 9.w,
          ),
          Text(
            "立即支付",
            style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 6.w,
          ),
          Text(
            "￥${StringUtil.decimalParse(orderConfirmModelEntity?.totalMoney)}",
            style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'DDP5', height: 1.1),
          )
        ],
      );
    }
  }

  _submitOrder(OrderConfirmModelEntity? orderConfirmModelEntity, bool showConfirmTip) {
    // 判断当前门店的距离是否大于limit距离
    double shopDistance = orderConfirmModelEntity?.shop?.position?.distance ?? 0;
    double limitDistance = orderConfirmModelEntity?.limitDistance ?? 0;
    double tempDistance = orderConfirmModelEntity?.tempDistance ?? 0;

    int currentTakeMode = context.read<ShopMatchBloc>().state.curTakeFoodMode;
    logI("当前就餐方式为$currentTakeMode");
    logI("shopDistance$shopDistance");
    logI("limitDistance$limitDistance");
    logI("tempDistance$tempDistance");
    // 自提
    if (currentTakeMode == Constant.selfTakeModeCode) {
      if (shopDistance >= limitDistance) {
        // 显示门店距离较远弹窗
        showShopFarDistanceDialog(context, orderConfirmModelEntity, _bloc);
        return;
      }
      // 判断是否选了不在提示
      else if (showConfirmTip) {
        // 显示确认取餐门店
        showShopConfirmDialog(context, orderConfirmModelEntity, _bloc);
        return;
      }
    }
    // 外卖
    else if (currentTakeMode == Constant.takeOutModeCode) {
      // 显示收货地址距离较远弹窗
      if (tempDistance >= limitDistance) {
        showAddressFarDistanceDialog(context, orderConfirmModelEntity, _bloc);
        return;
      }
    }
    // 下单
    _bloc.add(OrderConfirmSubmitEvent(context: context));
  }

  @override
  void dispose() {
    // 如果当前是外卖，并且外卖地址为空，返回时，切换到自提
    if (_shopMatchBloc.state.curTakeFoodMode == Constant.takeOutModeCode &&
        _bloc.state.address == null) {
      _shopMatchBloc.add(SelfTakeMatchShopEvent());
    } else {
      if (_shopMatchBloc.state.curTakeFoodMode == Constant.selfTakeModeCode) {
        _shopMatchBloc.add(SelfTakeMatchShopEvent());
      } else {
        _shopMatchBloc.add(ShopInfoByAddressEvent(_bloc.state.address!));
      }
    }
    _shoppingCartBloc.add(SyncCartEvent());
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
