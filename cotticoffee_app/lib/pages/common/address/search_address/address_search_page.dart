import 'dart:ui';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/address/search_address/bloc/address_search_bloc.dart';
import 'package:cotti_client/pages/common/address/search_address/widget/address_search_bar.dart';
import 'package:cotti_client/pages/common/address/search_address/widget/address_search_list_item.dart';
import 'package:cotti_client/pages/common/store/views/map_center_icon.dart';
import 'package:cotti_client/service/location/location_result.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// FileName: address_search_page
///
/// Description: 地址搜索
/// Author: zekun.li@abite.com
/// Date: 2022/3/3

class AddressSearchPage extends StatefulWidget {
  final double? lat;
  final double? lon;

  const AddressSearchPage({Key? key, this.lat, this.lon}) : super(key: key);

  @override
  _AddressSearchPageState createState() {
    return _AddressSearchPageState();
  }
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  AddressSearchBloc _bloc = AddressSearchBloc();
  CameraPosition? _kInitialPosition = null;

  static MyLocationStyleOptions locationOptions = MyLocationStyleOptions(true,
      icon: BitmapDescriptor.fromIconPath("assets/images/store/ic_store_map_default_icon.png"),
      circleFillColor: Colors.transparent,
      circleStrokeColor: Colors.transparent);

  final List<Widget> _approvalNumberWidget = <Widget>[];

  ///先将申请的Android端可以和iOS端key设置给AMapApiKey
  static const AMapApiKey amapApiKeys =
      AMapApiKey(androidKey: Constant.androidMapKey, iosKey: Constant.iosMapKey);

  late AMapWidget map;

  final Map<String, Marker> _initMarkerMap = <String, Marker>{};

  BitmapDescriptor? customMarker;
  BitmapDescriptor? userCustomMarker;

  AMapLocation? userLocation;

  initPosition() {
    var lat = double.parse("39.909187");
    var lon = double.parse("116.397451");

    if (widget.lat != null && widget.lon != null) {
      lat = widget.lat!;
      lon = widget.lon!;
    }

    var latLng = LatLng(lat, lon);

    _kInitialPosition = CameraPosition(target: latLng, zoom: 14);
  }

  @override
  void initState() {
    super.initState();
    initPosition();

    WidgetsBinding.instance!.addPostFrameCallback((mag) {
      buildAComplete();
    });
    _setCustomMarker().then((value) => customMarker = value);
    _setUserCustomMarker().then((value) => userCustomMarker = value);
  }

  Future<BitmapDescriptor> _setUserCustomMarker() async {
    return BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: window.devicePixelRatio,
          size: Size(30.w, 30.w),
        ),
        "assets/images/shop/ic_store_map_user_icon.png",
        mipmaps: false);
  }

  void buildAComplete() {
    logW("buildAComplete");
    // super.buildAComplete();
    if (widget.lat != null && widget.lon != null) {
      _bloc.state.hasLocationCityCenter = false;
      _bloc.state.lat = widget.lat;
      _bloc.state.lng = widget.lon;
      _bloc.add(
        RequestCityInfoEvent(cityInfoCallBack: () {
          _bloc.add(RequestSearchAddressList());
        }),
      );
    } else {
      _bloc.add(InitEvent(context: context));
      // if (Constant.longitude != null && Constant.latitude != null) {
      //   _bloc.state.hasLocationCityCenter = false;
      // } else {
      //   _bloc.state.hasLocationCityCenter = true;
      // }
    }
  }

  IconController iconController = IconController();

  Widget _buildPage(BuildContext context) {
    return BlocBuilder<AddressSearchBloc, AddressSearchState>(
      builder: (context, state) {
        updatePosition(state);
        // _addMarker(state);
        return Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 281.h,
                  width: 375.w,
                  child: AMapWidget(
                    rotateGesturesEnabled: false,
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    initialCameraPosition: _kInitialPosition,
                    myLocationStyleOptions: locationOptions,
                    onMapCreated: onMapCreated,
                    onCameraMove: onMapCameraMove,
                    onLocationChanged: onMapLocationChanged,
                    apiKey: amapApiKeys,
                    onCameraMoveEnd: onMapCameraMoveEnd,
                    markers: Set<Marker>.of(_initMarkerMap.values),
                  ),
                ),
                Positioned(
                  top: 281.h / 2.0 - 37.h,
                  left: 375.w / 2.0 - 12.w,
                  child: MapCenterIcon(
                    iconController: iconController,
                  ),
                ),
                Positioned(
                  right: 12.w,
                  bottom: 20.w,
                  child: GestureDetector(
                    onTap: () {
                      _gotoUserLocation();
                    },
                    child: Image.asset(
                      'assets/images/shop/shop_list_map_location.png',
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: 48.h,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.addresses.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AddressSearchListItem(
                          model: state.addresses[index],
                          isSelected: state.addresses[index].id == state.selectedAddress.id,
                          onTap: () {
                            _bloc.add(SelectedPoiAddressEvent(state.addresses[index]));
                          },
                        );
                      },
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: AddressSearchBar(),
                  ),
                ],
              ),
            ),
            _buildConfirmAddress()
          ],
        );
      },
    );
  }

  Widget _buildConfirmAddress() {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              offset: Offset(0, -1),
              blurRadius: 4,
            ),
          ],
        ),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 16.w,
        ),
        child: InkWell(
          onTap: () {
            _bloc.add(ConfirmPoiAddressEvent(context));
          },
          child: Container(
            height: 44.h,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: CottiColor.primeColor,
            ),
            child: Text(
              "确定",
              style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      title: '地址搜索',
      pageBackgroundColor: Colors.white,
      child: BlocProvider(
        create: (BuildContext context) => _bloc,
        child: Builder(builder: (context) => _buildPage(context)),
      ),
    );
  }

  AMapController? _mapController;

  void onMapCameraMove(_) {
    if (!iconController.moved) {
      iconController.moveUp();
      setState(() {});
    }
  }

  void onMapLocationChanged(AMapLocation? location) {
    userLocation = location;
  }

  void onMapCameraMoveEnd(CameraPosition? position) {
    iconController.begain();
    if (position == null || position.target == null || _bloc.state.moveToSelected) {
      _bloc.state.moveToSelected = false;
      return;
    }
    _bloc.state.hasLocationCityCenter = false;

    // double latitude = position.target!.latitude;
    // double latitude = position.target!.latitude;
    _bloc.state.lat = position.target!.latitude;
    _bloc.state.lng = position.target!.longitude;
    _bloc.add(
      RequestCityInfoEvent(cityInfoCallBack: () {
        _bloc.add(RequestSearchAddressList());
      }),
    );
  }

  void onMapCreated(AMapController controller) {
    /// 以后使用自定义View的时候打开
    // MapUtil.widgetToIcon(globalKey).then((value) {
    //   ABiteLog.d("widgetToIcon------->$value ");
    //   locationOptions.icon = value;
    //   setState(() {});
    // });

    setState(() {
      _mapController = controller;
      // getApprovalNumber();
    });
  }

  _gotoUserLocation() async {
    logW("_gotoUserLocation action");
    LocationResult? locationResult = _bloc.state.locationResult;

    logI('msg');

    if (_mapController != null && userLocation != null) {
      LatLng userLocarion = userLocation!.latLng;
      await _mapController!.moveCamera(CameraUpdate.newLatLng(userLocarion), animated: true);
    }
  }

  /// 获取审图号
  void getApprovalNumber() async {
    //普通地图审图号
    String? mapContentApprovalNumber = await _mapController?.getMapContentApprovalNumber();
    //卫星地图审图号
    String? satelliteImageApprovalNumber = await _mapController?.getSatelliteImageApprovalNumber();
    setState(() {
      if (null != mapContentApprovalNumber) {
        _approvalNumberWidget.add(Text(mapContentApprovalNumber));
      }
      if (null != satelliteImageApprovalNumber) {
        _approvalNumberWidget.add(Text(satelliteImageApprovalNumber));
      }
    });
  }

  void updatePosition(AddressSearchState state) {
    if (state.moveToSelected) {
      // state.moveToSelected = false;
      var latLng = LatLng(state.selectedLatitude, state.selectedLongitude);
      _mapController?.moveCamera(CameraUpdate.newLatLng(latLng));
    }
  }

  Future<BitmapDescriptor> _setCustomMarker() async {
    return BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: window.devicePixelRatio,
        ),
        "assets/images/address/ic_store_map_marker@2x.png",
        mipmaps: true);
  }

  void _addMarker(AddressSearchState state) {
    // var shopDetail = state.detailModel;

    // if (shopDetail?.latitude != null && shopDetail?.latitude != null) {
    LatLng position = LatLng(state.selectedLatitude, state.selectedLongitude);
    Marker marker = Marker(
      position: position,
      icon: customMarker,
      infoWindowEnable: false,
      customWindow:
          CustomWindow(isShow: false, title: state.selectedAddress.name, isClickable: false),
    );

    _initMarkerMap["marker.id"] = marker;

    // }
  }
}
