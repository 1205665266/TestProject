
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_state.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_delivery_detail_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_state.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/deliver_progress.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/views/delivery_map.dart';
import 'package:cotti_client/utils/scheme_dispatcher.dart';
import 'package:cotti_client/widget/arrive_time.dart';
import 'package:cotti_client/widget/common_box.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/utils/log_util.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/24 10:45
///

class TakeOutFood extends StatefulWidget {

  final OrderDetailModel orderModel;

  const TakeOutFood({Key? key, required this.orderModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TakeOutFoodState();


}
class TakeOutFoodState extends State<TakeOutFood> with SingleTickerProviderStateMixin {


  final String waitMake = "WAIT_MAKE";
  final String making = "MAKING";
  final String makedOrCompleted = "MAKED_OR_COMPLETED";

  final String waitRiderPickUp = "WAIT_RIDER_PICK_UP";
  final String delivering = "DELIVERING";
  final String delivered = "DELIVERED";

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: _buildDeliverView(context),
    );
  }
  _isShowMap() {
    return widget.orderModel.orderStatusStr?.status == 'DELIVERING' && widget.orderModel.expressMode == 1;
  }

  double _getCurrentProgress() {
    int beginTime = DateTime.tryParse(widget.orderModel.expectTakeBeginTime??"")?.microsecondsSinceEpoch?? 0;
    var now = DateTime.now().microsecondsSinceEpoch;

    if(now >= beginTime) {
      return 1;
    }

    int payTime = DateTime.tryParse(widget.orderModel.payTime??"")?.microsecondsSinceEpoch??0;


    return (1 - (beginTime - now)/ (beginTime - payTime));
  }


  _getExpectTakeTime() {
    DateTime? beginTime = DateTime.tryParse(widget.orderModel.expectTakeBeginTime??"");


    if(beginTime != null) {
      return DateUtil.formatDate(beginTime, format: "HH:mm");
    }
    return "";
  }
  _getExpressUserName() {
    if(widget.orderModel.expressMode == 1) {
      return widget.orderModel.orderExpress?.expressUserName??"";
    }
    return "商家自配送";
  }

  _buildDeliverTitle() {
    return CommonBox(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 11.h),
      margin: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            "assets/images/order/order_detail/icon_deliver_header.svg",
            height: 44.h,
            width: 44.w,
          ),
          SizedBox(width: 11.w,),
          Expanded(
            child: Text(
              _getExpressUserName(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          Icon(
            IconFont.icon_lianxidianhua,
            color: CottiColor.textGray,
            size: 20.w,
          ),
          GestureDetector(
            onTap: () {
              if (widget.orderModel.expressMode == 1) {
                String phoneNum = widget.orderModel.orderExpress?.expressUserPhone?? "";
                SchemeDispatcher.dispatchPath(context, 'callphone://cotti?phoneNumber=$phoneNum');
              } else {
                String phoneNum = widget.orderModel.orderQueryExtend?.shopPhone??"";
                SchemeDispatcher.dispatchPath(context, 'callphone://cotti?phoneNumber=$phoneNum');
              }
              SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.callRiderOrderDetailClick, {
                "order_state": widget.orderModel.orderStatusStr?.statusStr
              });

            },
            child: Text(
              "联系骑手",
              style: TextStyle(
                  color: CottiColor.textBlack,
                  fontSize: 14.sp
              ),
            ),
          )


        ],
      ),
    );
  }
  _buildDeliverOrMakeStatus() {

    // 如果当前是制作状态，显示制作流程
    if(widget.orderModel.orderStatusStr?.status == waitMake
        || widget.orderModel.orderStatusStr?.status == making
        || widget.orderModel.orderStatusStr?.status == makedOrCompleted) {
      return _buildMakeStatus();
    }

    // 如果当前是配送状态，显示配送流程
    if(widget.orderModel.orderStatusStr?.status == waitRiderPickUp
        || widget.orderModel.orderStatusStr?.status == delivering
        || widget.orderModel.orderStatusStr?.status == delivered) {
      return _buildDeliverStatus();
    }
    return Container();
  }
  // 配送进度
  _buildDeliverProgress(BuildContext context) {
    // 配送中 显示配送进度  否则只显示时间
    bool isDelivering = widget.orderModel.orderStatusStr?.status == delivering;
    return Visibility(
      visible: isDelivering,
      child: Column(
        children: [
          _buildDeliverTitle(),
          Image.asset(
             "assets/images/order/order_detail/icon_deliver_divider.png",
            fit: BoxFit.fill,
            height: 13.h,
            width: double.infinity,
          ),
          CommonBox(
              margin: EdgeInsets.zero,
              child: Stack(
                children: [
                  Center(
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween<double>(begin: 0, end: _getCurrentProgress()),
                      builder: (context, value, child) {
                        return  DeliverProgress(radius: 55.w, progress: value);
                      },
                    ),
                  ),
                  _buildDeliverEstimatedTime(context)
                ],
              )
          )
        ],
      ),
      replacement: _buildEstimatedTime(context)
    );
  }
  _buildEstimatedTime(BuildContext context) {
    // 如果是配送完成，则不显示预计送达时间
    bool isDelivered = widget.orderModel.orderStatusStr?.status == delivered;
    if(isDelivered) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(top: 6.h),
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 16.h),

      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(4.r),topLeft: Radius.circular(4.r)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            _getExpectTakeTime(),
            style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 42.sp,
                fontFamily: 'DDP5'
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            "预计送达时间",
            style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          ArriveTime(
              tipsTextSize: 13.sp,
              fontWeight: FontWeight.bold,
              rightIconSize: Size(13.w, 13.h),
              configEntity: context.read<ConfigBloc>().state.configEntity
          )
        ],
      ),
    );
  }
  // 预估送达时间
  _buildDeliverEstimatedTime(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 110.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "预计送达时间",
            style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            _getExpectTakeTime(),
            style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 35.sp,
                fontFamily: 'DDP5'
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          ArriveTime(
              tipsTextSize: 13.sp,
              fontWeight: FontWeight.bold,
              rightIconSize: Size(13.w, 13.h),
              configEntity: context.read<ConfigBloc>().state.configEntity
          )
        ],
      ),
    );
  }
  // 制作状态
  _buildMakeStatus() {
    return CommonBox(
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '等待制作',
                style: TextStyle(
                  fontSize: widget.orderModel.orderStatusStr?.status == waitMake ? 14.sp : 12.sp,
                  color: widget.orderModel.orderStatusStr?.status == waitMake
                      ? CottiColor.textBlack
                      : CottiColor.textGray,
                  fontWeight: widget.orderModel.orderStatusStr?.status == waitMake
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
                  fontSize: widget.orderModel.orderStatusStr?.status == making ? 14.sp : 12.sp,
                  color: widget.orderModel.orderStatusStr?.status == making
                      ? CottiColor.textBlack
                      : CottiColor.textGray,
                  fontWeight: widget.orderModel.orderStatusStr?.status == making
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
                  fontSize: widget.orderModel.orderStatusStr?.status == makedOrCompleted ? 14.sp : 12.sp,
                  color: widget.orderModel.orderStatusStr?.status == makedOrCompleted
                      ? CottiColor.textBlack
                      : CottiColor.textGray,
                  fontWeight: widget.orderModel.orderStatusStr?.status == makedOrCompleted
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
  // 配送状态
  _buildDeliverStatus() {
    return CommonBox(
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '待骑手取餐',
                style: TextStyle(
                  fontSize: widget.orderModel.orderStatusStr?.status == waitRiderPickUp ? 14.sp : 12.sp,
                  color: widget.orderModel.orderStatusStr?.status == waitRiderPickUp
                      ? CottiColor.textBlack
                      : CottiColor.textGray,
                  fontWeight: widget.orderModel.orderStatusStr?.status == waitRiderPickUp
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
                '骑手配送中',
                style: TextStyle(
                  fontSize: widget.orderModel.orderStatusStr?.status == delivering ? 14.sp : 12.sp,
                  color: widget.orderModel.orderStatusStr?.status == delivering
                      ? CottiColor.textBlack
                      : CottiColor.textGray,
                  fontWeight: widget.orderModel.orderStatusStr?.status == delivering
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
                '已送达',
                style: TextStyle(
                  fontSize: widget.orderModel.orderStatusStr?.status == delivered ? 14.sp : 12.sp,
                  color: widget.orderModel.orderStatusStr?.status == delivered
                      ? CottiColor.textBlack
                      : CottiColor.textGray,
                  fontWeight: widget.orderModel.orderStatusStr?.status == delivered
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
  _showProcess() {
    return _isShowDeliveryProcess() || _isShowProductionProcess();
  }


  _isShowProductionProcess() {
    return widget.orderModel.orderStatusStr?.status == 'WAIT_MAKE' ||
        widget.orderModel.orderStatusStr?.status == 'MAKING' ||
        widget.orderModel.orderStatusStr?.status == 'MAKED_OR_COMPLETED';
  }

  _isShowDeliveryProcess() {
    return widget.orderModel.orderStatusStr?.status == 'WAIT_RIDER_PICK_UP' ||
        widget.orderModel.orderStatusStr?.status == 'DELIVERING' ||
        widget.orderModel.orderStatusStr?.status == 'DELIVERED';
  }


  // 配送tip
  _buildDeliverTip() {
    if (widget.orderModel.orderStatusStr?.orderDetailCopywriting?.isEmpty ?? true) {
      return const SizedBox();
    }
    return CommonBox(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.only(bottom: 20.h),
      child: Center(
        child: Text(
          widget.orderModel.orderStatusStr?.orderDetailCopywriting??"",
          style: TextStyle(
              fontSize: 14.sp,
              color: CottiColor.textBlack
          ),
        ),
      ),
    );
  }

  _buildStatus() {
    if (widget.orderModel.orderStatusStr?.orderDetailCopywriting?.isEmpty ?? true) {
      return const SizedBox();
    }
    return Container(
      margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
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
  // 地图相关信息
  _buildDeliveryMap() {

    return BlocConsumer<OrderDetailBloc, OrderDetailState>(
        listener: (context, state) {},
        builder: (context, state) {
          OrderDeliveryDetailModelEntity? orderDeliveryDetailModelEntity = state.orderDeliveryDetailModelEntity;
          LatLng destination = LatLng(orderDeliveryDetailModelEntity?.shippingAddressLatitude??39.909187, orderDeliveryDetailModelEntity?.shippingAddressLongitude??116.397451);
          LatLng rider = LatLng(orderDeliveryDetailModelEntity?.dispatcherLatitude??39.909187, orderDeliveryDetailModelEntity?.dispatcherLongitude??116.397451);
          return SizedBox(
              width: double.infinity,
              height: 342.h,
              child: state.orderDeliveryDetailModelEntity != null ? DeliveryMap(destinationPosition: destination, riderPosition: rider): Container()
          );
        }
    );

  }
  /// 配送信息
  _buildDeliverView(BuildContext context) {

    if(_showProcess()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: Column(
          children: [
            _buildDeliverProgress(context),
            _buildDeliverOrMakeStatus(),
            _buildDeliverTip(),
            if(showReceive())
              _buildNotificationSwitch(context)
          ],
        ),
      );
    } else {
      return _buildStatus();
    }

  }

  showReceive () {
    return (
        widget.orderModel.orderStatusStr?.status == 'MAKING' ||
        widget.orderModel.orderStatusStr?.status == 'MAKED_OR_COMPLETED' ||
        widget.orderModel.orderStatusStr?.status == 'WAIT_RIDER_PICK_UP' ||
        widget.orderModel.orderStatusStr?.status == 'DELIVERING'
    );
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
            return Visibility(
              visible: (state.userInfoEntity?.appMessageSwitch == 1) || !orderDetailState.systemNotification,
              child: GestureDetector(
                onTap: () {

                  // 如果用户关闭推送开关，则跳转到我的页面
                  if(state.userInfoEntity?.appMessageSwitch == 1) {
                    NavigatorUtils.push(context, MineRouter.accountSecurityPage);
                  } else if(!orderDetailState.systemNotification)  {
                    // 如果用户关闭APP推送开关
                    openAppSettings();
                  }
                  SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.acceptInfoOrderDetailClick, {
                    "order_state": orderDetailState.orderDetail?.orderStatusStr?.statusStr
                  });
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text(
                          '开始配送将为您推送配送通知',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CottiColor.textGray,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
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
                  ),
                ),
              ),
            );
          },
        );
      },
    );

  }
}
