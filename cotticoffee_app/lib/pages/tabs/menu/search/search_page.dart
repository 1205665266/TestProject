import 'dart:math';

import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/product/detail_pop.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_state.dart';
import 'package:cotti_client/pages/shopping_cart/shopping_cart_widget.dart';
import 'package:cotti_client/sensors/menu_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_item_entity.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/views/simple_menu_item.dart';
import 'package:cotti_client/pages/tabs/menu/search/bloc/search_bloc.dart';
import 'package:cotti_client/pages/tabs/menu/search/bloc/search_event.dart';
import 'package:cotti_client/pages/tabs/menu/search/bloc/search_state.dart';
import 'package:cotti_client/pages/tabs/menu/search/entity/search_label.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/custom_smart_footer.dart';
import 'package:cotti_client/widget/custom_smart_header.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/router/fluro_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'view/search_item_widget.dart';
import 'view/quick_search.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/27 18:30
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchBloc _bloc = SearchBloc();
  final InstallValue _installValue = InstallValue();
  late RefreshController _refreshController;

  int? shopMdCode;
  int startViewTime = 0;
  bool showCart = false;

  @override
  void initState() {
    super.initState();
    shopMdCode = context.read<ShopMatchBloc>().state.shopMdCode;
    if (shopMdCode != null) {
      _bloc.add(
        InitHistorySearchEvent(shopMdCode!, context.read<ShopMatchBloc>().state.curTakeFoodMode),
      );
    }
    _refreshController = RefreshController();

    startViewTime = DateUtil.getNowDateMs();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: _buildContent(),
    );
  }

  _buildContent() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return CustomPageWidget(
            title: "搜索",
            pageBackgroundColor: Colors.white,
            showLoading: state.loadStatus == LoadStatus.loading,
            customLoadingColor: null,
            child: SafeArea(
              child: Stack(
                children: [
                  BlocBuilder<ShoppingCartBloc, ShoppingCartState>(builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _headWidget(),
                        Expanded(
                          child: GestureDetector(
                              onTap: () => NavigatorUtils.unfocus(), child: _buildBody()),
                        )
                      ],
                    );
                  }),
                  if (showCart) const ShoppingCartWidget(),
                ],
              ),
            ));
      },
    );
  }

  _headWidget() {
    return Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 16.w),
        child: _searchWidget());
  }

  Widget _searchWidget() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: SearchItemWidget(
                autofocus: true,
                hideText: state.getDefaultLabel.labelText ?? "",
                installValue: _installValue,
                searchCallBack: (val) {
                  // 检查当前文案是否在热门推荐中
                  SearchLabel label = state.itemLabelList.firstWhere(
                      (element) => element.labelText == val,
                      orElse: () => SearchLabel()..labelText = val);
                  _onPressedItem(label, -1);
                },
                searchHideBack: () {
                  _onPressedItem(state.defaultLabel, -1);
                },
                clearCallback: () {
                  _installValue.value = SearchLabel();

                  _bloc.add(ClearSearchDataEvent());
                },
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildBody() {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.noMore) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
      },
      builder: (context, state) {
        return Visibility(
          visible: state.itemData.isNotEmpty,
          child: _buildSearchResult(),
          replacement: _buildLabelAndEmptyView(),
        );
      },
    );
  }

  _buildSearchResult() {
    SensorsAnalyticsFlutterPlugin.track(MenuSensorsConstant.searchSearchResultListView, {});
    return SmartRefresher(
        enablePullUp: true,
        enablePullDown: false,
        header: const CustomSmartHeader(),
        footer: CustomSmartFooter(
          footerText: "没有更多了",
          footerColor: CottiColor.textGray,
        ),
        controller: _refreshController,
        onLoading: () {
          SearchLabel label = _installValue.value;
          _bloc.add(
            LoadingMoreEvent(label, shopMdCode!,
                context.read<ShopMatchBloc>().state.curTakeFoodMode, DateTime.now().microsecond),
          );
        },
        child: _buildSearchListView());
  }

  _buildSearchListView() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 8.w, 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: "当前门店共",
                    style: TextStyle(
                        fontSize: 14.sp, color: CottiColor.textBlack, fontWeight: FontWeight.bold)),
                TextSpan(
                    text: " ${state.itemData.length} ",
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: CottiColor.textBlack,
                        fontFamily: 'DDP4',
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: "个相关餐品",
                    style: TextStyle(
                        fontSize: 14.sp, color: CottiColor.textBlack, fontWeight: FontWeight.bold))
              ])),
              SizedBox(
                height: 12.h,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    MenuItemEntity menuItemEntity = state.itemData[index];
                    menuItemEntity.firstSku?.noSaleMsg = "本店暂时售罄";
                    return Container(
                      padding:
                          EdgeInsets.only(bottom: index == state.itemData.length - 1 ? 0 : 28.h),
                      child: SimpleMenuItem(
                          menuItem: menuItemEntity,
                          itemClickListener: () {
                            SensorsAnalyticsFlutterPlugin.track(
                                MenuSensorsConstant.searchSearchResultListProductClick, {
                              "product_name": menuItemEntity.title,
                              "product_spu_id": menuItemEntity.itemNo,
                            });
                          }),
                    );
                  },
                  itemCount: state.itemData.length)
            ],
          ),
        );
      },
    );
  }

  _buildLabelAndEmptyView() {
    return Column(
      children: [_buildEmpty(), _buildLabelView()],
    );
  }

  _buildLabelView() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 13.w, top: 18.h),
              child: Column(
                children: [
                  QuickSearch(
                    title: "历史搜索",
                    data: _bloc.state.historyList,
                    onPressedItem: _onPressedItem,
                    type: 0,
                  ),
                  Visibility(
                    visible: _bloc.state.historyList.isNotEmpty,
                    child: SizedBox(height: 20.h),
                  ),
                  QuickSearch(
                    title: "热门推荐",
                    data: _bloc.state.itemLabelList,
                    onPressedItem: _onPressedItem,
                    type: 1,
                  ),
                  Visibility(
                    visible: _bloc.state.itemLabelList.isNotEmpty,
                    child: SizedBox(height: 20.h),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 14.h, right: 13.w),
              child: Visibility(
                visible: _bloc.state.historyList.isNotEmpty,
                child: GestureDetector(
                  onTap: () {
                    _bloc.add(DeleteHistoryEvent());

                    SensorsAnalyticsFlutterPlugin.track(
                        MenuSensorsConstant.searchHistoryClearClick, {});
                  },
                  child: SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: Icon(
                      IconFont.icon_shanchu1,
                      size: 16.w,
                      color: const Color(0xFF5e5e5e),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmpty() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return ValueListenableBuilder<SearchLabel>(
            valueListenable: _installValue,
            builder: (context, value, child) {
              return Visibility(
                  visible: _showEmptyView(value, state),
                  child: Container(
                    padding: EdgeInsets.only(top: 68.h, bottom: 50.h),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/menu/icon_search_empty.png',
                          width: 141.w,
                          height: 121.h,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "抱歉，未找到您想要的餐品，换个词试试吧",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: CottiColor.textGray,
                          ),
                        ),
                      ],
                    ),
                  ));
            });
      },
    );
  }

  _showEmptyView(SearchLabel searchLabel, SearchState state) {
    // 输入有值，但是是
    return (searchLabel.labelText?.isNotEmpty ?? false) &&
        (searchLabel.itemNo?.isEmpty ?? true) &&
        state.itemData.isEmpty &&
        state.loadStatus != LoadStatus.loading;
  }

  void _onPressedItem(SearchLabel label, int type) {
    // 标签点击，失焦操作
    if (type == 0 || type == 1) {
      NavigatorUtils.unfocus();
    }
    _installValue.value = label;

    if (!showCart) {
      setState(() {
        showCart = true;
      });
    }

    // 如果当前 label的itemNo不为空，则跳转到对应商品详情，否则进行搜索
    if (label.itemNo != null && label.itemNo!.isNotEmpty) {
      ProductDetailPopup.show(context, label.itemNo ?? "");
    } else {
      if (shopMdCode != null) {
        _bloc.add(
          SearchLabelEvent(label, shopMdCode!, context.read<ShopMatchBloc>().state.curTakeFoodMode,
              DateTime.now().microsecond),
        );
      }
    }

    _bloc.add(SaveHistoryEvent(label));

    // 热搜 || 历史item 点击搜索
    if (type == 0 || type == 1) {
      String key = "";
      if (type == 0) {
        key = MenuSensorsConstant.searchHistoryClick;
      } else {
        key = MenuSensorsConstant.searchRecommendClick;
      }
      Map<String, dynamic> trackParams = {
        "product_name": label.labelText,
        "product_spu_id": label.itemNo ?? ""
      };
      SensorsAnalyticsFlutterPlugin.track(key, trackParams);
    }
    // 手动点击搜索
    if (type == -1) {
      SensorsAnalyticsFlutterPlugin.track(MenuSensorsConstant.searchSearchButtonClick, {
        "search_input_value": label.labelText,
        "search_input_has_value": label.labelText?.isEmpty ?? false ? '无' : '有'
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();

    SensorsAnalyticsFlutterPlugin.track(MenuSensorsConstant.searchView,
        {"browse_duration": DateUtil.getNowDateMs() - startViewTime});
  }
}
