import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/bloc/order_voucher_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/divider_line.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/order_coupon.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/common_box.dart';
import 'package:cotti_client/widget/cotti_good_line_display.dart';
import 'package:cotti_client/widget/coupon_shape_border.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class OrderConfirmInfo extends StatefulWidget {
  const OrderConfirmInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderConfirmInfoState();
}

class _OrderConfirmInfoState extends State<OrderConfirmInfo> {
  bool _useBounty = false;

  bool expandMoreProduct = false;

  late OrderConfirmBloc _orderConfirmBloc;

  late OrderVoucherBloc _voucherBloc;

  @override
  void initState() {
    super.initState();

    _orderConfirmBloc = context.read<OrderConfirmBloc>();
    // voucherBloc = OrderVoucherBloc();
    _voucherBloc = context.read<OrderVoucherBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderConfirmBloc, OrderConfirmState>(builder: (context, state) {
      OrderConfirmModelEntity? confirmModel = state.orderConfirmModelEntity;
      logI("确认订单返回===>${confirmModel?.toJson()}");
      bool hasFilter = confirmModel?.takeFoodModeFilterContext != null &&
          confirmModel!.takeFoodModeFilterContext!.isNotEmpty &&
          (confirmModel.confirmGoodsItems?.isNotEmpty ?? false);
      return Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: Column(
            children: [
              if (hasFilter)
                Container(
                  height: 32.h,
                  padding: EdgeInsets.only(left: 12.w),
                  // margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
                  alignment: Alignment.centerLeft,
                  color: const Color(0xFFFBE7E5),
                  child: Text(
                    "${confirmModel.takeFoodModeFilterContext}",
                    style: TextStyle(color: CottiColor.primeColor, fontSize: 12.sp),
                  ),
                ),
              CommonBox(
                margin: EdgeInsets.zero,
                // margin: hasFilter
                //     ? EdgeInsets.only(left: 16.w, right: 16.w)
                //     : EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
                padding: EdgeInsets.only(top: 16.h, left: 12.w, right: 12.w, bottom: 12.h),
                // padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                child: _buildContent(confirmModel),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildContent(OrderConfirmModelEntity? confirmModel) {
    if (confirmModel == null) {
      return Container();
    }
    if (confirmModel.confirmGoodsItems?.isEmpty ?? true) {
      return _buildEmptyView(confirmModel);
    } else {
      ConfigBloc cBloc = GlobalBlocs.get<ConfigBloc>(ConfigBloc.blocName);

      bool showVoucher = cBloc.state.configEntity?.showVoucher ?? false;

      int availableVoucherCount = confirmModel.memberAvailableVoucherCount ?? 0;

      return Column(
        children: [
          _buildProductInfo(confirmModel),
          const DividerLine(),
          SizedBox(
            height: 8.h,
          ),
          _buildDiscountMoneyItem(confirmModel),
          _buildSpecialDiscountMoneyItem(confirmModel),
          Visibility(
            visible: showVoucher || (availableVoucherCount > 0),
            child: _buildVoucherItem(confirmModel),
          ),
          _buildCouponItem(confirmModel),
          _buildBountyItem(confirmModel),
          _buildDeliveryItem(confirmModel),
          SizedBox(
            height: 8.h,
          ),
          const DividerLine(),
          SizedBox(
            height: 14.h,
          ),
          _totalPayableMoney(confirmModel)
        ],
      );
    }
  }

  Widget _buildEmptyView(OrderConfirmModelEntity? confirmModel) {
    return SizedBox(
        height: 301.h,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/order/order_list/icon_list_current_empty.png',
              width: 141.w,
              height: 121.h,
            ),
            SizedBox(
              height: 24.h,
            ),
            Text(
              _getTitle(),
              style: TextStyle(color: const Color(0xFF111111), fontSize: 16.sp),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              _getSubTitle(),
              style: TextStyle(color: const Color(0xFF666666), fontSize: 13.sp),
            )
          ],
        ));
  }

  _getTitle() {
    int curTakeFoodMode = context.read<ShopMatchBloc>().state.curTakeFoodMode;
    int currentTakeTypeMode = context.read<OrderConfirmBloc>().state.currentTakeTypeMode;
    if (curTakeFoodMode == Constant.takeOutModeCode) {
      return "所选餐品不支持外卖配送";
    }
    if (currentTakeTypeMode == Constant.eatInModeCode) {
      return "所选餐品不支持堂食";
    }

    return "所选餐品不支持外带";
  }

  _getSubTitle() {
    int curTakeFoodMode = context.read<ShopMatchBloc>().state.curTakeFoodMode;
    int currentTakeTypeMode = context.read<OrderConfirmBloc>().state.currentTakeTypeMode;
    if (curTakeFoodMode == Constant.takeOutModeCode) {
      return "建议切换其他取餐方式";
    }
    if (currentTakeTypeMode == Constant.eatInModeCode) {
      return "建议切换其他取餐方式或更换门店";
    }

    return "建议切换其他取餐方式或更换门店";
  }

  Widget _buildSpecialDiscountMoneyItem(OrderConfirmModelEntity confirmModel) {
    if ((confirmModel.financeDetail?.specialOfferDiscountMoney ?? 0) > 0) {
      return _buildCommonItem(
        Text(
          "特价活动",
          style: TextStyle(
            color: CottiColor.textBlack,
            fontSize: 14.sp,
          ),
        ),
        Text(
          "-¥${confirmModel.financeDetail?.specialOfferDiscountMoney}",
          style: TextStyle(
            color: CottiColor.primeColor,
            fontSize: 16.sp,
            fontFamily: 'DDP4',
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildDeliveryItem(OrderConfirmModelEntity confirmModel) {
    if (confirmModel.financeDetail?.deliveryMoney == null) {
      return Container();
    }
    return _buildCommonItem(
        GestureDetector(
          onTap: () {
            showDeliveryRuleDialog(confirmModel);
            SensorsAnalyticsFlutterPlugin.track(
                OrderSensorsConstant.orderConfirmDeliverDescBrowseEvent, {});
          },
          child: Row(
            children: [
              Text(
                "配送费",
                style: TextStyle(
                  color: CottiColor.textBlack,
                  fontSize: 14.sp,
                ),
                strutStyle: const StrutStyle(forceStrutHeight: true),
              ),
              SizedBox(
                width: 4.w,
              ),
              Icon(
                IconFont.icon_tips,
                size: 12.w,
                color: CottiColor.textGray,
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildFirstOrderView(confirmModel),
            SizedBox(
              width: 6.w,
            ),
            _buildDeliveryPayView(confirmModel)
          ],
        ));
  }

  _buildDeliveryPayView(OrderConfirmModelEntity confirmModel) {
    if (confirmModel.benefitStatus == 1 && confirmModel.financeDetail?.deliveryPayMoney != null) {
      return Text(
        "¥${StringUtil.decimalParse(confirmModel.financeDetail?.deliveryPayMoney)}",
        style: TextStyle(color: CottiColor.textBlack, fontSize: 16.sp, fontFamily: 'DDP4'),
      );
    }

    if (confirmModel.financeDetail?.deliveryMoney == confirmModel.financeDetail?.deliveryPayMoney) {
      return Text(
        "¥${StringUtil.decimalParse(confirmModel.financeDetail?.deliveryMoney)}",
        style: TextStyle(color: CottiColor.textBlack, fontSize: 16.sp, fontFamily: 'DDP4'),
      );
    }

    return Row(
      children: [
        Text(
          "¥${StringUtil.decimalParse(confirmModel.financeDetail?.deliveryMoney)}",
          style: TextStyle(
            color: CottiColor.textGray,
            fontSize: 16.sp,
            fontFamily: 'DDP4',
            decoration: TextDecoration.lineThrough,
          ),
        ),
        if (confirmModel.financeDetail?.deliveryPayMoney != null)
          SizedBox(
            width: 4.w,
          ),
        Text(
          "¥${StringUtil.decimalParse(confirmModel.financeDetail?.deliveryPayMoney)}",
          style: TextStyle(color: CottiColor.textBlack, fontSize: 16.sp, fontFamily: 'DDP4'),
        ),
      ],
    );
  }

  _buildFirstOrderView(OrderConfirmModelEntity confirmModel) {
    if (confirmModel.benefitStatus != 1) {
      return Container();
    }
    ConfigState configState = context.read<ConfigBloc>().state;
    return Row(
      children: [
        Container(
          height: 15.h,
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFFBE7E5), width: 1.w)),
          padding: EdgeInsets.only(left: 3.w, right: 3.w),
          child: Text(
            configState
                    .configEntity?.firstOrderFreeShippingGlobalResult?.firstOrderFreeShippingMsg ??
                "",
            style: TextStyle(fontSize: 10.sp, color: CottiColor.primeColor),
          ),
        ),
        if ((confirmModel.financeDetail?.deliveryMoney ?? 0) > 0)
          Container(
            alignment: Alignment.center,
            color: const Color(0xFFFBE7E5),
            height: 15.h,
            padding: EdgeInsets.only(left: 4.w, right: 4.w),
            child: Text(
              "￥${confirmModel.financeDetail?.deliveryMoney ?? 0}",
              style: TextStyle(
                fontSize: 13.sp,
                color: CottiColor.primeColor,
                fontFamily: 'DDP4',
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
      ],
    );
  }

  showDeliveryRuleDialog(OrderConfirmModelEntity confirmModel) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SafeArea(
              child: SingleChildScrollView(
                  child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
            ),
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40.h,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    textDirection: TextDirection.rtl,
                    children: [
                      Center(
                        child: Text(
                          "配送费规则说明",
                          style: TextStyle(color: CottiColor.textBlack, fontSize: 16.sp),
                        ),
                      ),
                      IconButton(
                        icon: Icon(IconFont.icon_close, size: 20.sp, color: CottiColor.textGray),
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "使用条件：",
                      style: TextStyle(fontSize: 16.sp, color: CottiColor.textBlack),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      confirmModel.deliverRuleDesc ?? "",
                      style: TextStyle(fontSize: 12.sp, color: CottiColor.textBlack),
                    )
                  ],
                ),
                if (confirmModel.benefitStatus == 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 12.h,
                      ),
                      Text(
                        context
                                .read<ConfigBloc>()
                                .state
                                .staticTextEntity
                                ?.confirmOrderPage
                                ?.firstOrderFreeDispatchRuleTitle ??
                            '',
                        style: TextStyle(fontSize: 16.sp, color: CottiColor.textBlack),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        confirmModel.benefitDeliverRuleDesc ?? "",
                        style: TextStyle(fontSize: 12.sp, color: CottiColor.textBlack),
                      )
                    ],
                  )
              ],
            ),
          )));
        });
  }

  Widget _buildDiscountMoneyItem(OrderConfirmModelEntity confirmModel) {
    if ((confirmModel.financeDetail?.totalProductDiscountMoney ?? 0) > 0) {
      return _buildCommonItem(
        Text(
          "商品直减",
          style: TextStyle(
            color: CottiColor.textBlack,
            fontSize: 14.sp,
          ),
        ),
        Text(
          "-¥${confirmModel.financeDetail?.totalProductDiscountMoney}",
          style: TextStyle(
            color: CottiColor.primeColor,
            fontSize: 16.sp,
            fontFamily: 'DDP4',
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildCouponItem(OrderConfirmModelEntity confirmModel) {
    return _buildCommonItem(
        Text(
          "优惠券",
          style: TextStyle(
            color: CottiColor.textBlack,
            fontSize: 14.sp,
          ),
        ),
        GestureDetector(
          onTap: () {
            if (_orderConfirmBloc.state.address == null &&
                context.read<ShopMatchBloc>().state.curTakeFoodMode == Constant.takeOutModeCode) {
              ToastUtil.show("请先选择收货地址");
              return;
            }
            _gotoCouponPage(confirmModel);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 1.w),
                  child: Visibility(
                    visible: (confirmModel.financeDetail?.couponDiscountMoney ?? 0) > 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Visibility(
                              visible: confirmModel.usedCouponName?.isNotEmpty ?? false,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2.r),
                                child: Material(
                                  color: CottiColor.primeColor,
                                  shape: CouponShapeBorder(circleSize: 4.r),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 1.h,
                                    ),
                                    child: Text(
                                      confirmModel.usedCouponName ?? "",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis,
                                        // height: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '-¥${StringUtil.decimalParse(confirmModel.financeDetail?.couponDiscountMoney)}',
                          style: TextStyle(
                            color: CottiColor.primeColor,
                            fontSize: 16.sp,
                            fontFamily: 'DDP4',
                          ),
                        ),
                      ],
                    ),
                    replacement: Visibility(
                      visible: (confirmModel.availableCouponCount ?? 0) > 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${confirmModel.availableCouponCount}',
                            style: TextStyle(
                              color: CottiColor.primeColor,
                              fontSize: 16.sp,
                              fontFamily: "DDP5",
                              height: 1,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 4.w),
                            child: Text(
                              '张可用',
                              style: TextStyle(
                                color: CottiColor.textBlack,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      replacement: Text(
                        '暂无可用',
                        style: TextStyle(
                          color: CottiColor.textBlack,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(
                "assets/images/icon_more.svg",
                width: 14.w,
                height: 14.h,
                color: CottiColor.textBlack,
              )
            ],
          ),
        ));
  }

  Widget _buildVoucherItem(OrderConfirmModelEntity confirmModel) {
    bool useVoucher =
        (double.tryParse(confirmModel.financeDetail?.totalVoucherDiscountMoney ?? "0") ?? 0) > 0;

    /// 防止 费用明细有数据而 useVoucherSkus 或者 usedVoucherName 无数据；
    bool showVoucheretail = (confirmModel.useVoucherSkus?.length ?? 0) > 1 ||
        (confirmModel.usedVoucherName?.isNotEmpty ?? false);

    return _buildCommonItem(
      Text(
        "代金券",
        style: TextStyle(
          color: CottiColor.textBlack,
          fontSize: 14.sp,
        ),
      ),
      GestureDetector(
        onTap: () {
          if (_orderConfirmBloc.state.address == null &&
              context.read<ShopMatchBloc>().state.curTakeFoodMode == Constant.takeOutModeCode) {
            ToastUtil.show("请先选择收货地址");
            return;
          }
          _gotoVoucherPage(confirmModel);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 1.w),
                child: Visibility(
                  visible: useVoucher,
                  child: Row(
                    children: [
                      Expanded(
                        child: Visibility(
                          visible: showVoucheretail,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(2.r),
                                  child: Material(
                                    color: CottiColor.primeColor,
                                    shape: (confirmModel.useVoucherSkus?.length ?? 0) > 1
                                        ? null
                                        : CouponShapeBorder(circleSize: 4.r),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                        vertical: 1.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2.r),
                                      ),
                                      child: Visibility(
                                        visible: (confirmModel.useVoucherSkus?.length ?? 0) > 1,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "已选",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "PingFangSC-Medium, PingFang SC",
                                                // height: 1.2,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                                              child: Text(
                                                "${confirmModel.useVoucherSkus?.length ?? 0}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "DDP4",
                                                  // height: 1.2,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "张",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "PingFangSC-Medium, PingFang SC",
                                                // height: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        replacement: Text(
                                          confirmModel.usedVoucherName ?? "",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "PingFangSC-Medium, PingFang SC",
                                            overflow: TextOverflow.ellipsis,
                                            // height: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '-¥${StringUtil.decimalParse(confirmModel.financeDetail?.totalVoucherDiscountMoney)}',
                        style: TextStyle(
                          color: CottiColor.primeColor,
                          fontSize: 16.sp,
                          fontFamily: 'DDP4',
                        ),
                      ),
                    ],
                  ),
                  replacement: Visibility(
                    visible: (confirmModel.availableVoucherCount ?? 0) > 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${confirmModel.availableVoucherCount}',
                          style: TextStyle(
                            color: CottiColor.primeColor,
                            fontSize: 16.sp,
                            fontFamily: "DDP5",
                            height: 1,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Text(
                            '张可用',
                            style: TextStyle(
                              color: CottiColor.textBlack,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    replacement: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '暂无可用',
                        style: TextStyle(
                          color: CottiColor.textBlack,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SvgPicture.asset(
              "assets/images/icon_more.svg",
              width: 14.w,
              height: 14.h,
              color: CottiColor.textBlack,
            )
          ],
        ),
      ),
    );
  }

  Future showBountyRule(OrderConfirmModelEntity confirmModel) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SafeArea(
              child: SingleChildScrollView(
                  child: Container(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
            child: Column(
              children: [
                Container(
                  height: 40.h,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    textDirection: TextDirection.rtl,
                    children: [
                      Center(
                        child: Text(
                          "奖励金规则说明",
                          style: TextStyle(color: CottiColor.textBlack, fontSize: 16.sp),
                        ),
                      ),
                      IconButton(
                        icon: Icon(IconFont.icon_close, size: 20.sp, color: CottiColor.textGray),
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "使用条件：",
                      style: TextStyle(
                          fontSize: 15.sp, color: CottiColor.textBlack, fontFamily: 'DDP5'),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      confirmModel.bountyRuleDesc ?? "",
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: CottiColor.textBlack,
                          fontFamily: 'DDP4',
                          height: 1.5),
                    )
                  ],
                )
              ],
            ),
          )));
        });
  }

  /// 奖励金item
  Widget _buildBountyItem(OrderConfirmModelEntity confirmModel) {
    _useBounty = confirmModel.useBounty ?? false;
    bool showMyBounty = context.read<ConfigBloc>().state.configEntity?.showMyBounty ?? false;

    // 配置显示奖励金 || 奖励金金额大于0
    if (!showMyBounty && (confirmModel.financeDetail?.totalBounty ?? 0) <= 0) {
      return Container();
    }
    return _buildCommonItem(
        GestureDetector(
          onTap: () {
            showBountyRule(confirmModel);
            SensorsAnalyticsFlutterPlugin.track(
                OrderSensorsConstant.orderConfirmBountyDescBrowseEvent, {});
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "奖励金",
                style: TextStyle(
                  color: CottiColor.textBlack,
                  fontSize: 14.sp,
                ),
                strutStyle: const StrutStyle(forceStrutHeight: true),
              ),
              SizedBox(
                width: 4.w,
              ),
              Icon(
                IconFont.icon_tips,
                size: 12.sp,
                color: CottiColor.textGray,
              ),
              Visibility(
                  visible: (confirmModel.financeDetail?.totalBounty ?? 0) > 0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Text(
                      "共有${StringUtil.decimalParse(confirmModel.financeDetail?.totalBounty)}奖励金",
                      style: TextStyle(
                          color: CottiColor.primeColor, fontSize: 12.sp, fontFamily: 'DDP4'),
                      strutStyle: const StrutStyle(forceStrutHeight: true),
                    ),
                  )),
            ],
          ),
        ),
        Visibility(
          visible: (confirmModel.financeDetail?.totalBounty ?? 0) > 0,
          child: Visibility(
            visible: (confirmModel.financeDetail?.bountyDeductionNum ?? 0) > 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 6.w),
                    child: Text(
                      '-￥${StringUtil.decimalParse(confirmModel.financeDetail?.bountyDiscountMoney)}',
                      style: TextStyle(
                        color: CottiColor.primeColor,
                        fontSize: 16.sp,
                        fontFamily: 'DDP4',
                      ),
                    )),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _useBounty = !_useBounty;
                        if (_useBounty) {
                          // 使用奖励金
                          SensorsAnalyticsFlutterPlugin.track(
                              OrderSensorsConstant.orderConfirmBountyCheckedClickEvent, {});
                        } else {
                          SensorsAnalyticsFlutterPlugin.track(
                              OrderSensorsConstant.orderConfirmBountyUncheckedClickEvent, {});
                        }
                      });
                      _orderConfirmBloc.add(OrderConfirmChangeBountyEvent(context, _useBounty));
                    },
                    child: Icon(
                      _useBounty ? IconFont.icon_select : IconFont.icon_unselect,
                      size: 16.w,
                      color: _useBounty ? CottiColor.primeColor : CottiColor.textGray,
                    ))
              ],
            ),
            replacement: Text(
              '暂不可用',
              style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 12.sp,
              ),
            ),
          ),
          replacement: Text(
            '暂无奖励金',
            style: TextStyle(
              color: CottiColor.textBlack,
              fontSize: 12.sp,
            ),
          ),
        ));
  }

  Widget _buildCommonItem(Widget leftChild, Widget rightChild) {
    return Container(
      height: 32.h,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leftChild,
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 28.w),
              alignment: Alignment.centerRight,
              child: rightChild,
            ),
          ),
        ],
      ),
    );
  }

  // 显示下单价格
  double? _getPrice(double? specialPrice, double? facePrice, double? lineThroughPrice) {
    // 如果有活动价 则直接显示活动价
    if (specialPrice != null) {
      return specialPrice;
    }
    return lineThroughPrice ?? 0;
  }

  Widget _buildProductInfo(OrderConfirmModelEntity confirmModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 16.h),
          itemBuilder: (context, index) {
            OrderConfirmModelConfirmGoodsItems product = confirmModel.confirmGoodsItems![index];
            return CottiGoodLineDisplay(
              productName: product.title ?? '',
              goodsImgUrl: product.image,
              price:
                  _getPrice(product.specialPrice, product.facePrice, product.lineThroughPrice) ?? 0,
              standardPrice: product.facePrice,
              quantity: product.buyNum,
              skuName: product.skuShowName,
              discount: product.preferenceTypeDesc,
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemCount: expandMoreProduct || (confirmModel.confirmGoodsItems?.length ?? 0) < 3
              ? (confirmModel.confirmGoodsItems?.length ?? 0)
              : 3,
          // itemCount: confirmModel.confirmGoodsItems?.length ?? 0,
        ),
        if ((confirmModel.confirmGoodsItems?.length ?? 0) > 3) _expandMoreView(confirmModel)
      ],
    );
  }

  Widget _expandMoreView(OrderConfirmModelEntity confirmModel) {
    return SizedBox(
      height: 48.h,
      child: Center(
          child: GestureDetector(
        onTap: () {
          setState(() {
            expandMoreProduct = !expandMoreProduct;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(expandMoreProduct ? "收起" : "展开更多",
                style: TextStyle(fontSize: 12.sp, color: CottiColor.textBlack)),
            Icon(
              expandMoreProduct ? IconFont.icon_shangjiantou1 : IconFont.icon_xiajiantou1_copy,
              size: 14.sp,
              color: CottiColor.textBlack,
            )
          ],
        ),
      )),
    );
  }

  Widget _totalPayableMoney(OrderConfirmModelEntity confirmModel) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: "共",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: CottiColor.textBlack,
                    )),
                TextSpan(
                    text: " ${_getTotalProductNum(confirmModel)} ",
                    style: TextStyle(
                        fontSize: 16.sp, color: CottiColor.primeColor, fontFamily: 'DDP5')),
                TextSpan(
                    text: "件商品",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: CottiColor.textBlack,
                    ))
              ])),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '合计',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: CottiColor.textBlack,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '¥${StringUtil.decimalParse(confirmModel.totalMoney)}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: CottiColor.textBlack,
                      fontFamily: 'DDP5',
                    ),
                    strutStyle: const StrutStyle(
                      forceStrutHeight: true,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
          Visibility(
            visible: (confirmModel.discountMoney ?? 0) > 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: confirmModel.discountPlanContext?.isNotEmpty ?? false,
                  child: Text(
                    confirmModel.discountPlanContext ?? "",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: CottiColor.textGray,
                    ),
                  ),
                  replacement: Container(),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "共优惠",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: CottiColor.textBlack,
                        // height: 1
                      ),
                    ),
                    Text(
                      "￥${StringUtil.decimalParse(confirmModel.discountMoney)}",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: CottiColor.primeColor,
                          fontFamily: 'DDP4',
                          height: 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _gotoCouponPage(OrderConfirmModelEntity confirmModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (buildContext) {
        return BlocProvider.value(
          value: BlocProvider.of<OrderConfirmBloc>(context),
          child: BlocProvider.value(
            value: _voucherBloc,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.r),
                topLeft: Radius.circular(8.r),
              ),
              child: OrderCoupon(confirmModel),
            ),
          ),
        );
      },
    );

    // 埋点
    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.confirmOrderCouponClick,
        {"is_check_coupon": confirmModel.chooseNotUseCoupon ?? false ? "是" : "否"});
  }

  _gotoVoucherPage(OrderConfirmModelEntity confirmModel) {
    logI("_orderConfirmBloc.state.voucherSkusList = ${_orderConfirmBloc.state.voucherSkusList}");

    /// 计算当前列表使用代金券的数量;
    int voucherNum = 0;
    for(VoucherSkuModelEntity sku in _orderConfirmBloc.state.voucherSkusList??[]){
      if((sku.voucherDiscountMoney??0)>0){
        voucherNum += 1;
      }
    }

    var map = {
      "chooseVoucher":voucherNum > 0,
      "voucherNum":voucherNum,
      "availableVoucherCount":_orderConfirmBloc.state.orderConfirmModelEntity?.availableVoucherCount??0,
    };

    SensorsAnalyticsFlutterPlugin.track(
        OrderSensorsConstant.confirmOrderVoucherClick, map);

    _voucherBloc.add(OrderVoucherInitEvent(
        goodsItems: _orderConfirmBloc.state.voucherSkusList ?? [], context: context));
    _voucherBloc.add(ShowVoucherRootPopupEvent(context: context));
  }

  _getTotalProductNum(OrderConfirmModelEntity confirmModel) {
    int total = 0;
    confirmModel.confirmGoodsItems?.forEach((element) {
      total += element.buyNum ?? 0;
    });

    return total;
  }
}
