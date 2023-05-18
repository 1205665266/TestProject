import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/vocher_template_info_entity.dart';

VocherTemplateInfoEntity $VocherTemplateInfoEntityFromJson(Map<String, dynamic> json) {
	final VocherTemplateInfoEntity vocherTemplateInfoEntity = VocherTemplateInfoEntity();
	final String? templateTypeNo = jsonConvert.convert<String>(json['templateTypeNo']);
	if (templateTypeNo != null) {
		vocherTemplateInfoEntity.templateTypeNo = templateTypeNo;
	}
	final String? no = jsonConvert.convert<String>(json['no']);
	if (no != null) {
		vocherTemplateInfoEntity.no = no;
	}
	final int? voucherType = jsonConvert.convert<int>(json['voucherType']);
	if (voucherType != null) {
		vocherTemplateInfoEntity.voucherType = voucherType;
	}
	final String? useType = jsonConvert.convert<String>(json['useType']);
	if (useType != null) {
		vocherTemplateInfoEntity.useType = useType;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		vocherTemplateInfoEntity.title = title;
	}
	final String? voucherDesc = jsonConvert.convert<String>(json['voucherDesc']);
	if (voucherDesc != null) {
		vocherTemplateInfoEntity.voucherDesc = voucherDesc;
	}
	final String? voucherName = jsonConvert.convert<String>(json['voucherName']);
	if (voucherName != null) {
		vocherTemplateInfoEntity.voucherName = voucherName;
	}
	final String? voucherSubtitle = jsonConvert.convert<String>(json['voucherSubtitle']);
	if (voucherSubtitle != null) {
		vocherTemplateInfoEntity.voucherSubtitle = voucherSubtitle;
	}
	final String? voucherImage = jsonConvert.convert<String>(json['voucherImage']);
	if (voucherImage != null) {
		vocherTemplateInfoEntity.voucherImage = voucherImage;
	}
	return vocherTemplateInfoEntity;
}

Map<String, dynamic> $VocherTemplateInfoEntityToJson(VocherTemplateInfoEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['templateTypeNo'] = entity.templateTypeNo;
	data['no'] = entity.no;
	data['voucherType'] = entity.voucherType;
	data['useType'] = entity.useType;
	data['title'] = entity.title;
	data['voucherDesc'] = entity.voucherDesc;
	data['voucherName'] = entity.voucherName;
	data['voucherSubtitle'] = entity.voucherSubtitle;
	data['voucherImage'] = entity.voucherImage;
	return data;
}