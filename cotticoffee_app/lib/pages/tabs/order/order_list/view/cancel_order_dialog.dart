import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_cancel_reason_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// FileName: cancel_order_dialog
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/3/2
class CancelOrderDialog extends StatefulWidget {
  const CancelOrderDialog(
      {Key? key, this.maxHeight, required this.cancelReason, required this.callback})
      : super(key: key);
  final double? maxHeight;
  final List<OrderCancelReasonModel> cancelReason;
  final Function(OrderCancelReasonModel, String?) callback;

  static Future show(BuildContext context, List<OrderCancelReasonModel> cancelReason,
      Function(OrderCancelReasonModel, String?) callback,
      {double? maxHeight}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: CancelOrderDialog(
              maxHeight: maxHeight,
              cancelReason: cancelReason,
              callback: callback,
            ),
          ),
        );
      },
    );
  }

  @override
  _CancelOrderDialogState createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  int selectIndex = 0;
  int maxLength = 50;
  String? otherReasons;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: widget.maxHeight ?? double.infinity),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        _buildSubTitle(),
        _buildBody(),
        _bottom(),
      ],
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
                    '取消订单',
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

  _buildSubTitle() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 14.h),
      child: Text(
        '请选择取消原因',
        style: TextStyle(
          color: const Color(0xFF999999),
          fontSize: 12.sp,
        ),
      ),
    );
  }

  _buildBody() {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return _buildItem(index, widget.cancelReason[index]);
            },
            separatorBuilder: (context, index) {
              return Divider(height: 1.h, color: const Color(0xFFE5E5E5));
            },
            itemCount: widget.cancelReason.length,
          ),
          Visibility(
            visible: widget.cancelReason.isNotEmpty &&
                (widget.cancelReason[selectIndex].canEdit ?? false),
            child: _reason(),
          ),
        ],
      ),
    );
  }

  _buildItem(int index, OrderCancelReasonModel cancelReasonModel) {
    return InkWell(
      onTap: () {
        setState(() {
          selectIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        height: 50.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              cancelReasonModel.orderCancelReason ?? '',
              style: TextStyle(
                color: const Color(0xFF333333),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(
                width: 22.w,
                height: 22.h,
                child: selectIndex == index
                    ? SvgPicture.asset("assets/images/order/comment/icon_selected.svg")
                    : SvgPicture.asset("assets/images/order/comment/icon_unselected.svg")),
          ],
        ),
      ),
    );
  }

  Widget _reason() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Divider(height: 1.h, color: const Color(0xFFE5E5E5)),
          Container(
            margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 12.h),
            height: 90.h,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F7),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TextField(
              keyboardAppearance: Brightness.light,
              cursorHeight: 17.h,
              style: TextStyle(
                color: const Color(0xFF111111),
                fontSize: 12.sp,
              ),
              strutStyle: StrutStyle(
                height: 1.1.h,
              ),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: "请填写具体原因",
                hintStyle: TextStyle(
                  color: const Color(0xFF979797),
                  fontSize: 12.sp,
                ),
                border: InputBorder.none,
                counterStyle: ((otherReasons?.length ?? 0) >= maxLength)
                    ? const TextStyle(color: Color(0xFFFF1600))
                    : null,
              ),
              cursorColor: const Color(0xFFFF6A39),
              maxLines: 3,
              maxLength: maxLength,
              onChanged: (String change) {
                otherReasons = change;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  _bottom() {
    return SafeArea(
      top: false,
      child: Container(
        height: 68.h,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            widget.callback(widget.cancelReason[selectIndex], otherReasons);
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            height: 42.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CottiColor.primeColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              "提交",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
