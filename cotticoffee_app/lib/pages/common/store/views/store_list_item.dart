import 'dart:io';

import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/store/bloc/store_bloc.dart';
import 'package:cotti_client/pages/common/store/entity/store_list_data_entity.dart';
import 'package:cotti_client/sensors/store_sensors_constant.dart';
import 'package:cotti_client/utils/distance_util.dart';
import 'package:cotti_client/utils/go_map_util.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class StoreListItem extends StatefulWidget {
  const StoreListItem({
    Key? key,
    this.isNearest = true,
    this.shopMdCode,
    required this.model,
    required this.shopTypeFrBos,
    required this.frameCallBack,
    required this.oftenUsed,
  }) : super(key: key);
  final StoreListDataModel model;
  final List<StoreListDataShopTypeFrBos> shopTypeFrBos;
  final bool isNearest;
  final int? shopMdCode;
  final ValueChanged<BuildContext> frameCallBack;

  /// 是否常去门店，埋点使用；
  final bool oftenUsed;

  @override
  State<StoreListItem> createState() => _StoreListItemState();
}

class _StoreListItemState extends State<StoreListItem> {
  bool isSelected = false;
  late StoreBloc _storeListBloc;
  List<Widget> installedMapList = [];
  Color shopTypeColor = Colors.white;
  String shopTypeName = '';

  bool showFuture = false;

  @override
  void initState() {
    super.initState();
    _storeListBloc = context.read<StoreBloc>();

    isSelected = widget.shopMdCode == widget.model.shopMdCode;

    _configShopType();
    generateInstallMapList();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.model.selected && mounted) {
        logI(
            'WidgetsBinding.instance in code ${widget.shopMdCode} item ${widget.model.shopName} == ${widget.model.selected}');
        widget.frameCallBack(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.status != null) {
      showFuture = widget.model.status == 0;
    }

    _configShopType();
    return InkWell(
        onTap: () {
          SensorsAnalyticsFlutterPlugin.track(StoreSensorsConstant.storeListItemCommonClick, {
            'store_state': widget.model.closed ?? true ? widget.model.statusReminder : '已打烊',
            'oftenUsed': widget.oftenUsed ? '是' : '否'
          });

          SensorsAnalyticsFlutterPlugin.track(StoreSensorsConstant.storeListItemOtherClick, {
            'closed': widget.model.closed ?? true ? widget.model.statusReminder : '已打烊',
          });

          logI('widget.model.shopMdCode ---- ${widget.model.shopMdCode} ${widget.model.shopName}');

          if (widget.model.shopMdCode != null) {
            context.read<ShopMatchBloc>().add(ShopInfoByShopMdCodeEvent(widget.model.shopMdCode!));
          }
          NavigatorUtils.pop(context);
        },
        child: ClipRRect(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.w),
                padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 14.w, bottom: 14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                  border: widget.model.selected
                      ? Border.all(color: CottiColor.primeColor, width: 1)
                      : null,
                ),
                child: Opacity(
                  opacity: showFuture ? 0.5 : 1,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  (shopTypeName == null || shopTypeName.isNotEmpty)
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: shopTypeColor,
                                            borderRadius: BorderRadius.circular(2.r),
                                          ),
                                          margin: EdgeInsets.only(right: 4.w),
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(left: 4.w, right: 4.w),
                                          child: Text(
                                            shopTypeName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.sp,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  Expanded(
                                    child: Container(
                                      height: 22.w,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.model.shopName!,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: const Color(0xFF3A3B3C),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                              _timeConfig(),
                              Container(
                                margin: EdgeInsets.only(top: 8.w),
                                child: Text(
                                  widget.model.address!,
                                  style: TextStyle(
                                      color: const Color(0xFF3A3B3C),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.w,
                                      overflow: TextOverflow.ellipsis,
                                      height: 1.5),
                                  maxLines: 2,
                                ),
                              ),

                              /// 顯示儲值卡
                              Offstage(
                                offstage: widget.model.canteenCardNameDesc == null,
                                child: Container(
                                  padding: EdgeInsets.only(top: 7.h),
                                  child: Row(
                                    children: [
                                      SvgPicture.network(
                                        "https://cdn-product-prod.yummy.tech/wechat/cotti/images/icon_canteen_card.svg",
                                        width: 12.w,
                                        height: 12.w,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        widget.model.canteenCardNameDesc ?? "",
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: CottiColor.textGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 12, bottom: 12),
                          color: const Color(0xFFD8D8D8),
                          width: 0.5.w,
                        ),
                        SizedBox(
                          width: (ScreenUtil().screenWidth - 2 * 16.w) * (88.0 / 343),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 22.w,
                                child: Text(
                                  (widget.model.closed! || widget.model.statusReminder != null)
                                      ? '去看看'
                                      : '去下单',
                                  style: TextStyle(
                                      color: Color(0xFF3A3B3C),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              _configDistance(),
                              InkWell(
                                onTap: () {
                                  showNavigationSelection();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 12.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/shop/shop_list_list_nav_image.svg',
                                        width: 16.w,
                                        height: 16.w,
                                        fit: BoxFit.fill,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 4.w),
                                        child: Text(
                                          '导航前往',
                                          style: TextStyle(
                                            color: Color(0xFF4AA1FF),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              widget.isNearest
                  ? const SizedBox(
                      height: 0,
                    )
                  : Positioned(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(4.r)),
                        child: SvgPicture.asset(
                          'assets/images/shop/shop_list_often_used.svg',
                          width: 20.w,
                          height: 20.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      left: 16.w,
                      top: 0,
                      width: 20.w,
                      height: 20.w,
                    ),
            ],
          ),
        ));
  }

  /// 获得已安装的地图软件列表
  void generateInstallMapList() {
    var lat = widget.model.latitude ?? "";
    var lon = widget.model.longitude ?? "";

    MapUtil.checkInstallMapList(lon, lat).then((value) {
      if (value.isEmpty) {
        return;
      }
      for (var element in value) {
        if (element == "高德") {
          installedMapList.add(
              InkWell(onTap: () => MapUtil.gotoAMap(lon, lat), child: _buttonItem("使用高德地图导航")));
          installedMapList.add(_splitLine(0.5.h));
        } else if (element == "百度") {
          installedMapList.add(
              InkWell(onTap: () => MapUtil.gotoBaiduMap(lon, lat), child: _buttonItem("使用百度地图导航")));
          installedMapList.add(_splitLine(0.5.h));
        } else if (element == "腾讯") {
          installedMapList.add(InkWell(
              onTap: () => MapUtil.gotoTencentMap(lon, lat), child: _buttonItem("使用腾讯地图导航")));
          installedMapList.add(_splitLine(0.5.h));
        } else if (element == "苹果" && Platform.isIOS) {
          installedMapList.add(InkWell(
              onTap: () => MapUtil.gotoAppleMap(lon, lat), child: _buttonItem("使用苹果自带地图导航")));
          installedMapList.add(_splitLine(0.5.h));
        }
      }
      installedMapList.add(_splitLine(6.h));
      installedMapList
          .add(InkWell(onTap: () => Navigator.of(context).pop(), child: _buttonItem("取消")));
    });
  }

  Widget _buttonItem(String content) {
    return SizedBox(
      height: 58.h,
      child: Center(child: Text(content)),
    );
  }

  Widget _splitLine(double height) {
    return Container(
      height: height,
      color: const Color(0xFFEEEEEE),
    );
  }

  void _configShopType() {
    for (var element in widget.shopTypeFrBos) {
      if (element.index == widget.model.shopType) {
        logI('element${element.index}');

        shopTypeColor = StringUtil.hexToColor(element.color!);
        shopTypeName = element.name!;
      }
    }
  }

  Widget _timeConfig() {
    if (showFuture) {
      String guidanceToBeOpened =
          GlobalBlocs.get<ConfigBloc>(ConfigBloc.blocName).state.guidanceToBeOpened;

      return Container(
        margin: EdgeInsets.only(top: 8.w),
        decoration: BoxDecoration(
          color: CottiColor.textHint,
          border: Border.all(color: CottiColor.textHint, width: 0.5.w),
          borderRadius: BorderRadius.all(Radius.circular(1.w)),
        ),
        height: 16.w,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: widget.model.planSetUpTimeStr == null
                  ? const SizedBox()
                  : Container(
                      height: 16.w,
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 4.w, right: 4.w),
                      child: Text(
                        widget.model.planSetUpTimeStr ?? '',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: CottiColor.textGray,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'DDP4',
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
            ),
            Container(
              height: 16.w,
              alignment: Alignment.center,
              color: CottiColor.textHint,
              padding: EdgeInsets.only(left: 4.w, right: 4.w),
              child: Text(
                guidanceToBeOpened,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (widget.model.closed!) {
      if (widget.model.showSaleType == 2) {
        return Container(
          margin: EdgeInsets.only(top: 8.w),
          height: 16.w,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: 0.w, right: 4.w),
                child: Text(
                  widget.model.currentSaleTime ?? '今日门店休息',
                  style: TextStyle(
                    color: CottiColor.textGray,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'DDP4',
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(top: 8.w),
          decoration: BoxDecoration(
            border: Border.all(color: CottiColor.textHint, width: 0.5.w),
            borderRadius: BorderRadius.all(Radius.circular(1.w)),
          ),
          height: 16.w,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 4.w, right: 4.w),
                  // alignment: Alignment.centerLeft,
                  child: Text(
                    widget.model.currentSaleTime ?? '今日门店休息',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: CottiColor.textGray,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'DDP4',
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              Container(
                height: 16.w,
                alignment: Alignment.center,
                color: CottiColor.textHint,
                padding: EdgeInsets.only(left: 4.w, right: 4.w),
                child: Text(
                  widget.model.statusReminder ?? '休息中',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      return Container(
        margin: EdgeInsets.only(top: 8.w),
        height: 16.w,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 0.w, right: 4.w),
              child: Text(
                widget.model.currentSaleTime ?? '今日门店休息',
                style: TextStyle(
                  color: CottiColor.textGray,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'DDP4',
                  fontSize: 12.sp,
                ),
              ),
            ),
            widget.model.statusReminder == null
                ? const SizedBox(
                    width: 0,
                  )
                : Container(
                    height: 16.w,
                    color: CottiColor.textHint,
                    padding: EdgeInsets.only(left: 0.w, right: 4.w),
                    child: Text(
                      widget.model.statusReminder ?? '休息中',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 11.sp,
                      ),
                    ),
                  )
          ],
        ),
      );
    }
  }

  Widget _configDistance() {
    String? tip;

    String? distanceStr;
    if (widget.model.distance != null) {
      if (widget.model.stepDistance != null) {
        tip = '距您步行';
        distanceStr = DistanceUtil.convertDistance(widget.model.stepDistance);
      } else {
        tip = '距您';
        distanceStr = DistanceUtil.convertDistance(widget.model.distance);
      }
    } else {}

    if (tip != null && distanceStr != null) {
      return Container(
        margin: EdgeInsets.only(top: 8.w),
        height: 16.w,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: tip,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF6C6C6C),
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: distanceStr,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'DDP4',
                  color: const Color(0xFF3A3B3C),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 8.w),
        height: 16.w,
        child: const Text(''),
      );
    }
  }

  showNavigationSelection() async {
    if (installedMapList.isEmpty) {
      ToastUtil.show("您未安装地图应用，无法为您导航");
      return;
    }

    SensorsAnalyticsFlutterPlugin.track(StoreSensorsConstant.storeListItemNaviClick, {
      'store_closed': widget.model.closed ?? true ? '是' : '否',
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 500.h),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: installedMapList,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(18.r)),
          ),
        ),
      ),
    );
  }
}
