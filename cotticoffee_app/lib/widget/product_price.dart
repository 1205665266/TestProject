import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/22 15:44
class ProductPrice extends StatelessWidget {
  ///如果有特价商品,如果传入SKU会优先使用SKU 里的价格
  final SkuEntity? skuEntity;

  ///商品价格
  final double? productPrice;

  ///商品原价(划线价)
  final double? standardPrice;

  ///售价前面的¥符号大小
  final double? symbolSize;

  ///销售价字体大小
  final double? productPriceSize;

  ///原价字体大小
  final double? standardPriceSize;

  final bool rmbForceStrutHeight;

  final bool showActivityPrice;

  const ProductPrice({
    Key? key,
    this.skuEntity,
    this.symbolSize,
    this.productPriceSize,
    this.standardPriceSize,
    this.productPrice,
    this.standardPrice,
    this.rmbForceStrutHeight = true,
    this.showActivityPrice = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double productPrice = skuEntity != null ? _productPrice(skuEntity) : (this.productPrice ?? 0);
    double standardPrice =
        skuEntity != null ? _standardPrice(skuEntity) : (this.standardPrice ?? 0);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '¥',
          style: TextStyle(
            color: CottiColor.textBlack,
            fontSize: symbolSize ?? 10.sp,
            fontWeight: FontWeight.bold,
          ),
          strutStyle: rmbForceStrutHeight ? const StrutStyle(forceStrutHeight: true) : null,
        ),
        Text(
          StringUtil.decimalParse(productPrice),
          style: TextStyle(
            color: CottiColor.textBlack,
            fontSize: productPriceSize ?? 16.sp,
            fontFamily: 'DDP5',
          ),
          strutStyle: const StrutStyle(forceStrutHeight: true),
        ),
        SizedBox(width: 4.w),
        if (standardPrice > productPrice)
          Text(
            "¥${StringUtil.decimalParse(standardPrice)}",
            style: TextStyle(
              color: CottiColor.textGray,
              fontSize: standardPriceSize ?? 11.sp,
              decoration: TextDecoration.lineThrough,
              fontFamily: 'DDP4',
            ),
            strutStyle: const StrutStyle(forceStrutHeight: true),
          ),
      ],
    );
  }

  double _productPrice(SkuEntity? skuModel) {
    if (skuModel == null) {
      return 0;
    }
    int? price;
    if (skuModel.specialActivityLimit?.activityStatus == 0 && showActivityPrice) {
      price = skuModel.activityPrice;
    }
    price ??= skuModel.sellPrice ?? 0;
    return price / 100.0;
  }

  double _standardPrice(SkuEntity? skuModel) {
    return (skuModel?.standardPrice ?? 0) / 100.0;
  }
}
