import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';

import '../pages/common/city/entity/city_list_data_entity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/26 09:13
class Constant {
  ///当前版本号
  static int currVersionCode = 114;

  static bool get hasLogin =>
      GlobalBlocs.get<UserBloc>(UserBloc.blocName).state.status == UserStatus.loggedIn;

  static int? get memberId =>
      GlobalBlocs.get<UserBloc>(UserBloc.blocName).state.userModel?.memberId;

  /// 堂食
  static const int eatInModeCode = 0;

  /// 外带
  static const int toGoModeCode = 1;

  ///外卖code
  static const int takeOutModeCode = 2;

  ///自提code
  static const int selfTakeModeCode = 100;

  /// 小程序 username
  static const String miniProgramUserName = 'gh_e0f5951e0d87';

  ///高德地图android key
  static const String androidMapKey = '745f9ee561f56bed47120fb871fb636a';

  ///高德地图iOS key
  static const String iosMapKey = '33529a4ede1e5d887e33233e4dd3d252';

  static const String wxAppID = "wxf58b402156f69237";

  ///选择的城市
  static CityListDataData cityDataEntity = CityListDataData();

  ///记录自动展开过的待开业门店
  static List<int> toBeOpenShopCodes = [];
}
