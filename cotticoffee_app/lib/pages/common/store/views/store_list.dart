import 'dart:ui';

import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/store/bloc/store_bloc.dart';
import 'package:cotti_client/pages/common/store/entity/store_list_data_entity.dart';
import 'package:cotti_client/pages/common/store/views/store_list_item.dart';
import 'package:cotti_client/pages/common/store/views/store_top_search_widget.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/sensors/store_sensors_constant.dart';
import 'package:cotti_client/widget/custom_smart_footer.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import '../../city/entity/city_list_data_entity.dart';

class StoreList extends StatefulWidget {
  const StoreList({
    Key? key,
    this.storeListEntity,
    this.selectedStoreModel,
    this.cityDataEntity,
    this.shopMdName,
    required this.shopListLoading,
    this.isFromConfirm = false,
    required this.moveMapEventTimeStamp,
  }) : super(key: key);

  final StoreListDataEntity? storeListEntity;
  final StoreListDataModel? selectedStoreModel;
  final CityListDataData? cityDataEntity;
  final int moveMapEventTimeStamp;

  ///搜索的门店
  final String? shopMdName;

  final bool shopListLoading;

  final bool isFromConfirm;

  @override
  State<StoreList> createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  /// scrollKey、scrollController用于实现滚动到选中门店
  GlobalKey scrollKey = GlobalKey();
  ScrollController scrollController = ScrollController();
  int lastMoveMapEventTimeStamp = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        color: const Color(0xFFF5F6F7),
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 60.w,
              left: 0,
              bottom: 0,
              right: 0,
              child: _buildStoreDataList(),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: StoreTopSearchWidget(
                cityDataEntity: widget.cityDataEntity,
                isFromConfirm: widget.isFromConfirm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String configCityName() {
    if (widget.cityDataEntity?.cityName != null) {
      return widget.cityDataEntity!.cityName!;
    } else {
      return "请选择";
    }
  }

  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
    initialLoadStatus: LoadStatus.noMore,
  );

  Widget _buildStoreLoadingWidget() {
    return Container(
      alignment: Alignment.center,
      child: LottieBuilder.asset(
        'assets/images/lotti/loading_data.json',
        width: 48.w,
        height: 48.h,
      ),
    );
  }

  Widget _buildStoreListWidget({required String stringTip}) {
    if (widget.shopListLoading) {
      return _buildStoreLoadingWidget();
    }
    bool shownearbyEmpty = (widget.storeListEntity?.nearbyShopList ?? []).isEmpty;
    bool showoftenUsedEmpty = (widget.storeListEntity?.oftenUsedShopList ?? []).isEmpty;
    bool showEmpty = shownearbyEmpty && showoftenUsedEmpty;
    if (showEmpty) {
      return _buildShopListEmptyWidget();
    }

    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      controller: _refreshController,
      footer: CustomSmartFooter(
        footerText: '— 更多附近门店筹备中，敬请期待 —',
      ),
      child: CustomScrollView(
        key: scrollKey,
        controller: scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: 6.h,
                ),
                _buildSliverPersistentHeader('常去门店', widget.storeListEntity?.oftenUsedShopList),
                _buildCommonStoreList(widget.storeListEntity?.oftenUsedShopList ?? []),
                _buildSliverPersistentHeader(stringTip, widget.storeListEntity?.nearbyShopList),
                _buildOtherStoreList(widget.storeListEntity?.nearbyShopList ?? []),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchListWidget() {

    if (widget.shopListLoading) {
      return _buildStoreLoadingWidget();
    }

    bool shownearbyEmpty = (widget.storeListEntity?.nearbyShopList ?? []).isEmpty;
    bool showoftenUsedEmpty = (widget.storeListEntity?.oftenUsedShopList ?? []).isEmpty;

    bool showEmpty = shownearbyEmpty && showoftenUsedEmpty;

    if (showEmpty) {
      return _buildSearchEmptyWidget();
    }
    List<StoreListDataModel> list = [
      ...widget.storeListEntity?.nearbyShopList ?? [],
      ...widget.storeListEntity?.oftenUsedShopList ?? []
    ];

    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      controller: _refreshController,
      footer: CustomSmartFooter(
        footerText: '— 更多附近门店筹备中，敬请期待 —',
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: 12.h,
                ),
                _buildOtherStoreList(list),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopListEmptyWidget() {
    return Container(
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/menu/icon_nearby_no_stores.png',
            width: 141,
            height: 121,
          ),
          SizedBox(
            height: 32.h,
          ),
          Text(
            '您附近暂无可到店自取门店',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xff5e5e5e),
              // fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Text(
            '可拖拽地图查看其他区域或切换城市查看',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xff5e5e5e),
            ),
          ),
          SizedBox(
            height: 32.h,
          ),
          GestureDetector(
            onTap: () {
              /// 切换城市
              Map<String, dynamic> params = {
                "fromConfirm": widget.isFromConfirm ? 'true' : 'false'
              };
              NavigatorUtils.push(context, CommonPageRouter.cityListPage, params: params)
                  .then((value) {
                StoreBloc bloc = context.read<StoreBloc>();
                logI('city page pop !!!');
                if (value != null) {
                  logI('选择的城市：${value.toJson()}');
                  bool isFromHaveStore = bloc.state.storeListEntity?.nearbyShopList != null &&
                      (bloc.state.storeListEntity?.nearbyShopList ?? []).isNotEmpty;
                  if (!isFromHaveStore) {
                    isFromHaveStore = bloc.state.storeListEntity?.oftenUsedShopList != null &&
                        (bloc.state.storeListEntity?.oftenUsedShopList ?? []).isNotEmpty;
                  }

                  SensorsAnalyticsFlutterPlugin.track(
                      StoreSensorsConstant.storeListCitySelectedClick,
                      {'isFromHaveStore': isFromHaveStore});

                  context.read<StoreBloc>().add(StoreListChangeCityEvent(value,context: context));
                }
              });
            },
            child: Container(
              width: 144.w,
              height: 39.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CottiColor.primeColor,
                borderRadius: BorderRadius.all(Radius.circular(2.r)),
              ),
              child: Text(
                '切换城市',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchEmptyWidget() {
    return Container(
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/shop/shop_empty_img.svg',
            width: 141,
            height: 121,
          ),
          SizedBox(
            height: 32.h,
          ),
          Text(
            '抱歉，未找到您想要的门店，换个词试试吧',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xff5e5e5e),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDataList() {
    String stringTip;
    if ((widget.storeListEntity?.oftenUsedShopList ?? []).isEmpty) {
      stringTip = '附近门店';
    } else {
      stringTip = '附近其他门店';
    }

    bool isShowSearchShop = false;
    if (widget.shopMdName != null && widget.shopMdName != '') {
      isShowSearchShop = true;
    }

    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        //开始滚动
        // if (notification is ScrollStartNotification) {
        //   focusNode.unfocus();
        // }
        return true;
      },
      child:
          isShowSearchShop ? _buildSearchListWidget() : _buildStoreListWidget(stringTip: stringTip),
    );
  }

  Widget _buildSliverPersistentHeader(String title, List<StoreListDataModel>? listData) {
    return listData!.isNotEmpty
        ? MySliverPersistentHeaderDelegate(title: title)
        : _buildSliverToBoxAdapter();
  }

  Widget _buildSliverToBoxAdapter() {
    return const SizedBox(
      height: 0,
    );
  }

  /// 常用门店列表
  Widget _buildCommonStoreList(List<StoreListDataModel> commonStores) {
    List<Widget> list = [];

    for (int index = 0; index < commonStores.length; index++) {
      StoreListItem item = StoreListItem(
        isNearest: false,
        model: commonStores[index],
        shopMdCode: widget.selectedStoreModel?.shopMdCode,
        shopTypeFrBos: widget.storeListEntity?.shopTypeFrBos??[],
        frameCallBack: itemFrameCallBackAction,
        oftenUsed: true,
      );
      list.add(item);
    }

    return Column(
      children: list,
    );
  }

  /// 附近门店列表
  Widget _buildOtherStoreList(List<StoreListDataModel> otherStores) {
    List<Widget> list = [];

    for (int index = 0; index < otherStores.length; index++) {
      StoreListItem item = StoreListItem(
        isNearest: true,
        model: otherStores[index],
        shopMdCode: widget.selectedStoreModel?.shopMdCode,
        shopTypeFrBos: widget.storeListEntity?.shopTypeFrBos??[],
        frameCallBack: itemFrameCallBackAction,
        oftenUsed: true,
      );
      list.add(item);
    }

    return Column(
      children: list,
    );
  }

  /// 选中门店item build完成的回调，用于滚动到选中位置
  void itemFrameCallBackAction(BuildContext itemContext) {
    if (widget.moveMapEventTimeStamp == lastMoveMapEventTimeStamp) {
      return;
    }
    lastMoveMapEventTimeStamp = widget.moveMapEventTimeStamp;
    RenderBox? scrollBox = scrollKey.currentContext?.findRenderObject() as RenderBox?;
    RenderBox? renderBox = itemContext.findRenderObject() as RenderBox?;
    if (renderBox != null && scrollBox != null) {
      Offset offset = renderBox.localToGlobal(Offset.zero);
      logI('frameCallBack: (BuildContext itemContext 111) = $offset');
      Offset scrollOffset = scrollBox.localToGlobal(Offset.zero);
      logI('frameCallBack: (BuildContext scrollOffset 111) = $scrollOffset');
      double diff = offset.dy - scrollOffset.dy;
      logI('frameCallBack: (BuildContext diff 111) = $diff');

      scrollController.animateTo(
        diff - 6.h,
        duration: const Duration(microseconds: 1000),
        curve: Curves.easeIn,
      );
    }
  }
}

class MySliverPersistentHeaderDelegate extends StatelessWidget {
  final String title;

  const MySliverPersistentHeaderDelegate({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CottiColor.backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      alignment: Alignment.centerLeft,
      height: 38.0.h,
      child: Text(
        title,
        style: TextStyle(
          color: CottiColor.textGray,
          fontSize: 13.sp,
          height: 1.3,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
