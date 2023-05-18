import 'package:cotti_client/generated/json/base/json_field.dart';

import 'dart:convert';

import 'package:cotti_client/generated/json/voucher_sku_model_entity.g.dart';

@JsonSerializable()
class VoucherSkuModelEntity {

	/// 商品编码
	String? itemNo;
	/// 商品ID
	int? itemId;
	/// 商品规格ID
	int? skuId;
	/// 商品规格编号
	String? skuNo;
	/// 商品规格编号
	String? skuName;
	/// C端sku展示名称
	String? skuShowName;
	/// 商品名称
	String? title;
	/// 图片
	String? image;
	/// 商品面价（标准价）
	String? facePrice;
	/// since APP 105 优惠券减免金额
	double? couponDiscountMoney;
	/// since APP 105 代金券券减免金额
	double? voucherDiscountMoney;
	/// 商品划线价（折后价）
	String? lineThroughPrice;
	/// 特价商品价格（不为空时，该商品是特价）
	String? specialPrice;
	/// 特价商品可用活动库存
	int? specialAvaNum;
	/// 购买数量
	int? buyNum;
	/// 商品分类
	String? categoryCode;
	/// 优惠类型
	String? preferenceType;
	/// 优惠类型描述
	String? preferenceTypeDesc;
	/// since APP105 代金券编码
	String? voucherNo;
	/// since APP105 代金券名称
	String? voucherName;
	/// since APP 105 sku是否选择不用代金券券（true-不用券；false-用券）
	bool? chooseNotUseCashCoupon;

	double? saleUnitPrice;
	double? baseUnitPrice;

	@JSONField(name:"itemNo",serialize: false)
	String? spuCode;

	/// 标记是否需要显示到sku列表，
	/// 在优惠券列表点击调整代金券时用于筛选sku；
	bool show = true;

	VoucherSkuModelEntity();

  factory VoucherSkuModelEntity.fromJson(Map<String, dynamic> json) => $VoucherSkuModelEntityFromJson(json);

	Map<String, dynamic> toMap(){
		Map<String, dynamic> map = toJson();

		map["spuCode"] = spuCode;
		if(saleUnitPrice == null){
			map["saleUnitPrice"] = lineThroughPrice;
		}
		if(baseUnitPrice == null){
			map["baseUnitPrice"] = facePrice;
		}
		map["cagetoryCode"] = categoryCode;
		map["purchaseNums"] = buyNum;

		return map;
	}

  Map<String, dynamic> toJson() => $VoucherSkuModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

	VoucherSkuModelEntity copy() {
		return VoucherSkuModelEntity.fromJson(toJson());
	}
}