import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Description:附近没有门店空白页
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/9 14:03
class NoStoresNearby extends StatefulWidget {
  const NoStoresNearby({Key? key}) : super(key: key);

  @override
  State<NoStoresNearby> createState() => _NoStoresNearbyState();
}

class _NoStoresNearbyState extends State<NoStoresNearby> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopMatchBloc, ShopMatchState>(
      builder: (context, state) {
        return Visibility(
          visible: state.selfTakeShopInfo != null &&
              state.selfTakeShopInfo?.shopDetail == null &&
              state.curTakeFoodMode == Constant.selfTakeModeCode,
          child: Container(
            color: CottiColor.backgroundColor,
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 175.h),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                children: [
                  _buildNoStore(state),
                  _buildBottomAd(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _buildNoStore(ShopMatchState state) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6.r)),
        color: Colors.white,
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset("assets/images/menu/@logo.svg"),
          ),
          Column(
            children: [
              SizedBox(height: 59.h),
              Image.asset(
                'assets/images/menu/icon_nearby_no_stores.png',
                width: 140.w,
                height: 120.h,
              ),
              SizedBox(height: 36.h),
              Text(
                state.selfTakeShopInfo?.shopMatchFailConfig?.shopMatchFailTitle ?? '',
                style: TextStyle(
                  color: CottiColor.textBlack,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ABiteBanner(
                margin: EdgeInsets.only(top: 59.h),
                bannerParam: BannerParam("cotti-menu-noShopsThisCity-guide"),
                width: 347.w,
                resize: true,
              ),
              SizedBox(height: 46.h),
            ],
          ),
        ],
      ),
    );
  }

  _buildBottomAd() {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: Offset(0, 1.h),
            blurRadius: 3.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ABiteBanner(
        bannerParam: BannerParam("cotti-menu-noShopsThisCity-banner"),
        borderRadius: BorderRadius.circular(6.r),
        width: 347.w,
        resize: true,
      ),
    );
  }
}
