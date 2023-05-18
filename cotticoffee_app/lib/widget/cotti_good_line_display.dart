import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/23 18:43
class CottiGoodLineDisplay extends StatelessWidget {
  final String? goodsImgUrl;
  final String productName;
  final double price;
  final double? standardPrice;
  final int? quantity;
  final String? skuName;
  final String? discount;

  const CottiGoodLineDisplay({
    Key? key,
    required this.goodsImgUrl,
    required this.productName,
    required this.price,
    this.standardPrice,
    this.quantity,
    this.skuName,
    this.discount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CottiImageWidget(
            goodsImgUrl ?? '',
            imgH: 70.w,
            imgW: 70.w,
            resize: "w_${400},h_${400}",
            borderRadius: BorderRadius.all(Radius.circular(3.r)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildName(),
          ),
          SizedBox(width: 4.w),
          _buildPrice(),
        ],
      ),
    );
  }

  Widget _buildName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productName,
          style: TextStyle(
            color: CottiColor.textBlack,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          skuName ?? '',
          style: TextStyle(
            fontSize: 12.sp,
            color: CottiColor.textGray,
          ),
        ),
      ],
    );
  }

  _buildPrice() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Visibility(
                  visible: discount?.isNotEmpty ?? false,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 2.h, right: 6.w),
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: CottiColor.primeColor, width: 1.w),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                    child: Text(
                      discount ?? '',
                      style: TextStyle(
                        color: CottiColor.primeColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                Text(
                  "¥${StringUtil.decimalParse(price)}",
                  style: TextStyle(
                    color: CottiColor.textBlack,
                    fontFamily: 'DDP5',
                    fontSize: 18.sp,
                  ),
                  strutStyle: const StrutStyle(forceStrutHeight: true),
                ),
              ],
            ),
            Visibility(
              visible: (standardPrice ?? 0) > price,
              child: Text(
                '¥${StringUtil.decimalParse(standardPrice)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'DDP4',
                  color: CottiColor.textGray,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
          ],
        ),
        Text(
          'x$quantity',
          style: TextStyle(
            color: CottiColor.textBlack,
            fontSize: 12.sp,
            fontFamily: 'DDP4',
          ),
        ),
      ],
    );
  }
}
