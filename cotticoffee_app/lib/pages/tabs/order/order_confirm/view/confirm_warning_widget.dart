import 'package:cotti_client/global/style.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmWarningWidget extends StatefulWidget {
  final Widget child;

  const ConfirmWarningWidget({Key? key, required this.child}) : super(key: key);

  @override
  _ConfirmWarningWidgetState createState() {
    return _ConfirmWarningWidgetState();
  }
}

class _ConfirmWarningWidgetState extends State<ConfirmWarningWidget> with TickerProviderStateMixin {
  double scaleY = 1;
  double scaleX = 1;

  double bgOpacity = 0;

  late AnimationController _controller;
  // late AnimationController _opacityController;
  late CurvedAnimation _curvedAnimation;

  int count = 0;

  bool showMark = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    // _opacityController = AnimationController(duration: const Duration(milliseconds: 3700), vsync: this);

    _curvedAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.addStatusListener((AnimationStatus status) {
      if (AnimationStatus.completed == status) {
        _controller.reset();
        count++;
        if (count < 2) {
          _controller.forward();
        } else {
          if (mounted) {
            setState(() {
              showMark = false;
            });
          }
        }
      }
    });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      RenderBox? renderBox = context.findRenderObject() as RenderBox?;

      Size? size = renderBox?.size ?? Size.zero;

      double width = 22.w;
      double height = 22.h;

      scaleY = height / size.height;
      scaleX = width / size.width;

      HapticFeedback.heavyImpact();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scaleY: (scaleY * _controller.value) + 1,
                scaleX: 1 + (scaleX * _controller.value),
                child: AnimatedBuilder(
                    animation: _curvedAnimation,
                    builder: (BuildContext oContext, Widget? cChild) {
                      return Opacity(
                        opacity: (1 - _curvedAnimation.value),
                        child: child,
                      );
                    },
                ),
              );
            },
            child: Visibility(
              visible: showMark,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE7E5).withOpacity(0),
                  border: Border.all(color: CottiColor.primeColor, width: 1.4.w),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return Opacity(
                opacity: 1 - _controller.value,
                child: child,
              );
            },
            child: Visibility(
              visible: showMark,
              child: Container(
                decoration: BoxDecoration(
                  color: CottiColor.primeColor.withOpacity(0.15),
                  border: Border.all(color: CottiColor.primeColor, width: 1.w),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.reset();
    _controller.removeStatusListener((status) {});
    super.dispose();
  }
}
