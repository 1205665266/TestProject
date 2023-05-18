import 'package:abitelogin/pages/util/login_utils.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_state.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/sensors/mine_sensors_constant.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/10 4:29 PM
class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({Key? key}) : super(key: key);

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          child: ABiteBanner(
            bannerParam: BannerParam('cotti-my-bg-banner'),
            width: ScreenUtil().screenWidth,
            fit: BoxFit.fitWidth,
            resize: true,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 217.h, left: 16.w, right: 16.w),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              return BlocBuilder<MineBloc, MineState>(
                builder: (context, state) {
                  return _buildContent(userState, state);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContent(UserState userState, MineState state) {
    return GestureDetector(
      onTap: () {
        goEditUserPage();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 64.w,
            height: 64.w,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CottiImageWidget(
                  (userState.status == UserStatus.loggedIn
                          ? state.userInfoEntity?.headPortrait
                          : null) ??
                      'https://cdn-product-prod.yummy.tech/wechat/cotti/images/mine/ic_user_no_login.png',
                  borderRadius: BorderRadius.circular(34.r),
                ),
                Positioned(
                  left: -12.w,
                  bottom: -12.w,
                  child: ABiteBanner(
                    width: 88.w,
                    fit: BoxFit.fitWidth,
                    resize: true,
                    bannerParam: BannerParam("cotti-common-avatar-easterEgg"),
                    onTapItemCallBack: (_) {
                      goEditUserPage();
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Container(
              height: 38.h,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          Constant.hasLogin ? _getShowNickName(userState, state) : '未登录',
                          style: TextStyle(
                            color: CottiColor.textBlack,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Icon(IconFont.icon_right),
                    ],
                  ),
                  Visibility(
                    visible: userState.status == UserStatus.loggedIn,
                    child: Text(
                      userState.status == UserStatus.loggedIn
                          ? StringUtil.mobilePhoneEncode(userState.userModel?.mobile)
                          : '',
                      style: TextStyle(
                        color: CottiColor.textGray,
                        fontSize: 12.sp,
                      ),
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

  goEditUserPage() {
    SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.informationMineClick, {});
    if (Constant.hasLogin) {
      NavigatorUtils.push(context, MineRouter.editUserPage);
    } else {
      LoginUtils.login(context);
    }
  }

  /// nickName为空时显示手机号
  String _getShowNickName(UserState userState, MineState state) {
    String? nickName = state.userInfoEntity?.nickname;
    return nickName ?? StringUtil.mobilePhoneEncode(userState.userModel?.mobile);
  }
}
