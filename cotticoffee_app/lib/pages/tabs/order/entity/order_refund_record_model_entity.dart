import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_refund_record_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class OrderRefundRecordModelEntity {

	dynamic orderId;
	dynamic orderNo;
	dynamic memberId;
	String? refundNo;
	String? refundTime;
	double? refundTotal;
	List<OrderRefundRecordModelOrderQueryProductDTOList>? orderQueryProductDTOList;
  
  OrderRefundRecordModelEntity();

  factory OrderRefundRecordModelEntity.fromJson(Map<String, dynamic> json) => $OrderRefundRecordModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderRefundRecordModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderRefundRecordModelOrderQueryProductDTOList {

	dynamic id;
	dynamic orderId;
	dynamic memberId;
	dynamic shopId;
	String? skuCode;
	String? skuName;
	String? skuNameShow;
	dynamic productId;
	dynamic productType;
	dynamic productCode;
	String? productName;
	String? productNameShow;
	dynamic quantity;
	dynamic oneCategoryId;
	dynamic twoCategoryId;
	dynamic threeCategoryId;
	dynamic originPrice;
	dynamic payableMoney;
	dynamic payMoney;
	double? refundMoney;
	dynamic mayRefundMoney;
	dynamic refundStatus;
	dynamic returnFoodStatus;
	dynamic productIncome;
	dynamic taxClassification;
	dynamic taxClassificationId;
	dynamic createTime;
	dynamic modifyTime;
	dynamic orderCreateTime;
	dynamic oldModifyTime;
	dynamic priceDiscountMoney;
	dynamic afterDiscountMoney;
	dynamic packageDiscountMoney;
	dynamic couponDiscountMoney;
	dynamic voucherDiscountMoney;
	dynamic activityDiscountMoney;
	dynamic channelDiscountMoney;
	dynamic otherDiscountMoney;
	dynamic totalDiscountMoney;
	dynamic dealMoney;
	dynamic boxCount;
	dynamic boxPrice;
	dynamic boxMoney;
	dynamic boxPayableMoney;
	dynamic boxPayMoney;
	dynamic boxIncome;
	dynamic mayInvoiceMoney;
	dynamic invoicedMoney;
	dynamic thirdDiscountMoney;
	dynamic couponRecordNo;
	dynamic pocketIndex;
	dynamic packageOrNot;
	dynamic orderPackageId;
	dynamic packageFloor;
	dynamic refundNo;
	dynamic refundTime;
	String? productImgUrl;
	dynamic skuTagCode;
	dynamic skuTagName;
	dynamic thirdProductCode;
	dynamic thirdSkuId;
	dynamic couponIncome;
	dynamic mergeType;
	String? skuProps;
  
  OrderRefundRecordModelOrderQueryProductDTOList();

  factory OrderRefundRecordModelOrderQueryProductDTOList.fromJson(Map<String, dynamic> json) => $OrderRefundRecordModelOrderQueryProductDTOListFromJson(json);

  Map<String, dynamic> toJson() => $OrderRefundRecordModelOrderQueryProductDTOListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}