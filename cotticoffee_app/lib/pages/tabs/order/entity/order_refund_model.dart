
import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_refund_model.g.dart';

@JsonSerializable()
class OrderRefundModel {

	OrderRefundModel();

	factory OrderRefundModel.fromJson(Map<String, dynamic> json) => $OrderRefundModelFromJson(json);

	Map<String, dynamic> toJson() => $OrderRefundModelToJson(this);

  int? orderId;
  String? orderNo;
  int? memberId;
  String? refundNo;
  String? refundTime;
  double? refundTotal;
  @JSONField(name: "orderQueryProductDTOList")
  List<OrderRefundProductList>? orderProductList;
}

@JsonSerializable()
class OrderRefundProductList {

	OrderRefundProductList();

	factory OrderRefundProductList.fromJson(Map<String, dynamic> json) => $OrderRefundProductListFromJson(json);

	Map<String, dynamic> toJson() => $OrderRefundProductListToJson(this);

  int? id;
  int? orderId;
  int? memberId;
  int? shopId;
  String? skuCode;
  String? skuName;
  String? skuNameShow;
  int? productId;
  int? productType;
  String? productCode;
  String? productName;
  String? productNameShow;
  int? quantity;
  int? oneCategoryId;
  int? twoCategoryId;
  int? threeCategoryId;
  double? originPrice;
  double? payableMoney;
  double? payMoney;
  double? refundMoney;
  double? mayRefundMoney;
  int? refundStatus;
  int? returnFoodStatus;
  double? productIncome;
  String? taxClassification;
  int? taxClassificationId;
  String? createTime;
  String? modifyTime;
  String? orderCreateTime;
  String? oldModifyTime;
  double? priceDiscountMoney;
  double? afterDiscountMoney;
  double? packageDiscountMoney;
  double? couponDiscountMoney;
  double? voucherDiscountMoney;
  double? activityDiscountMoney;
  double? channelDiscountMoney;
  double? otherDiscountMoney;
  double? totalDiscountMoney;
  double? dealMoney;
  double? boxCount;
  double? boxPrice;
  double? boxMoney;
  double? boxPayableMoney;
  double? boxPayMoney;
  double? boxIncome;
  double? mayInvoiceMoney;
  double? invoicedMoney;
  double? thirdDiscountMoney;
  String? couponRecordNo;
  int? pocketIndex;
  int? packageOrNot;
  int? orderPackageId;
  int? packageFloor;
  String? refundNo;
  String? refundTime;
  String? productImgUrl;
  String? skuTagCode;
  String? skuTagName;
  String? thirdProductCode;
  int? thirdSkuId;
  double? couponIncome;
  int? mergeType;
}
