import 'dart:async';

import 'package:abitelogin/abitelogin.dart';
import 'package:bloc/bloc.dart';
import 'package:cotti_client/config/env.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/entity/config_entity.dart';
import 'package:cotti_client/pages/tabs/mine/help/api/help_api.dart';
import 'package:cotti_client/pages/tabs/mine/help/entity/last_order_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/routers/web_view_router.dart';
import 'package:cotti_client/utils/scheme_dispatcher.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'help_event.dart';

part 'help_state.dart';

class HelpBloc extends Bloc<HelpEvent, HelpState> {
  HelpBloc() : super(HelpState()) {
    on<OnlineServiceEvent>(_onlineServiceAction);
    on<PhoneCallEvent>(_phoneCallEvent);
  }

  Future<LastOrderEntity> _getOrderDetailModel(OnlineServiceEvent event) async {
    if (event.orderDetailModel == null) {
      logW("event.orderDetailModel = ${event.orderDetailModel}");

      /// 我的页面，需要请求最后的订单数据
      return await HelpApi.getLastOrder();
    } else {
      logW("event.orderDetailModel = ${event.orderDetailModel}");
      OrderDetailModel model = event.orderDetailModel!;

      List<String>? productNames;

      if (model.orderQueryProducts != null) {
        productNames = <String>[];
        for (OrderQueryProduct product in model.orderQueryProducts!) {
          productNames.add(product.productNameShow ?? "");
        }
      }

      String? statusStr;

      switch (model.status) {

        /// 订单状态
        /// CREATED(10, "已新建"),
        /// SUBMITTED(20, "待履约"),
        /// ON_SERVICE(30, "已取货"),
        /// CANCELED(40, "已取消"),
        /// COMPLETE(50, "已完成");
        case 10:
          statusStr = "已新建";
          break;
        case 20:
          statusStr = "待履约";
          break;
        case 30:
          statusStr = "已取货";
          break;
        case 40:
          statusStr = "已取消";
          break;
        case 50:
          statusStr = "已完成";
          break;
        default:
          statusStr = "";
          break;
      }

      return LastOrderEntity()
        ..totalPayableMoney = model.orderQueryFinance?.totalPayableMoney
        ..status = model.status
        ..statusStr = statusStr
        ..orderNo = model.orderNo
        ..productNames = productNames
        ..productQuantity = productNames?.length
        ..createTime = DateTime.parse(model.createTime!).millisecondsSinceEpoch
        ..memberNickName = model.orderQueryExtend?.memberNickName;
    }
  }

  _onlineServiceAction(OnlineServiceEvent event, emit) async {
    LastOrderEntity lastOrder = await _getOrderDetailModel(event);

    /// 拼订单详情网址,orderNo后拼接App用于H5识别来源
    /// http://10.132.20.244:8080/?orderId=251128563479642113App/#/orderdetail
    String orderUrl =
        '${Env.currentEnvConfig.h5 ?? ''}?orderid=${lastOrder.orderNo}App/#/orderdetail';

    // String orderUrl = 'http://10.132.20.244:8080/?orderId=${value.orderNo}App/#/orderdetail';
    orderUrl = Uri.encodeComponent(orderUrl);

    /// 订单金额
    double money = lastOrder.totalPayableMoney ?? 0;
    money = money == 0 ? 0 : money * 100;

    /// 拼接商品名称
    String goodName = "";

    if (lastOrder.productNames != null && lastOrder.productNames!.isNotEmpty) {
      if (lastOrder.productNames!.length == 1) {
        goodName = lastOrder.productNames![0];
      } else {
        for (String element in lastOrder.productNames!) {
          goodName = goodName + element + '；';
        }
      }
    } else {
      goodName = '--';
    }

    /// 拼接客服网址
    ConfigBloc cBloc = GlobalBlocs.get(ConfigBloc.blocName);
    ConfigEntity? configEntity = cBloc.state.configEntity;

    // String sobotUrl =
    //     "https://cotti.soboten.com/chat/h5/v2/index.html?sysnum=7e4943d988834c2f9f48fceb710f553b&channelid=8&title_flag=2&custom_title=COTTI COFFEE 服务中心";
    String sobotUrl = "";
    if (configEntity != null && configEntity.customerServiceOrderUrl != null) {
      sobotUrl = configEntity.customerServiceOrderUrl!;
    } else {
      ToastUtil.show('未获取到相关配置');
      return;
    }

    if (_orderEntityisNotEmpty(lastOrder)) {
      /// 拼接订单信息
      sobotUrl =
          '$sobotUrl&order_status=0&status_custom=${lastOrder.statusStr ?? '--'}&create_time=${lastOrder.createTime ?? '--'}&order_code=${lastOrder.orderNo ?? "--"}&goods_count=${lastOrder.productQuantity ?? '--'}&total_fee=${money.round() == 0 ? '0.00' : money.round()}&goods=[{"name": "$goodName", "pictureUrl": "https://cdn-product-prod.yummy.tech/wechat/cotti/images/mine/u-ic-random-4.png\"}]&order_url=$orderUrl';
    }
    logW('sobotUrl == $sobotUrl');

    if (LoginRouter.navigatorKey.currentContext != null) {
      NavigatorUtils.push(
        LoginRouter.navigatorKey.currentContext!,
        WebViewRouter.webView,
        params: {'url': Uri.encodeFull(sobotUrl), 'isOnlineCustomerServicePage': 'true'},
      );
    }
  }

  _phoneCallEvent(PhoneCallEvent event, emit) {
    SchemeDispatcher.dispatchPath(event.context, 'callphone://cotti?phoneNumber=${event.phoneNum}');
  }

  /// 判断最后的订单信息是否完全为空；
  /// 完全为空时不拼接订单信息
  _orderEntityisNotEmpty(LastOrderEntity lastOrder) {
    if (lastOrder.statusStr != null) {
      return true;
    }
    if (lastOrder.createTime != null) {
      return true;
    }
    if (lastOrder.orderNo != null) {
      return true;
    }
    if (lastOrder.productQuantity != null) {
      return true;
    }
    if (lastOrder.totalPayableMoney != null) {
      return true;
    }
    if (lastOrder.productNames != null) {
      return true;
    }
    return false;
  }
}
