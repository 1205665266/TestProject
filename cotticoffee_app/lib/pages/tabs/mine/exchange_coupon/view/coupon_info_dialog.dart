import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/entity/validate_entity.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/2/16 10:23
class CouponInfoDialog extends StatefulWidget {
  final Function callBack;
  final ValidateEntity validateEntity;

  const CouponInfoDialog({
    Key? key,
    required this.callBack,
    required this.validateEntity,
  }) : super(key: key);

  @override
  State<CouponInfoDialog> createState() => _CouponInfoDialogState();

  static Future show(BuildContext context, ValidateEntity validateEntity, Function callBack) {
    return showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Material(
            color: Colors.transparent,
            child: CouponInfoDialog(
              validateEntity: validateEntity,
              callBack: callBack,
            ),
          ),
        );
      },
    );
  }
}

class _CouponInfoDialogState extends State<CouponInfoDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _content(),
        SizedBox(height: 32.h),
        _buildClose(),
      ],
    );
  }

  Widget _content() {
    return Container(
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.symmetric(horizontal: 36.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.r),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildTitle(),
          SizedBox(height: 24.h),
          _buildCouponInfo(),
          _buildCouponCount(),
          SizedBox(height: 19.h),
          _buildAction(),
        ],
      ),
    );
  }

  _buildTitle() {
    return Text(
      '您正在兑换抖音团购商品',
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16.sp,
        color: CottiColor.textBlack,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  _buildCouponInfo() {

    bool isCount = widget.validateEntity.templateProductType == 3;

    Widget info = Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          isCount ? BoxShadow(
            color: const Color(0xff000000).withOpacity(0.08),
            offset: Offset(0, 2.h),
            spreadRadius: -2.r,
            blurRadius: 4.r,
            // blurStyle: BlurStyle.inner,
          ):const BoxShadow(),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 6.w,
            child: Image.asset(
              "assets/images/mine/icon_douyin_coupon.png",
              width: 80.w,
              height: 72.w,
            ),
          ),
          Container(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.validateEntity.productName ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: CottiColor.textBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '¥',
                      style: TextStyle(
                        color: CottiColor.primeColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "DDP5",
                        fontSize: 12.sp,
                        height: 1,
                      ),
                      strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                        height: 1,
                      ),
                    ),
                    Text(
                      "${Decimal.tryParse(widget.validateEntity.payAmount ?? '')}",
                      style: TextStyle(
                        color: CottiColor.primeColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "DDP5",
                        fontSize: 22.sp,
                        height: 1,
                      ),
                      strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                        height: 1,
                      ),
                    ),
                    Text(
                      isCount ? '/${widget.validateEntity.total}次' : '/份',
                      style: TextStyle(
                        color: CottiColor.primeColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: "DDP6",
                        fontSize: 12.sp,
                        height: 1,
                      ),
                      strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                        height: 1,
                      ),
                    ),
                    // SizedBox(
                    //   width: 4.w,
                    // ),
                    // Text(
                    //   "¥${widget.validateEntity.originalAmount}",
                    //   style: TextStyle(
                    //     color: CottiColor.textHint,
                    //     fontFamily: "DDP5",
                    //     fontWeight: FontWeight.w500,
                    //     fontSize: 14.sp,
                    //     decoration: TextDecoration.lineThrough,
                    //     decorationStyle: TextDecorationStyle.solid,
                    //     height: 1,
                    //   ),
                    //   strutStyle: const StrutStyle(
                    //     forceStrutHeight: true,
                    //     height: 1,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if(!isCount){
      return info;
    }else{
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            info,
            Container(
                padding: EdgeInsets.only(left: 14.w),
                height: 32.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: Text(
                        "剩余可兑数量:",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: CottiColor.textBlack,
                          height: 1,
                        ),
                        strutStyle: const StrutStyle(
                          forceStrutHeight: true,
                          height: 1,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      child: Text(
                        "${widget.validateEntity.num}",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: CottiColor.primeColor,
                          fontFamily: "DDP5",
                          height: 1,
                        ),
                        strutStyle: const StrutStyle(
                          forceStrutHeight: true,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }
  }

  _buildCouponCount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '商品将兑换为 ',
              style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
              strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,),
            ),
            Text(
              widget.validateEntity.num ?? '',
              style: TextStyle(
                color: CottiColor.primeColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
              strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,),
            ),
            Text(
              ' 张',
              style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
              strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/images/mine/icon_coupon_info_dialog.svg",
              width: 16.w,
              height: 16.w,
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: Text(
                widget.validateEntity.couponName ?? '',
                maxLines: 2,
                style: TextStyle(
                  color: CottiColor.primeColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                strutStyle: const StrutStyle(forceStrutHeight: true),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildAction() {
    return GestureDetector(
      onTap: () {
        widget.callBack();
        Navigator.pop(context);
      },
      child: Container(
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2.r)),
          color: CottiColor.primeColor,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF470800).withOpacity(0.11),
              offset: Offset(0, 8.h),
              blurRadius: 12.r,
              spreadRadius: -5,
            ),
          ],
        ),
        child: Text(
          "确认兑换",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildClose() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Opacity(
        opacity: 0.77,
        child: SvgPicture.asset(
          "assets/images/ic_btn_close.svg",
          width: 30.w,
          height: 30.w,
        ),
      ),
    );
  }
}
