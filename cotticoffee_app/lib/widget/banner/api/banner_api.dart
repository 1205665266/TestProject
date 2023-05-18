import 'dart:async';
import 'dart:convert' as convert;

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/service/push/jpush_wrapper.dart';
import 'package:cotti_client/widget/banner/model/ad_sort_entity.dart';
import 'package:cotti_client/widget/banner/model/banner_model.dart';
import 'package:cotticommon/cotticommon.dart';

import '../model/banner_param.dart';
import '../model/update_frequency_param.dart';

/// FileName: banner_api
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/10
class BannerApi {
  static const _bannerList = '/customer/position/list';
  static const _adSortList = '/customer/position/adSortList';
  static const _updateFrequency = '/customer/position/updateFrequency';
  static final String _sid = "${DateTime.now().microsecondsSinceEpoch}";

  static Future<List<BannerModel>> getBannerList(BannerParam bannerParam) {
    bannerParam.sessionId = _sid;
    bannerParam.did = SpUtil.getString(JPushWrapper.keyRegistrationID);
    bannerParam.memberId = Constant.memberId;
    return CottiNetWork()
        .get(_bannerList, queryParameters: bannerParam.toJson(), showToast: false)
        .then((value) {
      List listObj = value ?? [];
      if (bannerParam.code != null && !bannerParam.isNoCache) {
        SpUtil.putString(bannerParam.code!, convert.jsonEncode(listObj));
      }
      return listObj.map((e) {
        BannerModel model = BannerModel.fromJson(e);
        model.param = bannerParam.toJson();
        return model;
      }).toList();
    }).catchError((onError) {
      if (bannerParam.code != null) {
        String catchData = SpUtil.getString(bannerParam.code!, defValue: '[]');
        List catchList = convert.jsonDecode(catchData);
        return catchList.map((e) => BannerModel.fromJson(e)).toList();
      }
    });
  }

  static Future<List<AdSortEntity>> getBannerSortList(BannerParam bannerParam) {
    return CottiNetWork()
        .get(_adSortList, queryParameters: bannerParam.toJson(), showToast: false)
        .then((value) {
      List listObj = value ?? [];
      if (bannerParam.code != null && !bannerParam.isNoCache) {
        SpUtil.putString(bannerParam.code!, convert.jsonEncode(listObj));
      }
      return listObj.map((e) => AdSortEntity.fromJson(e)).toList();
    }).catchError((onError) {
      if (bannerParam.code != null) {
        String catchData = SpUtil.getString(bannerParam.code!, defValue: '[]');
        List catchList = convert.jsonDecode(catchData);
        return catchList.map((e) => AdSortEntity.fromJson(e)).toList();
      }
    });
  }

  static Future updateFrequency(
      UpdateFrequencyParam updateFrequencyParam, BannerParam bannerParam) {
    bannerParam.sessionId = _sid;
    bannerParam.did = SpUtil.getString(JPushWrapper.keyRegistrationID);
    bannerParam.memberId = Constant.memberId;
    return CottiNetWork().post(
      _updateFrequency,
      showToast: false,
      data: updateFrequencyParam.toUpdateFrequencyJson(bannerParam),
    );
  }
}
