
import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_express.g.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/3/17 2:00 下午
@JsonSerializable()
class OrderExpress {

	OrderExpress();

	factory OrderExpress.fromJson(Map<String, dynamic> json) => $OrderExpressFromJson(json);

	Map<String, dynamic> toJson() => $OrderExpressToJson(this);

  ///配送商名称
  String? supplierName;

  ///配送员名称
  String? expressUserName;

  ///配送员手机
  String? expressUserPhone;

  ///	配送单号
  String? expressOrderNo;

  ///取消配送描述
  String? cancelDesc;

  ///配送状态流转
  List<DispatchInfo>? dispatchInfoList;

  ///快递信息
  List<ExpressInfo>? expressInfoList;
}

@JsonSerializable()
class DispatchInfo {

	DispatchInfo();

	factory DispatchInfo.fromJson(Map<String, dynamic> json) => $DispatchInfoFromJson(json);

	Map<String, dynamic> toJson() => $DispatchInfoToJson(this);

  String? state;
  String? time;
}

@JsonSerializable()
class ExpressInfo {

	ExpressInfo();

	factory ExpressInfo.fromJson(Map<String, dynamic> json) => $ExpressInfoFromJson(json);

	Map<String, dynamic> toJson() => $ExpressInfoToJson(this);

  ///物流轨迹节点内容
  String? context;
  String? time;

  ///签收状态 (0在途，1揽收，2疑难，3签收，4退签，5派件，6退回，7转投)
  String? status;
}
