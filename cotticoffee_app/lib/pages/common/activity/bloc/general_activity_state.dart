
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/widget/banner/widget/abite_banner.dart';

class GeneralActivityState {
  ///是否显示广告弹窗
  late bool showPopUps;

  /// 广告位活动id
  late String activityId;

  ///领取资格
  late int checkQualificationStatus;

  /// 发券结果
  late int receiveRewardStatus;

  late bool isShowNewMember;
  late bool isLogin;
  late BannerController floatBannerController;
  late BannerController popBannerController;
  GeneralActivityState init() {
    return GeneralActivityState()
      ..showPopUps = true
      ..activityId = ''
      ..checkQualificationStatus = 0
      ..receiveRewardStatus = 0
      ..isShowNewMember = !Constant.hasLogin
      ..isLogin = Constant.hasLogin
      ..floatBannerController = BannerController()
      ..popBannerController = BannerController();
  }

  GeneralActivityState clone() {
    return GeneralActivityState()
      ..showPopUps = showPopUps
      ..activityId = activityId
      ..checkQualificationStatus = checkQualificationStatus
      ..receiveRewardStatus = receiveRewardStatus
      ..isShowNewMember = isShowNewMember
      ..isLogin = isLogin
      ..floatBannerController = floatBannerController
      ..popBannerController = popBannerController;
  }
}
