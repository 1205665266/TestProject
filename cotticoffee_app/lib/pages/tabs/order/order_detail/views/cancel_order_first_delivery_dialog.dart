import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelOrderFirstDeliveryDialog extends StatefulWidget {
  OrderDetailModelCancleOrderConfigDTO? cancelOrderConfigDTO;
  final Function(int) callback;

  CancelOrderFirstDeliveryDialog(
      {Key? key, required this.cancelOrderConfigDTO, required this.callback})
      : super(key: key);

  @override
  State<CancelOrderFirstDeliveryDialog> createState() => _CancelOrderFirstDeliveryDialogState();

  static Future show(BuildContext context,
      OrderDetailModelCancleOrderConfigDTO? cancelOrderConfigDTO, Function(int) callback) {

    logI("首单取消$cancelOrderConfigDTO");
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: CancelOrderFirstDeliveryDialog(
              cancelOrderConfigDTO: cancelOrderConfigDTO,
              callback: callback,
            ),
          ),
        );
      },
    );
  }
}

class _CancelOrderFirstDeliveryDialogState extends State<CancelOrderFirstDeliveryDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: double.infinity),
      color: Colors.white,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        _buildBody(),
        SizedBox(
          height: 12.h,
        ),
        _buildDescription(),
        SizedBox(
          height: 20.h,
        ),
        _buildBottom()
      ],
    );
  }

  Widget _title() {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        children: [
          Align(
            child: Text(
              widget.cancelOrderConfigDTO?.title ?? "",
              style: TextStyle(
                color: const Color(0xFF3A3B3C),
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
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        widget.cancelOrderConfigDTO?.content??"",
        style: TextStyle(
          color: const Color(0xFF3A3B3C),
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildDescription() {

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _buildDescriptionItem(widget.cancelOrderConfigDTO!.description![index].head, widget.cancelOrderConfigDTO!.description![index].text),
      itemCount: widget.cancelOrderConfigDTO?.description?.length,
    );
  }

  Widget _buildDescriptionItem(String? head, String? text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      color: const Color(0xFFF5F6F7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            head??"",
            style: TextStyle(
              fontSize: 12.sp,
              color: CottiColor.textBlack,
              fontWeight: FontWeight.w700
            ),
          ),
          SizedBox(height: 5.h,),
          Text(
            text??"",
            style: TextStyle(
                fontSize: 11.sp,
                color: CottiColor.textBlack
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  widget.callback(0);
                  NavigatorUtils.pop(context);
                },
                child: Container(
                  height: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5.w,
                      color: CottiColor.textHint
                    )
                  ),
                  child: Text(
                    "确认取消",
                    style: TextStyle(
                      color: CottiColor.textHint,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 7.w,),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  NavigatorUtils.pop(context);
                },
                child: Container(
                  height: 40.h,
                  alignment: Alignment.center,
                  color: CottiColor.primeColor,
                  child: Text(
                    "我再想想",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
