import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/bloc/order_voucher_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class VoucherGoodsItem extends StatefulWidget {
  final VoucherSkuModelEntity goodsItem;

  const VoucherGoodsItem({Key? key, required this.goodsItem}) : super(key: key);

  @override
  _VoucherGoodsItemState createState() {
    return _VoucherGoodsItemState();
  }
}

class _VoucherGoodsItemState extends State<VoucherGoodsItem> {
  @override
  Widget build(BuildContext context) {
    String imgUrl = widget.goodsItem.image ?? "";
    double voucherNum = widget.goodsItem.voucherDiscountMoney ?? 0.0;
    String pName = widget.goodsItem.title ?? "";
    String pp = widget.goodsItem.facePrice ?? "";
    String skuDes = widget.goodsItem.skuShowName ?? "";
    String qName = widget.goodsItem.voucherName ?? "";
    String vCode = widget.goodsItem.voucherNo ?? "";

    bool useVoucher = (widget.goodsItem.voucherDiscountMoney??0) > 0;

    return BlocBuilder<OrderVoucherBloc, OrderVoucherState>(
      builder: (context, state) {
        /// 24.w+70.w+8.h+14.h
        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: 12.w,
            horizontal: 12.w,
          ),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3.r),
                      child: CottiImageWidget(
                        imgUrl,
                        imgW: 70.w,
                        imgH: 70.w,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 12.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    pName,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: CottiColor.textBlack,
                                    ),
                                  ),
                                ),
                                Text(
                                  "￥$pp",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: CottiColor.textBlack,
                                    fontFamily: "DDP5",
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              skuDes,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: CottiColor.textGray,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                height: 18.h,
                child: Visibility(
                  visible: !useVoucher,
                  child: InkWell(
                    onTap: () {
                      _chooseAction();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "未使用代金券",
                          style: TextStyle(
                            color: CottiColor.textBlack,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "选择代金券",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: CottiColor.textHint,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/images/order/order_confirm/ic_right_arrow.svg",
                                height: 10.h,
                                width: 10.h,
                                // color: CottiColor.textHint,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  replacement: InkWell(
                    onTap: () {
                      _chooseAction();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "使用",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: CottiColor.textBlack,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Text(
                                  widget.goodsItem.voucherName ?? "",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: CottiColor.primeColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "-￥$voucherNum",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: CottiColor.primeColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "DDP5",
                                  height: 1,
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/images/order/order_confirm/ic_right_arrow.svg",
                                height: 10.h,
                                width: 10.h,
                                // color: CottiColor.textHint,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _chooseAction() {
    OrderVoucherBloc ovBloc = BlocProvider.of<OrderVoucherBloc>(context);
    OrderConfirmBloc ocBloc = BlocProvider.of<OrderConfirmBloc>(context);

    logI("widget.goodsItem == ${widget.goodsItem}");

    var map = {
      "skuNo":widget.goodsItem.skuNo,
      "chooseVoucher":widget.goodsItem.voucherNo?.isNotEmpty??false,
      "voucherNo":widget.goodsItem.voucherNo,
      "voucherName":widget.goodsItem.voucherName,
      "voucherDiscountMoney":widget.goodsItem.voucherDiscountMoney,
    };

    SensorsAnalyticsFlutterPlugin.track(
        OrderSensorsConstant.confirmOrderVoucherSkuListClick, map);

    ovBloc.add(
      ShowVoucherSubPopupEvent(
        context: context,
        goodsItem: widget.goodsItem,
      ),
    );
  }
}
