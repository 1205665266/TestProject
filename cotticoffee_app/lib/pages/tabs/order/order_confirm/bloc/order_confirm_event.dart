part of 'order_confirm_bloc.dart';

abstract class OrderConfirmEvent {}

class OrderConfirmSubmitEvent extends OrderConfirmEvent {
  BuildContext context;

  OrderConfirmSubmitEvent({required this.context});
}

class OrderConfirmChangeTakeModeEvent extends OrderConfirmEvent {

  BuildContext context;
  int takeMode;

  OrderConfirmChangeTakeModeEvent({required this.takeMode, required this.context});
}
class OrderConfirmInitVerifyEvent extends OrderConfirmEvent {
  BuildContext context;
  bool fromDetail;
  Map<String, dynamic>? productInfo;

  OrderConfirmRequestModel requestModel;

  OrderConfirmInitVerifyEvent({required this.context, required this.requestModel, required this.fromDetail, this.productInfo});
}

class OrderConfirmVerifyEvent extends OrderConfirmEvent {

  BuildContext context;

  OrderConfirmRequestModel requestModel;

  OrderConfirmVerifyEvent({required this.context, required this.requestModel});
}

class OrderConfirmChangeBountyEvent extends OrderConfirmEvent {
  bool useBounty;
  BuildContext context;
  OrderConfirmChangeBountyEvent(this.context, this.useBounty);
}

class OrderConfirmChangeCouponEvent extends OrderConfirmEvent {
  BuildContext context;
  List<String>? couponList;
  OrderConfirmChangeCouponEvent(this.context, this.couponList);
}

class OrderConfirmNoUseCouponEvent extends OrderConfirmEvent {
  BuildContext context;
  OrderConfirmNoUseCouponEvent(this.context);
}


class OrderConfirmRemarkEvent extends OrderConfirmEvent {
  String remark;

  OrderConfirmRemarkEvent({required this.remark});
}

class OrderConfirmPayTypeEvent extends OrderConfirmEvent {
  PayTypeModel? payTypeModel;

  OrderConfirmPayTypeEvent({required this.payTypeModel});
}

class OrderConfirmRemarkListEvent extends OrderConfirmEvent {
  OrderConfirmRemarkListEvent();
}

class OrderConfirmShowConfirmTipEvent extends OrderConfirmEvent {
  bool isShowTip;
  OrderConfirmShowConfirmTipEvent({required this.isShowTip});
}
class OrderConfirmInitShowConfirmTipEvent extends OrderConfirmEvent {
  OrderConfirmInitShowConfirmTipEvent();
}

class OrderConfirmInitFirstTakeModeEvent extends OrderConfirmEvent {
  int firstTakeMode;
  OrderConfirmInitFirstTakeModeEvent(this.firstTakeMode);
}

class OrderConfirmGetPayFormListEvent extends OrderConfirmEvent {
  int? shopMdCode;
  int takeFoodMode;
  OrderConfirmGetPayFormListEvent(this.shopMdCode, this.takeFoodMode);
}

class OrderConfirmChangeAddressEvent extends OrderConfirmEvent {

  MemberAddressEntity? address;
  OrderConfirmChangeAddressEvent(this.address);
}
