import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/order_confirm_page.dart';
import 'package:cotti_client/service/pay/abite_pay.dart';
import 'package:cotti_client/service/pay/model/pay_type_model.dart';
import 'package:cotti_client/service/pay/pay_list_view.dart';
import 'package:cotti_client/utils/abite_pay_util.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/3/15 10:51 上午
class ToPayDialog extends StatefulWidget {
  const ToPayDialog(
      {Key? key,
      required this.payable,
      required this.orderId,
      required this.orderNo,
      required this.payTypeList,
      this.callBack})
      : super(key: key);
  final double payable;
  final String orderId;
  final String orderNo;
  final List<PayTypeModel> payTypeList;
  final Function(ABitePayResult)? callBack;

  @override
  State<ToPayDialog> createState() => _ToPayDialogState();

  static void show(BuildContext context, double payable, String orderId, String orderNo,
      int? takeMode, int? shopMdCode, Function(ABitePayResult)? callBack) {
    AbitePay()
        .cottiPayList(data: {"shopMdCode": shopMdCode, "tookFoodMode": takeMode}).then((value) {
      if (value.isNotEmpty) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return ToPayDialog(
              payable: payable,
              orderId: orderId,
              orderNo: orderNo,
              callBack: callBack,
              payTypeList: value.where((e) => e.payFrom != PayForm.canteenCard.index).toList(),
            );
          },
        );
      }
    }).catchError((onError) {
      logI("paytypelist---->$onError");
    });
  }
}

class _ToPayDialogState extends State<ToPayDialog> {
  PayTypeModel? _payType;

  @override
  void initState() {
    super.initState();

    _payType = widget.payTypeList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                child: Text(
                  "待支付",
                  style: TextStyle(
                    color: const Color(0xFF333333),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "¥",
                      style: TextStyle(
                          color: CottiColor.primeColor, fontSize: 16.sp, fontFamily: 'DDP5'),
                    ),
                    Text(
                      "${widget.payable}",
                      style: TextStyle(
                          color: CottiColor.primeColor, fontSize: 22.sp, fontFamily: 'DDP5'),
                      strutStyle: const StrutStyle(forceStrutHeight: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
          PayListWidget(
            payTypeList: widget.payTypeList,
            itemPadding: EdgeInsets.symmetric(horizontal: 20.w),
            currentPayType: _payType,
            callBack: (payType) => _payType = payType,
          ),
          SafeArea(
            top: false,
            child: Container(
              height: 68.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w),
              child: GestureDetector(
                onTap: () {
                  if (_payType == null) {
                    ToastUtil.show("请选择支付方式");
                  } else {
                    AbitePay().pay(_payType!, widget.orderId, widget.orderNo).then((value) {
                      if (widget.callBack != null) {
                        widget.callBack!(value);
                      }
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: CottiColor.primeColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "去支付",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
