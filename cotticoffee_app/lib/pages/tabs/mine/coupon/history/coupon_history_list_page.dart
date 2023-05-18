import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/coupon/coupon_list/widget/coupon_empty_widget.dart';
import 'package:cotti_client/pages/tabs/mine/coupon/history/bloc/coupon_history_bloc.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_coupon_list_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/order_coupon_item.dart';
import 'package:cotti_client/sensors/coupon_sensors_constant.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/custom_smart_footer.dart';
import 'package:cotti_client/widget/custom_smart_header.dart';
import 'package:cotti_client/widget/my_underline_indicator.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class CouponHistoryListPage extends StatefulWidget {
  const CouponHistoryListPage({Key? key}) : super(key: key);

  @override
  _CouponHistoryListPageState createState() {
    return _CouponHistoryListPageState();
  }
}

class _CouponHistoryListPageState extends State<CouponHistoryListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CouponHistoryBloc _bloc = CouponHistoryBloc();
  final RefreshController _controller = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _bloc.state.tabs.length);

    _changeTab(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<CouponHistoryBloc, CouponHistoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          return CustomPageWidget(
            title: '历史优惠券',
            appBarBackgroundColor: Colors.white,
            showLoading: state.showLoading,
            extendBodyBehindAppBar: false,
            child: SafeArea(
              top: false,
              child: Stack(
                children: [
                  Positioned(
                    top: 44.h,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _buildPage(),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _buildTab(),
                  ),

                  // Expanded(child: _buildPage()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// tab
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
          ),
          // labelPadding: EdgeInsets.only(top: 15.h, bottom: 11.h),
          unselectedLabelStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
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
              child: Text(_bloc.state.tabs[index].name),
            ),
          ),
        ),
      ),
    );
  }

  /// listPage
  Widget _buildPage() {
    logW('in _buildPage !!!');
    return BlocConsumer<CouponHistoryBloc, CouponHistoryState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.noMore) {
          _controller.loadNoData();
        } else {
          _controller.loadComplete();
        }
        if (state.refreshStatus == RefreshStatus.completed) {
          _controller.refreshCompleted();
        }
      },
      builder: (context, state) {
        if (state.couponList == null || state.couponList!.isEmpty) {
          return const CouponEmptyWidget();
        }
        return SmartRefresher(
          enablePullUp: true,
          controller: _controller,
          header: const CustomSmartHeader(),
          footer: CustomSmartFooter(),
          onLoading: () => _bloc.add(CouponHistoryLoadingEvent()),
          onRefresh: () => _bloc.add(CouponHistoryRefreshEvent(delayed: 0)),
          child: ListView.builder(
            padding: EdgeInsets.only(top: 12.h),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              OrderCouponListModelConfirmOrderCouponDtoList orderModel =
                  _bloc.state.couponList![index];
              return Stack(
                children: [
                  OrderCouponItem(
                    orderModel,
                    OrderCouponItemSource.history,
                    atLast: index == (_bloc.state.couponList?.length ?? 0)-1,
                  ),
                  if (state.queryType == 1)
                    Positioned(
                      right: 16.w,
                      child: _buildStamp(orderModel.invalidType),
                    ),
                ],
              );
            },
            itemCount: _bloc.state.couponList?.length ?? 0,
          ),
        );
      },
    );
  }

  /// action

  void _changeTab(int index) {
    _tabController.index = index;

    String key = index == 0
        ? CouponSensorsConstant.usedCouponTabView
        : CouponSensorsConstant.overdueCouponView;

    SensorsAnalyticsFlutterPlugin.track(key, {});

    _bloc.add(CouponHistoryTabChangeEvent(
      queryType: _bloc.state.tabs[index].status,
    ));
  }

  Widget _buildStamp(int? invalidType) {
    switch (invalidType) {
      case 10:
        return SvgPicture.asset(
          "assets/images/mine/ic_overdue.svg",
          width: 45.w,
          height: 45.w,
        );
      case 20:
        return SvgPicture.asset(
          "assets/images/mine/ic_refund.svg",
          width: 45.w,
          height: 45.w,
        );
      case 30:
        return SvgPicture.asset(
          "assets/images/mine/ic_invalid.svg",
          width: 45.w,
          height: 45.w,
        );
      default:
        return const SizedBox();
    }
  }
}
