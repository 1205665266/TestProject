import 'package:cotti_client/pages/tabs/mine/coupon/coupon_list/bloc/coupon_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/coupon/coupon_list/widget/coupon_empty_widget.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/order_coupon_item.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/custom_smart_footer.dart';
import 'package:cotti_client/widget/custom_smart_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CouponListWidget extends StatefulWidget {
  final int pageIndex;
  final ScrollController controller;
  final double listPaddingBottom;

  const CouponListWidget({
    Key? key,
    required this.pageIndex,
    required this.controller,
    this.listPaddingBottom = 0,
  }) : super(key: key);

  @override
  _CouponListWidgetState createState() {
    return _CouponListWidgetState();
  }
}

class _CouponListWidgetState extends State<CouponListWidget> {
  final RefreshController _controller = RefreshController(initialRefresh: false);
  double? bottomBarSafeHeight;

  @override
  Widget build(BuildContext context) {
    bottomBarSafeHeight ??= MediaQuery.of(context).padding.bottom;
    return BlocConsumer<CouponBloc, CouponState>(
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
          enablePullUp: !state.showEmpty,
          controller: _controller,
          header: const CustomSmartHeader(),
          footer: CustomSmartFooter(height: widget.listPaddingBottom + bottomBarSafeHeight!),
          onLoading: () => context.read<CouponBloc>().add(CouponLoadingEvent()),
          onRefresh: () => context.read<CouponBloc>().add(CouponRefreshEvent(delayed: 0)),
          child: state.showEmpty ? const CouponEmptyWidget() : _buildList(),
        );
      },
    );
  }

  Widget _buildList() {
    CouponBloc bloc = context.read<CouponBloc>();
    int count = bloc.state.couponList?.length ?? 0;
    return ListView.builder(
      padding: EdgeInsets.only(top: 12.h),
      controller: widget.controller,
      itemBuilder: (BuildContext context, int index) {
        bool hasBanner = bloc.state.tabCode == 1 && bloc.state.bannerModel != null;
        return Column(
          children: [
            if (hasBanner && index == 0) _buildBanner([bloc.state.bannerModel!]),
            OrderCouponItem(
              bloc.state.couponList![index],
              OrderCouponItemSource.list,
              atLast: index == (count - 1),
            ),
          ],
        );
      },
      itemCount: count,
    );
  }

  _buildBanner(List<BannerModel> bannerModels) {
    return ABiteBanner(
      margin: EdgeInsets.only(bottom: 12.h),
      banners: bannerModels,
      width: ScreenUtil().screenWidth - 32.w,
      borderRadius: BorderRadius.circular(4.r),
      fit: BoxFit.cover,
    );
  }
}
