import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/cash_coupon_template/view/view.dart';
import 'package:cotti_client/pages/tabs/mine/coupon/coupon_list/bloc/coupon_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/coupon/coupon_list/widget/coupon_list_widget.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/sensors/coupon_sensors_constant.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/my_underline_indicator.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class CouponListPage extends StatefulWidget {
  const CouponListPage({Key? key}) : super(key: key);

  @override
  _CouponListPageState createState() {
    return _CouponListPageState();
  }
}

class _CouponListPageState extends State<CouponListPage> with SingleTickerProviderStateMixin {
  final CouponBloc _bloc = CouponBloc();
  final double bottomActionBarHeight = 46.h;
  final ScrollController _controller = ScrollController();
  late TabController _tabController;
  late String t;

  @override
  void initState() {
    super.initState();
    t = context.read<ConfigBloc>().state.configEntity?.couponExchangeMenuConfigForHis ?? '';
    _tabController = TabController(vsync: this, length: _bloc.state.tabs.length);
    _bloc.add(CouponGetDataListEvent(pageNo: 1, tabCode: 0));
    _bloc.add(CouponGetNumEvent());
    _bloc.add(CouponBannerEvent());
    SensorsAnalyticsFlutterPlugin.track(CouponSensorsConstant.couponListView, {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<CouponBloc, CouponState>(
        listener: (context, state) {},
        builder: (context, state) {
          return CustomPageWidget(
            title: '优惠券',
            showLoading: state.showLoading,
            customLoadingColor: Colors.transparent,
            extendBodyBehindAppBar: false,
            child: Stack(
              children: [
                Positioned(
                  top: 44.h,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CouponListWidget(
                    pageIndex: _bloc.state.tabCode,
                    listPaddingBottom: bottomActionBarHeight,
                    controller: _controller,
                  ),
                ),
                _buildTab(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildFootBtn(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab() {
    return Container(
      width: double.infinity,
      height: 44.h,
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
        child: TabBar(
          onTap: (index) => _changeTab(index),
          labelColor: CottiColor.primeColor,
          unselectedLabelColor: const Color(0xFF5F5F5F),
          labelStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            fontFamily: "DDP4",
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            fontFamily: "DDP4",
          ),
          indicator: MyUnderlineTabIndicator(
            width: 62.w,
            borderSide: BorderSide(
              width: 2.h,
              color: CottiColor.primeColor,
            ),
          ),
          controller: _tabController,
          tabs: List.generate(
            _bloc.state.tabs.length,
            (index) => Container(
              alignment: Alignment.center,
              height: 42.h,
              child: Text(
                _bloc.state.tabs[index].title,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFootBtn() {
    return CouponBottomActionBar(
      controller: _controller,
      bottomActionBarHeight: bottomActionBarHeight,
      mainTitle: "历史优惠券",
      subTitle: t,
      mainClickCallback: () => _gotoHistoryPage(),
      subClickCallback: () => _gotoExchangeCoupon(),
    );
  }

  void _changeTab(int index) {
    _tabController.index = index;
    _bloc.add(CouponTabChangeEvent(
      tabCode: _bloc.state.tabs[index].status,
    ));
    _bloc.add(CouponGetNumEvent());
  }

  void _gotoHistoryPage() {
    SensorsAnalyticsFlutterPlugin.track(CouponSensorsConstant.historyCouponlistClick, {});
    NavigatorUtils.push(context, MineRouter.couponHistoryListPage);
  }

  void _gotoExchangeCoupon() {
    NavigatorUtils.push(context, MineRouter.exchangeCouponPage, params: {
      "title": t,
    }).then(
      (value) {
        _bloc.add(CouponGetDataListEvent(pageNo: 1, tabCode: _tabController.index));
        _bloc.add(CouponGetNumEvent());
      },
    );
  }
}
