import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/widget/banner/model/ad_sort_entity.dart';
import 'package:cotti_client/widget/banner/banner.dart';


AdSortEntity $AdSortEntityFromJson(Map<String, dynamic> json) {
	final AdSortEntity adSortEntity = AdSortEntity();
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		adSortEntity.code = code;
	}
	final List<BannerModel>? list = jsonConvert.convertListNotNull<BannerModel>(json['list']);
	if (list != null) {
		adSortEntity.list = list;
	}
	return adSortEntity;
}

Map<String, dynamic> $AdSortEntityToJson(AdSortEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['code'] = entity.code;
	data['list'] =  entity.list?.map((v) => v.toJson()).toList();
	return data;
}