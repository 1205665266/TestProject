import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_comment_entity_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class OrderCommentEntityEntity {
  static OrderCommentEntityEntity test() {
    OrderCommentEntityOrderItemCommentList item1 = OrderCommentEntityOrderItemCommentList()
      ..imageUrls = ['', '', '', '']
      ..content = '这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价'
      ..thumbnail = 'https://yummy-common-pre.obs.cn-north-4.myhuaweicloud.com:443/productmanager-admin/productcenter/16666816803757800_咖啡杯44.jpg'
      ..skuProps = '规格值1/规格值2字数很多很多的情况下是规格值1/规格值2字数很多很多的情况下是规格值1/规格值2字数很多很多的情况下是规格值1/规格值2字数很多很多的情况下是规格值1/规格值2字数很多很多的情况下是规格值1/规格值2字数很多很多的情况下是规格值1/规格值2字数很多很多的情况下是规格值1/规格值2字数很多很多的情况下是'
      ..name = '陨石拿铁1'
      ..evaluateLabels = ["出货神速", "口味赞"]
      ..startCount = 5;

    OrderCommentEntityOrderItemCommentList item2 = OrderCommentEntityOrderItemCommentList()
      ..imageUrls = ['', '', '', '']
      ..content = '这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价'
      ..thumbnail = 'https://yummy-common-pre.obs.cn-north-4.myhuaweicloud.com:443/productmanager-admin/productcenter/16666816803757800_咖啡杯44.jpg'
      ..skuProps = '规格值1/规格值2'
      ..name = '陨石拿铁2'
      ..evaluateLabels = ["出货神速", "口味赞"]
      ..startCount = 4;

    OrderCommentEntityOrderItemCommentList item3 = OrderCommentEntityOrderItemCommentList()
      ..imageUrls = ['', '', '', '']
      ..content = '这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价'
      ..thumbnail = 'https://yummy-common-pre.obs.cn-north-4.myhuaweicloud.com:443/productmanager-admin/productcenter/16666816803757800_咖啡杯44.jpg'
      ..skuProps = '规格值1/规格值2'
      ..name = '陨石拿铁3'
      ..evaluateLabels = ["出货神速", "口味赞"]
      ..startCount = 3;

    OrderCommentEntityOrderItemCommentList item4 = OrderCommentEntityOrderItemCommentList()
      ..imageUrls = ['', '', '', '']
      ..content = '这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价'
      ..thumbnail = 'https://yummy-common-pre.obs.cn-north-4.myhuaweicloud.com:443/productmanager-admin/productcenter/16666816803757800_咖啡杯44.jpg'
      ..skuProps = '规格值2/规格值3'
      ..name = '陨石拿铁4'
      ..evaluateLabels = ["出货神速", "口味赞"]
      ..startCount = 2;

    OrderCommentEntityOrderItemCommentList item5 = OrderCommentEntityOrderItemCommentList()
      ..imageUrls = ['', '', '', '']
      ..content = '这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价'
      ..thumbnail = 'https://yummy-common-pre.obs.cn-north-4.myhuaweicloud.com:443/productmanager-admin/productcenter/16666816803757800_咖啡杯44.jpg'
      ..skuProps = '规格值2/规格值3'
      ..name = '陨石拿铁5'
      ..evaluateLabels = ["出货神速", "口味赞"]
      ..startCount = 1;

    OrderCommentEntityOrderItemCommentList item6 = OrderCommentEntityOrderItemCommentList()
      ..imageUrls = ['', '', '', '']
      ..content = '这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价'
      ..thumbnail = 'https://yummy-common-pre.obs.cn-north-4.myhuaweicloud.com:443/productmanager-admin/productcenter/16666816803757800_咖啡杯44.jpg'
      ..skuProps = '规格值5/规格值1'
      ..name = '陨石拿铁6'
      ..evaluateLabels = ["出货神速", "口味赞"]
      ..startCount = 0;

    return OrderCommentEntityEntity()
      ..orderSatisfaction = 1
      ..orderEvaluateLabels = ["出货神速", "口味赞"]
      ..content = "这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价这里是订单评价"
      ..imageUrls = ["", "", "", "", "", "", "", "", ""]
      ..orderCreateTime = "2022-11-16"
      ..evaluateCreateTime = "2022-11-16"
      ..shopName = "总部实验店"
      ..orderItemCommentList = [item1,item2,item3,item4,item5,item6];
  }

  /// 订单满意度：1 满意 2 不满意
  int? orderSatisfaction;

  /// 订单评价标签
  List<String>? orderEvaluateLabels;

  /// 订单评价文字
  String? content;

  /// 订单评价图片
  List<String>? imageUrls;

  /// 订单下单时间
  String? orderCreateTime;

  /// 订单评价创建时间
  String? evaluateCreateTime;

  /// 门店名称
  String? shopName;

  /// 订单商品评价列表
  List<OrderCommentEntityOrderItemCommentList>? orderItemCommentList;

  OrderCommentEntityEntity();

  factory OrderCommentEntityEntity.fromJson(Map<String, dynamic> json) =>
      $OrderCommentEntityEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderCommentEntityEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderCommentEntityOrderItemCommentList {
  /// 商品sku code
  String? skuCode;

  /// 商品名称
  String? name;

  /// 商品图片缩略图链接地址
  String? thumbnail;

  /// 商品评价满意度：1 满意 2 不满意
  int? goodsSatisfaction;

  /// 商品评价标签
  List<String>? evaluateLabels;

  /// 商品评价文字
  String? content;

  /// 商品评价图片url
  List<String>? imageUrls;

  /// 评价星级
  int? startCount;

  /// sku规格项
  String? skuProps;

  OrderCommentEntityOrderItemCommentList();

  factory OrderCommentEntityOrderItemCommentList.fromJson(Map<String, dynamic> json) =>
      $OrderCommentEntityOrderItemCommentListFromJson(json);

  Map<String, dynamic> toJson() => $OrderCommentEntityOrderItemCommentListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
