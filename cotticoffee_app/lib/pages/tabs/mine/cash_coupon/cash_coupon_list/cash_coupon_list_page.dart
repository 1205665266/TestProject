import 'package:cotti_client/utils/scheme_dispatcher.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/custom_smart_footer.dart';
import 'package:cotti_client/widget/custom_smart_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bloc/cash_coupon_bloc.dart';
import 'view/view.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/13 09:33
class CashCouponListPage extends StatefulWidget {
  final String recentlyExpiredCount;

  const CashCouponListPage({Key? key, required this.recentlyExpiredCount}) : super(key: key);

  @override
  State<CashCouponListPage> createState() => _CashCouponListPageState();
}

class _CashCouponListPageState extends State<CashCouponListPage> {
  double? bottomBarHeight;
  final RefreshController _controller = RefreshController(initialRefresh: false);
  final CashCouponBloc _bloc = CashCouponBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(CashRefreshEvent(QueryType.due));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bloc,
      child: CustomPageWidget(
        title: "即将到期代金券",
        child: _buildContent(),
      ),
    );
  }

  _buildContent() {
    bottomBarHeight ??= MediaQuery.of(context).padding.bottom;
    return BlocConsumer<CashCouponBloc, CashCouponState>(
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
        return SmartRefresher(
          controller: _controller,
          enablePullUp: true,
          header: const CustomSmartHeader(),
          footer: CustomSmartFooter(footerText: "— 没有更多啦 —"),
          onLoading: () => _bloc.add(CashLoadingEvent(QueryType.due)),
          onRefresh: () => _bloc.add(CashRefreshEvent(QueryType.due)),
          child: ListView.separated(
            itemCount: state.cashCouponList.length + 1,
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: state.loadStatus == LoadStatus.noMore ? 0 : bottomBarHeight!,
            ),
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              if (index == 0) {
                return ExpirationPrompt(num: widget.recentlyExpiredCount);
              }
              return CashCouponItem(
                actionEnum: ActionEnum.useNow,
                cashCouponEntity: state.cashCouponList[index - 1],
                actionCallBack: () {
                  SchemeDispatcher.dispatchPath(context, "cottitab://coffee?tabIndex=1");
                },
              );
            },
          ),
        );
      },
    );
  }
}
