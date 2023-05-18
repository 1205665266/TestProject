import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/common/activity/model/activity_results_model.dart';
import 'package:cotti_client/pages/common/activity/model/check_qualification_result_model.dart';

/// FileName: activity_url
///
/// Description:
/// Author: hongtao.li@abite.com
/// Date: 2021/12/20
class ActivityApi {

  /// 通用发券接口 [POST]
  static const String receiveRewardUrl = "/marketing/receiveReward";

  /// 领券资格校验接口 [POST]

  static const String checkQualificationUrl =
      "/marketing/checkQualification";



  static Future<ActivityResultsModel> getReceiveReward(Map<String, dynamic> data) {
    return CottiNetWork().post(
      receiveRewardUrl,
      data: data,
    ).then((value) => ActivityResultsModel.fromJson(value));
  }


  static Future<CheckQualificationResultModel> checkQualification(Map<String, dynamic> data) {
    return CottiNetWork().post(
      receiveRewardUrl,
      data: data,
    ).then((value) => CheckQualificationResultModel.fromJson(value));
  }
}
