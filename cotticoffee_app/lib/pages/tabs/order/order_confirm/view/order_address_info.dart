import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/divider_line.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/widget/arrive_time.dart';
import 'package:cotti_client/widget/common_box.dart';
import 'package:cotticommon/router/fluro_navigator.dart';
import 'package:flutter/material.dart';

import 'package:cotti_client/global/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class OrderAddressInfo extends StatefulWidget {
  const OrderAddressInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderAddressInfoState();
}

class _OrderAddressInfoState extends State<OrderAddressInfo> {
  OrderConfirmBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<OrderConfirmBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAddressInfo();
  }

  _buildAddressInfo() {
    return BlocConsumer<ShopMatchBloc, ShopMatchState>(
      listener: (context, state) {
        // 如果全局已选择地址被删除，则清空确认订单页面的地址
        if (state.address == null) {
          _bloc?.add(OrderConfirmChangeAddressEvent(null));
        }
      },
      builder: (context, shopMatchState) {
        return BlocBuilder<OrderConfirmBloc, OrderConfirmState>(
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 16.h),
              margin: EdgeInsets.only(left: 16.w, right: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(4.r),bottomLeft: Radius.circular(4.r),),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _contentList(state),
              ),
            );
          },
        );
      },
    );
  }

  _contentList(OrderConfirmState state) {
    List<Widget> list = [];
    list.add(_buildAddressTitle());

    if(state.address != null
        && state.orderConfirmModelEntity?.estimateTip != null
        && state.orderConfirmModelEntity?.estimateTime != null
        && state.orderConfirmModelEntity?.dispatchTime != null) {

      list.add(const DividerLine());
      list.add(SizedBox(
        height: 11.h,
      ),);
      list.add(_buildMakeAndDispatchTimeTView());
    }
    return list;
  }
  _buildAddressTitle() {
    return GestureDetector(
        onTap: () {
          NavigatorUtils.push(
              context, CommonPageRouter.takeAddressListPage,
              params: {"isSelectTakeAddress": true}).then((value) {
            if (value != null) {
              _bloc?.add(OrderConfirmChangeAddressEvent(value));
            }
          });

          // 埋点
          SensorsAnalyticsFlutterPlugin.track(
              OrderSensorsConstant.orderConfirmAddressSwitch, {});
        },
        child: _buildAddressNameOrHintView()
    );
  }

  _buildAddressNameOrHintView() {
    return BlocBuilder<OrderConfirmBloc, OrderConfirmState>(
      builder: (context, state) {
        if(state.address != null) {
          return SizedBox(
              height: 80.h,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: state.address?.labelName?.isNotEmpty ?? false,
                          child: Text(
                              "${state.address?.labelName}-",
                              style: TextStyle(
                                  color: CottiColor.textBlack,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  height: 1
                              )
                          ),
                        ),
                        Flexible(
                          child: Text(
                              "${state.address?.location ?? ""}${state.address?.address ?? ""}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: CottiColor.textBlack,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DDP5',
                                  height: 1
                              )),
                        ),
                        SvgPicture.asset(
                          "assets/images/icon_more.svg",
                          width: 14.w,
                          height: 18.h,
                          color: CottiColor.textBlack,
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 9.h,
                    ),
                    Text(
                        "${state.address?.contact ?? ""} ${_getEncodePhone(
                            state.address?.contactPhone ?? "")}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: CottiColor.textGray,
                            fontSize: 12.sp,
                            height: 1.4
                        ))
                  ],
                ),
              )
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Row(
              children: [
                Text(
                    "请选择收货地址",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: CottiColor.textBlack,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DDP5',
                    )),
                SvgPicture.asset(
                  "assets/images/icon_more.svg",
                  width: 14.w,
                  height: 18.h,
                  color: CottiColor.textBlack,
                )
              ],
            ),
          );
        }

      },
    );
  }

  _getEncodePhone(String phone) {
    if (phone.isNotEmpty) {
      return phone.substring(0, 3) + '****' + phone.substring(7);
    }
    return "";
  }

  _buildMakeAndDispatchTimeTView() {
    return BlocBuilder<OrderConfirmBloc, OrderConfirmState>(builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildMakeAndDispatchTimeTip(state.orderConfirmModelEntity),
          ),
          Container(
            margin: EdgeInsets.only(top: 2.h),
            child: ArriveTime(
              tipsTextSize: 13.sp,
              fontWeight: FontWeight.bold,
              configEntity: context
                  .read<ConfigBloc>()
                  .state
                  .configEntity,
            ),
          )
        ],
      );
    });
  }

  _buildMakeAndDispatchTimeTip(OrderConfirmModelEntity? modelEntity) {
    var estimateTip = modelEntity?.estimateTip ?? "";
    var estimateTime = modelEntity?.estimateTime ?? "";
    var dispatchTime = modelEntity?.dispatchTime ?? "";
    if (estimateTip.isEmpty || estimateTime.isEmpty || dispatchTime.isEmpty) {
      return Container();
    }
    var split = estimateTip.split("X");
    return Text.rich(TextSpan(children: [
      TextSpan(
        text: split[0],
        style: TextStyle(
          fontSize: 12.sp,
          color: CottiColor.textBlack,
          fontFamily: 'DDP4',
        ),
      ),
      TextSpan(
        text: " $estimateTime ",
        style: TextStyle(
          fontSize: 20.sp,
          color: CottiColor.primeColor,
          fontFamily: 'DDP6',
        ),
      ),
      TextSpan(
        text: split[1],
        style: TextStyle(
          fontSize: 12.sp,
          color: CottiColor.textBlack,
          fontFamily: 'DDP4',
        ),
      ),
      TextSpan(
        text: " $dispatchTime ",
        style: TextStyle(
          fontSize: 20.sp,
          color: CottiColor.primeColor,
          fontFamily: 'DDP6',
        ),
      ),
      TextSpan(
        text: split[2],
        style: TextStyle(
          fontSize: 12.sp,
          color: CottiColor.textBlack,
          fontFamily: 'DDP4',
        ),
      )
    ]));
  }
}
