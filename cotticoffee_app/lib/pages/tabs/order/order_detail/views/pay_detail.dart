import 'dart:io';

import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/divider_line.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/utils/go_map_util.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/common_box.dart';
import 'package:cotti_client/widget/cotti_good_line_display.dart';
import 'package:cotti_client/widget/mini_label_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/23 20:18
class PayDetail extends StatefulWidget {
  OrderDetailModel orderDetail;

  PayDetail({required this.orderDetail, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PayDetailState();
}

class PayDetailState extends State<PayDetail> {
  final List<Widget> installedMapList = [];

  _getInstallMap(BuildContext context, double lon, double lat) {
    MapUtil.checkInstallMapList(lon, lat).then((value) {
      if (value.isEmpty) {
        return;
      }
      for (var element in value) {
        if (element == "高德") {
          installedMapList.add(
              InkWell(onTap: () => MapUtil.gotoAMap(lon, lat), child: _buttonItem("使用高德地图导航")));
          installedMapList.add(_splitLine(0.5.h));
        } else if (element == "百度") {
          installedMapList.add(
              InkWell(onTap: () => MapUtil.gotoBaiduMap(lon, lat), child: _buttonItem("使用百度地图导航")));
          installedMapList.add(_splitLine(0.5.h));
        } else if (element == "腾讯") {
          installedMapList.add(InkWell(
              onTap: () => MapUtil.gotoTencentMap(lon, lat), child: _buttonItem("使用腾讯地图导航")));
          installedMapList.add(_splitLine(0.5.h));
        } else if (element == "苹果" && Platform.isIOS) {
          installedMapList.add(InkWell(
              onTap: () => MapUtil.gotoAppleMap(lon, lat), child: _buttonItem("使用苹果自带地图导航")));
          installedMapList.add(_splitLine(0.5.h));
        }
      }
      installedMapList.add(_splitLine(6.h));
      installedMapList
          .add(InkWell(onTap: () => Navigator.of(context).pop(), child: _buttonItem("取消")));
    });
  }

  Widget _buttonItem(String content) {
    return SizedBox(
      height: 58.h,
      child: Center(child: Text(content)),
    );
  }

  Widget _splitLine(double height) {
    return Container(
      height: height,
      color: const Color(0xFFEEEEEE),
    );
  }

  @override
  void initState() {
    super.initState();

    _getInstallMap(context, widget.orderDetail.longitude ?? 0, widget.orderDetail.latitude ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: CommonBox(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.h),
          child: Column(
            children: [
              _buildTitle(widget.orderDetail),
              SizedBox(height: 13.h),
              const DividerLine(),
              SizedBox(height: 11.h),
              _buildProductInfo(widget.orderDetail),
              if ((widget.orderDetail.orderQueryFinance?.priceDiscountMoney ?? 0) > 0)
                _buildCouponItem(
                  '商品直减',
                  '-¥${StringUtil.decimalParse(widget.orderDetail.orderQueryFinance?.priceDiscountMoney)}',
                  '',
                ),
              if ((widget.orderDetail.orderQueryFinance?.specialDiscountMoney ?? 0) > 0)
                _buildCouponItem(
                  '特价活动',
                  '-¥${StringUtil.decimalParse(widget.orderDetail.orderQueryFinance?.specialDiscountMoney)}',
                  '',
                ),
              if ((widget.orderDetail.orderQueryFinance?.voucherDiscountMoney ?? 0) > 0)
                _buildCouponItem(
                  '代金券',
                  '-¥${StringUtil.decimalParse(widget.orderDetail.orderQueryFinance?.voucherDiscountMoney)}',
                  '',
                ),
              if ((widget.orderDetail.orderQueryFinance?.couponDiscountMoney ?? 0) > 0)
                _buildCouponItem(
                  '优惠券',
                  '-¥${StringUtil.decimalParse(widget.orderDetail.orderQueryFinance?.couponDiscountMoney)}',
                  '',
                ),
              if ((widget.orderDetail.orderQueryFinance?.awardDiscountMoney ?? 0) > 0)
                _buildCouponItem(
                  '奖励金',
                  '-¥${StringUtil.decimalParse(widget.orderDetail.orderQueryFinance?.awardDiscountMoney)}',
                  '',
                ),
              if (widget.orderDetail.takeType == 2) _buildDeliveryItem(),
              Container(
                margin: EdgeInsets.only(top: 3.h),
                color: CottiColor.dividerGray,
                height: 0.5.h,
              ),
              _totalPayableMoney(widget.orderDetail),
            ],
          ),
        ),
      ),
    );
  }

  _buildTitle(OrderDetailModel orderDetail) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              MiniLabelWidget(
                radius: 2.r,
                label: orderDetail.takeTypeStr,
                textPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
                textSize: 12.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  orderDetail.takeType == 2
                      ? orderDetail.orderQueryExtend?.takePoiAddress ?? ''
                      : orderDetail.orderQueryExtend?.shopName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: CottiColor.textBlack,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: orderDetail.takeType == 0 || orderDetail.takeType == 1,
          child: GestureDetector(
            onTap: () => _toMap(orderDetail),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/order/order_detail/icon_navigation.svg',
                    width: 12.w, color: const Color(0xFF4AA1FF)),
                SizedBox(width: 4.w),
                Text(
                  '导航前往',
                  style: TextStyle(
                    color: const Color(0xFF4AA1FF),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _showNavigationSelection() async {
    if (installedMapList.isEmpty) {
      ToastUtil.show("您未安装地图应用，无法为您导航");
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 500.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: installedMapList,
            ),
          ),
        ),
      ),
    );
  }

  _buildProductInfo(OrderDetailModel orderDetail) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 15.h),
      itemBuilder: (context, index) {
        OrderQueryProduct queryProduct = orderDetail.orderQueryProducts![index];
        return CottiGoodLineDisplay(
          productName: queryProduct.productNameShow ?? '',
          goodsImgUrl: queryProduct.productImgUrl,
          price: queryProduct.payableMoney ?? 0,
          standardPrice: queryProduct.originPrice,
          quantity: queryProduct.quantity,
          skuName: queryProduct.skuNameShow,
          discount: queryProduct.preferenceTypeDesc,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 16.h);
      },
      itemCount: orderDetail.orderQueryProducts?.length ?? 0,
    );
  }

  _buildDeliveryItem() {
    return Container(
      height: 32.h,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '配送费',
              style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 14.sp,
              ),
            ),
          ),
          if (widget.orderDetail.orderQueryFinance?.deliveryDiscountType == 1)
            Row(
              children: [
                _buildFirstOrderView(),
                SizedBox(
                  width: 6.w,
                ),
                _buildDeliveryPayView()
              ],
            ),
          if (widget.orderDetail.orderQueryFinance?.deliveryDiscountType != 1)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _totalDeliveryMoney(widget.orderDetail.orderQueryFinance),
                  style: TextStyle(
                    color: CottiColor.textGray,
                    fontSize: 14.sp,
                    fontFamily: 'DDP4',
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.w),
                  child: Text(
                    '¥${widget.orderDetail.orderQueryFinance?.deliveryPayMoney}',
                    style: TextStyle(
                      color: CottiColor.textBlack,
                      fontSize: 14.sp,
                      fontFamily: 'DDP4',
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  _buildDeliveryPayView() {
    return Text(
      "¥${StringUtil.decimalParse(widget.orderDetail.orderQueryFinance?.deliveryPayMoney)}",
      style: TextStyle(color: CottiColor.textBlack, fontSize: 16.sp, fontFamily: 'DDP4'),
    );
  }

  _buildFirstOrderView() {
    if (widget.orderDetail.orderQueryFinance?.deliveryDiscountType != 1) {
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
        if ((widget.orderDetail.orderQueryFinance?.totalDeliveryMoney ?? 0) > 0)
          Container(
            alignment: Alignment.center,
            color: const Color(0xFFFBE7E5),
            height: 15.h,
            padding: EdgeInsets.only(left: 4.w, right: 4.w),
            child: Text(
              "￥${widget.orderDetail.orderQueryFinance?.totalDeliveryMoney ?? 0}",
              style: TextStyle(
                fontSize: 11.sp,
                color: CottiColor.primeColor,
                fontFamily: 'DDP4',
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
      ],
    );
  }

  _buildCouponItem(String name, String value, String subValue) {
    return Container(
      height: 32.h,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 14.sp,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: subValue.isEmpty ? 0.w : 6.w),
                child: Text(
                  value,
                  style: TextStyle(
                    color: CottiColor.textBlack,
                    fontSize: 14.sp,
                    fontFamily: 'DDP4',
                  ),
                ),
              ),
              Text(
                subValue,
                style: TextStyle(
                  color: CottiColor.textBlack,
                  fontSize: 14.sp,
                  fontFamily: 'DDP4',
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _totalDeliveryMoney(OrderQueryFinance? orderQueryFinance) {
    if ((orderQueryFinance?.totalDeliveryMoney ?? 0) > (orderQueryFinance?.deliveryPayMoney ?? 0)) {
      return '¥${orderQueryFinance!.totalDeliveryMoney}';
    }
    return '';
  }

  _totalPayableMoney(OrderDetailModel orderDetail) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTotalQuantity(orderDetail.productQuantity ?? 0),
              _totalDiscountMoneyMessage(orderDetail.orderQueryFinance?.totalDiscountMoney ?? 0)
            ],
          ),
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
              SizedBox(width: 4.w),
              Text(
                '¥',
                style: TextStyle(
                  fontSize: 22.sp,
                  color: CottiColor.textBlack,
                  fontFamily: 'DDP5',
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                StringUtil.decimalParse(orderDetail.orderQueryFinance?.totalPayableMoney),
                style: TextStyle(
                  fontSize: 22.sp,
                  color: CottiColor.textBlack,
                  fontFamily: 'DDP5',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildTotalQuantity(int productQuantity) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$productQuantity',
          style: TextStyle(
            fontSize: 16.sp,
            color: CottiColor.primeColor,
            fontFamily: 'DDP5',
          ),
          strutStyle: const StrutStyle(forceStrutHeight: true),
        ),
        Text(
          ' 件商品',
          style: TextStyle(
            fontSize: 14.sp,
            color: CottiColor.textBlack,
            fontFamily: 'DDP5',
          ),
          strutStyle: const StrutStyle(forceStrutHeight: true),
        ),
      ],
    );
  }

  _totalDiscountMoneyMessage(double totalDiscountMoney) {
    if (totalDiscountMoney > 0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '，共优惠 ',
            style: TextStyle(fontSize: 14.sp, color: CottiColor.textBlack, fontFamily: 'DDP5'),
            strutStyle: const StrutStyle(forceStrutHeight: true),
          ),
          Text(
            '￥${StringUtil.decimalParse(totalDiscountMoney)}',
            style: TextStyle(fontSize: 16.sp, color: CottiColor.primeColor, fontFamily: 'DDP5'),
            strutStyle: const StrutStyle(forceStrutHeight: true),
          )
        ],
      );
    }
    return Container();
  }

  _toMap(OrderDetailModel orderDetail) {
    _showNavigationSelection();

    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.navigationOrderDetailClick,
        {"order_state": orderDetail.orderStatusStr?.statusStr});
  }
}
