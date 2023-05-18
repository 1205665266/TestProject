import 'dart:async';

import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/widget/cotti_vertical_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/10 16:03
class CouponBottomActionBar extends StatefulWidget {
  final ScrollController controller;
  final double bottomActionBarHeight;
  final String mainTitle;
  final String subTitle;
  final VoidCallback mainClickCallback;
  final VoidCallback subClickCallback;

  const CouponBottomActionBar({
    Key? key,
    required this.controller,
    required this.bottomActionBarHeight,
    required this.mainTitle,
    required this.mainClickCallback,
    required this.subClickCallback,
    this.subTitle = '',
  }) : super(key: key);

  @override
  State<CouponBottomActionBar> createState() => _CouponBottomActionBarState();
}

class _CouponBottomActionBarState extends State<CouponBottomActionBar> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _animationSlide;
  late Animation<double> _animationFade;
  bool isVisible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animationSlide =
        Tween(begin: Offset.zero, end: const Offset(0.0, 1.0)).animate(_slideController);
    _animationFade = Tween(begin: 1.0, end: .0).animate(_fadeController);
    widget.controller.addListener(() {
      if (widget.controller.offset <= 0) {
        return;
      }
      if (isVisible) {
        _slideController.forward();
        _fadeController.forward();
        isVisible = false;
      }
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 500), () {
        _slideController.reverse();
        _fadeController.reverse();
        isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationFade,
      child: SlideTransition(
        position: _animationSlide,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(25, 70, 106, 0.05),
                offset: Offset(0, -2.h),
                blurRadius: 7.r,
                spreadRadius: 0,
              ),
            ],
          ),
          child: _buildButton(),
        ),
      ),
    );
  }

  _buildButton() {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: widget.bottomActionBarHeight,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => widget.mainClickCallback(),
                child: Text(
                  widget.mainTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CottiColor.textGray,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (widget.subTitle.isNotEmpty)
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.subClickCallback(),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      CottiVerticalDivider(
                        dividerWidth: 1.w,
                        dividerMargin: EdgeInsets.only(top: 12.h, bottom: 5.h),
                        dividerColor: CottiColor.dividerGray,
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: EdgeInsets.only(top: 7.h),
                        child: Text(
                          widget.subTitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: CottiColor.textGray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 7.h),
                        child: SvgPicture.asset("assets/images/mine/ic_exchange_right.svg"),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
