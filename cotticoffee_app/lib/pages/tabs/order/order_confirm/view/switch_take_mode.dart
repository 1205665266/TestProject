import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/widget/custom_shape_painter.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/4 16:45
class SwitchTakeMode extends StatefulWidget {
  const SwitchTakeMode({Key? key}) : super(key: key);

  @override
  State<SwitchTakeMode> createState() => _SwitchTakeModeState();
}

class _SwitchTakeModeState extends State<SwitchTakeMode> {
  final List<Offset> leftShape = [
    // const Offset(0, 0),
    Offset(0, 4.h),
    Offset(4.h, 0),
    Offset(170.w, 0),
    Offset(176.w, 40.h),
    Offset(0, 40.h),
  ];

  final List<Offset> rightShape = [
    // Offset(343.w, 0),
    Offset(339.w, 0),
    Offset(343.w, 4.h),
    Offset(343.w, 40.h),
    Offset(176.w, 40.h),
    Offset(182.w, 0),
  ];

  late ShopMatchBloc _shopMatchBloc;
  late OrderConfirmBloc _orderConfirmBloc;
  int firstTakeMode = Constant.selfTakeModeCode;

  @override
  void initState() {
    super.initState();
    _shopMatchBloc = BlocProvider.of<ShopMatchBloc>(context);
    _orderConfirmBloc = BlocProvider.of<OrderConfirmBloc>(context);
    firstTakeMode = _orderConfirmBloc.state.firstConfirmTakeModeTye;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopMatchBloc, ShopMatchState>(
      listenWhen: (previous, current) {
        if (current.switchSelfTakeFromTakeOutTimeStamp !=
            previous.switchSelfTakeFromTakeOutTimeStamp) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        // 外卖切换自提，根据外卖地址没有匹配到合适的自提门店，跳转到选择门店页面
        if (!state.switchSelfTakeFromTakeOut) {
          NavigatorUtils.push(context, CommonPageRouter.storeListPage,
              params: {"isFromConfirm": true});
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
          child: SizedBox(
            height: 40.h,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E6E7),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(4.r),topRight: Radius.circular(4.r),),
                    ),
                  ),
                ),
                CustomPaint(
                  painter: CustomShapePainter(
                    points:
                        state.curTakeFoodMode == Constant.selfTakeModeCode ? leftShape : rightShape,
                  ),
                ),
                BlocBuilder<OrderConfirmBloc, OrderConfirmState>(
                  builder: (cx, orderConfirmState) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _buildItem(
                            '到店自取',
                            state.curTakeFoodMode == Constant.selfTakeModeCode,
                            () {
                              // 如果初始进来是外卖，切换自提时，都要通过外卖地址请求附近门店作为自提门店
                              if (orderConfirmState.firstConfirmTakeModeTye ==
                                  Constant.takeOutModeCode) {
                                if (_shopMatchBloc.state.address != null) {
                                  _shopMatchBloc.add(
                                      ShopInfoBySwitchAddressEvent(_shopMatchBloc.state.address!));
                                } else {
                                  NavigatorUtils.push(context, CommonPageRouter.storeListPage);
                                }
                              } else {
                                _shopMatchBloc.add(SelfTakeMatchShopEvent(needToBeOpenShop: false));
                              }

                              SensorsAnalyticsFlutterPlugin.track(
                                  OrderSensorsConstant.orderConfirmSwitchServiceType, {"type": 2});
                            },
                          ),
                        ),
                        Expanded(
                          child: _buildItem(
                            '外卖配送',
                            state.curTakeFoodMode == Constant.takeOutModeCode,
                            () {
                              // 如果当前外卖地址没有门店信息，则跳转到选择地址页面
                              if (_orderConfirmBloc.state.address == null) {
                                NavigatorUtils.push(context, CommonPageRouter.takeAddressListPage,
                                    params: {"isSelectTakeAddress": true}).then((value) {
                                  _orderConfirmBloc.add(OrderConfirmChangeAddressEvent(value));
                                });
                              } else {
                                _shopMatchBloc
                                    .add(ShopInfoByAddressEvent(_orderConfirmBloc.state.address!));
                              }

                              SensorsAnalyticsFlutterPlugin.track(
                                  OrderSensorsConstant.orderConfirmSwitchServiceType, {"type": 1});
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildItem(String name, bool isSelect, VoidCallback click) {
    return GestureDetector(
      onTap: click,
      child: Container(
        height: isSelect ? 40.h : 35.h,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Text(
          name,
          style: TextStyle(
            fontSize: isSelect ? 15.sp : 14.sp,
            color: isSelect ? CottiColor.primeColor : const Color(0xFF8A8B8D),
            fontWeight: isSelect ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
