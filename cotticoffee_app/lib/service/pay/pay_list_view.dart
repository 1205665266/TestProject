import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'abite_pay.dart';
import 'model/pay_type_model.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/3/14 11:06 下午
class PayListWidget extends StatefulWidget {
  const PayListWidget({Key? key, this.payTypeList,this.currentPayType, this.itemPadding, this.itemSeparator, this.callBack}) : super(key: key);
  final EdgeInsets? itemPadding;
  final Widget? itemSeparator;
  final Function(PayTypeModel)? callBack;
  final List<PayTypeModel>? payTypeList;
  final PayTypeModel? currentPayType;

  @override
  State<PayListWidget> createState() => _PayListWidgetState();
}

class _PayListWidgetState extends State<PayListWidget> {
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    selectIndex = widget.payTypeList?.indexWhere((element) => element.payFrom == widget.currentPayType?.payFrom, 0)?? 0;
    logI('selectIndex ===$selectIndex');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: widget.payTypeList?.length ?? 0,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        PayTypeModel? payType = widget.payTypeList?[index];
        return InkWell(
          onTap: () {
            if (widget.callBack != null) {
              widget.callBack!(payType!);
            }
            setState(() {
              selectIndex = index;
            });
          },
          child: Container(
            height: 48.h,
            alignment: Alignment.center,
            padding: widget.itemPadding?? EdgeInsets.only(left: 28.w, right: 28.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Visibility(
                      visible: payType?.showIcon != null && (payType?.showIcon?.isNotEmpty?? false),
                      child: CottiImageWidget(
                        payType?.showIcon ?? '',
                        imgW: 18.w,
                        imgH: 18.h,
                        fit: BoxFit.fill,
                      ),
                      replacement: SvgPicture.asset(
                        'assets/images/order/comment/icon_default_pay.svg',
                        height: 14.w,
                        width: 14.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      payType?.showName ?? '',
                      style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                Icon(
                  selectIndex == index ? Icons.check_circle : Icons.circle_outlined,
                  size: 20.w,
                  color: selectIndex == index ? CottiColor.primeColor : CottiColor.textGray,
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return widget.itemSeparator ?? Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w),
          color: const Color(0xFFE5E5E5),
          height: 0.5.h,
        );
      },
    );
  }
}
