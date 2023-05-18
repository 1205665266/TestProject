import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/order_confirm_page.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_state.dart';
import 'package:cotti_client/widget/common_box.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/order_info_item.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/20 2:52 PM
class OtherWidget extends StatefulWidget {
  const OtherWidget({Key? key}) : super(key: key);

  @override
  State<OtherWidget> createState() => _OtherWidgetState();
}

class _OtherWidgetState extends State<OtherWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailBloc, OrderDetailState>(
      builder: (context, state) {
        OrderDetailModel? orderDetail = state.orderDetail;
        if (orderDetail == null) {
          return const SizedBox();
        }
        return Container(
          margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: CommonBox(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 16.h),
              child: Column(
                children: [
                  OrderInfoItem(
                    '订单编号',
                    orderDetail.orderNo,
                    rightIcon: SvgPicture.asset('assets/images/order/order_detail/icon_copy.svg', width: 10.w, color: CottiColor.textBlack,),
                    clickRight: () {
                      _copyOrder(orderDetail.orderNo ?? '');
                      SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.copyOrderCodeOrderDetailClick, {
                        "order_state": orderDetail.orderStatusStr?.statusStr
                      });
                    },
                  ),
                  OrderInfoItem('下单时间', orderDetail.createTime),
                  if (orderDetail.orderQueryPay?.payFormName?.isNotEmpty ?? false)
                    _buildPayType(orderDetail),


                  if (orderDetail.payTime?.isNotEmpty ?? false)
                    OrderInfoItem('付款时间', orderDetail.payTime),
                  if (orderDetail.cancelTime?.isNotEmpty ?? false)
                    OrderInfoItem('取消时间', orderDetail.cancelTime),
                  if (_showFinishTime(orderDetail)) OrderInfoItem('完成时间', '${DateUtil.formatDateMs(orderDetail.finishTime?.toInt()??0)}'),
                  if (orderDetail.orderQueryExtend?.memberRemark?.isNotEmpty ?? false)
                    OrderInfoItem(
                      '订单备注',
                      orderDetail.orderQueryExtend?.memberRemark,
                      subTitleFontSize: 12.sp,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _buildPayType(OrderDetailModel? orderDetail) {

    if(orderDetail?.orderQueryPay?.payFrom == PayForm.canteenCard.index) {
      return OrderInfoItem(
        '支付方式',
        orderDetail?.canteenCardName,
        subTitleFontSize: 13.sp,
      );
    }
    return  OrderInfoItem(
      '支付方式',
      orderDetail?.orderQueryPay?.payFormName,
      subTitleFontSize: 13.sp,
    );


  }

  _copyOrder(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ToastUtil.show('复制成功');
  }

  _showFinishTime(OrderDetailModel orderDetail) {
    if (orderDetail.takeType == 2) {
      return orderDetail.status == 50;
    } else {
      return orderDetail.orderStatusStr?.status == 'HISTORY_COMPLETED';
    }
  }
}
