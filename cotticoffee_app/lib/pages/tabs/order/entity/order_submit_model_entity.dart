import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_submit_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class OrderSubmitModelEntity {

	String? orderId;
	String? orderNo;
	int? checkCode;
	String? checkMsg;
	List<OrderSubmitModelUnavailableItemList>? unavailableItemList;
	List<OrderSubmitModelSaleableItemList>? saleableItemList;
  
  OrderSubmitModelEntity();

  factory OrderSubmitModelEntity.fromJson(Map<String, dynamic> json) => $OrderSubmitModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderSubmitModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderSubmitModelUnavailableItemList {

	String? spuCode;
	String? skuCode;
	String? skuShowName;
	int? skuId;
	int buyNum = 0;
	int quantity = 0;
	String? title;
	String? image;
	double? facePrice;
	double? lineThroughPrice;
	int? saleable;
	double? specialPrice;
	int? limitType;
  
  OrderSubmitModelUnavailableItemList();

  factory OrderSubmitModelUnavailableItemList.fromJson(Map<String, dynamic> json) => $OrderSubmitModelUnavailableItemListFromJson(json);

  Map<String, dynamic> toJson() => $OrderSubmitModelUnavailableItemListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderSubmitModelSaleableItemList {

	String? spuCode;
	String? skuCode;
	String? skuShowName;
	int? skuId;
	int? buyNum;
	int? quantity;
	String? title;
	String? image;
	double? facePrice;
	double? lineThroughPrice;
	int? saleable;
	double? specialPrice;
	int? limitType;
  
  OrderSubmitModelSaleableItemList();

  factory OrderSubmitModelSaleableItemList.fromJson(Map<String, dynamic> json) => $OrderSubmitModelSaleableItemListFromJson(json);

  Map<String, dynamic> toJson() => $OrderSubmitModelSaleableItemListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}