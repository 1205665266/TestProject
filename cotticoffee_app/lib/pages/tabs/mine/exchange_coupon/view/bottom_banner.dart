import 'dart:async';

import 'package:cotti_client/pages/tabs/mine/exchange_coupon/bloc/exchange_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/bloc/exchange_state.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/box_move_animation.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/2/14 15:53
class BottomBanner extends StatefulWidget {
  const BottomBanner({Key? key}) : super(key: key);

  @override
  State<BottomBanner> createState() => _BottomBannerState();
}

class _BottomBannerState extends State<BottomBanner> {
  final ValueNotifier<bool> _moveChange = ValueNotifier(false);
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExchangeBloc, ExchangeState>(
      listenWhen: (previous, current) =>
          previous.exchangeSuccessTime != current.exchangeSuccessTime,
      listener: (context, state) {
        logI("in listener !!");
        HapticFeedback.heavyImpact();
        _moveChange.value = true;
        _countDownHide();
      },
      builder: (context, state) {
        return BoxMoveAnimation(
          animationChange: _moveChange,
          duration: const Duration(seconds: 1),
          child: _buildContent(state),
        );
      },
    );
  }

  _buildContent(ExchangeState state) {

    String bannerCode = (state.validateEntity?.templateType??1) == 1 ? "cotti-couponExchange-success" : "cotti-voucherExchange-success";

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            bottom: 45.h,
            left: 8.w,
            // right: 0,
            child: ABiteBanner(
              key: UniqueKey(),
              // bannerParam: BannerParam('cotti-couponExchange-success'),
              bannerParam: BannerParam(bannerCode),
              width: 359.w,
              resize: true,
            ),
          ),
          Positioned(
            left: 92.w,
            right: 99.w,
            bottom: 45.h,
            child: SizedBox(
              height: 42.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          state.couponExchange?.couponName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (state.validateEntity?.templateProductType??0) == 3,
                          child: Container(
                            height: 16.w,
                            padding: EdgeInsets.symmetric(horizontal: 2.w,),
                            constraints: BoxConstraints(
                              minWidth: 16.w,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFEFE),
                              borderRadius: BorderRadius.circular(8.w),
                            ),
                            margin: EdgeInsets.only(left: 4.w),
                            alignment: Alignment.center,
                            child: Text(
                              "x${state.couponExchange?.num}",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: "DDP5",
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFCD4444),
                                height: 1,
                              ),
                              strutStyle: StrutStyle(
                                forceStrutHeight: true,
                                height: 1,
                              ),
                            ),
                          ),
                      ),
                    ],
                  ),

                  if (state.couponExchange?.couponSubtitle?.isNotEmpty ?? false)
                    Text(
                      state.couponExchange?.couponSubtitle ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _countDownHide() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 8), () {
      _moveChange.value = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
