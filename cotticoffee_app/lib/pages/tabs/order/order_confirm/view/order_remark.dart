import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/order_remark_edit_view.dart';
import 'package:cotti_client/widget/common_box.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class OrderRemark extends StatefulWidget {
  const OrderRemark({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderRemarkState();
}

class _OrderRemarkState extends State<OrderRemark> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<OrderConfirmBloc, OrderConfirmState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            showEditRemarkSheet();
            SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.confirmOrderRemarkClick, {});
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: CommonBox(
                margin: EdgeInsets.zero,
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '订单备注',
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: CottiColor.textBlack,
                            fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 60.w,
                      ),
                      Expanded(
                        child: Text(
                          // '你还啊啊啊阿萨斯大叔大婶大叔大婶大萨达手打',
                          state.remark,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: CottiColor.textGray,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/images/icon_more.svg",
                        width: 14.w,
                        height: 14.h,
                        color: CottiColor.textGray,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showEditRemarkSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext cx) {
          return BlocProvider.value(
            value: BlocProvider.of<OrderConfirmBloc>(context),
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r),topRight: Radius.circular(8.r)),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: MediaQuery.of(cx).viewInsets.bottom),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 48.h,
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          textDirection: TextDirection.rtl,
                          children: [
                            Center(
                              child: Text(
                                "请填写备注",
                                style: TextStyle(color: CottiColor.textBlack, fontSize: 16.sp),
                              ),
                            ),
                            IconButton(
                              icon:
                              Icon(IconFont.icon_close, size: 20.sp, color: CottiColor.textGray),
                              alignment: Alignment.center,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ),
                      ),
                      const OrderRemarkEditView()
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
