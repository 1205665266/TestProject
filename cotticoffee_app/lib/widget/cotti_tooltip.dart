import 'dart:async';

import 'package:cotti_client/widget/simple_tooltip/simple_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/3 14:48
class CottiTooltip extends StatefulWidget {
  ///提示文案
  final String tip;

  ///
  final Widget child;

  ///Tip弹出的方向
  final TooltipDirection tooltipDirection;

  ///点击任意位置Tip是否消失[clickAnywhereHide]默认true
  final bool clickAnywhereHide;

  ///Tip是否弹出[showControl.value = true 弹出,反之消失]
  final ValueNotifier<bool> showControl;

  ///箭头在Tip上的偏移量，默认剧中
  final Offset? targetCenter;

  ///弹出后多长时间关闭  [duration] 大于0生效，小于0或者null则无效
  final int? duration;

  final double? maxWidth;

  final RouteObserver<PageRoute>? routeObserver;

  final double? arrowTipDistance;

  const CottiTooltip({
    Key? key,
    required this.child,
    required this.tip,
    required this.showControl,
    this.targetCenter,
    this.tooltipDirection = TooltipDirection.down,
    this.clickAnywhereHide = true,
    this.duration,
    this.routeObserver,
    this.maxWidth,
    this.arrowTipDistance,
  }) : super(key: key);

  @override
  State<CottiTooltip> createState() => _CottiTooltipState();
}

class _CottiTooltipState extends State<CottiTooltip> with RouteAware {
  OverlayEntry? _overlayEntry;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.showControl.addListener(_showChangeHandle);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.showControl.value) {
        _addOverlay();
        _countDownHide();
      }
      widget.routeObserver?.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.showControl,
      builder: (BuildContext context, value, Widget? child) {
        return SimpleTooltip(
          show: value,
          tooltipDirection: widget.tooltipDirection,
          ballonPadding: EdgeInsets.all(0.w),
          backgroundColor: const Color(0xFF9A9899).withOpacity(0.9),
          borderWidth: 0,
          minWidth: 100.w,
          maxWidth: widget.maxWidth ?? 132.w,
          targetCenter: widget.targetCenter,
          minimumOutSidePadding: 8.w,
          borderRadius: 2.r,
          arrowLength: 6.w,
          arrowBaseWidth: 10.w,
          arrowTipDistance: widget.arrowTipDistance ?? 5.h,
          animationDuration: const Duration(milliseconds: 1),
          hideOnTooltipTap: true,
          routeObserver: widget.routeObserver,
          customShadows: const [],
          content: Text(
            widget.tip,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal,
              fontFamily: null,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }

  _addOverlay() {
    if (!widget.clickAnywhereHide) {
      return false;
    }
    if (_overlayEntry != null) {
      _removeOverlay();
    }
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          widget.showControl.value = false;
          _removeOverlay();
        },
        child: const SizedBox(),
      );
    });
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  _showChangeHandle() {
    if (widget.showControl.value) {
      _addOverlay();
      _countDownHide();
    }
  }

  _countDownHide() {
    _timer?.cancel();
    if ((widget.duration ?? 0) > 0) {
      _timer = Timer(
        Duration(seconds: widget.duration!),
        () {
          widget.showControl.value = false;
          _removeOverlay();
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _removeOverlay();
    _timer?.cancel();
    widget.showControl.removeListener(_removeOverlay);
    widget.routeObserver?.unsubscribe(this);
  }
}
