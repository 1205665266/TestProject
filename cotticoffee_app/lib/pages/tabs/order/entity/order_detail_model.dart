import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/order_detail_model.g.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_express.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_status_str_entity.dart';

@JsonSerializable()
class OrderDetailModel {
  OrderDetailModel();

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) => $OrderDetailModelFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailModelToJson(this);

  ///订单ID
  int? id;

  ///订单号
  String? orderNo;

  ///会员ID
  int? memberId;

  ///会员手机号
  String? mobile;

  ///门店ID
  int? shopId;
  double? latitude;
  double? longitude;

  ///订单来源
  int? origin;

  ///订单类型（ 1-立即单；2-预约单);
  int? type;

  ///实际订单类型
  int? actualType;

  ///完成类型，正常/非正常完成
  int? finishType;

  /// 订单状态
  /// CREATED(10, "已新建"),
  /// SUBMITTED(20, "待履约"),
  /// ON_SERVICE(30, "已取货"),
  /// CANCELED(40, "已取消"),
  /// COMPLETE(50, "已完成");
  int? status;

  ///制作状态
  int? productStatus;

  /// NO_EXPRESS(-1, "无需配送"),
  /// WAIT_DELIVERY(1, "待发货"),
  /// HAS_DELIVERY(2, "已发货"),
  /// CREATE_FAILED(5, "创建失败/配送异常"),
  /// WAIT_DISTRIBUTION(10, "待分配"),
  /// RECEIVE_ORDER(20, "骑手已接单"),
  /// ARRIVE_STORE(30, "骑手已到店"),
  /// GET_MEAL(40, "骑手已取餐"),
  /// COMPLETION(50, "已完成"),
  /// CANCEL(90, "已取消"),
  /// EXCEPTION_COMPLETION(60, "异常完成"),
  /// INVALID(70, "无效");
  int? expressStatus;

  /// 发票状态
  int? invoiceStatus;

  ///退款状态
  ///REFUNDING(0, "退款中"),
  /// REFUNDABLE(1, "未退款"),
  /// PARTIAL_REFUNDED(2, "部分退款"),
  /// ALL_REFUNDED(3, "已退款");
  int? refundStatus;

  /// PLATFORM_EXPRESS(1, "平台配送"),
  /// BUSINESS_SELF_EXPRESS(2, "商家自配送");
  int? expressMode;

  ///YES(1, "有赞回迁订单"),
  /// NO(2, "非有赞回迁订单");
  int? isYouzanMigrate;

  ///订单创建时间
  String? createTime;

  ///退款时间
  String? refundTime;

  ///订单修改时间
  String? modifyTime;

  ///订单取消时间
  String? cancelTime;

  ///订单截止倒计时时间（S）
  int? deadLineSeconds;

  ///订单支付截止时间
  String? paymentDeadlineTime;

  ///订单支付时间
  String? payTime;

  ///订单完成时间
  num? finishTime;

  ///订单渠道
  int? channel;

  ///品牌编号
  String? brandNo;

  ///运营模式
  String? shopOperationMode;

  ///运营模式
  int? cooperationMode;

  ///销售性质
  int? saleNature;

  ///城市编码
  String? cityCode;

  ///购买商品总数量
  int? productQuantity;

  ///是否隐藏取消按钮
  ///0 否， 1 是
  int? hiddenCancel;

  ///0：显示，  1：隐藏 是否显示联系骑手
  int? hiddenExpressPhone;

  ///是否已经评价：0否 1是
  int? isEvaluate;

  ///订单是否允许评价: 0否 1是
  int? allowEvaluate;

  ///取货类型：1自提、2外送、3快递
  int? takeType;

  ///预计取货/送达开始时间
  String? expectTakeBeginTime;

  ///预计取货/送达结束时间
  String? expectTakeEndTime;

  ///配送商预计送达时间
  String? distributorExpectTime;

  String? takeTypeStr;

  ///订单财务信息
  @JSONField(name: "orderFinanceDetail")
  OrderQueryFinance? orderQueryFinance;

  ///订单扩展信息
  @JSONField(name: "orderExtendDetail")
  OrderQueryExtend? orderQueryExtend;

  ///订单支付信息
  @JSONField(name: "orderPayDetail")
  OrderQueryPay? orderQueryPay;

  ///快递信息
  @JSONField(name: "orderExpressDetail")
  OrderExpress? orderExpress;

  ///订单取消信息
  @JSONField(name: "orderCancelDetail")
  OrderQueryCancel? orderQueryCancel;

  ///订单中的商品的集合信息
  @JSONField(name: "orderProducts")
  List<OrderQueryProduct>? orderQueryProducts;
  @JSONField(name: "orderStatusStrMsg")
  OrderStatusStrEntity? orderStatusStr;

  /// 取餐码为空时的缺省值
  String? takeNoEmptyContext;
  /// 订单已取消时，显示的缺省值
  String? canteenCardHiddenCancelContext;
  /// 食堂支付的 支付方式信息
  String? canteenCardName;
  /// 支付序号
  String? canteenPaySerialNumber;

  OrderDetailModelCancleOrderConfigDTO? cancleOrderConfigDTO;
}

@JsonSerializable()
class OrderQueryFinance {
  OrderQueryFinance();

  factory OrderQueryFinance.fromJson(Map<String, dynamic> json) => $OrderQueryFinanceFromJson(json);

  Map<String, dynamic> toJson() => $OrderQueryFinanceToJson(this);

  double? totalProductMoney;

  ///商品总售价
  double? totalOriginMoney;

  ///商品总应付
  double? totalPayableMoney;

  ///总已退款金额
  double? totalRefundMoney;

  ///商品总实付
  double? actuallyMoney;

  double? totalDiscountMoney;

  ///订单总实付
  double? orderActuallyPayMoney;

  ///订单可开票金额
  double? invoiceMoney;

  ///订单已开票金额
  double? invoicedMoney;

  ///订单可退款金额
  double? mayRefundMoney;

  ///折扣减免
  double? priceDiscountMoney;

  ///优惠券减免
  double? couponDiscountMoney;

  /// 代金券减免
  double? voucherDiscountMoney;

  ///特价减免
  double? specialDiscountMoney;

  ///奖励金减免
  double? awardDiscountMoney;

  ///配送费原价
  double? totalDeliveryMoney;

  ///配送费实付
  double? deliveryPayMoney;

  ///20221213 配送减免类型 0-无减免 1-会员首单外卖权益-免配送费 2-门店营业设置-配送优惠
  int? deliveryDiscountType;
}

@JsonSerializable()
class OrderQueryExtend {
  OrderQueryExtend();

  factory OrderQueryExtend.fromJson(Map<String, dynamic> json) => $OrderQueryExtendFromJson(json);

  Map<String, dynamic> toJson() => $OrderQueryExtendToJson(this);

  ///门店ID
  int? shopId;

  ///门店名称
  String? shopName;

  ///门店所在城市
  String? shopCity;

  ///门店地址
  String? shopAddress;

  ///门店电话
  String? shopPhone;

  ///会员备注
  String? memberRemark;

  ///取餐码
  String? takeNo;

  ///会员性别
  int? memberSex;

  ///门店序号
  String? shopSequenceNumber;

  ///会员昵称
  String? memberNickName;

  ///取餐码状态
  int? takeNoStatus;

  ///门店主数据编号
  String? shopMdCode;

  ///会员编号
  String? memberNo;

  ///收货人地址
  String? takeAddress;

  /// 收货地址POI名称 + 门牌号
  String? takePoiAddress;

  int? takeHumSex;

  ///收货人手机号
  String? takeHumPhone;

  ///收货人名称
  String? takeHumName;

  ///物流动态
  String? logisticsDynamics;

  ///骑手电话
  String? takeawayUserPhone;
}

@JsonSerializable()
class OrderQueryPay {
  OrderQueryPay();

  factory OrderQueryPay.fromJson(Map<String, dynamic> json) => $OrderQueryPayFromJson(json);

  Map<String, dynamic> toJson() => $OrderQueryPayToJson(this);

  ///订单支付状态
  int? status;

  ///订单支付单号
  String? payNo;

  ///支付模式
  int? payMode;

  ///支付方式
  int? payFrom;

  ///支付方式名称
  String? payFormName;

  ///支付金额
  double? payMoney;
}

@JsonSerializable()
class OrderQueryCancel {
  OrderQueryCancel();

  factory OrderQueryCancel.fromJson(Map<String, dynamic> json) => $OrderQueryCancelFromJson(json);

  Map<String, dynamic> toJson() => $OrderQueryCancelToJson(this);

  ///取消类型 用户/咖啡师/配送员/系统,参见枚举',
  int? cancelUserType;

  ///取消原因
  String? cancelReason;

  ///取消类型
  int? cancelReasonType;
}

@JsonSerializable()
class OrderQueryProduct {
  OrderQueryProduct();

  factory OrderQueryProduct.fromJson(Map<String, dynamic> json) => $OrderQueryProductFromJson(json);

  Map<String, dynamic> toJson() => $OrderQueryProductToJson(this);

  String? productImgUrl;

  ///sku 编码
  String? skuCode;

  ///sku 名称
  String? skuName;

  ///展示sku名称
  String? skuNameShow;

  ///商品ID
  int? productId;

  /// 商品编码
  String? productCode;

  ///商品名称
  String? productName;

  ///展示商品名称
  String? productNameShow;

  ///商品原价
  double? originPrice;

  ///折扣后单价
  double? afterDiscountMoney;

  ///购买数量
  int? quantity;

  ///商品应付金额
  double? payableMoney;

  ///商品实付金额
  double? payMoney;

  ///商品退款金额
  double? refundMoney;

  ///退款状态 参见枚举
  int? refundStatus;

  ///退货状态 参见枚举
  int? returnFoodStatus;

  String? preferenceTypeDesc;
}

@JsonSerializable()
class OrderDetailModelCancleOrderConfigDTO {

  String? title;
  String? content;
  List<OrderDetailModelCancleOrderConfigDTODescription>? description;

  OrderDetailModelCancleOrderConfigDTO();

  factory OrderDetailModelCancleOrderConfigDTO.fromJson(Map<String, dynamic> json) => $OrderDetailModelCancleOrderConfigDTOFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailModelCancleOrderConfigDTOToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderDetailModelCancleOrderConfigDTODescription {

  String? head;
  String? text;

  OrderDetailModelCancleOrderConfigDTODescription();

  factory OrderDetailModelCancleOrderConfigDTODescription.fromJson(Map<String, dynamic> json) => $OrderDetailModelCancleOrderConfigDTODescriptionFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailModelCancleOrderConfigDTODescriptionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}