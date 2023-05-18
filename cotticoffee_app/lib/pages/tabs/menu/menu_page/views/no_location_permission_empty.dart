import 'dart:io';

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

/// Description: 没有定位权限显示的占位页面
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/8 14:02
class NoLocationPermissionEmpty extends StatefulWidget {
  const NoLocationPermissionEmpty({Key? key}) : super(key: key);

  @override
  State<NoLocationPermissionEmpty> createState() => _NoLocationPermissionEmptyState();
}

class _NoLocationPermissionEmptyState extends State<NoLocationPermissionEmpty> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopMatchBloc, ShopMatchState>(
      builder: (context, state) {
        return Visibility(
          visible: state.currentShopDetail == null &&
              state.locationResult != null &&
              state.locationResult?.errorCode != 0 &&
              state.curTakeFoodMode == Constant.selfTakeModeCode,
          child: Container(
            color: CottiColor.backgroundColor,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 175.h),
            child: Column(
              children: [
                SizedBox(height: 100.h),
                SvgPicture.asset(
                  'assets/images/menu/icon_no_location_permission.svg',
                  width: 140.w,
                  height: 120.h,
                ),
                SizedBox(height: 32.h),
                Text(
                  '呃...COTTI 无法定位到您哦',
                  style: TextStyle(
                    color: CottiColor.textBlack,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                state.locationResult?.errorCode == 12 ||
                        (Platform.isIOS && state.locationResult?.errorCode == 2)
                    ? _buildNoLocation()
                    : _buildLocationError()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoLocation() {
    return Column(
      children: [
        Text(
          '可开启定位或手动选择门店',
          style: TextStyle(
            color: const Color(0xFF666666),
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 44.h),
        GestureDetector(
          onTap: () => openAppSettings(),
          child: Container(
            width: 144.w,
            height: 39.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CottiColor.primeColor,
              borderRadius: BorderRadius.all(Radius.circular(2.r)),
            ),
            child: Text(
              '开启定位',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: () => NavigatorUtils.push(context, CommonPageRouter.storeListPage),
          child: Container(
            width: 144.w,
            height: 39.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 0.5.w, color: CottiColor.primeColor),
              borderRadius: BorderRadius.all(Radius.circular(2.r)),
              color: Colors.white,
            ),
            child: Text(
              '选择门店',
              style: TextStyle(
                color: CottiColor.primeColor,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationError() {
    return Column(
      children: [
        Text(
          '请查看手机系统设置中定位授权是否开启',
          style: TextStyle(
            color: const Color(0xFF666666),
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 44.h),
        GestureDetector(
          onTap: () => context.read<ShopMatchBloc>().add(SelfTakeMatchShopEvent()),
          child: Container(
            width: 144.w,
            height: 39.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CottiColor.primeColor,
              borderRadius: BorderRadius.all(Radius.circular(2.r)),
            ),
            child: Text(
              '刷新定位',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
