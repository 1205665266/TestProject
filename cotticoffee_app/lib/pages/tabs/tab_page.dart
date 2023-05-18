import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/home/home_page.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/menu_page.dart';
import 'package:cotti_client/pages/tabs/mine/my/mine_page.dart';
import 'package:cotti_client/pages/tabs/order/order_list/order_page.dart';
import 'package:cotti_client/service/push/jpush_wrapper.dart';
import 'package:cotti_client/utils/upgrade_util.dart';
import 'package:cotti_client/widget/coupon_every_day.dart';
import 'package:cotti_client/widget/coupon_new_user.dart';
import 'package:cotti_client/widget/new_install_coupon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/9/30 6:06 下午
class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  final List<TabEnum> _tabs = const [TabEnum.home, TabEnum.menu, TabEnum.order, TabEnum.mine];
  final PageController _controller = PageController();
  final _bloc = GlobalBlocs.get<GlobalBloc>(GlobalBloc.blocName);
  late List<Widget> _pages;
  int dateTime = 0;

  @override
  void initState() {
    super.initState();
    _pages = [const HomePage(), const MenuPage(), const OrderPage(), const MinePage()];
    UpgradeUtil().checkUpgrade(context);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      FToast().init(context);
      JPushWrapper().launchAppNotification(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: _buildBody(),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildBody() {
    return WillPopScope(
      onWillPop: _back,
      child: Stack(
        children: [
          BlocConsumer<GlobalBloc, GlobalState>(
            bloc: _bloc,
            listener: (context, state) {
              _controller.jumpToPage(state.tabIndex);
            },
            builder: (context, state) {
              return PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                children: _pages,
              );
            },
          ),
          const CouponNewUser(),
          const CouponEveryDay(),
          const NewInstallCoupon(),
        ],
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      notchMargin: 4.w,
      shape: const CircularNotchedRectangle(),
      child: Row(
        children: List.generate(_tabs.length, (index) => _buildBarItem(_tabs[index])),
      ),
    );
  }

  Widget _buildBarItem(TabEnum tabEnum) {
    return Expanded(
      child: BlocBuilder<GlobalBloc, GlobalState>(
        bloc: _bloc,
        builder: (context, state) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _handleTapTab(tabEnum),
            child: SizedBox(
              height: 49.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 4.h),
                  SvgPicture.asset(
                    tabEnum.index == state.tabIndex ? tabEnum.checkedPath : tabEnum.notCheckPath,
                    width: 20.w,
                    height: 20.w,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    tabEnum.name,
                    style: TextStyle(
                      color: tabEnum.index == state.tabIndex
                          ? CottiColor.textBlack
                          : const Color(0xFF777777),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _handleTapTab(TabEnum tabEnum) {
    Map<String, dynamic> map = {};
    if (tabEnum.index == TabEnum.menu.index) {
      map.addAll({
        'takeFoodMode': context.read<ShopMatchBloc>().state.curTakeFoodMode,
        'isReLocation': !context.read<ShopMatchBloc>().state.isUserSelectShopCode,
      });
    }
    _bloc.add(SwitchTabEvent(tabEnum.index, arguments: map));
    HapticFeedback.selectionClick();
    SensorsAnalyticsFlutterPlugin.track(tabEnum.tabTackCode, {});
  }

  ///拦截返回事件
  Future<bool> _back() async {
    final int currTime = DateTime.now().millisecondsSinceEpoch;
    if (currTime - dateTime > 1000) {
      dateTime = currTime;
    } else {
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    _pages.clear();
    _controller.dispose();
  }
}

enum TabEnum { home, menu, order, mine }

extension TabIndexEnumExtension on TabEnum {
  String get name => ['首页', '点餐', '订单', '我的'][index];

  String get checkedPath => [
        'assets/images/tab_bar/icon_home.svg',
        'assets/images/tab_bar/icon_menu.svg',
        'assets/images/tab_bar/icon_order.svg',
        'assets/images/tab_bar/icon_mine.svg',
      ][index];

  String get notCheckPath => [
        'assets/images/tab_bar/icon_home_nor.svg',
        'assets/images/tab_bar/icon_menu_nor.svg',
        'assets/images/tab_bar/icon_order_nor.svg',
        'assets/images/tab_bar/icon_mine_nor.svg',
      ][index];

  String get tabTackCode => [
        'tab_home_click',
        'tab_menu_click',
        'tab_order_click',
        'mineTab_click',
      ][index];
}
