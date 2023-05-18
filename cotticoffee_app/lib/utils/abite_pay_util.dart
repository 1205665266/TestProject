import 'dart:async';

import 'package:cotticommon/cotticommon.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:tobias/tobias.dart' as tobias;

/// ////////////////////////////////////////////
/// @Author: Jianzhong Cai
/// @Date: 2022/3/11 上午10:02
/// @Email: jianzhong.cai@ucarinc.com
/// @Description:
/// 因用户非常规操作(如:跳转第三方支付后使用系统返回键关闭等),导致无法获取支付结果
/// 需支付页面监听app的生命周期，即由后台切换至前台时，向服务端查询支付状态
/// 根据不同状态做相应业务处理
/// /////////////////////////////////////////////

enum ABitPayState { succeed, failure, unknown }

class ABiteWeChatPayUtil {
  /// 使用示例
  void example() {
    final ABiteWeChatPayUtil weChatPayUtil = ABiteWeChatPayUtil();
    weChatPayUtil.pay(
      appId: 'appId',
      partnerId: 'partnerId',
      prepayId: 'prepayId',
      packageValue: 'packageValue',
      nonceStr: 'nonceStr',
      timeStamp: int.parse('timeStamp'),
      sign: 'sign',
      resultCallBack: (ABitePayResult aliPayResult) {
        /// 支付结果回调
      },
    );

    /// 需要时可关闭消息订阅
    weChatPayUtil.paySubscriptionClose();
  }

  /// 校验是否安装微信
  static Future<bool> isWeChatInstalled() {
    return fluwx.isWeChatInstalled;
  }

  /// 微信消息订阅
  StreamSubscription? _paySubscription;

  /// 关闭微信消息订阅
  void paySubscriptionClose() => _paySubscription?.cancel();

  ///微信支付
  ///
  ///[appId] 应用ID
  ///[partnerId] 商户号
  ///[prepayId] 预支付交易会话ID
  ///[packageValue] 订单详情扩展字符串
  ///[nonceStr] 随机字符串
  ///[timeStamp] 时间戳
  ///[sign] 签名
  ///[signType] signType
  ///[extData] extData
  ///[resultCallBack] 支付结果回调
  void pay(
      {required String appId,
      required String partnerId,
      required String prepayId,
      required String packageValue,
      required String nonceStr,
      required int timeStamp,
      required String sign,
      String? signType,
      String? extData,
      Function(ABitePayResult result)? resultCallBack}) async {
    bool isWeChatInstalled = await ABiteWeChatPayUtil.isWeChatInstalled();
    if (!isWeChatInstalled) {
      ToastUtil.show('未安装微信');
      resultCallBack?.call(const ABitePayResult(state: ABitPayState.unknown, msg: '未安装微信'));
      return;
    }

    paySubscriptionClose();
    _paySubscription = fluwx.weChatResponseEventHandler.listen((event) {
      paySubscriptionClose();
      if (event is fluwx.WeChatPaymentResponse) {
        if (event.isSuccessful) {
          resultCallBack?.call(const ABitePayResult(state: ABitPayState.succeed, msg: '支付成功'));
        } else {
          resultCallBack?.call(ABitePayResult(
              state: ABitPayState.failure, msg: event.errCode == -1 ? '支付失败' : '取消支付'));
        }
      }
    });

    fluwx.payWithWeChat(
      appId: appId,
      partnerId: partnerId,
      prepayId: prepayId,
      packageValue: packageValue,
      nonceStr: nonceStr,
      timeStamp: timeStamp,
      sign: sign,
      signType: signType,
      extData: extData,
    );
  }
}

class ABiteAliPayUtil {
  /// 使用示例
  void example() async {
    final ABitePayResult aliPayResult = await ABiteAliPayUtil.pay(
      payInfo: 'payInfo',
    );
  }

  /// 校验是否安装支付宝
  static Future<bool> isAliPayInstalled() {
    return tobias.isAliPayInstalled();
  }

  ///支付宝支付
  ///
  ///[payInfo] 支付信息的字符串
  ///[evn] 环境【目前 Android 的 APP 支付开发支持沙箱环境而 iOS 版的 APP 支付开发暂不支持沙箱环境】
  static Future<ABitePayResult> pay(
      {required String payInfo, tobias.AliPayEvn evn = tobias.AliPayEvn.ONLINE}) async {
    var payRes = await tobias.aliPay(payInfo, evn: evn);
    if (payRes['resultStatus'] == 9000 || payRes['resultStatus'] == '9000') {
      return const ABitePayResult(
        state: ABitPayState.succeed,
        msg: '订单支付成功',
      );
    } else {
      String msg = '订单支付失败';
      if (payRes['resultStatus'] == 8000 || payRes['resultStatus'] == '8000') {
        msg = '正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态';
      } else if (payRes['resultStatus'] == 6004 || payRes['resultStatus'] == '6004') {
        msg = '支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态';
      } else if (payRes['resultStatus'] == 6002 || payRes['resultStatus'] == '6002') {
        msg = '网络连接出错';
      } else if (payRes['resultStatus'] == 6001 || payRes['resultStatus'] == '6001') {
        msg = '用户中途取消';
      } else if (payRes['resultStatus'] == 5000 || payRes['resultStatus'] == '5000') {
        msg = '重复请求';
      }
      return ABitePayResult(
        state: ABitPayState.failure,
        msg: msg,
      );
    }
  }
}

class ABitePayResult {
  const ABitePayResult({
    required this.state,
    required this.msg,
  });

  ///是否支付成功
  final ABitPayState state;

  ///处理结果的描述
  final String msg;
}
