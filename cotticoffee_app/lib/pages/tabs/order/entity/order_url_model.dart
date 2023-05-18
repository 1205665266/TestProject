import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_url_model.g.dart';

@JsonSerializable()
class OrderUrlModel {
  OrderUrlModel();

  factory OrderUrlModel.fromJson(Map<String, dynamic> json) => $OrderUrlModelFromJson(json);

  Map<String, dynamic> toJson() => $OrderUrlModelToJson(this);

  late dynamic code;
  late OrderUrlData data;
  late String message;
  late bool success;
  late String traceId;
}

@JsonSerializable()
class OrderUrlData {
  OrderUrlData();

  factory OrderUrlData.fromJson(Map<String, dynamic> json) => $OrderUrlDataFromJson(json);

  Map<String, dynamic> toJson() => $OrderUrlDataToJson(this);

  late dynamic success;
  late String url;
  late String bookKey;
}
