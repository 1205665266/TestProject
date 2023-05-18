import 'package:cotti_client/network/cotti_net_work.dart';

class RedApi {
  static const _sharingShare = '/wechat/activity/sharing/share';

  static Future sharingShare(String orderId, String activityNo) {
    return CottiNetWork().post(
      _sharingShare,
      showToast: false,
      data: {'orderId': orderId, 'activityNo': activityNo},
    );
  }
}
