import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/1/11 15:52
class FloatBanner extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final double? paddingBottom;

  const FloatBanner({
    Key? key,
    required this.child,
    required this.controller,
    this.paddingBottom,
  }) : super(key: key);

  @override
  State<FloatBanner> createState() => _FloatBannerState();
}

class _FloatBannerState extends State<FloatBanner> {
  final ValueNotifier<double> animationEnd = ValueNotifier(-8);
  Timer? _timer;
  final double start = -8;
  final double end = 42;

  ///是否回到初始位置
  bool isReset = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      isReset = false;
      animationEnd.value = end;
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 1), () {
        isReset = true;
        animationEnd.value = start;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ValueListenableBuilder(
          valueListenable: animationEnd,
          builder: (BuildContext context, double value, Widget? child) {
            return TweenAnimationBuilder(
              tween: Tween<double>(end: value),
              curve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 500),
              builder: (BuildContext context, double? value, Widget? child) {
                return Positioned(
                  right: (value ?? 0) * -1,
                  bottom: widget.paddingBottom ?? 20.h,
                  child: Opacity(
                    opacity: isReset ? 1 : 0.8,
                    child: widget.child,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
