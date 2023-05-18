import 'package:abitelogin/abitelogin.dart';
import 'package:cotti_client/app.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/dialog_show_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/product/detail_pop.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/bloc/menu_bloc.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/bloc/menu_state.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/menu_mixin/shop_status_mixin.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/views/switch_button.dart';
import 'package:cotti_client/pages/tabs/tab_page.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/routers/menu_router.dart';
import 'package:cotti_client/sensors/menu_sensors_constant.dart';
import 'package:cotti_client/utils/distance_util.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/cotti_tooltip.dart';
import 'package:cotti_client/widget/first_order_free/first_order_free_widget.dart';
import 'package:cotti_client/widget/mini_label_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'scroll_desc.dart';

/// Description: 头部信息
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/25 19:52
class MenuHeadWidget extends StatefulWidget {
  const MenuHeadWidget({Key? key}) : super(key: key);

  @override
  State<MenuHeadWidget> createState() => _MenuHeadWidgetState();
}

class _MenuHeadWidgetState extends State<MenuHeadWidget> with ShopStatusMixin {
  late ShopMatchState shopMatchState;
  Key? scrollDescKey;
  final ValueNotifier<bool> _toolTipsControl = ValueNotifier(false);
  final ValueNotifier<bool> _showFirstFreeControl = ValueNotifier(false);
  final Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175.h,
      child: Stack(
        children: [
          ABiteBanner(
            bannerParam: BannerParam('cotti-menu-bg-banner'),
            width: 375.w,
            resize: true,
            fit: BoxFit.fitWidth,
          ),
          BlocListener<DialogShowBloc, DialogShowState>(
            listener: (context, diaState) {
              if (diaState.dialogNames.any((element) => element == ProductDetailPopup.popName)) {
                _toolTipsControl.value = false;
              }
            },
            child: BlocConsumer<ShopMatchBloc, ShopMatchState>(
              listenWhen: (p, c) {
                if (p.autoMatchShopTimeStamp != c.autoMatchShopTimeStamp &&
                    !c.shopClosed &&
                    !c.shopForceClosed) {
                  if (c.shopToBeOpened) {
                    String toBeOpenedTips =
                        c.currentShopDetail?.guidanceToBeOpenedContext?.toolTip ?? '';
                    _toolTipsControl.value = toBeOpenedTips.isNotEmpty;
                  } else {
                    _toolTipsControl.value = true;
                  }
                  if (c.curTakeFoodMode == Constant.takeOutModeCode) {
                    SensorsAnalyticsFlutterPlugin.track(
                        MenuSensorsConstant.menuTakeoutAddressTooltipShow, null);
                  } else {
                    SensorsAnalyticsFlutterPlugin.track(
                        MenuSensorsConstant.menuPickupShopTooltipShow, null);
                  }
                }
                return p.takeOutTimeStamp != c.takeOutTimeStamp &&
                    c.adapterAddressFromTag == 'menu';
              },
              listener: (context, state) {
                if (state.address == null) {
                  selectTakeAddress(context);
                } else {
                  context.read<ShopMatchBloc>().add(ShopInfoByAddressEvent(
                        shopMatchState.address!,
                        isAutoMatchShop: true,
                      ));
                }
              },
              builder: (context, state) {
                shopMatchState = state;
                return Container(
                  padding: EdgeInsets.only(top: 47.h, left: 18.w, right: 14.w),
                  child: _buildContent(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildContent() {
    return Column(
      children: [
        _buildSearch(),
        SizedBox(height: 29.h),
        Stack(
          clipBehavior: Clip.none,
          children: [
            shopMatchState.curTakeFoodMode == Constant.takeOutModeCode
                ? _buildTakeOut()
                : _buildSelfTake(),
            Positioned(
              top: -10.h,
              right: -3.w,
              child: FirstOrderFreeWidget(
                key: _key,
                tabEnum: TabEnum.menu,
                contextSize: 9.sp,
                display: shopMatchState.curTakeFoodMode == Constant.selfTakeModeCode,
                padding: EdgeInsets.fromLTRB(3.w, 1.h, 3.w, 2.h),
                showCallBack: (isShow) {
                  _showFirstFreeControl.value = isShow;
                },
                iconTriangle: 'assets/images/menu/icon_first_order_free_menu.svg',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return Row(
      children: [
        ABiteBanner(
          bannerParam: BannerParam('cotti-menu-header-banner'),
          height: 38.h,
          fit: BoxFit.fitHeight,
          resize: true,
          margin: EdgeInsets.only(right: 6.w),
        ),
        Expanded(
          child: BlocBuilder<MenuBloc, MenuState>(
            builder: (context, state) {
              return Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: shopMatchState.currentShopDetail != null && state.menuHeads.isNotEmpty,
                child: GestureDetector(
                  onTap: () {
                    NavigatorUtils.push(context, MenuRouter.searchPage);
                    SensorsAnalyticsFlutterPlugin.track(MenuSensorsConstant.menuSearchClick, {});
                  },
                  child: Container(
                    height: 32.h,
                    padding: EdgeInsets.only(
                      left: 12.w,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F8F8),
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          IconFont.icon_search,
                          color: const Color(0xFF979797),
                          size: 16.w,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          '搜索',
                          style: TextStyle(
                            color: const Color(0xFF979797),
                            fontSize: 14.sp,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelfTake() {
    String toBeOpenedTips =
        shopMatchState.currentShopDetail?.guidanceToBeOpenedContext?.toolTip ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            NavigatorUtils.push(context, CommonPageRouter.storeListPage);
            _toolTipsControl.value = false;
            SensorsAnalyticsFlutterPlugin.track(MenuSensorsConstant.orderConformSwitchShopClick, {
              "store_id": shopMatchState.shopMdCode,
              "store_closed": shopMatchState.currentShopDetail?.closed,
            });
          },
          child: _buildShopName(
            shopMatchState.currentShopDetail?.shopTypeFrBO?.name ?? '',
            StringUtil.colorParse(shopMatchState.currentShopDetail?.shopTypeFrBO?.color),
            Colors.white,
            shopMatchState.currentShopDetail?.shopName ??
                ((shopMatchState.currentShopDetail == null && !shopMatchState.noLocationPermission)
                    ? '逛逛已开业门店'
                    : '请选择门店'),
            shopMatchState.shopToBeOpened ? toBeOpenedTips : '已为您自动匹配门店，可下单后自助取餐',
          ),
        ),
        SizedBox(height: 6.h),
        _buildDesc(),
      ],
    );
  }

  _buildDesc() {
    List<String> descList = [];
    if (shopMatchState.selfTakeShopInfo?.shopDetail != null) {
      String space = "｜";
      List<String> temp = [];
      String canteenCardNameDesc =
          shopMatchState.selfTakeShopInfo?.shopDetail?.canteenCardNameDesc ?? "";
      String addressPrompt = shopMatchState.selfTakeShopInfo?.shopDetail?.addressPrompt ?? "";
      int? distance = shopMatchState.selfTakeShopInfo?.shopDetail?.distance;
      if ((distance ?? 0) > 0) {
        temp.add("距离您${DistanceUtil.convertDistance(distance)}");
      }
      if (addressPrompt.isNotEmpty) {
        temp.add(addressPrompt);
      }
      if (canteenCardNameDesc.isNotEmpty) {
        temp.add(canteenCardNameDesc);
      }
      if (temp.length > 2) {
        descList.add(temp[0] + space + temp[1]);
        descList.add(temp[2]);
      } else if (temp.length > 1) {
        descList.add(temp[0] + space + temp[1]);
      } else if (temp.isNotEmpty) {
        descList = temp;
      }
    }
    List<Widget> widgets = [];
    widgets.addAll(_buildDesList(descList));
    if (shopMatchState.noLocationPermission) {
      widgets.add(_buildNotLocation());
    }
    if (widgets.isNotEmpty) {
      return BlocListener<ShopMatchBloc, ShopMatchState>(
        listenWhen: (p, c) => p.shopMdCode != c.shopMdCode,
        listener: (context, state) {
          scrollDescKey = UniqueKey();
        },
        child: ScrollDesc(key: scrollDescKey, descList: widgets),
      );
    } else {
      return const SizedBox();
    }
  }

  List<Widget> _buildDesList(List<String> descList) {
    return List.generate(
      descList.length,
      (index) => Text(
        descList[index],
        style: TextStyle(
          fontSize: 12.sp,
          color: CottiColor.textBlack,
        ),
        strutStyle: const StrutStyle(forceStrutHeight: true),
      ),
    );
  }

  _buildNotLocation() {
    return GestureDetector(
      onTap: () => openAppSettings(),
      child: Text.rich(
        TextSpan(
          text: '开启定位',
          style: TextStyle(
            color: const Color(0xFF4AA1FF),
            fontSize: 12.sp,
            decoration: TextDecoration.underline,
          ),
          children: const [
            TextSpan(
              text: '，为您推荐附近门店',
              style: TextStyle(
                color: CottiColor.textBlack,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTakeOut() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            selectTakeAddress(context);
            SensorsAnalyticsFlutterPlugin.track(MenuSensorsConstant.orderSwitchAddressClick, {
              "address_id": shopMatchState.address?.id,
              "store_closed": shopMatchState.currentShopDetail?.closed,
            });
          },
          child: shopMatchState.address == null
              ? const SizedBox()
              : _buildShopName(
                  shopMatchState.address?.labelName ?? '',
                  null,
                  CottiColor.primeColor,
                  "${shopMatchState.address?.location}${shopMatchState.address?.address}",
                  '已为您自动匹配收货地址COTTI 将尽快为您送达',
                ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Text(
              shopMatchState.address?.contact ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: CottiColor.textBlack,
              ),
              strutStyle: const StrutStyle(
                forceStrutHeight: true,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              StringUtil.mobilePhoneEncode(shopMatchState.address?.contactPhone),
              style: TextStyle(
                fontSize: 12.sp,
                color: CottiColor.textBlack,
                fontFamily: 'DDP4',
              ),
              strutStyle: const StrutStyle(
                forceStrutHeight: true,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _showFirstFreeControl,
              builder: (BuildContext context, bool value, Widget? child) {
                return Visibility(
                  visible: value && shopMatchState.address != null,
                  child: Text(
                    "｜${context.read<ConfigBloc>().state.firstOrderFreeShippingMsg}",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: CottiColor.textBlack,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShopName(
    String labelName,
    Color? labelBgColor,
    Color labelTextColor,
    String shopName,
    String tips,
  ) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              if (labelName.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: MiniLabelWidget(
                    label: labelName,
                    backgroundColor: labelBgColor,
                    textSize: 11.sp,
                    textColor: labelTextColor,
                    textPadding: EdgeInsets.symmetric(horizontal: 3.w),
                    radius: 1.r,
                    isBold: false,
                  ),
                ),
              Flexible(
                child: Text(
                  shopName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: CottiColor.textBlack,
                  ),
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                  ),
                ),
              ),
              CottiTooltip(
                tip: tips,
                duration: 5,
                showControl: _toolTipsControl,
                clickAnywhereHide: false,
                maxWidth: 140.w,
                routeObserver: CottiCoffeeApp.routeObserver,
                child: SvgPicture.asset(
                  "assets/images/icon_more.svg",
                  width: 12.w,
                  height: 14.h,
                  color: CottiColor.textBlack,
                ),
              ),
              SizedBox(width: 4.w),
            ],
          ),
        ),
        SwitchButton(
          curTakeFoodMode: shopMatchState.curTakeFoodMode,
          click: () => _switchTakeModel(),
        ),
      ],
    );
  }

  _switchTakeModel() {
    _toolTipsControl.value = false;
    if (shopMatchState.curTakeFoodMode == Constant.takeOutModeCode) {
      context.read<ShopMatchBloc>().add(SelfTakeMatchShopEvent(context: context));
      SensorsAnalyticsFlutterPlugin.track(MenuSensorsConstant.homeSelfPickupClick, {});
    } else {
      if (Constant.hasLogin) {
        _takeOut();
      } else {
        LoginUtils.login(context).then((value) {
          if (Constant.hasLogin) {
            _takeOut();
          }
        });
      }
      SensorsAnalyticsFlutterPlugin.track(MenuSensorsConstant.homeTakeoutClick, {});
    }
  }

  _takeOut() {
    if (shopMatchState.address != null) {
      context.read<ShopMatchBloc>().add(ShopInfoByAddressEvent(shopMatchState.address!));
    } else {
      context.read<ShopMatchBloc>().add(TakeOutAdapterEvent('menu'));
    }
  }
}
