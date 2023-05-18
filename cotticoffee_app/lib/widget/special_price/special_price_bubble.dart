import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/28 10:14
class SpecialPriceBubble extends StatefulWidget {
  final String specialText;
  final double discountRate;

  const SpecialPriceBubble({
    Key? key,
    required this.specialText,
    required this.discountRate,
  }) : super(key: key);

  @override
  State<SpecialPriceBubble> createState() => _SpecialPriceBubbleState();
}

class _SpecialPriceBubbleState extends State<SpecialPriceBubble> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CachedNetworkImage(
          imageUrl:
              "https://cdn-product-prod.yummy.tech/wechat/cotti/images/product/bg_bubble1.png",
          fadeOutDuration: null,
          height: 18.w,
          width: 5.w,
          errorWidget: (context, url, error) =>
              Image.asset('assets/images/menu/icon_special_left.png'),
          placeholder: (context, url) => Image.asset('assets/images/menu/icon_special_left.png'),
        ),
        Container(
          height: 15.8.w,
          margin: EdgeInsets.only(left: 4.5.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF3F2),
            border: Border(
              top: BorderSide(width: 0.5.h, color: const Color(0xFFAA4940)),
              bottom: BorderSide(width: 0.5.h, color: const Color(0xFFAA4940)),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.specialText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11.sp,
                  color: const Color(0xFFA74339),
                ),
                strutStyle: StrutStyle(
                  forceStrutHeight: true,
                  fontSize: 11.sp,
                  height: 1.3,
                ),
              ),
              Container(
                width: 1.w,
                height: 10.h,
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                color: const Color(0xFFA74339),
              ),
              Text(
                "${Decimal.parse("${widget.discountRate}")}折",
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFFA74339),
                  fontWeight: FontWeight.bold,
                ),
                strutStyle: StrutStyle(
                  forceStrutHeight: true,
                  fontSize: 11.sp,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: -5.w,
          child: CachedNetworkImage(
            imageUrl:
                "https://cdn-product-prod.yummy.tech/wechat/cotti/images/product/bg_bubble3.png",
            height: 18.w,
            width: 5.w,
            fadeOutDuration: null,
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/menu/icon_special_right.png'),
            placeholder: (context, url) => Image.asset('assets/images/menu/icon_special_right.png'),
          ),
        ),
      ],
    );
  }
}
