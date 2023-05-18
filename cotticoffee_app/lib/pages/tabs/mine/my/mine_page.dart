import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/config/env.dart';
import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_event.dart';
import 'package:cotti_client/pages/tabs/mine/my/views/switch_env.dart';
import 'package:cotti_client/pages/tabs/tab_page.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/banner/widget/float_banner.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'views/coupon_widget.dart';
import 'views/function_list.dart';
import 'views/user_info_widget.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/8/31 1:44 下午
class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  final BannerController _windowBannerController = BannerController();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  bool get wantKeepAlive => true;

  init() {
    context.read<MineBloc>().add(InitUserInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      showAppBar: false,
      resizeToAvoidBottomInset: false,
      child: BlocListener<GlobalBloc, GlobalState>(
        bloc: GlobalBlocs.get(GlobalBloc.blocName),
        listenWhen: (p, c) => p.tabIndex != c.tabIndex && c.tabIndex == TabEnum.mine.index,
        listener: (gContext, gState) {
          init();
          _windowBannerController.reload();
        },
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            init();
            if (state.status == UserStatus.loggedIn) {
              String isNewMember = state.userModel?.isNewMember == true ? '新用户' : '老用户';
              SensorsAnalyticsFlutterPlugin.registerSuperProperties({"member_type": isNewMember});
            } else {
              SensorsAnalyticsFlutterPlugin.registerSuperProperties({"member_type": '未登录'});
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                ListView(
                  controller: _controller,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 24.h),
                  children: contents(),
                ),
                ABiteBanner(
                  bannerParam: BannerParam(
                    'cotti-window-common',
                    isNoCache: true,
                    viewPage: "cotti-app-mine",
                  ),
                  bannerController: _windowBannerController,
                ),
                FloatBanner(
                  controller: _controller,
                  child: ABiteBanner(
                    width: 60.w,
                    resize: true,
                    bannerParam: BannerParam(
                      'cotti-float-common',
                      memberId: Constant.memberId,
                      viewPage: "cotti-app-mine",
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> contents() {
    return [
      const UserInfoWidget(),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            CouponWidget(),
            const FunctionList(),
            if (Env.currentEnvConfig.isDebug) const SwitchEnvWidget(),
            ABiteBanner(
              padding: EdgeInsets.only(top: 12.h),
              bannerParam: BannerParam("cotti-my-banner"),
              width: ScreenUtil().screenWidth - 32.w,
              resize: true,
              borderRadius: BorderRadius.circular(4.r),
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    ];
  }
}
