import 'package:cotti_client/generated/json/ad_sort_entity.g.dart';
import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/widget/banner/banner.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/31 19:01
@JsonSerializable()
class AdSortEntity {
  String? code;
  List<BannerModel>? list;

  AdSortEntity();

  factory AdSortEntity.fromJson(Map<String, dynamic> json) => $AdSortEntityFromJson(json);
}
