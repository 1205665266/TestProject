import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_event.dart';
import 'package:cotti_client/pages/shopping_cart/view/shopping_cart_goods.dart';
import 'package:cotti_client/sensors/cart_sensors_constant.dart';
import 'package:cotti_client/widget/box_move_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'bloc/shopping_cart_state.dart';
import 'view/cart_bottom_action_bar.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/18 19:07
class ShoppingCartWidget extends StatefulWidget {
  final ValueNotifier<bool>? shoppingCartOpenChange;

  const ShoppingCartWidget({Key? key, this.shoppingCartOpenChange}) : super(key: key);

  @override
  State<ShoppingCartWidget> createState() => _ShoppingCartWidgetState();
}

class _ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  ///购物车展开开关
  late ValueNotifier<bool> animationChange;
  ValueNotifier<bool> cartOffstageChange = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    if (widget.shoppingCartOpenChange != null) {
      animationChange = widget.shoppingCartOpenChange!;
    } else {
      animationChange = ValueNotifier(false);
    }
    animationChange.addListener(_shoppingCartOpenChange);
    ShopMatchState state = context.read<ShopMatchBloc>().state;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (state.shopMdCode != null) {
        context
            .read<ShoppingCartBloc>()
            .add(ShopChangeEvent(state.shopMdCode!, state.getTakeFoodModes));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopMatchBloc, ShopMatchState>(
      listenWhen: (previous, current) {
        return (previous.shopMdCode != current.shopMdCode ||
                previous.curTakeFoodMode != current.curTakeFoodMode) &&
            current.shopMdCode != null;
      },
      listener: (context, state) {
        context
            .read<ShoppingCartBloc>()
            .add(ShopChangeEvent(state.shopMdCode!, state.getTakeFoodModes));
      },
      child: BlocListener<ShoppingCartBloc, ShoppingCartState>(
        listener: (context, state) {
          if (state.selling.isEmpty && state.sellout.isEmpty) {
            animationChange.value = false;
            cartOffstageChange.value = true;
          } else {
            cartOffstageChange.value = false;
          }
        },
        child: _buildContent(),
      ),
    );
  }

  _buildContent() {
    return ValueListenableBuilder<bool>(
      valueListenable: cartOffstageChange,
      builder: (BuildContext context, value, Widget? child) {
        return Offstage(
          offstage: value,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: animationChange,
                builder: (BuildContext context, value, Widget? child) {
                  return Visibility(
                    visible: value,
                    child: GestureDetector(
                      onTap: () => animationChange.value = false,
                      child: Container(color: Colors.black.withOpacity(0.55)),
                    ),
                  );
                },
              ),
              BoxMoveAnimation(
                initShow: animationChange.value,
                animationChange: animationChange,
                child: const ShoppingCartGoods(),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: CartBottomActionBar(
                  cartOpenChange: animationChange,
                  cartOffstageChange: cartOffstageChange,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _shoppingCartOpenChange() {
    //购物车收起时，将删除确认取消
    if (!animationChange.value) {
      context.read<ShoppingCartBloc>().add(CleanConfirmEvent(false));
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationChange.removeListener(_shoppingCartOpenChange);
    SensorsAnalyticsFlutterPlugin.track(CartSensorsConstant.shoppingCartView, null);
  }
}
