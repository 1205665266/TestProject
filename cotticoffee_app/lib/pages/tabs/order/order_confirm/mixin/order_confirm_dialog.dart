import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/confirm_tip_map.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/confirm_warning_widget.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/order_confirm_page.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/mini_label_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

mixin OrderConfirmDialog {
  showShopConfirmDialog(BuildContext buildContext, OrderConfirmModelEntity? orderConfirmModelEntity,
      OrderConfirmBloc _bloc) {
    showModalBottomSheet(
        context: buildContext,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        enableDrag: false,
        builder: (context) {
          return SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      ConfirmTipMap(
                        bloc: _bloc,
                      ),
                      Positioned(
                        top: 12.h,
                        right: 10.w,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Image.asset(
                            'assets/images/order/order_confirm/ic_confirm_close_btn.png',
                            width: 24.sp,
                            height: 24.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                  _buildShopConfirmContent(context, buildContext, orderConfirmModelEntity, _bloc),
                ],
              ),
            ),
          );
        });
    // 埋点
    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.orderComfirmShopConfirmShow, {});
  }

  Widget _buildShopConfirmContent(BuildContext context, BuildContext buildContext,
      OrderConfirmModelEntity? orderConfirmModelEntity, OrderConfirmBloc _bloc) {

    String? shopTypeName = orderConfirmModelEntity?.shop?.base?.shopTypeName;
    String? shopTypeColor = orderConfirmModelEntity?.shop?.base?.color;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          left: 16.w, right: 16.w, bottom: 8.h + MediaQuery.of(context).padding.bottom),
      child: Column(
        children: [
          _buildTitleWidget(title: "请确认您的取餐门店"),
          Container(
            decoration: BoxDecoration(
              color: CottiColor.backgroundColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Visibility(
                                    visible: (shopTypeName == null || shopTypeName.isNotEmpty),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: StringUtil.hexToColor(shopTypeColor!),
                                        borderRadius: BorderRadius.circular(2.r),
                                      ),
                                      margin: EdgeInsets.only(right: 4.w),
                                      // alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 4.w, right: 4.w),
                                      height: 16.h,
                                      child: Text(
                                        shopTypeName!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ),
                                    replacement: const SizedBox(),
                                  ),
                                ),
                                TextSpan(
                                  text: "${orderConfirmModelEntity?.shop?.base?.shopName}",
                                  style: TextStyle(
                                    color: CottiColor.textBlack,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          "${orderConfirmModelEntity?.shop?.position?.address}",
                          style:
                              TextStyle(color: CottiColor.textBlack, fontSize: 12.sp, height: 1.5),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Visibility(
                          visible: _computeStepDistance(orderConfirmModelEntity).isNotEmpty,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/images/order/order_confirm/icon_location.svg",
                                height: 12.h,
                                width: 12.w,
                                color: CottiColor.textGray,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                _computeStepDistance(orderConfirmModelEntity),
                                style: TextStyle(color: CottiColor.textGray, fontSize: 12.sp),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 24.w,
                  ),
                  Container(
                    color: const Color(0xFFD8D8D8),
                    width: 0.5.w,
                  ),
                  _buildChangeWidget(
                    takeOut: false,
                    callback: () {
                      // 跳转到选择门店页面， 关闭弹窗
                      NavigatorUtils.pop(context);
                      NavigatorUtils.push(
                        context,
                        CommonPageRouter.storeListPage,
                        params: {"isFromConfirm": true},
                      );

                      // 埋点
                      SensorsAnalyticsFlutterPlugin.track(
                          OrderSensorsConstant.orderConfirmShopConfirmChangeShopClick, {});
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  NavigatorUtils.pop(context);
                  _bloc.add(
                    OrderConfirmShowConfirmTipEvent(isShowTip: true),
                  );
                  _bloc.add(
                    OrderConfirmSubmitEvent(context: buildContext),
                  );
                  // 埋点
                  SensorsAnalyticsFlutterPlugin.track(
                      OrderSensorsConstant.orderComfirmShopConfirmNotPromotClick, {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 17.w,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: CottiColor.primeColor, width: 1.w),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    "下次不再提示",
                    style: TextStyle(
                      color: CottiColor.primeColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 7.w,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    NavigatorUtils.pop(context);
                    _bloc.add(
                      OrderConfirmSubmitEvent(context: buildContext),
                    );
                    // 埋点
                    SensorsAnalyticsFlutterPlugin.track(
                        OrderSensorsConstant.orderConfirmShopConfirmPayClick, {});
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: CottiColor.primeColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: _bloc.state.currentPayTypeModel?.payFrom == PayForm.canteenCard.index
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "确认并提交订单",
                                style: confirmStyle(),
                              ),
                              Text(
                                "到店刷卡",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )
                        : Text(
                            "确认并支付",
                            style: confirmStyle(),
                          ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // 门店距离较远弹窗
  showShopFarDistanceDialog(BuildContext buildContext,
      OrderConfirmModelEntity? orderConfirmModelEntity, OrderConfirmBloc _bloc) {
    showModalBottomSheet(
        context: buildContext,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      ConfirmTipMap(
                        bloc: _bloc,
                      ),
                      Positioned(
                        top: 12.h,
                        right: 10.w,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Image.asset(
                            'assets/images/order/order_confirm/ic_confirm_close_btn.png',
                            width: 24.sp,
                            height: 24.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildShopFarDistanceContent(
                      context, buildContext, orderConfirmModelEntity, _bloc),
                ],
              ),
            ),
          );
        });
    // 埋点
    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.orderComfirmShopTooFarConfirmShow, {});
  }

  Widget _buildShopFarDistanceContent(BuildContext context, BuildContext buildContext,
      OrderConfirmModelEntity? orderConfirmModelEntity, OrderConfirmBloc _bloc) {
    String? shopTypeName = orderConfirmModelEntity?.shop?.base?.shopTypeName;

    String flagColor = orderConfirmModelEntity?.shop?.base?.color ?? '';
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          left: 16.w, right: 16.w, bottom: 8.h + MediaQuery.of(context).padding.bottom),
      child: Column(
        children: [
          _buildTitleWidget(title: "取餐门店距您较远，请确认后支付"),
          ConfirmWarningWidget(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFBE7E5).withOpacity(0.1),
                border: Border.all(color: CottiColor.primeColor, width: 1.4.w),
                borderRadius: BorderRadius.circular(4.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text.rich(
                                TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Visibility(
                                          visible: (shopTypeName == null || shopTypeName.isNotEmpty),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: colorFromString(flagColor),
                                              borderRadius: BorderRadius.circular(2.r),
                                            ),
                                            margin: EdgeInsets.only(right: 4.w),
                                            // alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: 4.w, right: 4.w),
                                            height: 16.h,
                                            child: Text(
                                              shopTypeName!,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                          ),
                                          replacement: const SizedBox(),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${orderConfirmModelEntity?.shop?.base?.shopName}",
                                        style: TextStyle(
                                          color: CottiColor.textBlack,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "${orderConfirmModelEntity?.shop?.position?.address}",
                            style: TextStyle(
                                color: CottiColor.textBlack, fontSize: 12.sp, height: 1.5),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Visibility(
                            visible: _computeStepDistance(orderConfirmModelEntity).isNotEmpty,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/order/order_confirm/icon_location.svg",
                                  height: 12.h,
                                  width: 12.w,
                                ),
                                Text(
                                  _computeStepDistance(orderConfirmModelEntity),
                                  style: TextStyle(color: CottiColor.primeColor, fontSize: 12.sp),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 24.w,
                    ),
                    Container(
                      color: const Color(0xFFD8D8D8),
                      width: 0.5.w,
                    ),
                    _buildChangeWidget(
                      takeOut: false,
                      callback: () {
                        NavigatorUtils.pop(context);
                        NavigatorUtils.push(
                          context,
                          CommonPageRouter.storeListPage,
                          params: {"isFromConfirm": true},
                        );
                        // 埋点
                        SensorsAnalyticsFlutterPlugin.track(
                            OrderSensorsConstant.orderConfirmShopTooFarConfirmChangeClick, {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          InkWell(
            onTap: () {
              NavigatorUtils.pop(context);
              _bloc.add(
                OrderConfirmSubmitEvent(context: buildContext),
              );

              // 埋点
              SensorsAnalyticsFlutterPlugin.track(
                  OrderSensorsConstant.orderConfirmShopTooFarConfirmPayClick, {});
            },
            child: Container(
              height: 40.h,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: CottiColor.primeColor,
              ),
              child: _bloc.state.currentPayTypeModel?.payFrom == PayForm.canteenCard.index
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "确认并提交订单",
                          style: confirmStyle(),
                        ),
                        Text(
                          "到店刷卡",
                          style: TextStyle(fontSize: 11.sp, color: Colors.white),
                        )
                      ],
                    )
                  : Text(
                      "确认并支付",
                      style: confirmStyle(),
                    ),
            ),
          )
        ],
      ),
    );
  }

  showAddressFarDistanceDialog(BuildContext buildContext,
      OrderConfirmModelEntity? orderConfirmModelEntity, OrderConfirmBloc _bloc) {
    showModalBottomSheet(
      context: buildContext,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ConfirmTipMap(
                      bloc: _bloc,
                    ),
                    Positioned(
                      top: 12.h,
                      right: 10.w,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image.asset(
                          'assets/images/order/order_confirm/ic_confirm_close_btn.png',
                          width: 24.sp,
                          height: 24.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                _buildAddressFarDistanceContent(
                    context, buildContext, orderConfirmModelEntity, _bloc),
              ],
            ),
          ),
        );
      },
    );

    // 埋点
    SensorsAnalyticsFlutterPlugin.track(
        OrderSensorsConstant.orderComfirmAddressTooFarConfirmShow, {});
  }

  Widget _buildAddressFarDistanceContent(BuildContext context, BuildContext buildContext,
      OrderConfirmModelEntity? orderConfirmModelEntity, OrderConfirmBloc _bloc) {

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          left: 16.w, right: 16.w, bottom: 8.h + MediaQuery.of(context).padding.bottom),
      child: Column(
        children: [
          _buildTitleWidget(title: "收货地址距您较远，请确认后支付"),
          ConfirmWarningWidget(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFBE7E5).withOpacity(0.1),
                border: Border.all(color: CottiColor.primeColor, width: 1.4.w),
                borderRadius: BorderRadius.circular(4.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Offstage(
                                      offstage: _bloc.state.address?.labelName == null,
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 28.w,
                                        margin: EdgeInsets.only(right: 4.w),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFAEAEA),
                                          borderRadius: BorderRadius.circular(2.r),
                                        ),
                                        height: 16.h,
                                        child: MiniLabelWidget(
                                          label: _bloc.state.address?.labelName,
                                          textColor: CottiColor.primeColor,
                                          textSize: 11.sp,
                                          backgroundColor:
                                          const Color(0xFFFAEAEA),
                                          isBold: false,
                                          textHeight: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${_bloc.state.address?.location}',
                                        style: TextStyle(
                                          color: CottiColor.textBlack,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${_bloc.state.address?.address}',
                                        style: TextStyle(
                                          color: CottiColor.textBlack,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                    style: TextStyle(
                                      color: CottiColor.textBlack,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${_bloc.state.address?.contact}",
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                    width: 3.w,
                                  ),
                                ),
                                TextSpan(
                                  text: "${_bloc.state.address?.contactPhone}",
                                ),
                              ],
                              style: TextStyle(
                                color: CottiColor.textBlack,
                                fontSize: 12.sp,
                                height: 1.5,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Visibility(
                            visible: _computeStepDistance(orderConfirmModelEntity).isNotEmpty,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/order/order_confirm/icon_location.svg",
                                  height: 12.h,
                                  width: 12.w,
                                ),
                                Text(
                                  _computeStepDistance(orderConfirmModelEntity),
                                  style: TextStyle(color: CottiColor.primeColor, fontSize: 12.sp),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 24.w,
                    ),
                    Container(
                      color: const Color(0xFFD8D8D8),
                      width: 0.5.w,
                    ),
                    _buildChangeWidget(
                      takeOut: true,
                      callback: () {
                        NavigatorUtils.pop(context);

                        NavigatorUtils.push(context, CommonPageRouter.takeAddressListPage,
                            params: {"isSelectTakeAddress": true}).then((value) {
                          if (value != null) {
                            _bloc.add(
                              OrderConfirmChangeAddressEvent(value),
                            );
                          }
                        });

                        // 埋点
                        SensorsAnalyticsFlutterPlugin.track(
                            OrderSensorsConstant.orderConfirmAddressTooFarConfirmChangeClick, {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          InkWell(
            onTap: () {
              NavigatorUtils.pop(context);
              _bloc.add(
                OrderConfirmSubmitEvent(context: buildContext),
              );
              // 埋点
              SensorsAnalyticsFlutterPlugin.track(
                  OrderSensorsConstant.orderConfirmAddressTooFarConfirmPayClick, {});
            },
            child: Container(
              height: 40.h,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: CottiColor.primeColor,
              ),
              child: Text(
                "确认并支付",
                style: confirmStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  TextStyle confirmStyle() {
    return TextStyle(
      fontSize: 14.sp,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    );
  }

  //  标题
  Widget _buildTitleWidget({required String title}) {
    return Container(
      height: 50.h,
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF333333),
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  //  更换按钮
  Widget _buildChangeWidget({required bool takeOut, required VoidCallback callback}) {
    return GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
        width: 80.w,
        color: Colors.transparent,
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              takeOut
                  ? "assets/images/order/order_confirm/ic_order_confirm_edit_takeout_new.svg"
                  : "assets/images/order/order_confirm/ic_order_confirm_edit_new.svg",
              height: 20.h,
              width: 20.w,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              takeOut ? "更换地址" : "更换门店",
              style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }

  String _computeStepDistance(OrderConfirmModelEntity? orderConfirmModelEntity) {
    double? stepDistance = orderConfirmModelEntity?.shop?.position?.stepDistance;
    double? distance = orderConfirmModelEntity?.shop?.position?.distance;

    if (stepDistance != null) {
      if (stepDistance > 1000) {
        if (stepDistance / 1000 >= 1000) {
          return "距您步行 ${(stepDistance / 1000).toStringAsFixed(0)}km";
        }
        return "距您步行 ${(stepDistance / 1000).toStringAsFixed(1)}m";
      }
      return "距您步行 ${stepDistance.toStringAsFixed(0)}m";
    }

    if (distance != null) {
      if (distance > 1000) {
        if (distance / 1000 >= 1000) {
          return "距您 ${(distance / 1000).toStringAsFixed(0)}km";
        }
        return "距您 ${(distance / 1000).toStringAsFixed(1)}km";
      }
      return "距您 ${distance.toStringAsFixed(0)}m";
    }
    return '';
  }

  Color colorFromString(String color) {
    return StringUtil.hexToColor(color);
  }
}
