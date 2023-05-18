import 'dart:math';

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_event.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_state.dart';
import 'package:cotti_client/pages/shopping_cart/entity/shopping_cart_entity.dart';
import 'package:cotti_client/sensors/cart_sensors_constant.dart';
import 'package:cotti_client/widget/mini_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'cart_item.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/19 16:19
class ShoppingCartGoods extends StatefulWidget {
  const ShoppingCartGoods({Key? key}) : super(key: key);

  @override
  State<ShoppingCartGoods> createState() => _ShoppingCartGoodsState();
}

class _ShoppingCartGoodsState extends State<ShoppingCartGoods> {
  late double contentMaxHeight;

  @override
  void initState() {
    super.initState();
    contentMaxHeight = ScreenUtil().screenHeight * 0.7;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
          child: Container(
            constraints: BoxConstraints(maxHeight: contentMaxHeight),
            padding: EdgeInsets.only(bottom: 48.h),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDiscountInfo(state.cartEntity.couponDiscountTip),
                Flexible(
                  child: _buildContent(state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildContent(ShoppingCartState state) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 52.h),
          child: SlidableAutoCloseBehavior(
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              slivers: [
                _buildItemList(state.selling, false, true),
                if (state.sellout.isNotEmpty) _buildSelloutTips(state.sellout.length),
                _buildItemList(state.sellout, true, state.showSellOutList),
                if (state.sellout.length > 1) _buildOpenAll(state.showSellOutList),
                SliverPadding(padding: EdgeInsets.only(bottom: 20.h)),
              ],
            ),
          ),
        ),
        _buildActionTop(state),
      ],
    );
  }

  _buildItemList(List<GoodsItem> selling, bool noSale, bool showAll) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          margin: EdgeInsets.only(top: 20.h),
          child: CartItem(noSale: noSale, item: selling[index], index: index),
        ),
        childCount: showAll ? selling.length : min(selling.length, 1),
      ),
    );
  }

  _buildSelloutTips(int count) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 55.w, height: 0.5.h, color: CottiColor.textHint),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                '以下餐品当前门店不可售($count)',
                style: TextStyle(
                  color: const Color(0xFF666666),
                  fontSize: 12.sp,
                  fontFamily: 'DDP4',
                ),
                strutStyle: const StrutStyle(forceStrutHeight: true),
              ),
            ),
            Container(width: 55.w, height: 0.5.h, color: CottiColor.textHint),
          ],
        ),
      ),
    );
  }

  _buildOpenAll(bool showListAll) {
    return SliverToBoxAdapter(
      child: Center(
        child: GestureDetector(
          onTap: () => context.read<ShoppingCartBloc>().add(ShowSellOutChangeEvent()),
          behavior: HitTestBehavior.opaque,
          child: Container(
            margin: EdgeInsets.only(top: 20.h),
            padding: EdgeInsets.fromLTRB(18.w, 4.h, 14.w, 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F2F5).withOpacity(0.8),
              borderRadius: BorderRadius.all(Radius.circular(2.r)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  showListAll ? "收起不可售" : "展开全部",
                  style: TextStyle(
                    color: CottiColor.textHint,
                    fontSize: 11.sp,
                  ),
                  strutStyle: const StrutStyle(forceStrutHeight: true),
                ),
                Icon(
                  showListAll
                      ? IconFont.icon_caidan_zhankaishouqingshangjiantou
                      : IconFont.icon_caidan_zhankaishouqingxiajiantou,
                  size: 16.w,
                  color: CottiColor.textHint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildDiscountInfo(CouponDiscountTip? couponDiscountTip) {
    if (couponDiscountTip == null) {
      return const SizedBox();
    }
    return Container(
      color: const Color(0xFFFDF3F2),
      alignment: Alignment.center,
      height: 32.h,
      child: RichText(
        text: _buildDiscountText(couponDiscountTip),
      ),
    );
  }

  _buildNormalTextSpan(String str) {
    return TextSpan(
      children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Text(
            str,
            style: TextStyle(
              color: CottiColor.textBlack,
              fontSize: 14.sp,
            ),
            strutStyle: const StrutStyle(forceStrutHeight: true),
          ),
        ),
      ],
    );
  }

  _buildSpecialTextSpan(String str) {
    return TextSpan(
      children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              str,
              style: TextStyle(
                color: CottiColor.primeColor,
                fontSize: 14.sp,
                fontFamily: 'DDP6',
              ),
              strutStyle: const StrutStyle(forceStrutHeight: true),
            ),
          ),
        ),
      ],
    );
  }

  _buildActionTop(ShoppingCartState state) {
    return Container(
      height: 52.h,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: CottiColor.textBlack.withOpacity(0.06),
            spreadRadius: 1,
            blurRadius: 0,
            offset: Offset(0, 0.5.h),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildShopInfo(state),
          ),
          _buildCleanShoppingCart(state.isCleanConfirmation),
        ],
      ),
    );
  }

  _buildShopInfo(ShoppingCartState state) {
    return BlocBuilder<ShopMatchBloc, ShopMatchState>(
      builder: (context, matchState) {
        int curTakeFoodMode = matchState.curTakeFoodMode;
        String takeModeText =
            context.read<ConfigBloc>().state.getShopModeText(curTakeFoodMode) ?? '';
        return Row(
          children: [
            GestureDetector(
              onTap: () =>
                  context.read<ShoppingCartBloc>().add(SelectAllCartEvent(!state.isSelectAll)),
              behavior: HitTestBehavior.opaque,
              child: Icon(
                state.isSelectAll ? IconFont.icon_xuanzhong : IconFont.icon_weixuanzhong1,
                color: state.isSelectAll ? CottiColor.primeColor : CottiColor.textGray,
                size: 18.w,
              ),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                shopName(curTakeFoodMode, matchState) ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: CottiColor.textBlack,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                strutStyle: const StrutStyle(
                  forceStrutHeight: true,
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(2.r)),
              child: MiniLabelWidget(
                label: takeModeText,
                textSize: 12.sp,
                textPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              ),
            ),
            SizedBox(width: 12.w),
          ],
        );
      },
    );
  }

  _buildCleanShoppingCart(bool isShow) {
    return isShow
        ? GestureDetector(
            onTap: () {
              context.read<ShoppingCartBloc>().add(ClearCartEvent());
              SensorsAnalyticsFlutterPlugin.track(CartSensorsConstant.shoppingCartClearComfirmClick,
                  {"cart_count": context.read<ShoppingCartBloc>().state.getAllCartCount});
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40.w,
              decoration: BoxDecoration(
                border: Border.all(width: 0.5.w, color: CottiColor.textHint),
              ),
              child: Text(
                '确定',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CottiColor.textHint,
                  fontSize: 12.sp,
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              context.read<ShoppingCartBloc>().add(CleanConfirmEvent(true));
              SensorsAnalyticsFlutterPlugin.track(CartSensorsConstant.shoppingCartClearClick,
                  {"cart_count": context.read<ShoppingCartBloc>().state.getAllCartCount});
            },
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 40.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    IconFont.icon_shanchu,
                    size: 15.w,
                    color: CottiColor.textHint,
                  ),
                  Text(
                    '清空',
                    style: TextStyle(
                      color: CottiColor.textGray,
                      fontSize: 12.sp,
                    ),
                    strutStyle: const StrutStyle(
                      forceStrutHeight: true,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  TextSpan _buildDiscountText(CouponDiscountTip couponDiscountTip) {
    ///新增 如果使用了代金券，就强制显示金额
    couponText(String str, {bool isUserVoucher = false}) {
      if (couponDiscountTip.couponType == 20 && !isUserVoucher) {
        return TextSpan(children: [
          _buildSpecialTextSpan(str),
          _buildNormalTextSpan('折'),
        ]);
      }
      return _buildSpecialTextSpan("¥$str");
    }

    availableText() {
      if (couponDiscountTip.couponType == 20 && couponDiscountTip.isUserVoucher == 1) {
        return _buildNormalTextSpan('可另享');
      } else {
        return _buildNormalTextSpan('可享');
      }
    }

    if (couponDiscountTip.reducedMoney?.isNotEmpty ?? false) {
      if (couponDiscountTip.stillOweMoney == null) {
        return TextSpan(children: [
          _buildNormalTextSpan('已享'),
          couponText(couponDiscountTip.reducedMoney ?? '',
              isUserVoucher: couponDiscountTip.isUserVoucher == 1),
          _buildNormalTextSpan('优惠'),
        ]);
      } else {
        return TextSpan(children: [
          _buildNormalTextSpan('已享'),
          _buildSpecialTextSpan("¥${couponDiscountTip.reducedMoney}"),
          _buildNormalTextSpan('优惠，再买'),
          _buildSpecialTextSpan("¥${couponDiscountTip.stillOweMoney}"),
          availableText(),
          couponText(couponDiscountTip.canHaveMoney ?? ''),
          _buildNormalTextSpan('优惠'),
        ]);
      }
    } else {
      if (couponDiscountTip.stillOweMoney?.isNotEmpty ?? false) {
        return TextSpan(children: [
          _buildNormalTextSpan('再买'),
          _buildSpecialTextSpan("¥${couponDiscountTip.stillOweMoney}"),
          _buildNormalTextSpan('可享'),
          couponText(couponDiscountTip.canHaveMoney ?? ''),
          _buildNormalTextSpan('优惠'),
        ]);
      }
    }
    return const TextSpan();
  }

  String? shopName(int curTakeFoodMode, ShopMatchState matchState) {
    if (curTakeFoodMode == Constant.selfTakeModeCode) {
      return matchState.currentShopDetail?.shopName;
    } else {
      String? labelName = matchState.address?.labelName;
      if (labelName != null) {
        labelName += "-";
      }
      labelName ??= '';
      return "$labelName${matchState.address?.location}${matchState.address?.address}";
    }
  }
}
