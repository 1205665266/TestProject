import 'dart:async';

import 'package:cotti_client/network/cotti_net_work.dart';

class ShareApi {
  static const _addShareRecord = '/wechat/activity/sharing/addShareRecord';

  static Future addShareRecord(String orderId, String activityNo) async {
    await CottiNetWork()
        .post(_addShareRecord, data: {'orderId': orderId, 'activityNo': activityNo})
        .then((value) {})
        .catchError((onError) {});
  }
}
