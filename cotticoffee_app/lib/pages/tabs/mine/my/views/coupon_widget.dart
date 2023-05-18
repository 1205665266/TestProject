import 'package:abitelogin/abitelogin.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_event.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/sensors/mine_sensors_constant.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import '../bloc/mine_state.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/11 3:09 PM
class CouponWidget extends StatelessWidget {
  CouponWidget({Key? key}) : super(key: key);

  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        return BlocBuilder<MineBloc, MineState>(
          builder: (context, state) {
            if (Constant.hasLogin) {
              return _buildCouponInfo(state);
            } else {
              return Container(
                margin: EdgeInsets.only(top: 12.h),
                child: ABiteBanner(
                  bannerParam: BannerParam("cotti-my-unlogin-banner"),
                  borderRadius: BorderRadius.circular(4.r),
                  resize: true,
                  onTapItemCallBack: (bannerMode) {
                    if (!Constant.hasLogin) {
                      LoginUtils.login(context);
                    }
                  },
                ),
              );
            }
          },
        );
      },
    );
  }

  _buildCouponInfo(state) {
    bool display = state.couponBountyEntity?.bountyMsg?.display ?? false;
    // display = true;

    /// 是否显示代金券
    ConfigBloc cBloc = GlobalBlocs.get<ConfigBloc>(ConfigBloc.blocName);
    bool showVoucher = cBloc.state.configEntity?.showVoucher ?? false;
    int voucherNum = state.couponBountyEntity?.couponMsg?.availableVoucherCount ?? 0;

    bool displayVoucher = showVoucher || (voucherNum > 0);
    // displayVoucher = true;

    if (displayVoucher && display) {
      return _buildFullWidget(state);
    } else if (displayVoucher && !display) {
      return _buildCouponVoucherWidget(state);
    }

    return _buildNoVoucherWidget(state);
  }

  Widget _buildNoVoucherWidget(state) {
    num totalCouponAmount = state.couponBountyEntity?.couponMsg?.totalCouponAmount ?? 0;
    num expiringSoonCouponAmount =
        state.couponBountyEntity?.couponMsg?.expiringSoonCouponAmount ?? 0;
    num bounty = state.couponBountyEntity?.bountyMsg?.bounty ?? 0;
    bool display = state.couponBountyEntity?.bountyMsg?.display ?? false;
    // display = true;

    List<Widget> actions() {
      List<Widget> list = [];
      list.add(
        GestureDetector(
          onTap: () => gotoCouponPage(),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: _buildCoupon(
              '优惠券',
              totalCouponAmount,
              expiringSoonCouponAmount > 0 ? '$expiringSoonCouponAmount 张即将过期' : '',
              gotoCouponPage,
            ),
          ),
        ),
      );
      if (display) {
        list.add(Expanded(
          flex: 2,
          child: Container(),
        ));
        list.add(
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: 12.w, bottom: 12.w, right: 12.w),
              child: _buildCoupon('奖励金', bounty, '', gotoBountyPage, showBanner: true),
            ),
          ),
        );
      } else {
        list.add(_buildOnlyCouponBanner());
      }

      return list;
    }

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: actions(),
          ),
        ),
      ),
    );
  }

  Widget _buildCouponVoucherWidget(state) {
    num totalCouponAmount = state.couponBountyEntity?.couponMsg?.totalCouponAmount ?? 0;
    num expiringSoonCouponAmount =
        state.couponBountyEntity?.couponMsg?.expiringSoonCouponAmount ?? 0;

    num availableVoucherCount = state.couponBountyEntity?.couponMsg?.availableVoucherCount ?? 0;
    num closeExpiryVoucherCount = state.couponBountyEntity?.couponMsg?.closeExpiryVoucherCount ?? 0;

    return Container(
      margin: EdgeInsets.only(top: 4.h),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(4.r),
          bottomLeft: Radius.circular(4.r),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 70.h,
                ),
                child: ABiteBanner(
                  bannerParam: BannerParam("cotti-my-coupon-bg-banner"),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(top: 12.h, bottom: 10.h),
                color: Colors.transparent,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCVItem(
                        title: "代金券",
                        number: availableVoucherCount,
                        expiring: closeExpiryVoucherCount,
                        onTap: () {
                          gotoVoucherPage();
                        },
                      ),
                      Container(
                        color: CottiColor.dividerGray,
                        width: 1.w,
                        margin: EdgeInsets.only(bottom: 3.h, top: 2.h),
                      ),
                      _buildCVItem(
                        title: "优惠券",
                        number: totalCouponAmount,
                        expiring: expiringSoonCouponAmount,
                        onTap: () {
                          gotoCouponPage();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCVItem(
      {required String title,
      required num number,
      required GestureTapCallback onTap,
      num expiring = 0}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(left: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: CottiColor.textGray,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$number",
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: "DDP5",
                        fontWeight: FontWeight.w500,
                        color: CottiColor.textBlack,
                        height: 1),
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  Visibility(
                    visible: expiring > 0,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0.h),
                      child: Row(
                        children: [
                          Text(
                            "$expiring",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: "DDP5",
                              fontWeight: FontWeight.w500,
                              color: CottiColor.primeColor,
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            "张即将过期",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: CottiColor.textGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 代金券、优惠券、奖励金全部显示的完整版
  Widget _buildFullWidget(state) {
    num totalCouponAmount = state.couponBountyEntity?.couponMsg?.totalCouponAmount ?? 0;
    num expiringSoonCouponAmount =
        state.couponBountyEntity?.couponMsg?.expiringSoonCouponAmount ?? 0;

    num availableVoucherCount = state.couponBountyEntity?.couponMsg?.availableVoucherCount ?? 0;
    num closeExpiryVoucherCount = state.couponBountyEntity?.couponMsg?.closeExpiryVoucherCount ?? 0;

    num bountyCount = state.couponBountyEntity?.bountyMsg?.bounty ?? 0;

    return Container(
      margin: EdgeInsets.only(top: 14.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: Container(
          padding: EdgeInsets.only(top: 12.h, bottom: 10.h),
          color: Colors.white,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVerticalItem(
                  title: "代金券",
                  number: availableVoucherCount,
                  expiring: closeExpiryVoucherCount,
                  onTap: () {
                    gotoVoucherPage();
                  },
                ),
                Container(
                  color: CottiColor.dividerGray,
                  width: 1.w,
                  margin: EdgeInsets.only(bottom: 3.h, top: 2.h),
                ),
                _buildVerticalItem(
                  title: "优惠券",
                  number: totalCouponAmount,
                  expiring: expiringSoonCouponAmount,
                  onTap: () {
                    gotoCouponPage();
                  },
                ),
                Container(
                  color: CottiColor.dividerGray,
                  width: 1.w,
                  margin: EdgeInsets.only(bottom: 2.h),
                ),
                _buildVerticalItem(
                  title: "奖励金",
                  number: bountyCount,
                  onTap: () {
                    gotoBountyPage();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalItem(
      {required String title,
      required num number,
      required GestureTapCallback onTap,
      num expiring = 0}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "$number",
                style: TextStyle(
                  fontSize: 24.sp,
                  color: CottiColor.textBlack,
                  fontWeight: FontWeight.w500,
                  fontFamily: "DDP5",
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: CottiColor.textGray,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Offstage(
                offstage: expiring == 0,
                child: Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$expiring",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: CottiColor.primeColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: "DDP5",
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        "张即将过期",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: CottiColor.textHint,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildOnlyCouponBanner() {
    return SizedBox(
      height: 68.h,
      child: ABiteBanner(
        bannerParam: BannerParam("cotti-my-onlyCoupon-banner"),
      ),
    );
  }

  /// showBanner 奖励金需要显示广告位
  _buildCoupon(String title, num number, String? des, VoidCallback callback,
      {bool showBanner = false}) {
    return GestureDetector(
      onTap: () {
        if (des != null && des.contains('张即将过期')) {
          SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.expireCouponMineClick, {});
        }
        callback();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: CottiColor.textGray,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$number',
                  style: TextStyle(
                    color: CottiColor.textBlack,
                    fontSize: 24.sp,
                    fontFamily: 'DDP5',
                  ),
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                    // height: 0.7,
                  ),
                ),
                if (!showBanner)
                  Offstage(
                    offstage: des?.isEmpty ?? true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 4.w),
                          child: Text(
                            des ?? '',
                            style: TextStyle(
                              color: CottiColor.textGray,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Icon(
                          IconFont.icon_youjiantou,
                          color: CottiColor.textGray,
                          size: 12.sp,
                        ),
                      ],
                    ),
                  ),
                if (showBanner)
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 10.h,
                      child: ABiteBanner(
                        fit: BoxFit.fitHeight,
                        bannerParam: BannerParam("cotti-my-bonus-banner"),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void gotoCouponPage() async {
    await NavigatorUtils.push(_context, MineRouter.couponListPage);

    /// 刷新优惠券数量信息，防止前后显示不一致；
    _context.read<MineBloc>().add(InitUserInfoEvent());
  }

  void gotoBountyPage() {
    logI('gotoBountyPage');
    SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.bonusMineClick, {});
    NavigatorUtils.push(_context, MineRouter.bonusPage);
  }

  void gotoVoucherPage() {
    NavigatorUtils.push(_context, MineRouter.cashPackageListPage)
        .then((value) => _context.read<MineBloc>().add(InitUserInfoEvent()));
  }
}
