import 'package:cotti_client/service/location/position_info_entity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/26 19:00
class LocationResult {
  /// 12 代表没有定位权限 0代表定位成功 ,other 高德一些错误码
  int errorCode;
  String? errMessage;
  PositionInfoEntity? positionInfoEntity;

  LocationResult(this.errorCode, {this.errMessage, this.positionInfoEntity});
}
