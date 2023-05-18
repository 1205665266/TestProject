import 'package:azlistview/azlistview.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/address/search_address/widget/city_search_widget.dart';
import 'package:cotti_client/pages/common/city/bloc/city_list_bloc.dart';
import 'package:cotti_client/pages/common/city/views/city_list_item_widget.dart';
import 'package:cotti_client/sensors/store_sensors_constant.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'entity/city_list_data_entity.dart';
import 'enum/location_status_enum.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CityListPage extends StatefulWidget {
  final bool isAll;
  final bool fromConfirm;

  const CityListPage({Key? key, this.isAll = false, this.fromConfirm = false}) : super(key: key);

  @override
  State<CityListPage> createState() => _CityListPageState();
}

class _CityListPageState extends State<CityListPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  double susItemHeight = 20;

  late AnimationController _animationController;
  late Animation<double> _animation;

  final CityListBloc _bloc = CityListBloc();

  String? searchCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // title = "选择城市";
    WidgetsBinding.instance!.addObserver(this);
    _animationController =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _bloc.add(InitEvent(context));
    // super.resizeToAvoidBottomInset = false;
    // Future.delayed(const Duration(milliseconds: 5000), () {
    //   _bloc.add(RequestCurrentLocationCityInfoEvent());
    // });

    logI('fromConfirm = ==== cityListPage ${widget.fromConfirm}');

    _bloc.add(RequestCityListEvent(widget.isAll,widget.fromConfirm));

    SensorsAnalyticsFlutterPlugin.track(StoreSensorsConstant.cityListShow, {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        _bloc.add(RequestLocationPermissionEvent());
        // ABiteLog.w("${_bloc.state.isLocationPermission}", tag: 'didChangeAppLifecycleState');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _bloc,
      child: BlocBuilder<CityListBloc, CityListState>(builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: _buildBody(),
          /*body: CustomPageWidget(
              title: '城市定位',
              showAppBar: false,
              child: _buildBody(),
              // child: Column(
              //   children: [
              //     _buildCurrentCity(state.currentLocationCityModel, state.locationStatus),
              //     _buildCityList(state.cityList),
              //   ],
              // ),
          ),*/
        );
      }),
    );
  }

  Widget _buildBody() {
    logI('searchCode ----- !! $searchCode');
    if (_bloc.state.searchList.isNotEmpty || (searchCode != null && searchCode!.isNotEmpty)) {
      List<CityListDataData> cityList = [..._bloc.state.searchList];

      logI('_bloc.state.searchList == $cityList');

      cityList.insert(
          0,
          CityListDataData()
            ..cityName = '123'
            ..tagIndex = '123');

      return Column(
        children: [
          /// cityList 为顶部城市定位widget随列表滚动
          // _buildCityList(cityList),
          /// 顶部城市定位widget不随列表滚动
          _buildSearchCityList(_bloc.state.searchList),
        ],
      );
    } else {
      List<CityListDataData> cityList = [..._bloc.state.cityList];

      cityList.insert(
          0,
          CityListDataData()
            ..cityName = '123'
            ..tagIndex = '123');

      return Column(
        children: [
          /// cityList 为顶部城市定位widget随列表滚动
          _buildCurrentCity(_bloc.state.currentLocationCityModel, _bloc.state.locationStatus),
          _buildCityList(_bloc.state.cityList),

          /// 顶部城市定位widget不随列表滚动
          // _buildCityList(cityList),
        ],
      );
    }
  }
  double headWidgetHeight() {
    double topPadding = MediaQuery.of(context).padding.top;
    return topPadding.h + 44.h;
  }

  Widget _buildSearchCityList(List<CityListDataData> citySearchList) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - headWidgetHeight()),
        child: citySearchList.isNotEmpty
            ? ListView.separated(
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(1),
            itemBuilder: (BuildContext context, int position) =>
                _buildListItem(model: citySearchList[position], showDivider: false),
            itemCount: citySearchList.length,
            separatorBuilder: (_, index) => CityListItemWidget.cityListDivider(honValue: 20.w))
            : _searchEmptyWidget(),
      ),
    );
  }

  Widget _searchEmptyWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/menu/icon_nearby_no_stores.png',
            width: 140.w,
            height: 120.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            '未找到相关城市',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF969799)),
          ),
          SizedBox(
            height: 100.h,
          ),
        ],
      ),
    );
  }

  final FocusNode _focusNode = FocusNode();

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leadingWidth: 35.w,
      title: CitySearchWidget(
        hintText: '请输入城市名进行搜索',
        focusNode: _focusNode,
        onChanged: (val) {
          logW("search code -> $val");
          searchCode = val;
          _bloc.add(CityListSearchEvent(searchCode: val));
        },
        margin: EdgeInsets.only(right: 15.w),
      ),
      toolbarHeight: 42.h,
      titleSpacing: 1.w,
      // centerTitle: true,
      // backgroundColor: widget.appBarBackgroundColor,
      // systemOverlayStyle: widget.darkThem,
      elevation: 0,
      // actions: widget.actions,
      // automaticallyImplyLeading: widget.automaticallyImplyLeading,
      leading: UnconstrainedBox(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            NavigatorUtils.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: SvgPicture.asset(
              'assets/images/ic_back.svg',
              width: 20.w,
              height: 20.h,
              color: CottiColor.textBlack,
            ),
          ),
        ),
      ),
    );
  }

  /// 当前城市定位
  Widget _buildCurrentCity(
      CityListDataData? currentLocationCityModel, LocationStatusEnum locationStatus) {
    String locationImagePath = locationStatus != LocationStatusEnum.fail
        ? 'assets/images/city/ic_city_location_success.svg'
        : 'assets/images/city/ic_city_location_failure.svg';
    Color locationColor = locationStatus != LocationStatusEnum.fail
        ? const Color(0xFF3A3B3C)
        : CottiColor.primeColor;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              color: Colors.white,
              height: 28.h,
              alignment: Alignment.bottomLeft,
              child: Text(
                '定位',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF979797),
                ),
              )),
          InkWell(
            onTap: () {
              // ABiteLog.w('${currentLocationCityModel ?? ''}', tag: '定位城市');

              if (currentLocationCityModel != null) {
                // ABiteLog.w("$_bloc -- $context", tag: '1111');
                CityListDataData dataModel =
                    CityListDataData.fromJson(_bloc.state.currentLocationCityModel!.toJson());

                _bloc.add(PopStoreListPageEvent(context, cityModel: dataModel));

                SensorsAnalyticsFlutterPlugin.track(
                    StoreSensorsConstant.cityListCurrentLocationCityClick, {'cityName': dataModel.cityName});
              }
            },
            child: SizedBox(
              height: 48.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      locationImagePath,
                      width: 20.w,
                      height: 20.h,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                        currentLocationCityModel?.cityName ??
                            (locationStatus == LocationStatusEnum.positioning
                                ? '定位中'
                                : '定位失败，点击重试'),
                        style: TextStyle(fontSize: 13.sp, color: locationColor))
                  ],
                ),
                InkWell(
                  onTap: () {
                    _animationController.forward();
                    _animationController.addStatusListener((status) {
                      if (status == AnimationStatus.completed) {
                        //AnimationStatus.completed 动画在结束时停止的状态
                        _animationController.reset();
                      }
                    });
                    _bloc.state.locationStatus = LocationStatusEnum.positioning;
                    _bloc.add(RelocationEvent(this.context));

                    SensorsAnalyticsFlutterPlugin.track(
                        StoreSensorsConstant.cityListAgainLocationClick, {});
                  },
                  child: SizedBox(
                    height: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RotationTransition(
                          turns: _animation,
                          child: SvgPicture.asset(
                            'assets/images/city/ic_city_refresh.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text("重新定位",
                            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF979797))),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  /// 城市列表
  Widget _buildCityList(List<CityListDataData> cityList) {
    logI('1234');

    bool hasLocation = false;
    List<CityListDataData> indexList;

    CityListDataData? first = cityList.isNotEmpty ? cityList.first : null;

    if (first != null && first.tagIndex == '123') {
      indexList = [...cityList];
      indexList.removeAt(0);
      hasLocation = true;
    } else {
      indexList = cityList;
    }

    return Expanded(
      child: AzListView(
        data: cityList,
        padding: EdgeInsets.only(
          bottom: 20.h,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0 && hasLocation) {
            return _buildCurrentCity(
                _bloc.state.currentLocationCityModel, _bloc.state.locationStatus);
          }
          CityListDataData model = cityList[index];

          bool showDivider = index != (cityList.length - 1);
          return _buildListItem(model: model, showDivider: showDivider);
        },
        indexBarData: SuspensionUtil.getTagIndexList(indexList),
        indexBarOptions: const IndexBarOptions(
          needRebuild: true,
          ignoreDragCancel: true,
          downTextStyle: TextStyle(fontSize: 12, color: Colors.white),
          downItemDecoration: BoxDecoration(shape: BoxShape.circle, color: CottiColor.primeColor),
          indexHintWidth: 120 / 2,
          indexHintHeight: 100 / 2,
          indexHintDecoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/address/ic_index_bar_bubble_gray.png"),
              fit: BoxFit.contain,
              opacity: 0.8,
            ),
          ),
          indexHintAlignment: Alignment.centerRight,
          indexHintChildAlignment: Alignment(-0.25, 0.0),
          indexHintOffset: Offset(-8, 0),
        ),
        itemCount: cityList.length,
        susItemHeight: susItemHeight,
        susItemBuilder: (BuildContext context, int index) {
          CityListDataData model = cityList[index];
          logI('susItemBuilder: === ${model.tagIndex} index == $index ${model.cityName}');
          if (model.tagIndex == '123') {
            return Container();
          }
          return _buildSusListItem(model);
        },
      ),
    );
  }

  /// 城市项目
  Widget _buildListItem({required CityListDataData model, required bool showDivider}) {
    return Container(
      color: Colors.white,
      child: Column(children: [
        CityListItemWidget(
            model: model,
            textColor: const Color(0xFF3A3B3C),
            onTap: () {
              SensorsAnalyticsFlutterPlugin.track(
                  StoreSensorsConstant.cityListItemClick, {'cityName': model.cityName});
              _bloc.add(PopStoreListPageEvent(context, cityModel: model));
            }),
        showDivider ? CityListItemWidget.cityListDivider() : const SizedBox(),
      ]),
    );
  }

  /// 组头组件
  Widget _buildSusListItem(CityListDataData model) {
    String tag = model.getSuspensionTag();
    logI('susItemHeight === $susItemHeight');
    return Container(
      height: susItemHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20.0.w),
      color: const Color(0xFFF5F5F5),
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        softWrap: false,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF999999),
        ),
      ),
    );
  }
}
