import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/evaluate_config_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class EvaluateConfigEntity {
  /// 订单是否可评价
  bool? canComment;
  /// 订单不可评价原因：0 可以评价，1 超过评价时效，2 相同订单编号重复评价，3 全部退款，4 订单状态不是已完成，5 订单评价服务异常
  int? canNotCommentCause;
  /// 订单不可评价原因描述
  String? canNotCommentCauseStr;
  /// 订单商品满意评价所需的最小星数
  int? goodsSatisfiedMinStarCount;
  /// 可评价商品列表
  List<EvaluateConfigOrderItemList>? orderItemList;
  /// 订单满意标签
  List<String>? orderSatisfiedLabels;
  /// 订单不满意标签
  List<String>? orderDissatisfiedLabels;
  /// 商品满意标签
  List<String>? goodsSatisfiedLabels;
  /// 商品不满意标签
  List<String>? goodsDissatisfiedLabels;

  EvaluateConfigEntity();

  static EvaluateConfigEntity testExp() {
    return EvaluateConfigEntity()..orderDissatisfiedLabels = ["bumanyi1","bumanyi2"]
    ..orderSatisfiedLabels = ["manyi1","manyi2","manyi2","manyi2","manyi2","manyi2","manyi2","manyi2","manyi2"]
    ..goodsDissatisfiedLabels = ["pbumanyi1","pbumanyi2","pbumanyi2","pbumanyi2","pbumanyi2","pbumanyi2","pbumanyi2","pbumanyi2"]
    ..goodsSatisfiedLabels = ["pmanyi1","pmanyi2"]
    ..orderItemList = EvaluateConfigOrderItemList.testList();
  }

  factory EvaluateConfigEntity.fromJson(Map<String, dynamic> json) =>
      $EvaluateConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => $EvaluateConfigEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class EvaluateConfigOrderItemList {
  /// 商品sku code
  String? skuCode;
  /// 商品名称
  String? name;
  /// 商品图片缩略图链接地址
  String? thumbnail;
  ///sku规格
  String? skuProps;

  EvaluateConfigOrderItemList();

  factory EvaluateConfigOrderItemList.fromJson(Map<String, dynamic> json) =>
      $EvaluateConfigOrderItemListFromJson(json);

  Map<String, dynamic> toJson() => $EvaluateConfigOrderItemListToJson(this);

  static List<EvaluateConfigOrderItemList> testList(){

    List<EvaluateConfigOrderItemList> list = [];
    EvaluateConfigOrderItemList item1 = EvaluateConfigOrderItemList()
    ..name = '布丁奶茶2测试'
    ..skuCode = "SP1226-00001"
    ..skuProps = "布丁奶茶2测试"
    ..thumbnail = "https://yummy-common-pre.obs.cn-north-4.myhuaweicloud.com:443/productmanager-admin/productcenter/16660743848220838_咖啡杯_画板4.jpg";
    list.add(item1);

    EvaluateConfigOrderItemList item2 = EvaluateConfigOrderItemList()
      ..name = '蜂蜜柚子茶'
      ..skuCode = "SP1273-00003"
      ..skuProps = "蜂蜜柚子茶"
      ..thumbnail = "https://yummy-common-pre.obs.cn-north-4.myhuaweicloud.com:443/productmanager-admin/productcenter/16667649459110693_咖啡杯44.jpg";
    list.add(item2);


    return list;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
