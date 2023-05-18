import 'dart:typed_data';

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/service/location/location_result.dart';
import 'package:cotti_client/widget/widget_to_image.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

class ConfirmTipMap extends StatefulWidget {
  final OrderConfirmBloc bloc;

  const ConfirmTipMap({Key? key, required this.bloc}) : super(key: key);

  @override
  _ConfirmTipMapState createState() {
    return _ConfirmTipMapState(bloc);
  }
}

class _ConfirmTipMapState extends State<ConfirmTipMap> {
  final OrderConfirmBloc bloc;

  ///先将申请的Android端可以和iOS端key设置给AMapApiKey
  static const AMapApiKey amapApiKeys =
      AMapApiKey(androidKey: Constant.androidMapKey, iosKey: Constant.iosMapKey);

  Map<String, Marker> _initMarkerMap = <String, Marker>{};

  AMapController? mapController;

  CameraPosition? initPosition;
  LatLng? mapCenterTarget;
  LatLng? initTarget;
  CameraUpdate? mapCenterCamera;
  late LatLng userLatLng;
  late LatLng shopLatLng;

  late ShopMatchBloc _shopMatchBloc;

  final GlobalKey _userIconKey = GlobalKey();
  final GlobalKey _globalKey = GlobalKey();

  /// 标记用户头像image是否加载完成
  bool userIconIsReady = false;

  /// 标记门店头像image是否加载完成
  bool shopIconIsReady = false;

  bool? mapCreated;

  _ConfirmTipMapState(this.bloc);

  @override
  void initState() {
    super.initState();
  }

  void initPoint(){
    _shopMatchBloc = context.read<ShopMatchBloc>();

    logI("curTakeFoodMode curTakeFoodMode curTakeFoodMode !!!!${_shopMatchBloc.state.curTakeFoodMode}");

    OrderConfirmModelShopPosition? shopPosition = bloc.state.orderConfirmModelEntity?.shop?.position;

    LocationResult? userLocation = _shopMatchBloc.state.locationResult;

    double userLat = userLocation?.positionInfoEntity?.latitude ?? 0;
    double userLon = userLocation?.positionInfoEntity?.longitude ?? 0;

    double shopLat = shopPosition?.locationLatitude ?? 0;
    double shopLon = shopPosition?.locationLongitude ?? 0;

    if(_shopMatchBloc.state.curTakeFoodMode == 2){
      MemberAddressEntity? address = _shopMatchBloc.state.address;

      shopLat = double.tryParse(address?.lat??"0") ?? 0;
      shopLon = double.tryParse(address?.lng??"0") ?? 0;

    }

    userLatLng = LatLng(userLat, userLon);

    shopLatLng = LatLng(shopLat, shopLon);

    LatLng centerLatLng = LatLng((userLat + shopLat) / 2, (userLon + shopLon) / 2);

    double distance = getDistanse(shopLat, userLat, shopLon, userLon);

    logI('distance in tip map === $distance');

    int zoom = getZoom(distance);
    logI('zoom in tip map === $zoom');
    initPosition = CameraPosition(target: centerLatLng, zoom: zoom.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    initPoint();
    return SizedBox(
      width: double.infinity,
      height: 250.w,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.r),
          topLeft: Radius.circular(8.r),
        ),
        child: Stack(
          children: [
            _userIconMarker(),
            _cusMarker(),
            _buildWhiteMark(),
            AMapWidget(
              initialCameraPosition: initPosition,
              scaleEnabled: false,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              onMapCreated: _onMapCreated,
              onCameraMoveEnd: _onMapMoveEnd,
              // onLocationChanged: _onLocationChange,
              apiKey: amapApiKeys,
              markers: Set<Marker>.of(_initMarkerMap.values),
              rotateGesturesEnabled: false,
            ),
            _buildLocation(),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(AMapController controller) {
    logI('in _onMapCreated action !!!');
    mapCreated = true;
    mapController = controller;

    _updateMapBounds();

    Future.delayed(const Duration(milliseconds: 200), () {
      _addMarker();
    });
  }


  void _onMapMoveEnd(CameraPosition? position) {
    logI("in _onMapMoveEnd action ${position?.target}");
    if(position != null){
      if(init){
        initTarget = position.target;
        init = false;
      }
      mapCenterTarget = position.target;
      if(mounted){
        setState(() {

        });
      }
    }
  }

  Widget _buildWhiteMark() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  /// 用于生成用户头像Mark的图片
  Widget _userIconMarker() {
    UserBloc _userBloc = GlobalBlocs.get(UserBloc.blocName);

    String? headPortrait = _userBloc.state.userModel?.headPortrait;

    logI('String headPortrait = $headPortrait');

    if (headPortrait == null || headPortrait.isEmpty) {
      headPortrait =
          'https://cdn-product-prod.yummy.tech/wechat/cotti/images/mine/ic_user_no_login.png';
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
                child: Image.network(
                  headPortrait,
                  width: 35.w,
                  height: 35.w,
                  loadingBuilder:
                      (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress?.expectedTotalBytes ==
                        loadingProgress?.cumulativeBytesLoaded) {
                      logI('_userIconMarker loadingProgress === !!!! $loadingProgress');
                      if (!userIconIsReady) {
                        userIconIsReady = true;
                        Future.delayed(const Duration(milliseconds: 200), () {
                          _addMarker();
                        });
                      }
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

  Widget _buildLocation(){
    return Positioned(
      right: 6.w,
      bottom: 4.w,
      child: Visibility(
        visible: initTarget != null && !mapIsOnCenter(),
        child: GestureDetector(
          onTap: () {
            _changeToUserLocation();
          },
          child: Image.asset(
            'assets/images/order/order_confirm/shop_list_map_tip_location.png',
            width: 32.w,
            height: 32.w,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  ///预置自定义 marker
  Widget _cusMarker() {
    OrderConfirmModelShopBase? base = bloc.state.orderConfirmModelEntity?.shop?.base;

    logI('OrderConfirmModelShopBase? base = ${base.toString()}');

    String iconUrl = "";

    Widget imgWidget = const SizedBox();

    iconUrl = base?.iconUrl ?? "";

    Uri? uri = Uri.tryParse(iconUrl);
    imgWidget = uri != null
        ? Image.network(
            iconUrl,
            width: 45.w,
            height: 45.h,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress?.expectedTotalBytes == loadingProgress?.cumulativeBytesLoaded) {
                logI('_cusMarker loadingProgress === !!!! $loadingProgress');
                if (!shopIconIsReady) {
                  shopIconIsReady = true;
                  Future.delayed(const Duration(milliseconds: 200), () {
                    _addMarker();
                  });
                }
              }

              return child;
            },
          )
        : const SizedBox();


    String title = base?.shopName ?? '';

    if(_shopMatchBloc.state.curTakeFoodMode == 2){
      imgWidget = Image.asset(
        "assets/images/order/order_confirm/ic_address_poi.png",
        width: 45.w,
        height: 45.h,
      );
      title = "收货地址";
    }

    logW('String iconUrl = === $iconUrl');

    return Positioned(
      top: 10.h,
      left: 10.w,
      child: WidgetToImage(
        globalKeys: _globalKey,
        bgColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 7.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2.5.r)),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: CottiColor.textBlack,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SvgPicture.asset(
              "assets/images/order/order_confirm/ic_confirm_bottom_jj.svg",
              height: 7.h,
              width: 14.w,
              color: Colors.white,
            ),
            SizedBox(height: _shopMatchBloc.state.curTakeFoodMode == 2?0:7.h),
            imgWidget,
          ],
        ),
      ),
    );
  }

  _addMarker() async {
    logI('进入判断前：');

    Map<String, Marker> tempMap = {};

    logW("userLocation != null");

    UserBloc _userBloc = GlobalBlocs.get(UserBloc.blocName);

    String? headPortrait = _userBloc.state.userModel?.headPortrait;

    logI('String headPortrait = $headPortrait');

    if (shopIconIsReady||_shopMatchBloc.state.curTakeFoodMode==2) {
      /// 需要放大处理的Mark
      Uint8List bytes = await GetWidgetToImage.getUint8List(_globalKey);
      logW('Uint8List bytes = === $bytes');

      final Marker marker = Marker(
          position: shopLatLng,
          clickable: false,
          //使用默认hue的方式设置Marker的图标
          icon: BitmapDescriptor.fromBytes(bytes),
      );

      tempMap["-0123213"] = marker;
    }

    if (userIconIsReady) {
      /// 需要放大处理的Mark
      Uint8List bytes = await GetWidgetToImage.getUint8List(_userIconKey);
      final Marker marker = Marker(
        position: userLatLng,
        clickable: false,
        //使用默认hue的方式设置Marker的图标
        icon: BitmapDescriptor.fromBytes(bytes),
      );
      tempMap["3"] = marker;
    }

    _initMarkerMap = tempMap;
    logI('_initMarkerMap ----- key == ↓↓↓↓↓');
    _initMarkerMap.forEach((key, value) {
      logI('_initMarkerMap ----- key == $key');
    });
    logI('_initMarkerMap ----- key == ↑↑↑↑↑');

    // Future.delayed(const Duration(milliseconds: 1500), () {
    if (mounted) {
      setState(() {});
    }
    // });
  }

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
        16  100m
     * */
    if(distance < 0.05){
      return 18;
    }else
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

  _changeToUserLocation() {
    if (mapCenterCamera != null) {
      logI('moveCamera in _changeToUserLocation');
      // mapController?.moveCamera(CameraUpdate.newLatLng(initPosition!.target!));
      mapController?.moveCamera(mapCenterCamera!,animated: true);
    }
  }

  bool mapIsOnCenter(){
    logI("initTarget === $initTarget");
    logI("mapCenterTarget === $mapCenterTarget");
    bool isCenter = initTarget != null && (initTarget == mapCenterTarget);
    logI("bool isCenter = $isCenter");
    return isCenter;
  }

  void _updateMapBounds(){
    double sLat = math.min(userLatLng.latitude, shopLatLng.latitude);
    double sLon = math.min(userLatLng.longitude, shopLatLng.longitude);

    double nLat = math.max(userLatLng.latitude, shopLatLng.latitude);
    double nLon = math.max(userLatLng.longitude, shopLatLng.longitude);

    LatLng southwest = LatLng(sLat,sLon);

    LatLng northeast = LatLng(nLat,nLon);

    LatLngBounds llb = LatLngBounds(southwest: southwest,northeast: northeast);

    mapCenterCamera = CameraUpdate.newLatLngBounds(llb, 120);

    init = true;

    mapController?.moveCamera(mapCenterCamera!,animated: true);

  }

  bool init = false;

}
