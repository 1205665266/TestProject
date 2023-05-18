import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_template_entity.dart';

CashCouponTemplateEntity $CashCouponTemplateEntityFromJson(Map<String, dynamic> json) {
	final CashCouponTemplateEntity cashCouponTemplateEntity = CashCouponTemplateEntity();
	final int? recentlyExpiredCount = jsonConvert.convert<int>(json['recentlyExpiredCount']);
	if (recentlyExpiredCount != null) {
		cashCouponTemplateEntity.recentlyExpiredCount = recentlyExpiredCount;
	}
	final List<VoucherTemplateInfo>? voucherTemplateInfoList = jsonConvert.convertListNotNull<VoucherTemplateInfo>(json['voucherTemplateInfoList']);
	if (voucherTemplateInfoList != null) {
		cashCouponTemplateEntity.voucherTemplateInfoList = voucherTemplateInfoList;
	}
	return cashCouponTemplateEntity;
}

Map<String, dynamic> $CashCouponTemplateEntityToJson(CashCouponTemplateEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['recentlyExpiredCount'] = entity.recentlyExpiredCount;
	data['voucherTemplateInfoList'] =  entity.voucherTemplateInfoList?.map((v) => v.toJson()).toList();
	return data;
}

VoucherTemplateInfo $VoucherTemplateInfoFromJson(Map<String, dynamic> json) {
	final VoucherTemplateInfo voucherTemplateInfo = VoucherTemplateInfo();
	final String? templateTypeNo = jsonConvert.convert<String>(json['templateTypeNo']);
	if (templateTypeNo != null) {
		voucherTemplateInfo.templateTypeNo = templateTypeNo;
	}
	final String? templateTypeName = jsonConvert.convert<String>(json['templateTypeName']);
	if (templateTypeName != null) {
		voucherTemplateInfo.templateTypeName = templateTypeName;
	}
	final double? value = jsonConvert.convert<double>(json['value']);
	if (value != null) {
		voucherTemplateInfo.value = value;
	}
	final String? strValue = jsonConvert.convert<String>(json['strValue']);
	if (strValue != null) {
		voucherTemplateInfo.strValue = strValue;
	}
	final int? nums = jsonConvert.convert<int>(json['nums']);
	if (nums != null) {
		voucherTemplateInfo.nums = nums;
	}
	final String? pictureUrl = jsonConvert.convert<String>(json['pictureUrl']);
	if (pictureUrl != null) {
		voucherTemplateInfo.pictureUrl = pictureUrl;
	}
	final String? recentlyExpiredDateDesc = jsonConvert.convert<String>(json['recentlyExpiredDateDesc']);
	if (recentlyExpiredDateDesc != null) {
		voucherTemplateInfo.recentlyExpiredDateDesc = recentlyExpiredDateDesc;
	}
	final String? recentlyExpiredDate = jsonConvert.convert<String>(json['recentlyExpiredDate']);
	if (recentlyExpiredDate != null) {
		voucherTemplateInfo.recentlyExpiredDate = recentlyExpiredDate;
	}
	final bool? specialDisplay = jsonConvert.convert<bool>(json['specialDisplay']);
	if (specialDisplay != null) {
		voucherTemplateInfo.specialDisplay = specialDisplay;
	}
	return voucherTemplateInfo;
}

Map<String, dynamic> $VoucherTemplateInfoToJson(VoucherTemplateInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['templateTypeNo'] = entity.templateTypeNo;
	data['templateTypeName'] = entity.templateTypeName;
	data['value'] = entity.value;
	data['strValue'] = entity.strValue;
	data['nums'] = entity.nums;
	data['pictureUrl'] = entity.pictureUrl;
	data['recentlyExpiredDateDesc'] = entity.recentlyExpiredDateDesc;
	data['recentlyExpiredDate'] = entity.recentlyExpiredDate;
	data['specialDisplay'] = entity.specialDisplay;
	return data;
}