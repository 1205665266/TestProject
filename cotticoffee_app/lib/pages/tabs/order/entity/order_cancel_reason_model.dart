

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_cancel_reason_model.g.dart';

@JsonSerializable()
class CancelReasonList {

	CancelReasonList();

	factory CancelReasonList.fromJson(Map<String, dynamic> json) => $CancelReasonListFromJson(json);

	Map<String, dynamic> toJson() => $CancelReasonListToJson(this);

  @JSONField(name: "djCancelReasonDtoList")
  List<OrderCancelReasonModel>? orderCancelReasonModels;
}

@JsonSerializable()
class OrderCancelReasonModel {

	OrderCancelReasonModel();

	factory OrderCancelReasonModel.fromJson(Map<String, dynamic> json) => $OrderCancelReasonModelFromJson(json);

	Map<String, dynamic> toJson() => $OrderCancelReasonModelToJson(this);

  int? id;
  int? orderCancelType;
  String? orderCancelReason;
  int? orderCancelStatus;
  int? adapterOrderOrigin;
  String? code;
  bool? canEdit;
}
