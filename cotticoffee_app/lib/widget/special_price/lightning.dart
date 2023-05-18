import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/menu/entity/special_activity_limit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/28 16:05
class Lightning extends StatefulWidget {
  final SpecialActivityLimit special;
  final int quantity;

  const Lightning({Key? key, required this.special, required this.quantity}) : super(key: key);

  @override
  State<Lightning> createState() => _LightningState();
}

class _LightningState extends State<Lightning> {
  late String specialActivityLabel;

  @override
  void initState() {
    super.initState();
    specialActivityLabel = context.read<ConfigBloc>().state.specialActivityLabel;
  }

  @override
  Widget build(BuildContext context) {
    List<Span> spans = calcShowText();
    if (spans.isEmpty) {
      return const SizedBox();
    }
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(1.r),
        bottomRight: Radius.circular(1.r),
      ),
      child: Stack(
        children: [
          SvgPicture.asset(
            "assets/images/icon_lightning.svg",
            color: CottiColor.primeColor,
            height: 16.h,
          ),
          Container(
            height: 16.h,
            margin: EdgeInsets.only(left: 2.w),
            padding: EdgeInsets.only(left: 8.w, right: 3.w),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: 1.w, color: CottiColor.primeColor),
                top: BorderSide(width: 1.w, color: CottiColor.primeColor),
                bottom: BorderSide(width: 1.w, color: CottiColor.primeColor),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(spans.length, (index) {
                return Text(
                  spans[index].text,
                  style: TextStyle(
                    color: CottiColor.primeColor,
                    fontSize: spans[index].fontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: spans[index].isDDP ? "DDP6" : null,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  List<Span> calcShowText() {
    List<Span> spans = [];
    int limitAmount = widget.special.limitAmount ?? 0;
    double limitProgressBar = widget.special.limitProgressBar ?? 0;
    double? discountRate = widget.special.discountRate;
    switch (widget.special.activityShowType) {
      case 0:
      case 4:
        if (discountRate == null) {
          spans.add(Span(specialActivityLabel, 10.sp));
        } else {
          spans.add(Span(specialActivityLabel, 10.sp));
          spans.add(Span(" | ", 9.sp));
          spans.add(Span("${Decimal.parse('$discountRate')}", 13.sp, isDDP: true));
          spans.add(Span("折", 10.sp));
        }
        break;
      case 1:
      case 2:
        if (limitAmount > 0) {
          spans.add(Span("限购", 10.sp));
          spans.add(Span("$limitAmount", 13.sp, isDDP: true));
          spans.add(Span("件", 10.sp));
        }
        break;
      case 3:
        int count = limitAmount < widget.quantity ? limitAmount : widget.quantity;
        if (count > 0) {
          spans.add(Span("仅剩", 10.sp));
          spans.add(Span("$count", 13.sp, isDDP: true));
          spans.add(Span("件", 10.sp));
        }
        break;
      case 5:
        spans.add(Span("已抢", 10.sp));
        spans.add(
            Span(Decimal.parse("${limitProgressBar * 100}").toString() + "%", 13.sp, isDDP: true));
        break;
    }
    return spans;
  }
}

class Span {
  String text;

  double fontSize;

  bool isDDP;

  Span(this.text, this.fontSize, {this.isDDP = false});
}
