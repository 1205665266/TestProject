/// FileName: banner_param
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/8
class BannerParam {
  ///广告位模板编码
  final String? code;

  ///会员id
  int? memberId;

  ///设备唯一id
  String? did;

  ///会话id, 程序从启动到结束退出期间会话id不变
  String? sessionId;

  ///经度
  String? longitude;

  ///纬度
  String? latitude;

  ///展示页面 index 首页 menu 点餐页 orderList 订单列表页 my 我的 paySuccessful dingdan订单详情页（支付成功）
  String? viewPage;

  ///品牌主数据编码
  num? brandMdCode;

  ///城市主数据编码
  int? cityMdCode;

  /// 门店主数据编码
  int? shopMdCode;

  ///是否缓存，默认缓存
  bool isNoCache;

  ///登录状态改变后是否重试，默认不重新刷新数据
  bool isLoginRetry;

  BannerParam(
    this.code, {
    this.memberId,
    this.did,
    this.sessionId,
    this.longitude,
    this.latitude,
    this.viewPage,
    this.brandMdCode,
    this.cityMdCode,
    this.shopMdCode,
    this.isNoCache = false,
    this.isLoginRetry = false,
  });

  Map<String, dynamic> toJson() => {
        "code": code,
        "did": did,
        "memberId": memberId,
        "sessionId": sessionId,
        "longitude": longitude,
        "latitude": latitude,
        "viewPage": viewPage,
        "brandMdCode": brandMdCode,
        "cityMdCode": cityMdCode,
        'shopMdCode': shopMdCode,
      };

}
