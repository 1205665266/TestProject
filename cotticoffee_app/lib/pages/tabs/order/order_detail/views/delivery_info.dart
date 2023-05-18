import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_state.dart';
import 'package:cotti_client/widget/common_box.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/arrive_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'order_info_item.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/20 9:13 PM
class DeliveryInfo extends StatelessWidget {
  const DeliveryInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailBloc, OrderDetailState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: CommonBox(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 16.h),
              child: Column(
                children: [
                  OrderInfoItem('收货详情', _getAddress(state.orderDetail!), subTitleFontSize: 13.sp),
                  if (state.orderDetail?.expectTakeBeginTime != null
                      && (state.orderDetail?.expectTakeBeginTime?.isNotEmpty ?? false)
                      && state.orderDetail?.status != 40)
                    OrderInfoItem(
                      '预计送达',
                      state.orderDetail?.expectTakeBeginTime,
                      rightIcon: _buildCompensate(),
                    ),
                  if (_expressUserName(state.orderDetail!) != null
                      && _expressUserPhone(state.orderDetail!) != null
                      && state.orderDetail?.hiddenExpressPhone == 0)
                    OrderInfoItem(
                      '联系骑手',
                      _expressUserName(state.orderDetail!),
                      rightIcon: Icon(
                        IconFont.icon_lianxidianhua,
                        color: CottiColor.textGray,
                        size: 16.w,
                      ),
                      clickRight: () => launch("tel:${_expressUserPhone(state.orderDetail!)}"),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _buildCompensate() {
    return BlocBuilder<ConfigBloc, ConfigState>(
      builder: (context, state) {
        return Visibility(
          visible: state.configEntity?.arriveOnTime?.isNotEmpty ?? false,
          child: Container(
            margin: EdgeInsets.only(left: 3.w),
            child: ArriveTime(
              leftIconSize: 11.sp,
              fontWeight: FontWeight.w500,
              configEntity: state.configEntity,
            ),
          ),
        );
      },
    );
  }

  _getAddress(OrderDetailModel orderDetail) {
    var takeHumName = orderDetail.orderQueryExtend?.takeHumName;
    if (orderDetail.orderQueryExtend?.takeHumSex == 1) {
      takeHumName = "$takeHumName先生";
    }
    if (orderDetail.orderQueryExtend?.takeHumSex == 2) {
      takeHumName = "$takeHumName女士";
    }
    String takePhone = orderDetail.orderQueryExtend?.takeHumPhone ?? '';
    if (takePhone.isNotEmpty) {
      takeHumName = '$takeHumName | ${StringUtil.mobilePhoneEncode(takePhone)}';
    }
    return "$takeHumName\n${orderDetail.orderQueryExtend?.takeAddress}";
  }

  _expressUserName(OrderDetailModel orderDetail) {
    if (orderDetail.expressMode == 1) {
      return orderDetail.orderExpress?.expressUserName;
    } else {
      return '商家自配送';
    }
  }

  _expressUserPhone(OrderDetailModel orderDetail) {
    if (orderDetail.expressMode == 1) {
      return orderDetail.orderExpress?.expressUserPhone;
    } else {
      return orderDetail.orderQueryExtend?.shopPhone;
    }
  }
}
