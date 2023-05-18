import 'package:abitelogin/abitelogin.dart';
import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/home/view/coupon_item.dart';
import 'package:cotti_client/pages/tabs/home/view/effect_widget.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_event.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_state.dart';
import 'package:cotti_client/pages/tabs/tab_page.dart';
import 'package:cotti_client/sensors/home_sensors.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/31 17:36
class UserBanner extends StatefulWidget {
  const UserBanner({Key? key}) : super(key: key);

  @override
  State<UserBanner> createState() => _UserBannerState();
}

class _UserBannerState extends State<UserBanner> {
  @override
  Widget build(BuildContext context) {
    return EffectWidget(child: _buildContent());
  }

  _buildContent() {
    return BlocBuilder<MineBloc, MineState>(
      builder: (context, mineState) {
        return BlocConsumer<UserBloc, UserState>(
          listenWhen: (p, c) => p.status != UserStatus.loggedIn && c.status == UserStatus.loggedIn,
          listener: (context, state) => context.read<MineBloc>().add(InitUserInfoEvent()),
          builder: (context, userState) {
            if (userState.status == UserStatus.loggedIn) {
              return _buildUserInfo(mineState, userState);
            } else {
              SensorsAnalyticsFlutterPlugin.track(HomeSensors.homeFunctionLoginView, {});
              return ABiteBanner(
                bannerParam: BannerParam('cotti-index-userBar-notLogin-sfv1.1'),
                borderRadius: BorderRadius.all(Radius.circular(4.r)),
                width: 343.w,
                fit: BoxFit.fitWidth,
                resize: true,
                onTapItemCallBack: (model) {
                  SensorsAnalyticsFlutterPlugin.track(HomeSensors.homeFunctionLoginClick, {});
                  LoginUtils.login(context).then((value) {
                    context.read<MineBloc>().add(InitUserInfoEvent());
                  });
                },
              );
            }
          },
        );
      },
    );
  }

  _buildUserInfo(MineState mineState, UserState userState) {
    List<String> split = mineState.promptStr?.split('\n') ?? [];
    String nickname = mineState.userInfoEntity?.nickname ?? '';
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        ABiteBanner(
          bannerParam: BannerParam('cotti-index-userBar-logined-sfv1.1'),
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
          width: 343.w,
          resize: true,
        ),
        Row(
          children: [
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: () =>
                  GlobalBlocs.get(GlobalBloc.blocName).add(SwitchTabEvent(TabEnum.mine.index)),
              child: SizedBox(
                width: 40.w,
                height: 40.w,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CottiImageWidget(
                      mineState.userInfoEntity?.headPortrait ??
                          'https://cdn-product-prod.yummy.tech/wechat/cotti/images/mine/ic_user_no_login.png',
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    Positioned(
                      left: -7.w,
                      bottom: -7.w,
                      child: ABiteBanner(
                        bannerParam: BannerParam('cotti-common-avatar-easterEgg'),
                        resize: true,
                        width: 54.w,
                        fit: BoxFit.fitWidth,
                        onTapItemCallBack: (item) => GlobalBlocs.get(GlobalBloc.blocName)
                            .add(SwitchTabEvent(TabEnum.mine.index)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (split.isNotEmpty)
                    Text(
                      split[0].replaceAll(
                        '\$nickname\$',
                        nickname.isNotEmpty
                            ? nickname
                            : StringUtil.mobilePhoneEncode(userState.userModel?.mobile),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: CottiColor.textBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (split.length > 1)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        split[1].trim(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: CottiColor.textBlack,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _buildCouponInfo(mineState),
          ],
        ),
      ],
    );
  }

  _buildCouponInfo(MineState mineState) {
    if (mineState.couponBountyEntity == null) {
      return const SizedBox();
    }
    int availableVoucherCount = mineState.couponBountyEntity?.couponMsg?.availableVoucherCount ?? 0;
    int closeExpiryVoucherCount =
        mineState.couponBountyEntity?.couponMsg?.closeExpiryVoucherCount ?? 0;
    int expiringSoonCouponAmount =
        mineState.couponBountyEntity?.couponMsg?.expiringSoonCouponAmount ?? 0;
    int totalCouponAmount = mineState.couponBountyEntity?.couponMsg?.totalCouponAmount ?? 0;
    return CouponItem(
      availableVoucherCount: availableVoucherCount,
      closeExpiryVoucherCount: closeExpiryVoucherCount,
      expiringSoonCouponAmount: expiringSoonCouponAmount,
      totalCouponAmount: totalCouponAmount,
    );
  }
}
