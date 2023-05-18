import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_refund_record_model_entity.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RefundRecordDialog extends StatefulWidget {
  final double? maxHeight;
  final List<OrderRefundRecordModelEntity> recordList;

  const RefundRecordDialog({Key? key, this.maxHeight, required this.recordList}) : super(key: key);

  @override
  State<RefundRecordDialog> createState() => _RefundRecordDialogState();

  static Future show(BuildContext context, List<OrderRefundRecordModelEntity> recordList,
      {double? maxHeight}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return RefundRecordDialog(
          maxHeight: maxHeight,
          recordList: recordList,
        );
      },
    );
  }
}

class _RefundRecordDialogState extends State<RefundRecordDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: widget.maxHeight ?? double.infinity),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_title(), _buildList()],
    );
  }

  Widget _title() {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Align(
                  child: Text(
                    '退款记录',
                    style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(IconFont.icon_close, size: 20.sp, color: CottiColor.textGray),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Divider(
              height: 1.h,
              color: const Color(0xFFE5E5E5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Flexible(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          ListView.separated(
            shrinkWrap: true,
            itemCount: widget.recordList.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 4.h, bottom: 20.h),
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 20.h);
            },
            itemBuilder: (context, index) {
              return _buildItem(widget.recordList[index]);
            },
          ),
          const SafeArea(top: false, child: SizedBox()),
        ],
      ),
    );
  }

  _buildItem(OrderRefundRecordModelEntity orderRefundModel) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 8.w, right: 8.w),
          decoration: const BoxDecoration(
            color: Color(0xFFF9FAFB),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "退款时间：${orderRefundModel.refundTime}",
                style: TextStyle(
                  color: const Color(0xFF979797),
                  fontSize: 12.sp,
                ),
              ),
              Text.rich(
                TextSpan(
                    text: "合计：",
                    style: TextStyle(
                      color: const Color(0xFF7D7D7D),
                      fontSize: 12.sp,
                    ),
                    children: [
                      TextSpan(
                        text: "¥",
                        style: TextStyle(
                          color: CottiColor.primeColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            StringUtil.decimalParse(orderRefundModel.refundTotal),
                        style: TextStyle(
                          color: CottiColor.primeColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 14.h),
          itemBuilder: (context, index) {
            return _buildSubItem(orderRefundModel.orderQueryProductDTOList![index]);
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 20.h);
          },
          itemCount: orderRefundModel.orderQueryProductDTOList?.length ?? 0,
        ),
      ],
    );
  }

  _buildSubItem(OrderRefundRecordModelOrderQueryProductDTOList orderRefundProduct) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CottiImageWidget(
                orderRefundProduct.productImgUrl ?? '',
                imgW: 60.w,
                imgH: 60.w,
                borderRadius: BorderRadius.circular(3.r),
                fit: BoxFit.fill,
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderRefundProduct.productName ?? '',
                      style: TextStyle(
                        color: const Color(0xFF111111),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      strutStyle: StrutStyle(
                        forceStrutHeight: true,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      orderRefundProduct.skuNameShow ?? '',
                      style: TextStyle(
                        color: const Color(0xFF979797),
                        fontSize: 12.sp,
                      ),
                      strutStyle: StrutStyle(
                        forceStrutHeight: true,
                        fontSize: 12.sp,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "¥",
                  style: TextStyle(
                    color: const Color(0xFF111111),
                    fontSize: 12.sp,
                  ),
                ),
                TextSpan(
                  text: StringUtil.decimalParse(orderRefundProduct.refundMoney),
                  style: TextStyle(
                    color: const Color(0xFF111111),
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
