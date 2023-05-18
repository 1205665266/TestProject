

import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_state.dart';
import 'package:cotti_client/widget/widget_to_image.dart';
import 'package:cotticommon/bloc/user_bloc.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:cotticommon/utils/log_util.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryMap extends StatefulWidget {


  LatLng? destinationPosition;
  LatLng? riderPosition;

  DeliveryMap({required this.destinationPosition, required this.riderPosition, Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => DeliveryMapState();

}


class DeliveryMapState extends State<DeliveryMap> {

  ///先将申请的Android端可以和iOS端key设置给AMapApiKey
  static const AMapApiKey amapApiKeys = AMapApiKey(androidKey: Constant.androidMapKey, iosKey: Constant.iosMapKey);

  CameraPosition? _kInitialPosition;


  List<Marker> markers = [];

  BitmapDescriptor? userDescriptor;

  BitmapDescriptor? riderDescriptor0;
  BitmapDescriptor? riderDescriptor45;
  BitmapDescriptor? riderDescriptor90;
  BitmapDescriptor? riderDescriptor135;
  BitmapDescriptor? riderDescriptor180;
  BitmapDescriptor? riderDescriptor225;
  BitmapDescriptor? riderDescriptor270;
  BitmapDescriptor? riderDescriptor315;

  AMapController? _mapController;

  final GlobalKey _userIconKey = GlobalKey();

  /// 标记用户头像image是否加载完成
  bool userIconIsReady = false;



  @override
  void initState() {
    super.initState();
    initPosition();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _initDestinationIcon();
    });


  }

  /// 初始化位置
  void initPosition() async {
    /// 初始定位点默认在北京中心
    var lat = 39.909187;
    var lon = 116.397451;

    var latLng = widget.destinationPosition ?? LatLng(lat, lon);

    _kInitialPosition = CameraPosition(target: latLng, zoom: 10);


    var distance = getDistance(widget.destinationPosition!.latitude, widget.riderPosition!.latitude,
        widget.destinationPosition!.longitude, widget.riderPosition!.longitude);

    double zoom = getZoom(distance).toDouble();

    _kInitialPosition = CameraPosition(target: latLng, zoom: zoom);
  }

  //! 获取坐标极值之间的距离double
  getDistance(double lat1, double lat2, double lon1, double lon2) {
    //! 根据坐标，地球半径算出两个坐标之间的距离
    double pi = 3.14159265358979323846;
    double radLat1 = lat1 * pi / 180;
    double radLat2 = lat2 * pi / 180;
    double radLon1 = lon1 * pi / 180;
    double radLon2 = lon2 * pi / 180;
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
    if (distance > 1000) {
      return 3;
    } else if (distance >= 500 && distance < 1000) {
      return 4;
    } else if (distance >= 200 && distance < 5000) {
      return 5;
    } else if (distance >= 100 && distance < 200) {
      return 6;
    } else if (distance >= 50 && distance < 100) {
      return 7;
    } else if (distance >= 30 && distance < 50) {
      return 8;
    } else if (distance >= 20 && distance < 30) {
      return 9;
    } else if (distance >= 10 && distance < 20) {
      return 10;
    } else if (distance >= 5 && distance < 10) {
      return 11;
    } else if (distance >= 2 && distance < 5) {
      return 12;
    } else if (distance >= 1 && distance < 2) {
      return 13;
    } else if (distance >= 0.5 && distance < 1) {
      return 14;
    } else if (distance >= 0.2 && distance < 0.5) {
      return 15;
    } else if (distance >= 0.1 && distance < 0.2) {
      return 16;
    } else if (distance >= 0.05 && distance < 0.1) {
      return 17;
    } else if (distance >= 0.025 && distance < 0.05) {
      return 18;
    } else if (distance >= 0.01 && distance < 0.025) {
      return 19;
    }
  }
  /// 用于生成用户头像Mark的图片
  Widget _userIconMarker() {
    UserBloc _userBloc = GlobalBlocs.get(UserBloc.blocName);

    String? headPortrait = _userBloc.state.userModel?.headPortrait;


    if (headPortrait == null || headPortrait.isEmpty) {
      return Container();
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
              width: 41.w,
              height: 41.w,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1),
                child: Image.network(
                  headPortrait,
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

  _initDestinationIcon() async {


    userDescriptor = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: window.devicePixelRatio,
          size: Size(64.w, 64.w),
        ),
        "assets/images/order/order_detail/icon_map_user_marker.png",
        mipmaps: true);



    riderDescriptor0 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: window.devicePixelRatio,
          size: Size(64.w, 64.w),
        ),
        "assets/images/order/order_detail/icon_map_rider_0.png",
        mipmaps: true);

    riderDescriptor45 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: window.devicePixelRatio,
          size: Size(64.w, 64.w),
        ),
        "assets/images/order/order_detail/icon_map_rider_45.png",
        mipmaps: false);

    riderDescriptor90 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: window.devicePixelRatio,
          size: Size(64.w, 64.w),
        ),
        "assets/images/order/order_detail/icon_map_rider_90.png",
        mipmaps: true);

    riderDescriptor135 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: window.devicePixelRatio,
          size: Size(64.w, 64.w),
        ),
        "assets/images/order/order_detail/icon_map_rider_135.png",
        mipmaps: true);

    riderDescriptor180 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: window.devicePixelRatio,
          size: Size(64.w, 64.w),
        ),
        "assets/images/order/order_detail/icon_map_rider_180.png",
        mipmaps: true);

    riderDescriptor225 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: window.devicePixelRatio,
          size: Size(100.w, 100.w),
        ),
        "assets/images/order/order_detail/icon_map_rider_225.png",
        mipmaps: true);

    riderDescriptor270 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: window.devicePixelRatio,
          size: Size(200.w, 200.w),
        ),
        "assets/images/order/order_detail/icon_map_rider_270.png",
        mipmaps: true);

    riderDescriptor315 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: window.devicePixelRatio,
          size: Size(64.w, 64.w),
        ),
        "assets/images/order/order_detail/icon_map_rider_315.png",
        mipmaps: true);


    _initDefault();

    Timer(const Duration(milliseconds: 500), () {
      _initMarker();
    });


  }

  _initMarker() async {
    UserBloc _userBloc = GlobalBlocs.get(UserBloc.blocName);

    String? headPortrait = _userBloc.state.userModel?.headPortrait;

    logI('String headPortrait = $headPortrait');

    List<Marker> tempMarkers = [];
    Marker destinationMarker;
    if (headPortrait == null || headPortrait.isEmpty || !userIconIsReady) {
      destinationMarker = Marker(
          position: widget.destinationPosition,
          icon: userDescriptor,
          infoWindowEnable: false,
          customOnTap: (id) {});
    } else {
      /// 需要放大处理的Mark
      Uint8List bytes = await GetWidgetToImage.getUint8List(_userIconKey);
      destinationMarker = Marker(
          position: widget.destinationPosition,
          icon: BitmapDescriptor.fromBytes(bytes),
          infoWindowEnable: false,
          customOnTap: (id) {});

    }
    Marker riderMarker = Marker(
        position: widget.riderPosition,
        icon: _getRiderDescriptor(),
        infoWindowEnable: false,
        customWindow: const CustomWindow(isShow: true, title: "骑手正在全力配送中", isClickable: false),
        customOnTap: (id) {});

    tempMarkers.add(destinationMarker);
    tempMarkers.add(riderMarker);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          markers = tempMarkers;
        });
      }
    });

  }

  _initDefault() async {
    markers.clear();

    Marker destinationMarker = Marker(
        position: widget.destinationPosition,
        icon: userDescriptor,
        infoWindowEnable: false,
        customOnTap: (id) {});

    Marker riderMarker = Marker(
        position: widget.riderPosition,
        icon: _getRiderDescriptor(),
        infoWindowEnable: false,
        customWindow: const CustomWindow(isShow: true, title: "骑手正在全力配送中", isClickable: false),
        customOnTap: (id) {});

    markers.add(destinationMarker);
    markers.add(riderMarker);

    setState(() {});

  }

  _getRiderDescriptor() {


    double startX = widget.riderPosition?.longitude?? 0;
    double startY = widget.riderPosition?.latitude?? 0;
    double endX = widget.destinationPosition?.longitude?? 0;
    double endY = widget.destinationPosition?.latitude?? 0;


    double diffX = startX - endX;
    double diffY = startY - endY;


    double angle = math.atan(diffY.abs() / diffX.abs()) * 180 / math.pi;

    if (diffX > 0) {
      if(diffY > 0) {
        angle = 360 - angle;
      }
    } else {
      if (diffY > 0) {
        // 第四象限
        angle = 180 + angle;
      } else {
        // 第三象限
        angle = 180 - angle;
      }
    }

    if (angle > 22.5 && angle <= 67.5) {
      return riderDescriptor45;
    } else if (angle > 67.5 && angle <= 112.5) {
      return riderDescriptor90;
    } else if (angle > 112.5 && angle <= 157.5) {
      return riderDescriptor135;
    } else if (angle > 157.5 && angle <= 202.5) {
      return riderDescriptor180;
    } else if (angle > 202.5 && angle <= 247.5) {
      return riderDescriptor225;
    } else if (angle > 247.5 && angle <= 292.5) {
      return riderDescriptor270;
    } else if (angle > 292.5 && angle <= 337.5) {
      return riderDescriptor315;
    }
    return riderDescriptor0;

  }
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<OrderDetailBloc, OrderDetailState>(
      listenWhen: (previous, current) {
        return previous.orderDeliveryDetailModelEntity != current.orderDeliveryDetailModelEntity;
      },
      listener: (context, state) {
        _initMarker();
      },
      builder: (context, state) {
        return Stack(
          children: [
            _userIconMarker(),
            AMapWidget(
                initialCameraPosition: _kInitialPosition,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                apiKey: amapApiKeys,
                markers: Set<Marker>.of(markers),
                onCameraMoveEnd: (CameraPosition? cameraPosition) {},
                rotateGesturesEnabled: false
            ),
            Positioned(
              bottom: -1,
              left: 0,
              right: 0,
              child: Container(
                height: 40.h,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0x00FFFFFF), Color(0xFFF5F6F7)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)
                ),
              ),
            )
          ],
        );
      }
    );

  }

  @override
  void dispose() {
    super.dispose();
    _mapController?.disponse();
  }

}