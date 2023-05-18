import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/entity/evaluate_config_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/entity/order_comment_entity_entity.dart';

class OrderEvaluateApi {
  static const _orderCommentConfigUrl = "/orderComment/getOrderCommentConfig";
  static const _orderCommentCommentUrl = "/orderComment/submitOrderComment";
  static const _getOrderCommentUrl = "/orderComment/getOrderComment";

  static Future<EvaluateConfigEntity> getOrderCommentConfig({required String orderId}) {
    return CottiNetWork().get(
      _orderCommentConfigUrl,
      queryParameters: {"orderId": orderId},
    ).then((value) => EvaluateConfigEntity.fromJson(value));
  }

  static Future submitOrderComment({required Map<String, dynamic> params}) {
    return CottiNetWork().post(
      _orderCommentCommentUrl,
      data: params,
      showToast: false,
    ).then((value) => value ?? {});
  }

  static Future<OrderCommentEntityEntity> getOrderComment({required String orderId}) {
    return CottiNetWork().get(
      _getOrderCommentUrl,
      queryParameters: {"orderId":orderId},
      showToast: false,
    ).then((value) => OrderCommentEntityEntity.fromJson(value));
  }

}
