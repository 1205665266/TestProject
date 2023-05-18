import 'dart:async';

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/divider_line.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/widget/common_box.dart';
import 'package:cotti_client/widget/cotti_tooltip.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class OrderShopInfo extends StatefulWidget {
  const OrderShopInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderShopInfoState();
}

class _OrderShopInfoState extends State<OrderShopInfo> {
  OrderConfirmBloc? _bloc;
  final ValueNotifier<bool> showControl = ValueNotifier(false);
  final ValueNotifier<bool> showMatchControl = ValueNotifier(false);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<OrderConfirmBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return _buildShopInfo();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  _buildShopInfo() {
    return BlocConsumer<OrderConfirmBloc, OrderConfirmState>(listener: (previous, current) {
      showMatchControl.value = current.firstConfirmTakeModeTye == Constant.takeOutModeCode &&
          context.read<ShopMatchBloc>().state.switchSelfTakeFromTakeOut;

      if (showMatchControl.value) {
        _timer?.cancel();
        _timer = Timer(const Duration(milliseconds: 5000), () {
          _bloc?.add(OrderConfirmInitFirstTakeModeEvent(
              context.read<ShopMatchBloc>().state.curTakeFoodMode));
          showMatchControl.value = false;
        });

        // 埋点
        SensorsAnalyticsFlutterPlugin.track(
            OrderSensorsConstant.orderConfirmSwitchServiceTypeAutoSelectShopTipShow, {});
      }
    }, builder: (context, state) {
      return Container(
        padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.h),
        margin: EdgeInsets.only(left: 16.w, right: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4.r),
            bottomRight: Radius.circular(4.r),
          ),
        ),
        child: Column(
          children: [
            _shopInfo(state.orderConfirmModelEntity),
            _takFoodMode(state),
            _estimateTime(state.orderConfirmModelEntity)
          ],
        ),
      );
    });
  }

  _shopInfo(OrderConfirmModelEntity? orderConfirmModelEntity) {
    return BlocBuilder<ShopMatchBloc, ShopMatchState>(
      builder: (context, state) {
        return Container(
            height: 80.h,
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    NavigatorUtils.push(context, CommonPageRouter.storeListPage,
                        params: {"isFromConfirm": true});
                    // 埋点
                    SensorsAnalyticsFlutterPlugin.track(
                        OrderSensorsConstant.orderConfirmChangeShopShopNameClick, {});
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(state.currentShopDetail?.shopName ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: CottiColor.textBlack,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    height: 1)),
                            CottiTooltip(
                                child: SvgPicture.asset(
                                  "assets/images/icon_more.svg",
                                  width: 14.w,
                                  height: 18.h,
                                  color: CottiColor.textBlack,
                                ),
                                tip: "已为您自动匹配收货地址附近门店",
                                showControl: showMatchControl),
                          ],
                        ),
                        SizedBox(
                          height: 9.h,
                        ),
                        Text(
                          state.currentShopDetail?.address ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: CottiColor.textGray,
                            fontSize: 12.sp,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                Visibility(
                  visible: _computeStepDistance(orderConfirmModelEntity).isNotEmpty,
                  child: GestureDetector(
                    onTap: () {
                      NavigatorUtils.push(context, CommonPageRouter.storeListPage,
                          params: {"isFromConfirm": true});
                      // 埋点
                      SensorsAnalyticsFlutterPlugin.track(
                          OrderSensorsConstant.orderConfirmChangeShopDistanceClick, {});
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          top: 11.h,
                          left: 2.w,
                          right: 0.w,
                          bottom: 0,
                          child: SvgPicture.asset(
                            'assets/images/order/order_confirm/icon_map_tag.svg',
                            width: 49.w,
                            height: 49.w,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          height: 60.h,
                          child: Container(
                            color: const Color(0xFFFBE7E5),
                            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
                            child: Text(
                              _computeStepDistance(orderConfirmModelEntity),
                              style: TextStyle(
                                  color: CottiColor.primeColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  String _computeStepDistance(OrderConfirmModelEntity? orderConfirmModelEntity) {
    double? stepDistance = orderConfirmModelEntity?.shop?.position?.stepDistance;
    double? distance = orderConfirmModelEntity?.shop?.position?.distance;

    if (stepDistance != null) {
      if (stepDistance > 1000) {
        if (stepDistance / 1000 >= 1000) {
          return "距您步行${(stepDistance / 1000).toStringAsFixed(0)}km";
        }
        return "距您步行${(stepDistance / 1000).toStringAsFixed(1)}m";
      }
      return "距您步行${stepDistance.toStringAsFixed(0)}m";
    }

    if (distance != null) {
      if (distance > 1000) {
        if (distance / 1000 >= 1000) {
          return "距您${(distance / 1000).toStringAsFixed(0)}km";
        }
        return "距您${(distance / 1000).toStringAsFixed(1)}km";
      }
      return "距您${distance.toStringAsFixed(0)}m";
    }
    return '';
  }

  _computeTakeMode(List<int> takeModeList) => takeModeList.contains(0) && takeModeList.contains(1);

  String _computeOnlyTip(List<int> takeModeList) {
    String onlyTakeSelfTip = "当前门店仅支持外带，不支持堂食";
    String onlyEatInTip = "当前门店仅支持堂食，不支持外带";

    if (takeModeList.contains(0)) {
      return onlyEatInTip;
    } else if (takeModeList.contains(1)) {
      return onlyTakeSelfTip;
    } else {
      return "";
    }
  }

  _takFoodMode(OrderConfirmState orderConfirmState) {
    return BlocBuilder<ShopMatchBloc, ShopMatchState>(
      builder: (context, state) {
        if (!_computeTakeMode(state.getTakeFoodModes)) {
          return const SizedBox();
        }
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _takeFoodModeItem("外带", "To Go", orderConfirmState.currentTakeTypeMode == 1, () {
                var orderConfirmBloc = context.read<OrderConfirmBloc>();
                orderConfirmBloc.add(OrderConfirmChangeTakeModeEvent(
                    takeMode: Constant.toGoModeCode, context: context));
                setState(() {});
              }),
              SizedBox(width: 12.w),
              _takeFoodModeItem("堂食", "Dine In", orderConfirmState.currentTakeTypeMode == 0, () {
                var orderConfirmBloc = context.read<OrderConfirmBloc>();
                orderConfirmBloc.add(OrderConfirmChangeTakeModeEvent(
                    takeMode: Constant.eatInModeCode, context: context));
                setState(() {});
              })
            ],
          ),
        );
      },
    );
  }

  _takeFoodModeItem(String name, String subName, bool isSelect, Function onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          alignment: Alignment.center,
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.r),
            border: Border.all(
                width: 1.w, color: isSelect ? CottiColor.primeColor : CottiColor.textHint),
            color: isSelect ? const Color(0xFFFDF7F6) : Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: isSelect ? CottiColor.primeColor : CottiColor.textHint,
                  fontWeight: isSelect ? FontWeight.bold : FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                subName,
                style: TextStyle(
                    color: isSelect ? CottiColor.primeColor : CottiColor.textHint,
                    fontWeight: isSelect ? FontWeight.bold : FontWeight.w400,
                    fontSize: 10.sp),
              )
            ],
          ),
        ),
      ),
    );
  }

  _estimateTime(OrderConfirmModelEntity? modelEntity) {
    var estimateTip = modelEntity?.estimateTip ?? "";
    var estimateTime = modelEntity?.estimateTime ?? "";
    if (estimateTip.isEmpty || estimateTime.isEmpty) {
      return Container();
    }
    var split = estimateTip.split("X");
    return Column(
      children: [
        // 分割线
        const DividerLine(),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                    text: split[0],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: CottiColor.textBlack,
                      fontFamily: 'DDP4',
                    ),
                  ),
                  TextSpan(
                    text: " $estimateTime ",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: CottiColor.primeColor,
                      fontFamily: 'DDP6',
                    ),
                  ),
                  TextSpan(
                    text: split[1],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: CottiColor.textBlack,
                      fontFamily: 'DDP4',
                    ),
                  ),
                  WidgetSpan(
                    child: SizedBox(
                      width: 2.w,
                    ),
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        showControl.value = true;
                      },
                      child: Container(
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        height: 18.w,
                        width: 16.w,
                        child: CottiTooltip(
                            child: Icon(
                              IconFont.icon_tanhao,
                              size: 10.w,
                              color: CottiColor.textGray,
                            ),
                            tip: modelEntity?.estimateContext ?? "",
                            showControl: showControl),
                      ),
                    ),
                  )
                ]))),
          ],
        )
      ],
    );
  }
}
