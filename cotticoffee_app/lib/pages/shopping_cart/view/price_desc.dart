import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/shopping_cart/entity/shopping_cart_entity.dart';
import 'package:cotti_client/widget/product_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/25 11:49
class PriceDesc extends StatelessWidget {
  final double productPrice;

  final double? standardPrice;

  final DeliveryDiscountTip? deliveryDiscountTip;

  final String? firstOrderFreeShippingMsg;

  const PriceDesc({
    Key? key,
    required this.productPrice,
    this.deliveryDiscountTip,
    this.standardPrice,
    this.firstOrderFreeShippingMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Span> spans = _deliveryRichText();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ProductPrice(
          symbolSize: 14.sp,
          productPriceSize: 20.sp,
          standardPriceSize: 12.sp,
          productPrice: productPrice,
          standardPrice: standardPrice,
        ),
        if (spans.isNotEmpty)
          RichText(
            text: TextSpan(
              children: List.generate(spans.length, (index) => _buildText(spans[index])),
            ),
          )
      ],
    );
  }

  _deliveryRichText() {
    List<Span> spans = [];
    if (deliveryDiscountTip == null) {
      return spans;
    }
    int deliverType = deliveryDiscountTip!.deliverType ?? 0;
    double startDeliveryMoney = double.tryParse(deliveryDiscountTip!.startDeliveryMoney ?? '') ?? 0;
    double deliveryMoney = double.tryParse(deliveryDiscountTip!.deliveryMoney ?? '') ?? 0;
    bool firstOrderFreeDeliveryFee = deliveryDiscountTip!.firstOrderFreeDeliveryFee ?? false;
    int? gradientFreeType = deliveryDiscountTip!.gradientfreeType;
    if (firstOrderFreeDeliveryFee) {
      if (deliveryMoney != 0) {
        if ((firstOrderFreeShippingMsg ?? '').isNotEmpty) {
          spans.add(Span("$firstOrderFreeShippingMsg ", 1, 12.sp));
        }
        spans.add(Span("¥$deliveryMoney", 3, 12.sp));
      } else {
        spans.add(Span("免配送费", 1, 12.sp));
      }
      return spans;
    }
    switch (deliverType) {
      case 1:
        spans.add(Span("免配送费", 1, 12.sp));
        break;
      case 2:
        spans.add(Span("另需配送费", 1, 12.sp));
        spans.add(Span("¥${deliveryDiscountTip!.payDeliveryMoney}", 2, 13.sp));
        break;
      case 3:
        spans.add(Span("另需配送费", 1, 12.sp));
        spans.add(Span(" ", 1, 8.sp));
        spans.add(Span("¥${deliveryDiscountTip!.payDeliveryMoney}", 2, 13.sp));
        spans.add(Span(" ", 1, 8.sp));
        spans.add(Span("¥${deliveryDiscountTip!.deliveryMoney}", 3, 13.sp));
        break;
      case 4:
        spans.add(Span("配送费", 1, 12.sp));
        spans.add(Span(" ", 1, 8.sp));
        spans.add(Span("¥0", 2, 13.sp));
        spans.add(Span(" ", 1, 8.sp));
        spans.add(Span("¥${deliveryDiscountTip!.deliveryMoney}", 3, 13.sp));
        break;
    }
    if (spans.isEmpty) {
      return spans;
    }
    if (productPrice >= startDeliveryMoney && deliverType != 1) {
      switch (gradientFreeType) {
        case 1:
          spans.add(Span("，再买", 1, 12.sp));
          spans.add(Span("¥${deliveryDiscountTip!.stillOweDeliveryMoney}", 2, 13.sp));
          spans.add(Span("可免配送费", 1, 12.sp));
          break;
        case 2:
          spans.add(Span("，再买", 1, 12.sp));
          spans.add(Span("¥${deliveryDiscountTip!.stillOweDeliveryMoney}", 2, 13.sp));
          spans.add(Span("可减", 1, 12.sp));
          spans.add(Span("¥${deliveryDiscountTip!.nextLevelFreeDeliveryMoney}", 2, 13.sp));
          break;
      }
    }

    ///如果文字超长，整体字号缩小两号
    if ((deliverType == 2 || deliverType == 3) &&
        (gradientFreeType == 1 || gradientFreeType == 2)) {
      for (var element in spans) {
        element.fontSize -= 2.sp;
      }
    }
    return spans;
  }

  TextSpan _buildText(Span span) {
    return TextSpan(
      text: span.text,
      style: TextStyle(
        fontSize: span.fontSize,
        color: span.type == 1 ? CottiColor.textGray : CottiColor.textBlack,
        decoration: span.type == 3 ? TextDecoration.lineThrough : TextDecoration.none,
        fontFamily: span.type == 2 ? 'DDP4' : null,
      ),
    );
  }
}

class Span {
  String text;

  //1是文案，2是金额，3是划线金额
  int type;
  double fontSize;

  Span(this.text, this.type, this.fontSize);
}
