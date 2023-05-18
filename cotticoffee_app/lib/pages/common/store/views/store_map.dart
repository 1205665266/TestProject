import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/store/bloc/store_bloc.dart';
import 'package:cotti_client/pages/common/store/entity/store_list_data_entity.dart';
import 'package:cotti_client/pages/common/store/views/map_center_icon.dart';
import 'package:cotti_client/sensors/mine_sensors_constant.dart';
import 'package:cotti_client/sensors/store_sensors_constant.dart';
import 'package:cotti_client/service/location/location_result.dart';
import 'package:cotti_client/service/location/location_service.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/widget_to_image.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class StoreMap extends StatefulWidget {
  const StoreMap({Key? key, this.storeListEntity, this.selectedStoreModel, this.locationResult})
      : super(key: key);
  final StoreListDataEntity? storeListEntity;
  final StoreListDataModel? selectedStoreModel;

  final LocationResult? locationResult;

  @override
  State<StoreMap> createState() => _StoreMapState();
}

class _StoreMapState extends State<StoreMap> {
  CameraPosition? _kInitialPosition = null;

  late StoreBloc _bloc;

  static MyLocationStyleOptions locationOptions = MyLocationStyleOptions(
    true,
    icon: BitmapDescriptor.fromIconPath("assets/images/shop/ic_empty.png"),
    circleFillColor: Colors.transparent,
    circleStrokeColor: Colors.transparent,
  );

  ///先将申请的Android端可以和iOS端key设置给AMapApiKey
  static const AMapApiKey amapApiKeys =
      AMapApiKey(androidKey: Constant.androidMapKey, iosKey: Constant.iosMapKey);

  late AMapWidget map;

  Map<String, Marker> _initMarkerMap = <String, Marker>{};

  BitmapDescriptor? customMarker;
  BitmapDescriptor? userCustomMarker;
  Uint8List? customBytes;
  List<ShopTypeListModel>? shopTypeFrBos = [];
  List<StoreListDataModel>? _shopList;
  List<Widget> _mapShopTypeDesList = []; //地图图例

  LatLng? recordOldLatLng;

  LatLng? userLocation;

  IconController iconController = IconController();

  final GlobalKey _globalKey = GlobalKey();

  /// 标记图片加载完成的门店code，防止mark 闪烁的问题
  int? readyCode;

  final GlobalKey _userIconKey = GlobalKey();

  /// 标记用户头像image是否加载完成
  bool userIconIsReady = false;

  /// map 加载完成标记
  bool mapCreated = false;

  @override
  void dispose() {
    super.dispose();
    logI('in store_map dispose !!!');
  }

  @override
  void initState() {
// TODO: implement initState
    super.initState();

    _bloc = context.read<StoreBloc>();

    initPosition();
    _handleShopType(widget.storeListEntity);
  }

  _handleShopType(StoreListDataEntity? storeListEntity) async {
    logI('in _handleShopType storeListEntity == ${storeListEntity?.shopTypeFrBos}');
    var modelList = storeListEntity!.shopTypeFrBos ?? [];
    for (int i = 0; i < modelList.length; i++) {
      StoreListDataShopTypeFrBos oldModel = modelList[i];

      var imageUrl = oldModel.iconUrl!;

      Uint8List bytes =
          (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl)).buffer.asUint8List();

      logI('下载的图片数据$bytes');
      ShopTypeListModel newModel = ShopTypeListModel();
      newModel.iconUrl = oldModel.iconUrl;
      newModel.name = oldModel.name;
      newModel.color = oldModel.color;
      newModel.index = oldModel.index;
      newModel.bitMap = BitmapDescriptor.fromBytes(bytes);
      shopTypeFrBos!.add(newModel);
      logI('数据开始处理了：${shopTypeFrBos?.length}');
    }
    logI('in _handleShopType shopTypeFrBos == $shopTypeFrBos');

    UserBloc _userBloc = GlobalBlocs.get(UserBloc.blocName);

    String headPortrait = _userBloc.state.userModel?.headPortrait ?? "";

    logI('String headPortrait = $headPortrait');



    ByteData byteData = await rootBundle.load('assets/images/shop/ic_store_map_user_icon@2x.png');

    Uint8List uint8list = byteData.buffer.asUint8List();

    /// 生成用户未登录时的默认头像Mark图片

    userCustomMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 1,
          size: Size(130.w, 130.w),
        ),
        "assets/images/shop/ic_store_map_user_icon@2x.png",
        mipmaps: false);

    setState(() {});
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _addMarker();
    });
  }

  Uint8List? userIconBytes;

  //! 获取坐标极值之间的距离double
  getDistanse(double lat1, double lat2, double lon1, double lon2) {
    //! 根据坐标，地球半径算出两个坐标之间的距离

    double radLat1 = lat1 * math.pi / 180;
    double radLat2 = lat2 * math.pi / 180;
    double radLon1 = lon1 * math.pi / 180;
    double radLon2 = lon2 * math.pi / 180;
    double a = radLat1 - radLat2;
    double b = radLon1 - radLon2;
    double s = 2 *
        math.asin(math.sqrt(math.pow(math.sin(a / 2), 2) +
            math.cos(radLat1) * math.cos(radLat2) * math.pow(math.sin(b / 2), 2)));
    s = s * 6378.137;
    s = (s * 10000).round() / 10000;
    return s;
  }

  getZoom(double distance) {
    /**
        zoom	距离
        2	1000KM
        3	1000KM
        4	500KM
        5	200KM
        6	100KM
        7	50KM
        8	30KM
        9	20KM
        10	10KM
        11	5KM
        12	2KM
        13	1KM
        14	500m
        15	200m
     * */

    if (distance < 1) {
      ///16 100m
      return 16;
    } else if (distance < 5) {
      /// 12 2KM
      return 12;
    } else if (distance < 10) {
      /// 11 5KM
      return 11;
    } else if (distance < 25) {
      /// 9 20KM
      return 9;
    } else {
      /// 7 50KM
      return 7;
    }
  }

  /// 初始化位置
  void initPosition() async {
    // _kInitialPosition = null;
    /// 如果当前定位未成功，初始定位点默认在北京中心

    /// 初始定位点默认在北京中心
    var lat = 39.909187;
    var lon = 116.397451;

    var latLng = LatLng(lat, lon);

    try {
      _shopList = [
        ...widget.storeListEntity!.oftenUsedShopList ?? [],
        ...widget.storeListEntity!.nearbyShopList ?? []
      ];

      LocationResult locationResult = await LocationService().startLocation(context);
      logI('LocationResult locationResult =       1 _shopList = $_shopList');
      //
      var latitude = locationResult.positionInfoEntity?.latitude;
      var longitude = locationResult.positionInfoEntity?.longitude;
      logI('LocationResult locationResult =       2');
      if (latitude != null && longitude != null) {
        userLocation = LatLng(latitude, longitude);
      }
      logI('LocationResult locationResult =       3');
      StoreListDataModel? model;

      if (_shopList != null && _shopList!.isNotEmpty) {
        model = _shopList?.first;
      }
      logI('LocationResult locationResult =       4');
      for (StoreListDataModel m in _shopList ?? []) {
        if (m.selected
            // && !_bloc.state.isChangeCity
            ) {
          model = m;
        }
      }
      logI('LocationResult locationResult =       5 model = $model');

      model?.selected = true;

      bool isChangeCity = _bloc.state.isChangeCity;
      logI('LocationResult locationResult =       6 isChangeCity = $isChangeCity');

      if (!isChangeCity && latitude != null && longitude != null) {
        /// 首次进入场景，显示用户定位
        /// 用户定位坐标
        latLng = LatLng(latitude, longitude);

        if (model != null) {
          var distance = getDistanse(model.latitude!, latitude, model.longitude!, longitude);

          double zoom = getZoom(distance).toDouble();

          logW(
              'distance == $distance , zoom === $zoom  isChangeCity = ${_bloc.state.isChangeCity}');
          logI('_kInitialPosition =   12         1');
          _kInitialPosition = CameraPosition(target: latLng, zoom: zoom);
        } else {
          logI('_kInitialPosition =   12         2');
          _kInitialPosition = CameraPosition(target: latLng, zoom: 12);
        }
      } else if (isChangeCity) {
        logI('_kInitialPosition =   12         3');

        /// 切换城市场景，显示model定位；
        if (model != null) {
          logI('_kInitialPosition =   12         4');
          latLng = LatLng(model.latitude!, model.longitude!);
          _kInitialPosition = CameraPosition(target: latLng, zoom: 12);
        } else {
          logI('_kInitialPosition =   12         5');
        }
      }

      logI('LocationResult locationResult =       7 _kInitialPosition = $_kInitialPosition');
      logI('LocationResult locationResult =       8 model.latitude = ${model?.latitude}');
      logI('LocationResult locationResult =       9 model.longitude = ${model?.longitude}');
      if (_kInitialPosition == null &&
          model != null &&
          model.latitude != null &&
          model.longitude != null) {
        logI('in last if !!!!');
        LatLng modelTag = LatLng(model.latitude!, model.longitude!);
        _kInitialPosition = CameraPosition(target: modelTag, zoom: 12);
      }

      // if (_kInitialPosition == null) {
      //   logI('in last if !!!!22222');
      //   /// 兜底，显示天安门
      //   var lat = 39.909187;
      //   var lon = 116.397451;
      //   latLng = LatLng(lat, lon);
      //   _kInitialPosition = CameraPosition(target: latLng, zoom: 12);
      // }
    } catch (error) {
      logI('error in init map $error');
    }
    if (mounted) {
      /// 存在需要刷新的情况
      setState(() {});
    }

    // if(_mapController != null && _kInitialPosition?.target != null){
    // _mapController?.moveCamera(CameraUpdate.newLatLng(_kInitialPosition!.target!));
    // }

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _addMarker();
    });
  }

  _changeToUserLocation() {
    if (userLocation != null) {
      logI('moveCamera in _changeToUserLocation');

      SensorsAnalyticsFlutterPlugin.track(StoreSensorsConstant.storeMapLocationClick, {});

      _mapController?.moveCamera(CameraUpdate.newLatLng(userLocation!));
      setState(() {
        _showCenterIcon = false;
      });
    }
  }

  bool _moved = false;
  bool _showCenterIcon = false;

  Uint8List? mapImage;

  @override
  Widget build(BuildContext context) {
    // _changeMapCenter();

    logI('_kInitialPosition ==== $_kInitialPosition');
    // _kInitialPosition = null;
    CameraPosition temp;
    if (_kInitialPosition == null) {
      var lat = 39.909187;
      var lon = 116.397451;
      LatLng latLng = LatLng(lat, lon);
      temp = CameraPosition(target: latLng, zoom: 12);
    } else {
      temp = _kInitialPosition!;
    }

    double bottomOffset = 20.w;

    return BlocListener<StoreBloc, StoreState>(
      listener: (context, state) {
        logI('in StoreBloc listener     0 ${widget.storeListEntity?.nearbyShopList}');
        logI('in StoreBloc listener     1 ${state.storeListEntity?.nearbyShopList}');

        if (!(widget.storeListEntity == state.storeListEntity)) {
          initPosition();
          _handleShopType(state.storeListEntity);
        }

        if (state.storeListEntity == null) {
          return;
        }
        /*if (state.isChangeCity) {
          StoreListDataModel? model = state.storeListEntity?.nearbyShopList?.first;

          if (state.storeListEntity!.oftenUsedShopList!.isNotEmpty) {
            model = state.storeListEntity?.oftenUsedShopList?.first;
          }

          model?.selected = true;

          LatLng latLng = LatLng(model?.latitude ?? 0, model?.longitude ?? 0);
          logW(
              " 1111 LatLng latLng === $latLng   ${state.storeListEntity?.nearbyShopList?.first.shopName}");
          if (_kInitialPosition == null) {
            _kInitialPosition = CameraPosition(target: latLng, zoom: 15);
          } else {
            logI('moveCamera in listener');
            _mapController?.moveCamera(CameraUpdate.newLatLng(latLng));
          }
          state.isChangeCity = false;
          _addMarker();
          return;
        }*/

        _shopList = [
          ...state.storeListEntity!.oftenUsedShopList ?? [],
          ...state.storeListEntity!.nearbyShopList ?? []
        ];

        if (mapCenterTarget != null) {
          /// 排序
          _shopList?.sort((StoreListDataModel a, StoreListDataModel b) {
            double longa = mapCenterTarget!.longitude - (a.longitude ?? 0.0);
            double lata = mapCenterTarget!.latitude - (a.latitude ?? 0.0);

            double longb = mapCenterTarget!.longitude - (b.longitude ?? 0.0);
            double latb = mapCenterTarget!.latitude - (b.latitude ?? 0.0);

            return (longa * longa + lata * lata).compareTo(longb * longb + latb * latb);
          });

          for (int i = 0; i < _shopList!.length; i++) {
            StoreListDataModel model = _shopList![i];
            model.selected = i == 0;
          }
        }

        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          _addMarker();
        });
      },
      child: Container(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              _cusMarker(),
              _userIconMarker(),
              _kInitialPosition != null
                  ? Container(
                      color: Colors.white,
                      child: mapImage != null
                          ? Container(
                              child: Image.memory(mapImage!),
                              color: Colors.white,
                            )
                          : AMapWidget(
                              initialCameraPosition: temp,
                              scaleEnabled: false,
                              onMapCreated: _onMapCreated,
                              apiKey: amapApiKeys,
                              markers: Set<Marker>.of(_initMarkerMap.values),
                              onCameraMove: (CameraPosition? cameraPosition) {
                                logW("onCameraMove --- ");

                                if (!_moved &&
                                    !(iconController.animationController?.isAnimating ?? false)) {
                                  setState(() {
                                    _moved = true;
                                    _showCenterIcon = true;
                                    iconController.moveUp();
                                  });
                                }

                                // iconController.moveUp();
                              },
                              onCameraMoveEnd: _onCameraMoveEnd,
                              rotateGesturesEnabled: false,
                            ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
              Positioned(
                left: 16.w,
                bottom: bottomOffset,
                width: 64.w,
                // height: 54.w,
                child: Visibility(
                  visible: mapCreated,
                  child: Container(
                    padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(1.w)),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _addMapShopDesWidget()),
                  ),
                ),
              ),
              Positioned(
                // top: 812.h / 4.0 - 60.w,
                // left: 375.w / 2.0 - 25.5.w,
                top: 812.h / 4.0 - 42.h,
                left: 375.w / 2.0 - 12.w,
                child: Visibility(
                  visible: _showCenterIcon,
                  child: SizedBox(
                    height: 40.h,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Visibility(
                            visible: !_moved,
                            child: SvgPicture.network(
                              'https://cdn-product-prod.yummy.tech/wechat/cotti/images/CD4444/map_center_bottom_img_1.svg',
                              width: 24.w,
                              height: 9.w,
                            ),
                          ),
                        ),
                        Positioned(
                          child: MapCenterIcon(
                            iconController: iconController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 12.w,
                bottom: bottomOffset - 5,
                child: Visibility(
                  visible: mapCreated,
                  child: GestureDetector(
                    onTap: () {
                      _changeToUserLocation();
                    },
                    child: Image.asset(
                      'assets/images/shop/shop_list_map_location.png',
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<BitmapDescriptor> _setUserCustomMarker() async {
    return BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          // devicePixelRatio: window.devicePixelRatio,
          size: Size(30.w, 30.w),
        ),
        "assets/images/shop/ic_store_map_user_icon.png",
        mipmaps: false);
  }

  AMapController? _mapController;

  void _onMapCreated(AMapController controller) {
    mapCreated = true;
    /// 以后使用自定义View的时候打开
// MapUtil.widgetToIcon(globalKey).then((value) {
//   ABiteLog.d("widgetToIcon------->$value ");
//   locationOptions.icon = value;
//   setState(() {});
// });
    logW("_onMapCreated !!!!");

    mapCenterTarget = _kInitialPosition?.target;

    // if (_bloc.state.isChangeCity) {
    //   LatLng latLng = LatLng(_bloc.state.centerLatitude!, _bloc.state.centerLongitude!);
    //   logW("LatLng latLng === $latLng");
    //   controller.moveCamera(CameraUpdate.newLatLng(latLng));
    //   _bloc.state.isChangeCity = false;
    // }

    setState(() {
      _mapController = controller;
      // _changeMapCenter();
// getApprovalNumber();
    });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _addMarker();
    });
  }

  LatLng? mapCenterTarget;

  bool isFirst = true;

  void _onCameraMoveEnd(CameraPosition? cameraPosition) {
    logW("_onCameraMoveEnd --- ");

    mapCenterTarget = cameraPosition?.target;

    HapticFeedback.mediumImpact();

    setState(() {
      _moved = false;
    });

    iconController.begain();
    if (null == cameraPosition) {
      return;
    }
    logI('_onCameraMoveEnd===> ${cameraPosition.toMap()}');
    if (context.read<StoreBloc>().state.isChangeCity) {
      // context.read<StoreBloc>().state.isChangeCity = false;
      // return;
    }
    if (!context.read<StoreBloc>().state.showLoading
        // && !isFirst
        ) {
      logI('请求数据进入了===> ${cameraPosition.toMap()}');
      if (recordOldLatLng == null ||
          recordOldLatLng!.latitude != cameraPosition.target!.latitude ||
          recordOldLatLng!.longitude != cameraPosition.target!.longitude) {
        recordOldLatLng = cameraPosition.target;

        context.read<StoreBloc>().add(StoreListMapMoveEvent(
            cameraPosition.target!.latitude, cameraPosition.target!.longitude));
      }
    }
    isFirst = false;
  }

  void requestPermission() async {
// 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
// ABiteLog.d("定位权限申请通过");
    } else {
// ABiteLog.d("定位权限申请不通过");
    }
  }

  void _changeMapCenter() {
    if (_mapController != null &&
        widget.locationResult?.positionInfoEntity?.latitude != null &&
        recordOldLatLng == null &&
        isFirst) {
      var latLng = LatLng(widget.locationResult!.positionInfoEntity!.latitude!,
          widget.locationResult!.positionInfoEntity!.longitude!);
      logI('moveCamera in _changeMapCenter');
      _mapController?.moveCamera(CameraUpdate.newLatLng(latLng));
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
//获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
//已经授权
      return true;
    } else {
//未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  /// 用于生成用户头像Mark的图片
  Widget _userIconMarker() {
    UserBloc _userBloc = GlobalBlocs.get(UserBloc.blocName);

    String? headPortrait = _userBloc.state.userModel?.headPortrait;

    logI('String headPortrait = $headPortrait');

    if (headPortrait == null || headPortrait.isEmpty) {
      headPortrait = 'https://cdn-product-prod.yummy.tech/wechat/cotti/images/mine/ic_user_no_login.png';
    }

    return Positioned(
      top: 120,
      right: 120,
      child: WidgetToImage(
        globalKeys: _userIconKey,
        bgColor: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 35.w,
              height: 35.w,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1),
                child:Image.network(
                  headPortrait,
                  width: 35.w,
                  height: 35.w,
                  loadingBuilder:
                      (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    logI('loadingProgress === !!!! $loadingProgress');

                    if (loadingProgress?.expectedTotalBytes ==
                        loadingProgress?.cumulativeBytesLoaded) {
                      userIconIsReady = true;
                    }

                    return child;
                  },
                ),
              ),
            ),
            Image.asset(
              'assets/images/shop/ic_user_base_inmap.png',
              width: 16,
              height: 7,
              fit: BoxFit.fitHeight,
            ),
          ],
        ),
      ),
    );
  }

  ///预置自定义 marker
  Widget _cusMarker() {
    StoreListDataModel? first;
    for (StoreListDataModel model in _shopList ?? []) {
      if (model.selected) {
        first = model;
      }
    }

    String iconUrl = "";
    bool showTag = false;

    if (first != null && first.status != null) {
      showTag = first.status == 0;
    }

    Widget imgWidget = const SizedBox();
    for (StoreListDataShopTypeFrBos type in _bloc.state.storeListEntity?.shopTypeFrBos ?? []) {
      if (type.index == first?.shopType) {
        iconUrl = type.iconUrl ?? "";

        Uri? uri = Uri.tryParse(iconUrl);
        imgWidget = uri != null
            ? Image.network(
                iconUrl,
                width: 45.w,
                height: 45.h,
                loadingBuilder:
                    (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  logI('loadingProgress === !!!! $loadingProgress');

                  if (loadingProgress?.expectedTotalBytes ==
                      loadingProgress?.cumulativeBytesLoaded) {
                    readyCode = first?.shopMdCode;
                  }

                  return child;
                },
              )
            : const SizedBox();
      }
    }

    logW('String iconUrl = === $iconUrl');
    logW('StoreListDataModel? first = === ${first?.shopName}');

    String guidanceToBeOpened =
        GlobalBlocs.get<ConfigBloc>(ConfigBloc.blocName).state.guidanceToBeOpened;

    return WidgetToImage(
      globalKeys: _globalKey,
      bgColor: Colors.transparent,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 7.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(9.r)),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      first?.shopName ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: CottiColor.textBlack,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      IconFont.icon_right,
                      size: 20.w,
                      color: CottiColor.textGray,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              imgWidget,
            ],
          ),
          showTag
              ? Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffCCCCCC),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  child: Text(
                    guidanceToBeOpened,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      height: 1.2,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  int? selectedShopMdCode;

  void _addMarker() async {
    // _initMarkerMap.clear();
    logI('进入判断前：');

    Map<String, Marker> tempMap = {};

    logI('shopTypeFrBos in _addMarker == $shopTypeFrBos');
    logI('_shopList in _addMarker 1 == $_shopList');
    Marker? bigMarker;
    if (shopTypeFrBos != null && shopTypeFrBos!.isNotEmpty && _shopList != null) {
      logI('进入了判断：123');

      logI('_shopList in _addMarker 2 = $_shopList');

      for (int index = 0; index < _shopList!.length; index++) {
        StoreListDataModel element = _shopList![index];

        logW("element name -123321- ${element.shopName}  selected = ${element.selected}");

        if (element.longitude != null && element.longitude != null) {
          LatLng position = LatLng(element.latitude!, element.longitude!);

          /// element.shopMdCode == readyCode,只有图片加载完成了才继续，防止Mark闪烁。
          if (element.selected && element.shopMdCode == readyCode) {
            logW("element.selected ==== !!!${element.shopName}");

            selectedShopMdCode = element.shopMdCode;

            /// 需要放大处理的Mark
            Uint8List bytes = await GetWidgetToImage.getUint8List(_globalKey);
            logW('Uint8List bytes = === $bytes');

            final Marker marker = Marker(
                position: position,
                //使用默认hue的方式设置Marker的图标
                icon: BitmapDescriptor.fromBytes(bytes),
                onTap: (markerId) {
                  logW("mark on tap $markerId");
                  if (element.shopMdCode != null) {
                    context
                        .read<ShopMatchBloc>()
                        .add(ShopInfoByShopMdCodeEvent(element.shopMdCode!));
                  }
                  NavigatorUtils.pop(context);
                });
            bigMarker = marker;
            // tempMap["-0123213"] = marker;
            // tempMap["${element.shopMdCode}"] = marker;
          } else {
            BitmapDescriptor? bitMap;
            for (var shopTypeModel in shopTypeFrBos!) {
              if (shopTypeModel.index == element.shopType) {
                bitMap = shopTypeModel.bitMap;
              }
            }

            Marker marker = Marker(
              position: position,
              icon: bitMap,
              infoWindowEnable: false,
              onTap: (markerId) {
                logW("mark on tap $markerId");

                for (StoreListDataModel element in _shopList!) {
                  element.selected = false;
                }

                element.selected = true;
                setState(() {});
                WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                  _addMarker();
                });
              },
            );
            tempMap['${element.shopMdCode}'] = marker;
          }
        }
      }
    }

    if (userLocation != null) {
      logW("userLocation != null");

      UserBloc _userBloc = GlobalBlocs.get(UserBloc.blocName);

      String? headPortrait = _userBloc.state.userModel?.headPortrait;

      logI('String headPortrait = $headPortrait');


      if(userIconIsReady){
        /// 需要放大处理的Mark
        Uint8List bytes = await GetWidgetToImage.getUint8List(_userIconKey);
        final Marker marker = Marker(
          position: userLocation,
          //使用默认hue的方式设置Marker的图标
          icon: BitmapDescriptor.fromBytes(bytes),
        );
        tempMap["3"] = marker;
      }
/*
      if (headPortrait == null || headPortrait.isEmpty || !userIconIsReady) {
        Marker marker = Marker(
            position: userLocation,
            icon: userCustomMarker,
            infoWindowEnable: false,
            customOnTap: (id) {});
        tempMap['3'] = marker;
      } else {
        /// 需要放大处理的Mark
        Uint8List bytes = await GetWidgetToImage.getUint8List(_userIconKey);
        final Marker marker = Marker(
          position: userLocation,
          //使用默认hue的方式设置Marker的图标
          icon: BitmapDescriptor.fromBytes(bytes),
        );
        tempMap["3"] = marker;
      }*/
    }

    /// 为使bigMark层级较高 最后添加。
    if (bigMarker != null) {
      tempMap["-0123213"] = bigMarker;
    }

    _initMarkerMap = tempMap;
    logI('_initMarkerMap ----- key == ↓↓↓↓↓');
    _initMarkerMap.forEach((key, value) {
      logI('_initMarkerMap ----- key == $key');
    });
    logI('_initMarkerMap ----- key == ↑↑↑↑↑');

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  List<Widget> _addMapShopDesWidget() {
    if (widget.storeListEntity == null || widget.storeListEntity!.shopTypeFrBos == null) {
      return [];
    }

    List<Widget> list = [];
    var modelList = widget.storeListEntity!.shopTypeFrBos!;
    for (int i = 0; i < modelList.length; i++) {
      StoreListDataShopTypeFrBos oldModel = modelList[i];

      Widget widget = Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: StringUtil.hexToColor(oldModel.color!),
            width: 10.w,
            height: 4.w,
            margin: EdgeInsets.only(right: 5.w),
          ),
          Container(
            child: Text(
              oldModel.name!,
              style: TextStyle(
                color: StringUtil.hexToColor(oldModel.color!),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      );

      list.add(widget);
      logI('数据开始处理了：${shopTypeFrBos?.length}');
    }

    return list;
    setState(() {});
  }
}

class ShopTypeListModel {
  int? index;
  String? name;
  String? iconUrl;
  String? color;
  BitmapDescriptor? bitMap;
}
