import 'dart:ui';

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/box_move_animation.dart';
import 'package:cotti_client/widget/shop_be_open_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/2/1 15:57
class ShopToBeOpened extends StatefulWidget {
  const ShopToBeOpened({Key? key}) : super(key: key);

  @override
  State<ShopToBeOpened> createState() => _ShopToBeOpenedState();
}

class _ShopToBeOpenedState extends State<ShopToBeOpened> {
  final ValueNotifier<bool> _animationChange = ValueNotifier(false);
  Duration duration = const Duration(milliseconds: 150);
  final ValueNotifier<bool> _closedChange = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _defaultOpen(context.read<ShopMatchBloc>().state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopMatchBloc, ShopMatchState>(
      listener: (context, state) {
        _defaultOpen(state);
      },
      builder: (context, state) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: buildBeOpen(state),
            ),
            ShopBeOpenInfo(
              clickClose: () => _closeDetail(),
              animationChange: _animationChange,
              duration: duration,
            ),
          ],
        );
      },
    );
  }

  Widget buildBeOpen(ShopMatchState state) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        BoxMoveAnimation(
          initShow: true,
          animationChange: _closedChange,
          duration: duration,
          child: Padding(
            padding: EdgeInsets.only(bottom: 48.h, right: 36.w),
            child: ABiteBanner(
              bannerParam: BannerParam('cotti-menu-openingSoon-barIcon'),
              width: 123.w,
              height: 0,
              resize: true,
            ),
          ),
        ),
        BoxMoveAnimation(
          initShow: true,
          animationChange: _closedChange,
          duration: duration,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10.0,
                sigmaY: 10.0,
              ),
              child: GestureDetector(
                onTap: () async {
                  await _openDetail();
                  int takeMode = context.read<ShopMatchBloc>().state.curTakeFoodMode;
                  if (takeMode == Constant.selfTakeModeCode) {
                    context.read<ShopMatchBloc>().add(SelfTakeMatchShopEvent(context: context));
                  }
                },
                child: Container(
                  height: 48.h,
                  color: CottiColor.textHint.withOpacity(0.8),
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.read<ConfigBloc>().state.guidanceToBeOpened,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            state.openDateContext,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          SvgPicture.asset(
                            'assets/images/menu/icon_shop_closed_close.svg',
                            width: 16.w,
                            height: 16.w,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _closeDetail() async {
    _animationChange.value = false;
    await Future.delayed(duration);
    _closedChange.value = false;
  }

  _openDetail() async {
    _closedChange.value = true;
    await Future.delayed(duration);
    _animationChange.value = true;
  }

  _defaultOpen(ShopMatchState state) {
    if (state.currentShopDetail?.guidanceToBeOpenedContext?.isExpand == true &&
        state.shopMdCode != null &&
        (!Constant.toBeOpenShopCodes.contains(state.shopMdCode!))) {
      Future.delayed(duration).then((value) {
        Constant.toBeOpenShopCodes.add(state.shopMdCode!);
        if (mounted) {
          _openDetail();
        }
      });
    }
  }
}
