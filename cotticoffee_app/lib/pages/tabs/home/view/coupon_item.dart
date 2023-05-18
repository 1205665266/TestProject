import 'dart:math';

import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_event.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/widget/cotti_vertical_divider.dart';
import 'package:cotti_client/widget/triangle_painter.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/20 19:12
class CouponItem extends StatefulWidget {
  final int availableVoucherCount;
  final int closeExpiryVoucherCount;
  final int expiringSoonCouponAmount;
  final int totalCouponAmount;

  const CouponItem({
    Key? key,
    required this.availableVoucherCount,
    required this.closeExpiryVoucherCount,
    required this.expiringSoonCouponAmount,
    required this.totalCouponAmount,
  }) : super(key: key);

  @override
  State<CouponItem> createState() => _CouponItemState();
}

class _CouponItemState extends State<CouponItem>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _couponController;
  late AnimationController _voucherController;
  late CurvedAnimation _couponAnimation;
  late CurvedAnimation _voucherAnimation;
  final Duration _duration = const Duration(milliseconds: 450);

  @override
  void initState() {
    super.initState();
    _couponController = AnimationController(duration: _duration, vsync: this);
    _voucherController = AnimationController(duration: _duration, vsync: this);
    Animation<double> couponAnimation = Tween(begin: 0.0, end: 1.0).animate(_couponController);
    Animation<double> voucherAnimation = Tween(begin: 0.0, end: 1.0).animate(_voucherController);
    _couponAnimation = CurvedAnimation(parent: couponAnimation, curve: Curves.easeOutBack);
    _voucherAnimation = CurvedAnimation(parent: voucherAnimation, curve: Curves.easeOutBack);
    WidgetsBinding.instance?.addPostFrameCallback((_) => _showExpiryCount());
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.availableVoucherCount > 0 || widget.totalCouponAmount > 0)
          Container(
            height: 32.h,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            child: CottiVerticalDivider(
              dividerColor: CottiColor.dividerGray,
              dividerWidth: 1.w,
            ),
          ),
        if (widget.availableVoucherCount > 0)
          _couponItem(
            "代金券",
            widget.availableVoucherCount,
            widget.closeExpiryVoucherCount,
            _voucherAnimation,
            () {
              NavigatorUtils.push(context, MineRouter.cashPackageListPage).then(
                (value) => context.read<MineBloc>().add(InitUserInfoEvent()),
              );
            },
          ),
        if (widget.totalCouponAmount > 0)
          _couponItem(
            "优惠券",
            widget.totalCouponAmount,
            widget.expiringSoonCouponAmount,
            _couponAnimation,
            () {
              NavigatorUtils.push(context, MineRouter.couponListPage).then(
                (value) => context.read<MineBloc>().add(InitUserInfoEvent()),
              );
            },
          ),
      ],
    );
  }

  _couponItem(String name, int num, int expiringCoupon, animation, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 50.w,
        margin: EdgeInsets.only(right: 8.w),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Text(
                  "$num",
                  style: TextStyle(
                    color: CottiColor.textBlack,
                    fontSize: 16.sp,
                    fontFamily: "DDP6",
                  ),
                ),
                if (expiringCoupon > 0)
                  Positioned(
                    top: -20.h,
                    child: _buildDueCoupon(animation, expiringCoupon),
                  ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              name,
              style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDueCoupon(CurvedAnimation animation, int expiringCoupon) {
    return ScaleTransition(
      scale: animation,
      alignment: Alignment.bottomCenter,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: CottiColor.primeColor,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Text(
              '${expiringCoupon > 99 ? "99+" : expiringCoupon} 张即将过期',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.sp,
              ),
            ),
          ),
          Positioned(
            bottom: -3.h,
            child: Transform.rotate(
              angle: pi,
              child: CustomPaint(
                painter: TrianglePainter(CottiColor.primeColor),
                size: Size(10.w, 4.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _voucherController.reset();
        _couponController.reset();
        _showExpiryCount();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  _showExpiryCount() async {
    if (widget.closeExpiryVoucherCount > 0 && widget.expiringSoonCouponAmount > 0) {
      await Future.delayed(const Duration(milliseconds: 800));
      await _voucherController.forward();
      await Future.delayed(const Duration(milliseconds: 1500));
      await _voucherController.reverse();
      await Future.delayed(const Duration(milliseconds: 800));
      await _couponController.forward();
      await Future.delayed(const Duration(milliseconds: 1500));
      await _couponController.reverse();
    } else if (widget.closeExpiryVoucherCount > 0) {
      await Future.delayed(const Duration(milliseconds: 800));
      await _voucherController.forward();
    } else if (widget.expiringSoonCouponAmount > 0) {
      await Future.delayed(const Duration(milliseconds: 800));
      await _couponController.forward();
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    _voucherController.dispose();
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }
}
