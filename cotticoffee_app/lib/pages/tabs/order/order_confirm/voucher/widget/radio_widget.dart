import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RadioWidget extends StatelessWidget {
  final bool checked;
  double size;
  Color? seleColor;
  Color? noreColor;

  RadioWidget({Key? key, required this.checked, this.size = 18, this.seleColor, this.noreColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return checked
        ? SvgPicture.asset(
            'assets/images/order/order_confirm/icon_coupon_selected1.svg',
            width: size,
            height: size,
            color: seleColor ?? CottiColor.primeColor,
          )
        : SvgPicture.asset(
            'assets/images/order/order_confirm/icon_coupon_unselected.svg',
            width: size,
            height: size,
            color: noreColor ?? CottiColor.textHint,
          );
  }
}
