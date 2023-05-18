import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/cancel_count_dwon.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CanteenPickupCode extends StatelessWidget {
  final OrderDetailModel orderModel;

  const CanteenPickupCode({Key? key, required this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.only(bottom: 30.h, left: 12.w, right: 12.w),
      child: _buildSwipingCard(),
    );
  }

  _buildSwipingCard() {
    return Column(
      children: [
        CancelCountDown(orderDetail: orderModel),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: SizedBox(
              height: 66.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    orderModel.canteenPaySerialNumber ?? '',
                    style: TextStyle(
                        color: CottiColor.textBlack,
                        fontSize: 28.sp,
                        fontFamily: 'DDP5',
                        height: 1.2),
                  ),
                  Text(
                    '支付序号',
                    style: TextStyle(
                        color: CottiColor.textGray, fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
            Container(
              color: CottiColor.dividerGray,
              width: 0.5.w,
              height: 66.h,
            ),
            Expanded(
              child: SizedBox(
                height: 66.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      orderModel.takeNoEmptyContext ?? '',
                      style: TextStyle(
                          color: CottiColor.textHint,
                          fontSize: 16.sp,
                          fontFamily: 'DDP5',
                          height: 2.0),
                    ),
                    Text(
                      '取餐码',
                      style: TextStyle(
                          color: CottiColor.textGray, fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: CottiColor.dividerGray,
              width: 0.5.w,
              height: 66.h,
            ),
            Expanded(
              child: SizedBox(
                height: 66.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '￥',
                          style: TextStyle(color: CottiColor.textBlack, fontSize: 26.sp),
                        ),
                        Text(
                          StringUtil.decimalParse(orderModel.orderQueryFinance?.totalPayableMoney),
                          style: TextStyle(
                              color: CottiColor.textBlack, fontSize: 26.sp, fontFamily: 'DDP5'),
                        ),
                      ],
                    ),
                    Text(
                      '请到店刷卡支付',
                      style: TextStyle(
                          color: CottiColor.textGray, fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
