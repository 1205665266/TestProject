import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/help/bloc/help_bloc.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_event.dart';
import 'package:cotti_client/pages/tabs/order/order_list/bloc/order_state.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_model.dart';
import 'package:cotti_client/pages/tabs/order/order_list/view/order_item.dart';
import 'package:cotti_client/pages/tabs/tab_page.dart';
import 'package:cotti_client/widget/custom_smart_footer.dart';
import 'package:cotti_client/widget/custom_smart_header.dart';
import 'package:cotti_client/widget/keep_alive_wrapper.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/3/16 1:34 下午
class PageItem extends StatefulWidget {
  final ScrollController scrollController;

  const PageItem({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<PageItem> createState() => _PageItemState();
}

class _PageItemState extends State<PageItem> {
  final RefreshController _controller = RefreshController(initialRefresh: false);

  final HelpBloc _helpBloc = HelpBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
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
        bool showEmpty =
            state.orderList.isEmpty && state.loadStatus != LoadStatus.loading && !state.isChangeTab;
        return SmartRefresher(
          enablePullUp: !showEmpty,
          controller: _controller,
          scrollController: widget.scrollController,
          header: const CustomSmartHeader(),
          footer: CustomSmartFooter(
            footerColor: CottiColor.textGray,
          ),
          onLoading: () => context.read<OrderBloc>().add(OnLoadingEvent()),
          onRefresh: () => context.read<OrderBloc>().add(OnRefreshEvent(0)),
          child: Visibility(
            visible: showEmpty,
            child: _buildEmptyView(state.pageIndex),
            replacement: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h, bottom: 0),
              itemBuilder: (context, index) {
                OrderModel orderModel = state.orderList[index];
                return KeepAliveWrapper(
                  keepAlive: orderModel.status == 10,
                  child: OrderItem(
                    orderModel: orderModel,
                    pageIndex: state.pageIndex,
                    cancelOrderConfigDTO: state.cancelOrderConfigDTO,
                    helpBloc: _helpBloc,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 12.h);
              },
              itemCount: state.orderList.length,
            ),
          ),
        );
      },
    );
  }

  _buildEmptyView(int pageIndex) {
    return BlocBuilder<ConfigBloc, ConfigState>(builder: (context, state) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 130.h,
          ),
          Image.asset(
            pageIndex == 0
                ? "assets/images/order/order_list/icon_list_login.png"
                : "assets/images/order/order_list/icon_list_history_empty.png",
            width: 141.w,
            height: 121.h,
          ),
          SizedBox(
            height: 23.h,
          ),
          if (state.configEntity?.orderListEmptyContext != null &&
              (state.configEntity?.orderListEmptyContext?.isNotEmpty ?? false))
            Padding(
              padding: EdgeInsets.only(bottom: 43.h),
              child: Text(
                "${state.configEntity?.orderListEmptyContext}",
                style: TextStyle(fontSize: 14.sp, color: CottiColor.textGray),
              ),
            ),
          InkWell(
            onTap: () {
              GlobalBlocs.get<GlobalBloc>(GlobalBloc.blocName)
                  .add(SwitchTabEvent(TabEnum.menu.index, arguments: {
                "takeFoodMode": context.read<ShopMatchBloc>().state.shopMdCode != null
                    ? null
                    : Constant.selfTakeModeCode,
              }));
              SensorsAnalyticsFlutterPlugin.track(OrderSensorsConstant.toDrinkOrderListClick, {});
            },
            child: Container(
              width: 144.w,
              height: 40.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CottiColor.primeColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                "现在点单",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}
