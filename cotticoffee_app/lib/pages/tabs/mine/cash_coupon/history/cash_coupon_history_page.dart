import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/cash_coupon_list/bloc/cash_coupon_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/cash_coupon_list/view/view.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/cash_coupon_template/view/cash_coupon_empty.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/custom_smart_footer.dart';
import 'package:cotti_client/widget/custom_smart_header.dart';
import 'package:cotti_client/widget/my_underline_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/8 10:55
class CashCouponHistoryPage extends StatefulWidget {
  const CashCouponHistoryPage({Key? key}) : super(key: key);

  @override
  State<CashCouponHistoryPage> createState() => _CashCouponHistoryPageState();
}

class _CashCouponHistoryPageState extends State<CashCouponHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CashCouponBloc _bloc = CashCouponBloc();
  final RefreshController _controller = RefreshController(initialRefresh: false);
  double? bottomBarHeight;
  int tabSelectIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _bloc.add(CashRefreshEvent(_bloc.state.tabs[tabSelectIndex]));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      title: "历史代金券",
      child: BlocConsumer<CashCouponBloc, CashCouponState>(
        bloc: _bloc,
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
          return Column(
            children: [
              _buildTab(),
              Expanded(child: _buildList(state)),
            ],
          );
        },
      ),
    );
  }

  _buildTab() {
    return Container(
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
      child: TabBar(
        onTap: (index) => _changeTab(index),
        labelColor: CottiColor.primeColor,
        unselectedLabelColor: const Color(0xFF5F5F5F),
        labelStyle: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
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
              (index) {
            return Container(
              alignment: Alignment.center,
              height: 42.h,
              child: Text(_bloc.state.tabs[index].name),
            );
          },
        ),
      ),
    );
  }

  _changeTab(int index) {
    if (index != tabSelectIndex) {
      tabSelectIndex = index;
      _bloc.add(CashTabChangeEvent(_bloc.state.tabs[index]));
    }
  }

  _buildList(CashCouponState state) {
    bottomBarHeight ??= MediaQuery.of(context).padding.bottom;
    return SmartRefresher(
      controller: _controller,
      header: const CustomSmartHeader(),
      enablePullUp: !state.showEmpty,
      footer: CustomSmartFooter(footerText: "— 以上是最近 3 个月${state.tabs[tabSelectIndex].name}的代金券 —"),
      onLoading: () => _bloc.add(CashLoadingEvent(state.tabs[tabSelectIndex])),
      onRefresh: () => _bloc.add(CashRefreshEvent(state.tabs[tabSelectIndex])),
      child: state.showEmpty
          ? const CashCouponEmpty()
          : ListView.separated(
        itemCount: state.cashCouponList.length,
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 12.h,
          bottom: state.loadStatus == LoadStatus.noMore ? 0 : bottomBarHeight!,
        ),
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              CashCouponItem(
                actionEnum: ActionEnum.none,
                available: false,
                customTimeContent: customTimeContent(state, state.cashCouponList[index]),
                cashCouponEntity: state.cashCouponList[index],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: _buildStamp(state.cashCouponList[index].invalidType),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStamp(int? invalidType) {
    switch (invalidType) {
      case -1:
        return SvgPicture.asset(
          "assets/images/mine/ic_used.svg",
          width: 45.w,
          height: 45.w,
        );
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

  customTimeContent(CashCouponState state, CashCouponEntity cashCouponEntity) {
    if (state.tabs[tabSelectIndex] == QueryType.used) {
      return "使用时间：${cashCouponEntity.useTime}";
    } else if (state.tabs[tabSelectIndex] == QueryType.expired) {
      return "失效时间：${cashCouponEntity.invalidTime}";
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }
}
