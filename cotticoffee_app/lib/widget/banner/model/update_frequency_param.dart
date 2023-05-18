import 'banner_param.dart';

/// FileName: update_frequency_param
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/9
class UpdateFrequencyParam extends BannerParam {
  String? positionCode;

  UpdateFrequencyParam(this.positionCode, String? code) : super(code);

  Map<String, dynamic> toUpdateFrequencyJson(BannerParam bannerParam) => {
        "positionCode": positionCode,
        "code": bannerParam.code,
        "did": bannerParam.did,
        "sessionId": bannerParam.sessionId,
        "longitude": bannerParam.longitude,
        "latitude": bannerParam.latitude,
        "viewPage": bannerParam.viewPage,
        "brandMdCode": bannerParam.brandMdCode,
        "cityMdCode": bannerParam.cityMdCode,
        "memberId": bannerParam.memberId,
      };
}
