import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/pages/tabs/home/bloc/home_bloc.dart';
import 'package:cotti_client/pages/tabs/home/bloc/home_state.dart';
import 'package:cotti_client/pages/tabs/home/view/user_banner.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_event.dart';
import 'package:cotti_client/pages/tabs/tab_page.dart';
import 'package:cotti_client/sensors/home_sensors.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/banner/widget/float_banner.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'bloc/home_event.dart';
import 'view/activity_list.dart';
import 'view/take_mode.dart';
import 'view/top_title_banner.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/8/31 1:44 下午
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final String keyTopBannerHeight = 'keyTopBannerHeight';
  final ScrollController _controller = ScrollController();
  final HomeBloc _bloc = HomeBloc();
  late Size topBannerSize;
  final ValueNotifier<double> _notifier = ValueNotifier(0);
  final BannerController _homeWindowController = BannerController();

  bool topBannerLoadComplete = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _bloc.add(InitHomeEvent());
    context.read<MineBloc>().add(InitUserInfoEvent());
    double topHeight = SpUtil.getDouble(keyTopBannerHeight, 480.h);
    topBannerSize = Size(0, topHeight);
    SensorsAnalyticsFlutterPlugin.track(HomeSensors.homeView, {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomPageWidget(
      showAppBar: false,
      resizeToAvoidBottomInset: false,
      child: BlocProvider(
        create: (context) => _bloc,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return BlocListener<GlobalBloc, GlobalState>(
      bloc: GlobalBlocs.get(GlobalBloc.blocName),
      listenWhen: (p, c) => p.tabIndex != c.tabIndex,
      listener: (context, state) {
        if (state.tabIndex == TabEnum.home.index) {
          context.read<MineBloc>().add(InitUserInfoEvent());
          _bloc.add(CheckBannerDataEvent());
          _homeWindowController.reload();
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage('assets/images/home/bg_home.png'),
          ),
        ),
        child: Stack(
          children: [
            NotificationListener<ScrollUpdateNotification>(
              onNotification: (ScrollNotification notification) {
                scrollNotify();
                return true;
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: _controller,
                child: _buildScrollContent(),
              ),
            ),
            TopTitleBanner(notifier: _notifier),
            ABiteBanner(
              bannerParam: BannerParam(
                "cotti-window-common",
                isNoCache: true,
                viewPage: "cotti-app-home",
              ),
              bannerController: _homeWindowController,
            ),
            FloatBanner(
              controller: _controller,
              child: ABiteBanner(
                width: 60.w,
                resize: true,
                bannerParam: BannerParam(
                  "cotti-float-common",
                  viewPage: "cotti-app-home",
                  memberId: Constant.memberId,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollContent() {
    List<Widget> _list = _contentChildList();
    return Column(
      children: [
        if (!topBannerLoadComplete) SizedBox(height: topBannerSize.height),
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.topBannerList.isEmpty) {
              return const SizedBox();
            }
            return ABiteBanner(
              banners: state.topBannerList,
              width: 375.w,
              fit: state.topBannerList.length > 1 ? BoxFit.fill : BoxFit.fitWidth,
              pointEdgeInsets: EdgeInsets.only(right: 10.w, bottom: 18.h),
              resize: true,
              bannerSizeCallBack: (size) {
                SpUtil.putDouble(keyTopBannerHeight, size.height);
                topBannerSize = size;
                setState(() => topBannerLoadComplete = true);
              },
            );
          },
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          itemBuilder: (context, index) {
            return _list[index];
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 14.h);
          },
          itemCount: _list.length,
        )
      ],
    );
  }

  _contentChildList() {
    List<Widget> _list = [];
    _list.add(const TakeMode());
    _list.add(const UserBanner());
    _list.add(const AcitvityList());
    _list.add(_buildLogo());
    return _list;
  }

  _buildLogo() {
    return Center(
      child: SvgPicture.asset(
        "assets/images/home/main_logo.svg",
        width: 172.w,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  void scrollNotify() {
    if (_bloc.state.topBannerList.isEmpty) {
      return;
    } else {
      double diff = _controller.offset - topBannerSize.height;
      if (diff > 0) {
        _notifier.value = (diff / 100.h).clamp(0.5, 1);
      } else {
        _notifier.value = 0;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
