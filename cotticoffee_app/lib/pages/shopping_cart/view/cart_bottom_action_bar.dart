import 'package:abitelogin/abitelogin.dart';
import 'package:cotti_client/app.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/dialog_show_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';
import 'package:cotti_client/pages/product/detail_pop.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_state.dart';
import 'package:cotti_client/pages/shopping_cart/view/price_desc.dart';
import 'package:cotti_client/routers/order_router.dart';
import 'package:cotti_client/sensors/cart_sensors_constant.dart';
import 'package:cotti_client/widget/cotti_tooltip.dart';
import 'package:cotti_client/widget/red_dot_widget.dart';
import 'package:cotti_client/widget/shop_be_open_info.dart';
import 'package:cotti_client/widget/shop_closed_info.dart';
import 'package:cotti_client/widget/simple_tooltip/src/types.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/19 14:19
class CartBottomActionBar extends StatefulWidget {
  final ValueNotifier<bool> cartOpenChange;
  final ValueNotifier<bool> cartOffstageChange;

  const CartBottomActionBar({
    Key? key,
    required this.cartOpenChange,
    required this.cartOffstageChange,
  }) : super(key: key);

  @override
  State<CartBottomActionBar> createState() => _CartBottomActionBarState();
}

class _CartBottomActionBarState extends State<CartBottomActionBar> with TickerProviderStateMixin {
  final ValueNotifier<bool> _showControl = ValueNotifier(false);
  final ValueNotifier<bool> _shopClosedChange = ValueNotifier(false);
  final ValueNotifier<bool> _shopToBeOpenChange = ValueNotifier(false);
  late ShoppingCartState _state;
  late ShopMatchState _shopMatchState;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    animation = Tween<double>(begin: 1, end: 1.25).animate(controller);
    _shopMatchState = context.read<ShopMatchBloc>().state;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopMatchBloc, ShopMatchState>(
      listener: (context, matchState) {
        _shopMatchState = matchState;
        _defaultOpen(matchState);
      },
      builder: (context, matchState) {
        return BlocConsumer<ShoppingCartBloc, ShoppingCartState>(
          listenWhen: (previous, current) {
            if (previous.syncCarTimeStamp == 0 ||
                widget.cartOpenChange.value ||
                current.tipShowText.isEmpty ||
                _showProductDetail() ||
                _shopClosedChange.value ||
                _shopToBeOpenChange.value ||
                previous.syncCarTimeStamp == current.syncCarTimeStamp) {
              _showControl.value = false;
            } else {
              _showControl.value = true;
            }
            return previous.addCartTimeStamp != current.addCartTimeStamp;
          },
          listener: (context, state) async {
            await controller.forward();
            await controller.reverse();
            await controller.forward();
            await controller.reverse();
          },
          builder: (context, state) {
            _state = state;
            return _buildContent();
          },
        );
      },
    );
  }

  _buildContent() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        _buildShoppingInfo(),
        _buildShoppingCount(),
        ShopClosedInfo(
          shopOperateStr: _shopMatchState.currentShopDetail?.shopOperateStr ?? '',
          duration: const Duration(milliseconds: 150),
          clickClose: () => _shopClosedChange.value = false,
          animationChange: _shopClosedChange,
        ),
        ShopBeOpenInfo(
          duration: const Duration(milliseconds: 150),
          clickClose: () => _shopToBeOpenChange.value = false,
          animationChange: _shopToBeOpenChange,
        ),
      ],
    );
  }

  _buildShoppingInfo() {
    return SizedBox(
      height: 48.h,
      child: Row(
        children: [
          Offstage(
            offstage: _state.getAllCartCount <= 0,
            child: _buildPrice(),
          ),
          Expanded(
            child: _buildAccountBtn(),
          ),
        ],
      ),
    );
  }

  _buildPrice() {
    return Container(
      width: 275.w,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 74.w),
      color: const Color(0xFFF9F9F9),
      child: _state.selling.isEmpty
          ? _productSoldOut()
          : Padding(
              padding: EdgeInsets.only(top: 3.h),
              child: PriceDesc(
                deliveryDiscountTip: _state.cartEntity.deliveryDiscountTip,
                productPrice: double.tryParse("${_state.cartEntity.totalMoney}") ?? 0,
                standardPrice: double.tryParse("${_state.cartEntity.totalLineThroughPrice}"),
                firstOrderFreeShippingMsg:
                    context.read<ConfigBloc>().state.firstOrderFreeShippingMsg,
              ),
            ),
    );
  }

  _productSoldOut() {
    return Text(
      "餐品已售罄",
      style: TextStyle(
        color: CottiColor.textBlack,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _buildShoppingCount() {
    return Offstage(
      offstage: _state.getAllCartCount <= 0,
      child: CottiTooltip(
        tip: _state.tipShowText,
        showControl: _showControl,
        tooltipDirection: TooltipDirection.up,
        routeObserver: CottiCoffeeApp.routeObserver,
        arrowTipDistance: 3.h,
        targetCenter: Offset(46.w, .0),
        child: GestureDetector(
          onTap: () {
            widget.cartOpenChange.value = !widget.cartOpenChange.value;
            SensorsAnalyticsFlutterPlugin.track(CartSensorsConstant.shoppingCartClick, null);
          },
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 9.w, bottom: 4.h, right: _state.getSelectedSellingCount > 99 ? 8.w : .0),
                child: SvgPicture.asset(
                  'assets/images/shopping_cart/icon_shopping_bag.svg',
                  width: 58.w,
                  height: 58.h,
                ),
              ),
              Positioned(
                right: 4.w,
                child: ScaleTransition(
                  scale: animation,
                  child: RedDotWidget(count: _state.getSelectedSellingCount),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildAccountBtn() {
    if (_shopMatchState.currentShopDetail == null) {
      return const SizedBox();
    }
    if (_shopMatchState.shopToBeOpened) {
      return _buildToBeOpen();
    } else if (_shopMatchState.shopForceClosed) {
      return _buildShopUpdate();
    } else if (_shopMatchState.shopClosed) {
      return _buildShopClosed();
    } else {
      return _settleBtn();
    }
  }

  _buildShopClosed() {
    return Container(
      alignment: Alignment.center,
      color: CottiColor.textHint.withOpacity(0.98),
      child: GestureDetector(
        onTap: () {
          widget.cartOpenChange.value = false;
          _shopClosedChange.value = true;
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "本店休息中",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SvgPicture.asset(
              'assets/images/menu/icon_shop_closed_close.svg',
              width: 16.w,
              height: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  _buildToBeOpen() {
    String openDateContext = _shopMatchState.openDateContext;
    return GestureDetector(
      onTap: () {
        _reloadShopMatch();
        widget.cartOpenChange.value = false;
        _shopToBeOpenChange.value = true;
      },
      child: Container(
        alignment: Alignment.center,
        color: CottiColor.textHint.withOpacity(0.98),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.read<ConfigBloc>().state.guidanceToBeOpened,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/menu/icon_shop_closed_close.svg',
                  width: 16.w,
                  height: 16.w,
                ),
              ],
            ),
            if (openDateContext.isNotEmpty)
              Text(
                openDateContext,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  _buildShopUpdate() {
    return GestureDetector(
      onTap: () => _reloadShopMatch(),
      child: Container(
        alignment: Alignment.center,
        color: CottiColor.textHint.withOpacity(0.98),
        child: Text(
          "闭店升级中",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  //结算按钮
  _settleBtn() {
    bool isClick = canClickSettle();
    return GestureDetector(
      onTap: () {
        if (!isClick) {
          return;
        }
        if (Constant.hasLogin) {
          _settle();
        } else {
          LoginUtils.login(context).then((value) {
            if (Constant.hasLogin) {
              _settle();
            }
          });
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        color: isClick ? CottiColor.primeColor : CottiColor.textHint.withOpacity(0.98),
        child: settleBtnText(),
      ),
    );
  }

  bool canClickSettle() {
    if (_state.getSelectedSellingCount > 0) {
      if (_shopMatchState.curTakeFoodMode == Constant.selfTakeModeCode) {
        return true;
      } else {
        double startDeliveryMoney =
            double.tryParse("${_state.cartEntity.deliveryDiscountTip?.startDeliveryMoney}") ?? 0;
        double totalMoney = double.tryParse("${_state.cartEntity.totalMoney}") ?? 0;
        if (startDeliveryMoney == 0 || totalMoney >= startDeliveryMoney) {
          return true;
        }
      }
    }
    return false;
  }

  Widget settleBtnText() {
    TextStyle nor = TextStyle(
      color: Colors.white,
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
    );
    TextStyle rmbStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.sp,
      fontFamily: 'DDP5',
    );
    if (_shopMatchState.curTakeFoodMode == Constant.selfTakeModeCode) {
      return Text("结算", style: nor);
    }
    double startDeliveryMoney =
        double.tryParse("${_state.cartEntity.deliveryDiscountTip?.startDeliveryMoney}") ?? 0;
    double totalMoney = double.tryParse("${_state.cartEntity.totalMoney}") ?? 0;
    if (_state.getSelectedSellingCount > 0 &&
        (startDeliveryMoney == 0 || totalMoney >= startDeliveryMoney)) {
      return Text("结算", style: nor);
    }
    if (startDeliveryMoney > 0 && totalMoney == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("¥${Decimal.tryParse('$startDeliveryMoney')}", style: rmbStyle),
          Text("起送", style: nor),
        ],
      );
    }
    if (startDeliveryMoney > 0 && totalMoney < startDeliveryMoney) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("差", style: nor),
          Text(
            "¥${Decimal.parse("$startDeliveryMoney") - Decimal.parse("$totalMoney")}",
            style: rmbStyle,
          ),
          Text("起送", style: nor),
        ],
      );
    }
    return Text("结算", style: nor);
  }

  _settle() {
    if (_state.selling.any((element) => element.businessTypes?.isEmpty ?? true)) {
      ToastUtil.show("价格计算中，请稍等片刻");
    } else {
      NavigatorUtils.push(context, OrderRouter.orderConfirmPage);
    }
  }

  bool _showProductDetail() {
    return context
        .read<DialogShowBloc>()
        .state
        .dialogNames
        .any((element) => ProductDetailPopup.popName == element);
  }

  _reloadShopMatch() {
    int takeMode = context.read<ShopMatchBloc>().state.curTakeFoodMode;
    if (takeMode == Constant.selfTakeModeCode) {
      context.read<ShopMatchBloc>().add(SelfTakeMatchShopEvent(context: context));
    } else if (takeMode == Constant.takeOutModeCode) {
      MemberAddressEntity? address = context.read<ShopMatchBloc>().state.address;
      if (address != null) {
        context.read<ShopMatchBloc>().add(ShopInfoByAddressEvent(address));
      }
    }
  }

  ///自动展开即将开业引导页面
  _defaultOpen(ShopMatchState state) {
    if (state.currentShopDetail?.guidanceToBeOpenedContext?.isExpand == true &&
        state.shopMdCode != null &&
        (!Constant.toBeOpenShopCodes.contains(state.shopMdCode!))) {
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        Constant.toBeOpenShopCodes.add(state.shopMdCode!);
        if (mounted && !widget.cartOffstageChange.value) {
          widget.cartOpenChange.value = false;
          _shopToBeOpenChange.value = true;
        }
      });
    }
  }
}
