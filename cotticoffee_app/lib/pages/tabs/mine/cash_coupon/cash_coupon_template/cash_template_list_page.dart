import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/custom_smart_header.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bloc/cash_coupon_template_bloc.dart';
import 'view/cash_coupon_empty.dart';
import 'view/view.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/8 10:55
class CashTemplateListPage extends StatefulWidget {
  const CashTemplateListPage({Key? key}) : super(key: key);

  @override
  State<CashTemplateListPage> createState() => _CashTemplateListPageState();
}

class _CashTemplateListPageState extends State<CashTemplateListPage> {
  final CashCouponTemplateBloc _bloc = CashCouponTemplateBloc();
  final ScrollController _controller = ScrollController();
  final double bottomActionBarHeight = 46.h;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  double? bottomBarHeight;
  late String t;

  @override
  void initState() {
    super.initState();
    _bloc.add(InitCashCouponTemplateEvent(isFirst: true));
    t = context.read<ConfigBloc>().state.configEntity?.voucherExchangeMenuConfigForHis ?? '';
  }

  @override
  Widget build(BuildContext context) {
    bottomBarHeight ??= MediaQuery.of(context).padding.bottom;
    return BlocProvider(
      create: (context) => _bloc,
      child: _buildContent(),
    );
  }

  _buildContent() {
    return BlocConsumer<CashCouponTemplateBloc, CashCouponTemplateState>(
      listener: (_, state) {
        if (state.refreshStatus == RefreshStatus.completed) {
          _refreshController.refreshCompleted();
        }
      },
      builder: (context, state) {
        return CustomPageWidget(
          title: "代金券",
          showLoading: state.showLoading,
          loadingRatio: 0.35,
          customLoadingColor: Colors.transparent,
          child: Stack(
            children: [
              SmartRefresher(
                controller: _refreshController,
                header: const CustomSmartHeader(),
                onRefresh: () => _bloc.add(InitCashCouponTemplateEvent()),
                child: state.showEmpty
                    ? const CashCouponEmpty()
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                            16.w, 0.h, 16.w, (bottomBarHeight ?? 0) + bottomActionBarHeight + 12.h),
                        controller: _controller,
                        itemCount: state.listLength,
                        itemBuilder: (context, index) {
                          if (index == 0 && state.recentlyExpiredCount > 0) {
                            return ExpirationPrompt(state.recentlyExpiredCount);
                          }
                          int voucherTemplateItemIndex =
                              index - (state.recentlyExpiredCount > 0 ? 1 : 0);
                          return CashCouponTemplateItem(
                            state.cashCouponTemplate!
                                .voucherTemplateInfoList![voucherTemplateItemIndex],
                          );
                        },
                      ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CouponBottomActionBar(
                  controller: _controller,
                  bottomActionBarHeight: bottomActionBarHeight,
                  mainTitle: '历史代金券',
                  subTitle: t,
                  mainClickCallback: () =>
                      NavigatorUtils.push(context, MineRouter.cashCouponHistoryPage),
                  subClickCallback: () => _gotoExchangeCoupon(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _gotoExchangeCoupon() {
    NavigatorUtils.push(context, MineRouter.exchangeCouponPage, params: {"title": t}).then(
      (value) => _bloc.add(InitCashCouponTemplateEvent()),
    );
  }
}
