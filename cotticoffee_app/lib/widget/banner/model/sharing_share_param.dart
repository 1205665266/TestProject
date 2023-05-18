class SharingShareParam{
  ///订单号
  String? orderId;

  ///活动编号
  String? activityNo;
  SharingShareParam(this.orderId,this.activityNo);
  Map<String, dynamic> toJson() => {
    "activityNo": activityNo,
    "orderId": orderId,
  };

}