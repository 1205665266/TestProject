import 'dart:async';

import 'package:cotti_client/app.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/dialog_show_bloc.dart';
import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';
import 'package:cotti_client/pages/product/detail_pop.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_state.dart';
import 'package:cotti_client/pages/shopping_cart/shopping_cart_widget.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/bloc/menu_event.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/bloc/menu_state.dart';
import 'package:cotti_client/pages/tabs/tab_page.dart';
import 'package:cotti_client/sensors/menu_sensors_constant.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/banner/widget/float_banner.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'bloc/menu_bloc.dart';
import 'menu_mixin/shop_status_mixin.dart';
import 'views/menu_views.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/8/31 1:44 下午
class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, ShopStatusMixin, RouteAware {
  final MenuBloc _bloc = MenuBloc();
  final GlobalBloc globalBloc = GlobalBlocs.get(GlobalBloc.blocName);
  ValueNotifier toIndexNotifier = ValueNotifier(-1);
  ValueNotifier selectIndexNotifier = ValueNotifier(-1);
  final ValueNotifier<bool> cartOpenChange = ValueNotifier(false);
  final BannerController _pListController = BannerController();
  final ScrollController _controller = ScrollController();
  bool isShowShopStatusDialog = true;
  bool isForceLocation = true;
  Timer? _timer;
  int lastTime = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ShopMatchState current = context.read<ShopMatchBloc>().state;
      if (current.getTakeFoodModes.isNotEmpty && current.shopMdCode != null) {
        _bloc.add(MenuListEvent(current.getTakeFoodModes, current.shopMdCode));
      }
      _tabChange(globalBloc.state);
      CottiCoffeeApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
    });
    WidgetsBinding.instance?.addObserver(this);
    SensorsAnalyticsFlutterPlugin.track(MenuSensorsConstant.menuView, {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => _bloc,
      child: _content(),
    );
  }

  _content() {
    return BlocListener<DialogShowBloc, DialogShowState>(
      listener: (context, dialogShowState) => _dialogShow(dialogShowState),
      child: BlocListener<GlobalBloc, GlobalState>(
        bloc: globalBloc,
        listenWhen: (p, c) => p.tabIndex != c.tabIndex && c.tabIndex == TabEnum.menu.index,
        listener: (context, globalState) {
          _pListController.reload();
          _tabChange(globalState);
        },
        child: BlocListener<ShopMatchBloc, ShopMatchState>(
          listenWhen: (previous, current) {
            bool isListener = previous.currentTime != current.currentTime;
            _handleShopDialog(current);
            _bloc.add(ShowLoadingEvent(current.showLoading, current.firstGetShopInfo));
            if (isListener && current.shopMdCode != null) {
              _bloc.add(MenuListEvent(
                current.getTakeFoodModes,
                current.shopMdCode,
                showLoading: previous.shopMdCode != current.shopMdCode ||
                    previous.curTakeFoodMode != current.curTakeFoodMode,
              ));
            }
            return isListener;
          },
          listener: (context, state) {},
          child: CustomPageWidget(
            showAppBar: false,
            resizeToAvoidBottomInset: false,
            child: Stack(
              children: [
                _buildMenu(),
                const GoodsEmpty(),
                ShoppingCartWidget(shoppingCartOpenChange: cartOpenChange),
                _buildShopClosed(),
                const TakeAddressNotAvailable(),
                const NoLocationPermissionEmpty(),
                const NoStoresNearby(),
                _buildLoading(),
                _buildAd(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return Column(
      children: [
        const MenuHeadWidget(),
        SizedBox(height: 6.h),
        Expanded(child: _buildMenuList()),
      ],
    );
  }

  _buildMenuList() {
    return Row(
      children: [
        MenuLeftWidget(
          selectIndexNotifier: selectIndexNotifier,
          clickItemCallBack: (index) {
            toIndexNotifier.value = -1;
            toIndexNotifier.value = index;
          },
        ),
        Expanded(
          child: MenuRight(
            controller: _controller,
            toIndexNotifier: toIndexNotifier,
            firstItemIndexCallBack: (index) {
              selectIndexNotifier.value = index;
            },
          ),
        ),
      ],
    );
  }

  _buildLoading() {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, menuState) {
        return Visibility(
          visible: menuState.showLoading,
          child: Container(
            color: menuState.showLoadingBackground ? Colors.white : null,
            child: Column(
              children: [
                const Flexible(
                  child: FractionallySizedBox(
                    heightFactor: 0.5,
                    child: Center(),
                  ),
                ),
                LottieBuilder.asset(
                  'assets/images/lotti/loading_data.json',
                  width: 48.w,
                  height: 48.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildAd() {
    return Stack(
      children: [
        ABiteBanner(
          bannerParam: BannerParam(
            "cotti-window-common",
            isNoCache: true,
            viewPage: "cotti-app-plist",
          ),
          bannerController: _pListController,
        ),
        FloatBanner(
          controller: _controller,
          child: ABiteBanner(
            width: 60.w,
            resize: true,
            bannerParam: BannerParam(
              "cotti-float-common",
              viewPage: "cotti-app-plist",
              memberId: Constant.memberId,
            ),
          ),
        ),
      ],
    );
  }

  _buildShopClosed() {
    return BlocBuilder<ShopMatchBloc, ShopMatchState>(
      builder: (context, state) {
        return BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
          builder: (context, cartState) {
            if (cartState.getAllCartCount > 0) {
              return const SizedBox();
            }
            ShopDetail? shopDetail = state.currentShopDetail;
            if (state.shopToBeOpened) {
              return const ShopToBeOpened();
            } else if (state.shopForceClosed || state.shopClosed) {
              return ShopClosed(
                shopOperateStr: shopDetail?.shopOperateStr ?? '',
                forceClosed: state.shopForceClosed,
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  _tabChange(GlobalState state) {
    ShopMatchBloc shopMatchBloc = context.read<ShopMatchBloc>();
    if (state.tabIndex == TabEnum.menu.index) {
      _timer?.cancel();
      int duration = _bloc.state.menuHeads.isEmpty ? 0 : 500;
      int? takeMode = int.tryParse("${state.arguments?["takeFoodMode"]}");
      bool isReLocation = state.arguments?["isReLocation"] ?? false;
      takeMode ??= shopMatchBloc.state.curTakeFoodMode;
      if (takeMode != shopMatchBloc.state.curTakeFoodMode) {
        duration = 0;
      }

      ///防止频繁切换浪费性能
      _timer = Timer(Duration(milliseconds: duration), () {
        if (takeMode == Constant.selfTakeModeCode) {
          shopMatchBloc.add(SelfTakeMatchShopEvent(context: context, isReLocation: isReLocation));
        } else if (takeMode == Constant.takeOutModeCode) {
          if (Constant.hasLogin) {
            MemberAddressEntity? address = state.arguments?["address"];
            bool isAutoMatchShop = state.arguments?["isAutoMatchShop"] ?? false;
            address ??= context.read<ShopMatchBloc>().state.address;
            //参数中获取收货地址，获取不到取缓存
            if (address == null) {
              shopMatchBloc.add(TakeOutAdapterEvent('menu'));
            } else {
              shopMatchBloc.add(ShopInfoByAddressEvent(
                address,
                isAutoMatchShop: isAutoMatchShop,
              ));
            }
          } else {
            ///如果没有登录，则降级到自提
            shopMatchBloc.add(SelfTakeMatchShopEvent(context: context, isReLocation: isReLocation));
          }
        }
        bool? openCart = state.arguments?["openCart"];
        if (openCart ?? false) {
          cartOpenChange.value = true;
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        lastTime = DateTime.now().millisecondsSinceEpoch;
        break;
      case AppLifecycleState.resumed:
        int diff = (DateTime.now().millisecondsSinceEpoch - lastTime) ~/ 1000;
        ShopMatchState shopMatchState = context.read<ShopMatchBloc>().state;
        if (diff >= 300 || shopMatchState.selfTakeShopInfo == null) {
          if (shopMatchState.curTakeFoodMode == Constant.selfTakeModeCode &&
              globalBloc.state.tabIndex == TabEnum.menu.index &&
              isForceLocation) {
            context
                .read<ShopMatchBloc>()
                .add(SelfTakeMatchShopEvent(context: context, isReLocation: true));
          }
        }
        break;
    }
  }

  _handleShopDialog(ShopMatchState current) {
    if (!isShowShopStatusDialog) {
      return;
    }
    if (current.curTakeFoodMode == Constant.selfTakeModeCode) {
      showSelfTakeDialog(context, current);
    } else if (current.curTakeFoodMode == Constant.takeOutModeCode) {
      if (current.takeOutShopInfo?.takeOutShopResultType != 2) {
        showTakeoutDialog(context, current, current.takeOutShopInfo?.takeOutShopResultType);
      }
    }
  }

  _dialogShow(DialogShowState dialogShowState) {
    if (dialogShowState.dialogNames.any((element) => element == ProductDetailPopup.popName)) {
      isShowShopStatusDialog = false;
    } else {
      isShowShopStatusDialog = true;
      _handleShopDialog(context.read<ShopMatchBloc>().state);
    }
  }

  @override
  void didPopNext() {
    super.didPopNext();
    isShowShopStatusDialog = true;
    isForceLocation = true;
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if (mounted) {
        _handleShopDialog(context.read<ShopMatchBloc>().state);
      }
    });
  }

  @override
  void didPushNext() {
    super.didPushNext();
    isShowShopStatusDialog = false;
    isForceLocation = false;
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    CottiCoffeeApp.routeObserver.unsubscribe(this);
    WidgetsBinding.instance?.removeObserver(this);
  }
}
