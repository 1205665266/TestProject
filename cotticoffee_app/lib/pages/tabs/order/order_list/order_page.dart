import 'package:abitelogin/pages/util/login_utils.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/tab_page.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_event.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_state.dart';
import 'package:cotti_client/pages/tabs/order/order_list/view/page_item.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/banner/widget/float_banner.dart';
import 'package:cotti_client/widget/cotti_tabbar.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/my_underline_indicator.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/8/31 1:44 下午
class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  final OrderBloc _bloc = OrderBloc();
  final GlobalBloc globalBloc = GlobalBlocs.get(GlobalBloc.blocName);
  final BannerController _orderListController = BannerController();
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _bloc.state.tabs.length);
    _pageController = PageController();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (Constant.hasLogin) {
        _bloc.add(SwitchOrderStatusEvent(_bloc.state.tabs[0].status));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return BlocListener<GlobalBloc, GlobalState>(
            bloc: globalBloc,
            listener: (cx, globalState) {
              if (globalState.tabIndex == TabEnum.order.index) {
                _orderListController.reload();
                if (Constant.hasLogin) {
                  _bloc.add(SwitchOrderStatusEvent(_bloc.state.tabs[_tabController.index].status));
                }
              }
            },
            child: CustomPageWidget(
              title: '订单列表',
              automaticallyImplyLeading: false,
              showLoading: state.showLoading && Constant.hasLogin,
              customLoadingColor: null,
              child: _buildContent(),
            ),
          );
        },
      ),
    );
  }

  _buildContent() {
    return Stack(
      children: [
        BlocConsumer<UserBloc, UserState>(
            listenWhen: (previous, current) =>
                previous.status == UserStatus.loggedOut && current.status == UserStatus.loggedIn,
            listener: (context, state) =>
                _bloc.add(SwitchOrderStatusEvent(_bloc.state.tabs[_tabController.index].status)),
            builder: (context, state) {
              if (state.status == UserStatus.loggedIn) {
                return Stack(
                  children: [
                    _buildPage(),
                    _buildTab(),
                  ],
                );
              } else {
                return _buildLogInView();
              }
            }),
        ABiteBanner(
          bannerParam: BannerParam(
            "cotti-window-common",
            isNoCache: true,
            viewPage: "cotti-app-orderlist",
          ),
          bannerController: _orderListController,
        ),
        FloatBanner(
          controller: _scrollController,
          child: ABiteBanner(
            width: 60.w,
            resize: true,
            bannerParam: BannerParam(
              'cotti-float-common',
              memberId: Constant.memberId,
              viewPage: "cotti-app-orderlist",
            ),
          ),
        ),
      ],
    );
  }

  _buildLogInView() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 38.h,
          ),
          Expanded(
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 130.h,
                ),
                Image.asset(
                  'assets/images/order/order_list/icon_list_login.png',
                  width: 141.w,
                  height: 121.h,
                ),
                SizedBox(
                  height: 23.h,
                ),
                Text(
                  "更多信息，登录可见",
                  style: TextStyle(fontSize: 14.sp, color: CottiColor.textGray),
                ),
                SizedBox(
                  height: 44.h,
                ),
                InkWell(
                  onTap: () {
                    LoginUtils.login(context);
                    SensorsAnalyticsFlutterPlugin.track(
                        OrderSensorsConstant.orderListLoginClick, {});
                  },
                  child: Container(
                    width: 144.w,
                    height: 40.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: CottiColor.primeColor,
                        borderRadius: BorderRadius.all(Radius.circular(2.w))),
                    child: Text(
                      "立即登录",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTab() {
    return Container(
      width: double.infinity,
      height: 38.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(25, 70, 106, 0.06),
            offset: Offset(0, 2.h),
            blurRadius: 7.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: CottiTabbar(
          (index) => _changeTab(index),
          TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'DDP6',
            color: CottiColor.primeColor,
          ),
          TextStyle(
            fontSize: 14.sp,
            fontFamily: 'DDP4',
            color: const Color(0xFF5E5E5E),
          ),
          MyUnderlineTabIndicator(
            width: 62.w,
            borderSide: BorderSide(
              width: 2.h,
              color: CottiColor.primeColor,
            ),
          ),
          _tabController,
          List.generate(_bloc.state.tabs.length, (index) => _bloc.state.tabs[index].name),
        ),
      ),
    );
  }

  Widget _buildPage() {
    return Padding(
      padding: EdgeInsets.only(top: 38.h),
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemCount: _bloc.state.tabs.length,
        itemBuilder: (context, index) {
          return PageItem(
            scrollController: _scrollController,
          );
        },
      ),
    );
  }

  void _changeTab(int index) {
    _bloc.add(ChangeTabEvent(true));

    Future.delayed(const Duration(milliseconds: 200), () {
      _pageController.jumpToPage(index);
      _bloc.add(SwitchOrderStatusEvent(_bloc.state.tabs[index].status));
    });

    if (index == 0) {
      SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.orderListPageView, {});
    } else {
      SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.obligationOrderListView, {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
    _tabController.dispose();
    _pageController.dispose();
  }
}
