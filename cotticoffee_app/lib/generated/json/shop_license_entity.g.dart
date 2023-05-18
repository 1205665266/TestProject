import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/setting/entity/shop_license_entity.dart';

ShopLicenseList $ShopLicenseListFromJson(Map<String, dynamic> json) {
	final ShopLicenseList shopLicenseList = ShopLicenseList();
	final int? total = jsonConvert.convert<int>(json['total']);
	if (total != null) {
		shopLicenseList.total = total;
	}
	final List<ShopLicenseEntity>? list = jsonConvert.convertListNotNull<ShopLicenseEntity>(json['list']);
	if (list != null) {
		shopLicenseList.list = list;
	}
	return shopLicenseList;
}

Map<String, dynamic> $ShopLicenseListToJson(ShopLicenseList entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['total'] = entity.total;
	data['list'] =  entity.list?.map((v) => v.toJson()).toList();
	return data;
}

ShopLicenseEntity $ShopLicenseEntityFromJson(Map<String, dynamic> json) {
	final ShopLicenseEntity shopLicenseEntity = ShopLicenseEntity();
	final int? shopMdCode = jsonConvert.convert<int>(json['shopMdCode']);
	if (shopMdCode != null) {
		shopLicenseEntity.shopMdCode = shopMdCode;
	}
	final String? shopName = jsonConvert.convert<String>(json['shopName']);
	if (shopName != null) {
		shopLicenseEntity.shopName = shopName;
	}
	final dynamic cityMdCode = jsonConvert.convert<dynamic>(json['cityMdCode']);
	if (cityMdCode != null) {
		shopLicenseEntity.cityMdCode = cityMdCode;
	}
	final dynamic cityMdName = jsonConvert.convert<dynamic>(json['cityMdName']);
	if (cityMdName != null) {
		shopLicenseEntity.cityMdName = cityMdName;
	}
	final dynamic address = jsonConvert.convert<dynamic>(json['address']);
	if (address != null) {
		shopLicenseEntity.address = address;
	}
	final List<String>? images = jsonConvert.convertListNotNull<String>(json['images']);
	if (images != null) {
		shopLicenseEntity.images = images;
	}
	return shopLicenseEntity;
}

Map<String, dynamic> $ShopLicenseEntityToJson(ShopLicenseEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['shopMdCode'] = entity.shopMdCode;
	data['shopName'] = entity.shopName;
	data['cityMdCode'] = entity.cityMdCode;
	data['cityMdName'] = entity.cityMdName;
	data['address'] = entity.address;
	data['images'] =  entity.images;
	return data;
}