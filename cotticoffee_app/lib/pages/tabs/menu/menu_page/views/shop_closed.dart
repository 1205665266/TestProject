import 'dart:ui';

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';
import 'package:cotti_client/widget/box_move_animation.dart';
import 'package:cotti_client/widget/shop_closed_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Description: 门店闭店展示
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/8 14:37
class ShopClosed extends StatefulWidget {
  /// 店铺营业时间
  final String shopOperateStr;

  ///是否是强制闭店[forceClosed]默认false
  final bool forceClosed;

  const ShopClosed({
    Key? key,
    required this.shopOperateStr,
    this.forceClosed = false,
  }) : super(key: key);

  @override
  State<ShopClosed> createState() => _ShopClosedState();
}

class _ShopClosedState extends State<ShopClosed> {
  final ValueNotifier<bool> _animationChange = ValueNotifier(false);
  final ValueNotifier<bool> _closedChange = ValueNotifier(false);
  Duration duration = const Duration(milliseconds: 150);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: widget.forceClosed ? _buildForceClosed() : _buildClosedWidget(),
        ),
        ShopClosedInfo(
          duration: duration,
          animationChange: _animationChange,
          shopOperateStr: widget.shopOperateStr,
          clickClose: () => _closeDetail(),
        ),
      ],
    );
  }

  Widget _buildClosedWidget() {
    return BoxMoveAnimation(
      initShow: true,
      animationChange: _closedChange,
      duration: duration,
      child: GestureDetector(
        onTap: () async {
          _closedChange.value = true;
          await Future.delayed(duration);
          _animationChange.value = true;
          setState(() {});
        },
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
            ),
            child: Container(
              height: 48.h,
              color: CottiColor.textHint.withOpacity(0.8),
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '本店休息中',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images/menu/icon_shop_closed_close.svg',
                    width: 16.w,
                    height: 16.w,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildForceClosed() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: GestureDetector(
          onTap: () {
            int takeMode = context.read<ShopMatchBloc>().state.curTakeFoodMode;
            if (takeMode == Constant.selfTakeModeCode) {
              context.read<ShopMatchBloc>().add(SelfTakeMatchShopEvent(context: context));
            } else if (takeMode == Constant.takeOutModeCode) {
              MemberAddressEntity? address = context.read<ShopMatchBloc>().state.address;
              if (address != null) {
                context.read<ShopMatchBloc>().add(ShopInfoByAddressEvent(address));
              }
            }
          },
          child: Container(
            height: 48.h,
            color: CottiColor.textGray.withOpacity(0.8),
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            alignment: Alignment.centerLeft,
            child: Text(
              '闭店升级中',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _closeDetail() async {
    _animationChange.value = false;
    await Future.delayed(duration);
    _closedChange.value = false;
    setState(() {});
  }
}
