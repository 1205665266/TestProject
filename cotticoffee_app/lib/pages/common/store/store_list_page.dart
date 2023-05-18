import 'dart:io';

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/store/bloc/store_bloc.dart';
import 'package:cotti_client/pages/common/store/views/map_center_icon.dart';
import 'package:cotti_client/pages/common/store/views/store_list.dart';
import 'package:cotti_client/pages/common/store/views/store_map.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/sensors/store_sensors_constant.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreListPage extends StatefulWidget {
  bool isFromConfirm;

  StoreListPage({Key? key, this.isFromConfirm = false}) : super(key: key);

  @override
  State<StoreListPage> createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> with WidgetsBindingObserver {
  final StoreBloc _bloc = StoreBloc();
  ValueNotifier<double> topValueChange = ValueNotifier(812.h / 2.0);
  double recordDragDistance = 0;
  bool atBottom = true;
  late ShopMatchBloc _matchBloc;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    _matchBloc = context.read<ShopMatchBloc>();
    int? shopMdCode = _matchBloc.state.selfTakeShopInfo?.shopDetail?.shopMdCode;
    _bloc.add(CurrShopEvent(shopMdCode));
    _bloc.add(InitFromPageEvent(widget.isFromConfirm));
    _bloc.add(StoreListEvent(context));
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance?.addPersistentFrameCallback((timeStamp) {
      if (mounted) {
        if (MediaQuery.of(context).viewInsets.bottom == 0) {
        } else {
          if (topValueChange.value != 88.h) {
            topValueChange.value = 88.h;
            _bloc.state.atBottom = false;
            _bloc.add(StoreArrowChangeEvent());
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        return BlocListener<ShopMatchBloc, ShopMatchState>(
          listener: (context, dialogShowState) => {},
          bloc: _matchBloc,
          child: BlocBuilder<ShopMatchBloc, ShopMatchState>(
            builder: (matchContext, matchState) {
              return CustomPageWidget(
                showAppBar: false,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 812.h / 2,
                      child: state.storeListEntity != null
                          ? StoreMap(
                              storeListEntity: state.storeListEntity,
                              locationResult: state.locationResult,
                            )
                          : _buildEmptyMap(state),
                    ),
                    ValueListenableBuilder<double>(
                      valueListenable: topValueChange,
                      builder: (BuildContext context, value, Widget? child) {
                        return Stack(
                          clipBehavior: Clip.antiAlias,
                          children: [
                            Positioned(
                              top: topValueChange.value,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: GestureDetector(
                                onVerticalDragUpdate: (DragUpdateDetails details) {
                                  logI('开始拖动:${details.delta.dy}');
                                  double topDistance = topValueChange.value + details.delta.dy;
                                  recordDragDistance += details.delta.dy;

                                  if (topDistance > 812.h / 2.0) {
                                    topValueChange.value = 812.h / 2.0;
                                  } else if (topDistance < 88.h) {
                                    topValueChange.value = 88.h;
                                  } else {
                                    topValueChange.value = topDistance;
                                  }
                                },
                                onVerticalDragStart: (DragStartDetails details) {
                                  _closeKeyboard(context);
                                },
                                onVerticalDragEnd: (DragEndDetails details) {
                                  if (recordDragDistance > 0 && recordDragDistance < 20) {
                                    topValueChange.value = 88.h;

                                    _bloc.state.atBottom = false;
                                    _bloc.add(StoreArrowChangeEvent());
                                  } else if (recordDragDistance > 20) {
                                    topValueChange.value = 812.h / 2.0;
                                    _bloc.state.atBottom = true;
                                    _bloc.add(StoreArrowChangeEvent());
                                  } else if (recordDragDistance < -20) {
                                    topValueChange.value = 88.h;

                                    _bloc.state.atBottom = false;
                                    _bloc.add(StoreArrowChangeEvent());
                                  } else {
                                    topValueChange.value = 812.h / 2.0;

                                    _bloc.state.atBottom = true;
                                    _bloc.add(StoreArrowChangeEvent());
                                  }
                                  recordDragDistance = 0;
                                },
                                onPanEnd: (DragEndDetails e) {},
                                child: _showStroeList(state)
                                    ? StoreList(
                                        storeListEntity: state.storeListEntity,
                                        cityDataEntity: Constant.cityDataEntity,
                                        shopMdName: state.shopMdName,
                                        shopListLoading: state.shopListLoading||state.showLoading,
                                        isFromConfirm: widget.isFromConfirm,
                                        moveMapEventTimeStamp: state.moveMapEventTimeStamp,
                                      )
                                    : _buildEmptyList(state),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Positioned(
                      top: 50.h,
                      left: 0,
                      child: GestureDetector(
                        onTap: () => NavigatorUtils.pop(context),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: SvgPicture.asset(
                            'assets/images/shop/shop_list_go_back.svg',
                            width: 32.h,
                            height: 32.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(
            height: 60.w,
          ),
          LottieBuilder.asset(
            'assets/images/lotti/loading_data.json',
            width: 48.w,
            height: 48.h,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMap(StoreState state) {
    ShopMatchState matchState = _matchBloc.state;
    if ((matchState.locationResult?.errorCode == 12 ||
        (Platform.isIOS && matchState.locationResult?.errorCode == 2))) {
      return Stack(
        children: [
          Image.network(
            'https://cdn-product-prod.yummy.tech/wechat/cotti/images/common/map_no_bj.png',
            fit: BoxFit.fitHeight,
            height: 812.h / 2,
            width: double.infinity,
          ),
          Positioned(
            right: 12.w,
            bottom: 20.w,
            child: GestureDetector(
              onTap: () {
                openAppSettings();
              },
              child: Image.asset(
                'assets/images/shop/shop_list_map_location.png',
                width: 40.w,
                height: 40.w,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: 812.h / 4.0 - 37.h,
            left: 375.w / 2.0 - 12.w,
            child: Column(
              children: [
                MapCenterIcon(
                  iconController: IconController(),
                ),
                Transform.translate(
                  offset: Offset(0.0, -2.h),
                  child: SvgPicture.network(
                    'https://cdn-product-prod.yummy.tech/wechat/cotti/images/common/map_center_bottom_img_1.svg',
                    width: 24.w,
                    height: 9.w,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }

  bool _showStroeList(StoreState state){
    ShopMatchState matchState = _matchBloc.state;
    return state.storeListEntity != null || !(matchState.locationResult?.errorCode == 12 ||
        (Platform.isIOS && matchState.locationResult?.errorCode == 2));

  }

  Widget _buildEmptyList(StoreState state) {
    logI('in _buildEmptyList func !!!!');
    ShopMatchState matchState = _matchBloc.state;
    if ((matchState.locationResult?.errorCode == 12 ||
        (Platform.isIOS && matchState.locationResult?.errorCode == 2))) {
      return Container(
        color: CottiColor.backgroundColor,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  Map<String, dynamic> params = {
                    "fromConfirm": widget.isFromConfirm ? 'true' : 'false'
                  };
                  NavigatorUtils.push(context, CommonPageRouter.cityListPage, params: params)
                      .then((value) {
                    logI('选择的城市：${value.toJson()}');
                    if (value != null) {
                      _bloc.add(StoreListChangeCityEvent(value,context: context));
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.all(Radius.circular(2.w))),
                  height: 32.w,
                  margin: EdgeInsets.only(left: 16.w, top: 8.w, right: 16.w, bottom: 12.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 12.w, right: 2.w),
                            child: Text(
                              '请选择',
                              style: TextStyle(
                                  color: const Color(0xFF3A3B3C),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.sp),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/images/shop/shop_list_list_top_city_arrow.svg',
                            width: 16.w,
                            height: 16.w,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        color: Color(0xFFCFCFCF),
                        margin: EdgeInsets.only(left: 4.w, right: 8.w, top: 9.h, bottom: 9.h),
                        width: 1.w,
                      ),
                      Expanded(
                        child: Container(
                          height: 32.w,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '搜索门店',
                            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF979797)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/images/menu/icon_no_location_permission.svg',
              width: 140.w,
              height: 120.h,
            ),
            SizedBox(height: 22.h),
            Text(
              '呃...COTTI 无法定位到您哦',
              style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              '可开启定位或手动选择门店',
              style: TextStyle(
                color: const Color(0xFF666666),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () {
                SensorsAnalyticsFlutterPlugin.track(
                    StoreSensorsConstant.storeListLocationStreamerClick, {});
                openAppSettings();
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
                  '开启定位',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () {
                Map<String, dynamic> params = {
                  "fromConfirm": widget.isFromConfirm ? 'true' : 'false'
                };
                NavigatorUtils.push(context, CommonPageRouter.cityListPage, params: params)
                    .then((value) {
                  logI('选择的城市：${value.toJson()}');
                  if (value != null) {
                    _bloc.add(StoreListChangeCityEvent(value,context: context));
                  }
                });
              },
              child: Container(
                width: 144.w,
                height: 39.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5.w, color: CottiColor.primeColor),
                  borderRadius: BorderRadius.all(Radius.circular(2.r)),
                  color: Colors.white,
                ),
                child: Text(
                  '选择城市',
                  style: TextStyle(
                    color: CottiColor.primeColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Visibility(
      visible: state.shopListLoading||state.showLoading,
      child: _buildLoadingWidget(),
      replacement: Container(
        color: Colors.white,
      ),
    );
  }

  /// 收起键盘
  void _closeKeyboard(BuildContext context) {
    NavigatorUtils.unfocus();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
    WidgetsBinding.instance?.removeObserver(this);
  }
}
