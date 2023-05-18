import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_state.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_state.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/widget/common_box.dart';
import 'package:cotti_client/widget/cotti_tooltip.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/24 10:44
class SelfTake extends StatefulWidget {

  final OrderDetailModel orderModel;

  const SelfTake({Key? key, required this.orderModel}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SelfTakeState();


}

class _SelfTakeState extends State<SelfTake> {


  final ValueNotifier<bool> showControl = ValueNotifier(false);


  @override
  Widget build(BuildContext context) {
    if (showProcess()) {
      return _buildTakeProcess(context);
    } else {
      return _buildStatus();
    }
  }

  _buildTakeProcess(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 6.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: CommonBox(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              _takeCode(),
              _buildProcess(),
              _buildStatusStr(),
              if(showReceive())
                _buildNotificationSwitch(context)
            ],
          ),
        ),
      ),
    );
  }

  _takeCode() {
    return Visibility(
      visible: _showTakeCode(),
      child: Column(
        children: [
          Text(
            widget.orderModel.orderQueryExtend?.takeNo ?? '',
            style: TextStyle(
              fontSize: 42.sp,
              fontFamily: 'DDP5',
              color: CottiColor.textBlack,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '取餐码',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: CottiColor.textBlack,
            ),
          ),
        ],
      ),
    );
  }

  _buildProcess() {
    return Container(
      margin: EdgeInsets.only(top: 26.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '等待制作',
                style: TextStyle(
                  fontSize: widget.orderModel.orderStatusStr?.status == 'WAIT_MAKE' ? 14.sp : 12.sp,
                  color: widget.orderModel.orderStatusStr?.status == 'WAIT_MAKE'
                      ? CottiColor.textBlack
                      : CottiColor.textGray,
                  fontWeight: widget.orderModel.orderStatusStr?.status == 'WAIT_MAKE'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
          SvgPicture.asset('assets/images/order/order_detail/dotted_line_long.svg'),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '精心制作中',
                style: TextStyle(
                  fontSize: widget.orderModel.orderStatusStr?.status == 'MAKING' ? 14.sp : 12.sp,
                  color: widget.orderModel.orderStatusStr?.status == 'MAKING'
                      ? CottiColor.textBlack
                      : CottiColor.textGray,
                  fontWeight: widget.orderModel.orderStatusStr?.status == 'MAKING'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),

          SvgPicture.asset('assets/images/order/order_detail/dotted_line_long.svg'),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '制作完成',
                style: TextStyle(
                  fontSize: widget.orderModel.orderStatusStr?.status == 'MAKED_OR_COMPLETED' ? 14.sp : 12.sp,
                  color: widget.orderModel.orderStatusStr?.status == 'MAKED_OR_COMPLETED'
                      ? CottiColor.textBlack
                      : CottiColor.textGray,
                  fontWeight: widget.orderModel.orderStatusStr?.status == 'MAKED_OR_COMPLETED'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildStatusStr() {
    if (widget.orderModel.orderStatusStr?.orderDetailCopywriting?.isEmpty ?? true) {
      return const SizedBox();
    }
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 16.h),
      child: Text(
        widget.orderModel.orderStatusStr?.orderDetailCopywriting ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: CottiColor.textGray,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  showReceive () {

    return widget.orderModel.orderStatusStr?.status == 'MAKING' &&
        (widget.orderModel.orderStatusStr?.orderDetailCopywriting?.isNotEmpty ?? false);
  }

  showLate() {
    int beginTime = DateTime.tryParse(widget.orderModel.expectTakeBeginTime??"")?.microsecondsSinceEpoch?? 0;
    var now = DateTime.now().microsecondsSinceEpoch;

    return now >= beginTime;

  }

  _buildNotificationSwitch(BuildContext context) {
    return BlocConsumer<MineBloc, MineState>(
      bloc: context.read<MineBloc>(),
      listener: (context, state) {},
      builder: (context, state) {
        return BlocConsumer<OrderDetailBloc, OrderDetailState>(
          bloc: context.read<OrderDetailBloc>(),
          listener: (cx, orderDetailState) {},
          builder: (cx, orderDetailState) {
            logI('通知： ${orderDetailState.systemNotification}');
            return Visibility(
              visible: (state.userInfoEntity?.appMessageSwitch == 1) || !orderDetailState.systemNotification,
              child: GestureDetector(
                  onTap: () {
                    // 如果用户关闭推送开关，则跳转到我的页面
                    if(state.userInfoEntity?.appMessageSwitch == 1) {
                      NavigatorUtils.push(context, MineRouter.accountSecurityPage);
                    } else if(!orderDetailState.systemNotification) {
                      // 如果用户关闭APP推送开关
                      openAppSettings();
                    }
                    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.acceptInfoOrderDetailClick, {
                      "order_state": orderDetailState.orderDetail?.orderStatusStr?.statusStr
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 16.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                showLate() ?  '制作完成后将向您推送取餐通知' : '预估时长供参考，制作完成后将向您推送取餐通知',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: CottiColor.textGray,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showControl.value = true;
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: 18.w,
                                width: 16.w,
                                child: CottiTooltip(
                                    child: Icon(
                                      IconFont.icon_tanhao,
                                      size: 10.w,
                                      color: CottiColor.textGray,
                                    ),
                                    tip: '需先允许接收通知，若未开启接收通知，点击下方「接收通知」开启',
                                    showControl: showControl
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 16.h),
                        child: Text(
                          '接收通知',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CottiColor.primeColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            );
          },
        );
      },
    );

  }

  bool _showTakeCode() {
    if (widget.orderModel.status == 20) {
      return true;
    } else if (widget.orderModel.status == 30 || widget.orderModel.status == 50) {
      return ((widget.orderModel.finishTime ?? 0) - DateTime.now().millisecondsSinceEpoch) <=
          (24 * 60 * 60 * 1000);
    }
    return false;
  }

  showProcess() {
    return widget.orderModel.orderStatusStr?.status == 'WAIT_MAKE' ||
        widget.orderModel.orderStatusStr?.status == 'MAKING' ||
        widget.orderModel.orderStatusStr?.status == 'MAKED_OR_COMPLETED';
  }

  _buildStatus() {
    if (widget.orderModel.orderStatusStr?.orderDetailCopywriting?.isEmpty ?? true) {
      return const SizedBox();
    }
    return Container(
      margin: EdgeInsets.only(top: 20.h, bottom: 8.h),
      alignment: Alignment.center,
      child: Text(
        widget.orderModel.orderStatusStr?.orderDetailCopywriting ?? '',
        style: TextStyle(
          fontSize: 14.sp,
          color: CottiColor.textBlack,
        ),
      ),
    );
  }

}
