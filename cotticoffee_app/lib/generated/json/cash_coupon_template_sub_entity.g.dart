import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_template_sub_entity.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';


CashCouponTemplateSubEntity $CashCouponTemplateSubEntityFromJson(Map<String, dynamic> json) {
	final CashCouponTemplateSubEntity cashCouponTemplateSubEntity = CashCouponTemplateSubEntity();
	final String? tip = jsonConvert.convert<String>(json['tip']);
	if (tip != null) {
		cashCouponTemplateSubEntity.tip = tip;
	}
	final int? groupNum = jsonConvert.convert<int>(json['groupNum']);
	if (groupNum != null) {
		cashCouponTemplateSubEntity.groupNum = groupNum;
	}
	final List<CashCouponEntity>? cashCouponTemplateSubList = jsonConvert.convertListNotNull<CashCouponEntity>(json['cashCouponTemplateSubList']);
	if (cashCouponTemplateSubList != null) {
		cashCouponTemplateSubEntity.cashCouponTemplateSubList = cashCouponTemplateSubList;
	}
	return cashCouponTemplateSubEntity;
}

Map<String, dynamic> $CashCouponTemplateSubEntityToJson(CashCouponTemplateSubEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['tip'] = entity.tip;
	data['groupNum'] = entity.groupNum;
	data['cashCouponTemplateSubList'] =  entity.cashCouponTemplateSubList?.map((v) => v.toJson()).toList();
	return data;
}