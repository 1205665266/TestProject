

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/tab_page.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/widget/dialog/common_dialog.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

mixin OrderExceptionDialog {



  /// 显示门店休息弹窗
  showShopRest(BuildContext context, int currentTakeMode, OrderConfirmBloc bloc) {

    // 外卖
    if(currentTakeMode == Constant.takeOutModeCode) {
      CommonDialog.show(
          context,
          content: '当前门店休息中，暂不支持下单',
          mainButtonName: "更换收货地址",
          subButtonName: "选择门店自提"
      ).then((value) {
        if(value == 0) {
          logI('跳转选择门店自提');
          NavigatorUtils.push(context, CommonPageRouter.storeListPage, params: {"isFromConfirm": true});
        } else if(value == 1){
          logI('跳转更换收货地址');
          NavigatorUtils.push(context, CommonPageRouter.takeAddressListPage,params: {"isSelectTakeAddress": true}).then((value) {
            if (value != null) {
              bloc.add(OrderConfirmChangeAddressEvent(value));
            }
          });
        }});
      SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.orderConfirmDeliveryCloseBrownEvent, {});
    } else {
      CommonDialog.show(
          context,
          content: '当前门店休息中，暂不支持下单',
          mainButtonName: "更换门店自提",
          subButtonName: "选择收货地址"
      ).then((value) {
        if(value == 1) {
          logI('跳转选择门店自提');
          NavigatorUtils.push(context, CommonPageRouter.storeListPage, params: {"isFromConfirm": true});
        } else if(value == 0){
          logI('跳转更换收货地址');
          NavigatorUtils.push(context, CommonPageRouter.takeAddressListPage, params: {"isSelectTakeAddress": true}).then((value) {
            if (value != null) {
              bloc.add(OrderConfirmChangeAddressEvent(value));
            }
          });
        }});
    }

  }


  /// 显示当前门店不支持外卖配送弹窗提示
  showShopNotSupportTakeOut(BuildContext context, OrderConfirmBloc bloc) {
    CommonDialog.show(
        context,
        content: '当前门店暂不支持外卖配送',
        mainButtonName: "选择自提门店",
        subButtonName: "更换收货地址"
    ).then((value) {
      if(value == 1) {
        logI('跳转选择门店自提');
        NavigatorUtils.push(context, CommonPageRouter.storeListPage, params: {"isFromConfirm": true});
      } else if(value == 0){
        logI('跳转更换收货地址');
        NavigatorUtils.push(context, CommonPageRouter.takeAddressListPage, params: {"isSelectTakeAddress": true}).then((value) {
          if (value != null) {
            bloc.add(OrderConfirmChangeAddressEvent(value));
          }
        });
      }});
  }


  /// 显示门店暂不支持自提 弹窗提示
  showShopNotSupportSelfTake(BuildContext context, OrderConfirmBloc bloc) {
    CommonDialog.show(
        context,
        content: '当前门店暂不支持自提订单',
        mainButtonName: "更换门店自提",
        subButtonName: "选择收货地址"
    ).then((value) {
      if(value == 1) {
        logI('跳转选择门店自提');
        NavigatorUtils.push(context, CommonPageRouter.storeListPage, params: {"isFromConfirm": true});
      } else if(value == 0){
        logI('跳转更换收货地址');
        NavigatorUtils.push(context, CommonPageRouter.takeAddressListPage, params: {"isSelectTakeAddress": true}).then((value) {
          if (value != null) {
            bloc.add(OrderConfirmChangeAddressEvent(value));
          }
        });
      }});
  }

  /// 显示多笔订单未支付 弹窗提示
  showShopMultiOrderUnPay(BuildContext context, String msg) {
    CommonDialog.show(
        context,
        content: msg,
        mainButtonName: "查看订单",
        subButtonName: "取消"
    ).then((value) {
      if(value == 1) {
        GlobalBlocs.get(GlobalBloc.blocName).add(SwitchTabEvent(TabEnum.order.index));
        NavigatorUtils.pop(context);

        SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.orderConfirmWaitPayDialogGotoClickEvent, {});
      } else {
        SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.orderConfirmWaitPayDialogCancelClickEvent, {});
      }
    });

    SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.orderConfirmWaitPayDialogBrowseEvent, {});


  }
}