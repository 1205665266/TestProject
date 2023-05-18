import 'dart:convert';

import 'package:abitelogin/pages/util/login_utils.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/product/bloc/product_bloc.dart';
import 'package:cotti_client/pages/product/bloc/product_event.dart';
import 'package:cotti_client/pages/product/bloc/product_state.dart';
import 'package:cotti_client/pages/product/entity/product_spec_entity.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_event.dart';
import 'package:cotti_client/pages/shopping_cart/entity/cart_goods_item.dart';
import 'package:cotti_client/routers/order_router.dart';
import 'package:cotti_client/sensors/product_sensors_constant.dart';
import 'package:cotti_client/widget/add_sub_product.dart';
import 'package:cotti_client/widget/cotti_tooltip.dart';
import 'package:cotti_client/widget/simple_tooltip/simple_tooltip.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class ProductToolbar extends StatefulWidget {
  final int edit;
  final String sku;
  final int skuBuyNum;

  final Function()? refresh;

  const ProductToolbar(
      {Key? key, required this.edit, required this.sku, required this.skuBuyNum, this.refresh})
      : super(key: key);

  @override
  State<ProductToolbar> createState() => _ProductToolbarState();
}

class _ProductToolbarState extends State<ProductToolbar> {
  final ValueNotifier<bool> showControl = ValueNotifier(false);
  int cartMaxCount = GlobalBlocs.get<ConfigBloc>(ConfigBloc.blocName).state.maxCount;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        bool cannotBuy =
            (state.currentSkuData?.noSale == 1 || state.currentSkuData?.haltSale == 1) ||
                (state.currentSkuData?.noSale == 0 && state.currentSkuData?.saleOut == true);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  offset: const Offset(0.0, 1.0), //阴影y轴偏移量
                  blurRadius: 4, //阴影模糊程度
                  spreadRadius: 0 //阴影扩散程度
                  ),
            ],
          ),
          child: SafeArea(
            top: false,
            bottom: true,
            minimum: EdgeInsets.only(bottom: 14.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.currentSkuData != null) _productInfo(state, cannotBuy),
                if (cannotBuy) _btnDisable(state),
                if (!cannotBuy) _btnGroup(state)
              ],
            ),
          ),
        );
      },
    );
  }

  _editSku() {
    int getAllCartCount = context.read<ShoppingCartBloc>().state.getAllCartCount;
    ProductState productState = context.read<ProductBloc>().state;
    ProductSpecSkuCombinList? currentSkuData = productState.currentSkuData;
    int buyNum = productState.buyNum;
    if ((buyNum - widget.skuBuyNum + getAllCartCount) > cartMaxCount) {
      ToastUtil.show("购物车已满，请清除部分商品后再试");
      return;
    }

    context.read<ShoppingCartBloc>().add(EditSkuCartEvent(
          CartGoodsItem()
            ..itemNo = productState.productDetailData!.itemNo!
            ..skuCode = currentSkuData!.skuNo!
            ..buyNum = productState.buyNum,
          CartGoodsItem()
            ..itemNo = productState.productDetailData!.itemNo!
            ..skuCode = widget.sku
            ..buyNum = widget.skuBuyNum,
          productState.currentSkuIsActive ? currentSkuData.specialPriceActivity?.activityNo : null,
        ));
    Navigator.pop(context);
  }

  _buyNow() {
    ProductState productState = context.read<ProductBloc>().state;
    ProductSpecEntity? productSpecData = productState.productSpecData;
    ProductSpecSkuCombinList? currentSkuData = productState.currentSkuData;
    int buyNum = productState.buyNum;

    Map<String, dynamic> params = {
      "businessTypes": currentSkuData?.businessTypes,
      "spuNo": productSpecData?.itemNo,
      "skuNo": currentSkuData?.skuNo,
      "buyNum": buyNum,
      "specialPrice": productState.currentSkuIsActive
          ? currentSkuData?.specialPriceActivity?.specialPrice
          : null,
    };

    SensorsAnalyticsFlutterPlugin.track(ProductSensorsConstant.commonBuyItNow, {});
    if (!Constant.hasLogin) {
      LoginUtils.login(context).then((value) {
        if (Constant.hasLogin) {
          NavigatorUtils.push(context, OrderRouter.orderConfirmPage,
              params: {"fromDetail": true, "productInfo": json.encode(params)}).then((result) {
            if (result != null && result["refresh"]) {
              // 刷新订单详情
              logI("刷新商品详情");
              if (widget.refresh != null) {
                widget.refresh!();
              }
            }
          });
        }
      });
      return;
    }

    NavigatorUtils.push(context, OrderRouter.orderConfirmPage,
        params: {"fromDetail": true, "productInfo": json.encode(params)}).then((result) {
      if (result !=null && result["refresh"]) {
        // 刷新订单详情
        logI("刷新商品详情");
        if (widget.refresh != null) {
          widget.refresh!();
        }
      }
    });
  }

  _addCart() {
    int getAllCartCount = context.read<ShoppingCartBloc>().state.getAllCartCount;
    ProductState productState = context.read<ProductBloc>().state;
    ProductSpecEntity? productSpecData = productState.productSpecData;
    ProductSpecSkuCombinList? currentSkuData = productState.currentSkuData;
    int buyNum = productState.buyNum;
    if (buyNum + getAllCartCount > cartMaxCount) {
      ToastUtil.show("购物车已满，请清除部分商品后再试");
      return;
    }
    SensorsAnalyticsFlutterPlugin.track(ProductSensorsConstant.productDetailAddToCartClick, {});
    context.read<ShoppingCartBloc>().add(AddSkuCartEvent(
          productSpecData!.itemNo!,
          currentSkuData!.skuNo!,
          buyNum: buyNum,
          activityNo: productState.currentSkuIsActive
              ? currentSkuData.specialPriceActivity?.activityNo
              : null,
        ));
    Navigator.pop(context);
  }

  Widget _productInfo(ProductState state, bool cannotBuy) {
    bool isMax =
        state.buyNum >= (state.currentSkuData?.quantity ?? 0) || state.buyNum >= cartMaxCount;
    return SizedBox(
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _priceLine(state, cannotBuy),
                  if (state.currentSkuData?.spuShowName != '')
                    Container(
                      margin: EdgeInsets.only(top: 5.h),
                      child: Text(
                        "${state.currentSkuData?.spuShowName}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12.sp, height: 1, color: CottiColor.textGray),
                      ),
                    ),
                ],
              ),
            ),
          ),
          AddSubProduct(
            state.buyNum,
            countSize: 18.sp,
            contentPadding: EdgeInsets.only(top: 4.h, right: 16.w),
            btnSize: 20.w,
            addBtnClickable: !isMax,
            subBtnClickable: state.buyNum > 1,
            onTapSub: () {
              if (state.buyNum > 1) {
                context.read<ProductBloc>().add(ChangeBuyNumberEvent(false));
              }
            },
            onTapAdd: () {
              int willNum = state.buyNum + 1;
              if (willNum > (state.currentSkuData?.quantity ?? 0) || willNum > cartMaxCount) {
                // 超出库存上限，或购物车上限，禁止加购
                return;
              }
              context.read<ProductBloc>().add(ChangeBuyNumberEvent(true));
            },
          ),
        ],
      ),
    );
  }

  Widget _priceLine(ProductState state, bool cannotBuy) {
    String? salePrice;
    if (state.currentSkuData?.specialPriceActivity != null &&
        state.currentSkuData?.specialPriceActivity?.specialPrice != null &&
        state.currentSkuData?.specialPriceActivity?.specialPrice != '' &&
        (state.currentSkuData?.specialActivityLimitDTO?.limitAmount ?? 0) > 0 &&
        !cannotBuy) {
      int price = int.parse(state.currentSkuData?.specialPriceActivity?.specialPrice ?? '0');
      salePrice = "${price / 100.0}";
    } else {
      salePrice = state.currentSkuData?.sellPriceStr;
    }
    if (salePrice == null) {
      return const SizedBox();
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            "¥",
            style: TextStyle(fontSize: 16.sp, height: 1.5, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Text(
              salePrice,
              style: TextStyle(fontSize: 24.sp, fontFamily: 'DDP5'),
            ),
          ),
          if (salePrice != state.currentSkuData?.standardPriceStr)
            Padding(
              padding: EdgeInsets.only(right: 6.w),
              child: Text(
                "¥${state.currentSkuData?.standardPriceStr}",
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'DDP4',
                    color: CottiColor.textGray,
                    decoration: TextDecoration.lineThrough,
                    height: 1.72),
              ),
            ),
          if (!cannotBuy)
            (state.currentSkuData?.displayOncePrice == true)
                ? _activeTag(state)
                : _specialTag(state)
        ])
      ],
    );
  }

  Widget _specialTag(ProductState state) {
    if (state.currentSkuData?.specialActivityLimitDTO == null) {
      return const SizedBox();
    }
    int? activityShowType = state.currentSkuData?.specialActivityLimitDTO?.activityShowType;
    int limitAmount = state.currentSkuData?.specialActivityLimitDTO?.limitAmount ?? 0;
    if ([1, 2, 3].contains(activityShowType) && limitAmount <= 0) {
      return const SizedBox();
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 20.h,
          padding: EdgeInsets.only(left: 8.w, right: 3.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 1.w, color: CottiColor.primeColor),
              right: BorderSide(width: 1.w, color: CottiColor.primeColor),
              bottom: BorderSide(width: 1.w, color: CottiColor.primeColor),
              left: BorderSide(width: 1.w, color: CottiColor.primeColor),
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(4.r),
              bottomRight: Radius.circular(4.r),
            ),
          ),
          child: _specialTagText(state),
        ),
        Positioned(
          left: -2.5.w,
          child:
              SvgPicture.asset("assets/images/product/icon_light.svg", width: 10.w, height: 20.h),
        ),
      ],
    );
  }

  Widget _specialTagText(ProductState state) {
    if (state.currentSkuData?.specialActivityLimitDTO?.activityShowType == 1 ||
        state.currentSkuData?.specialActivityLimitDTO?.activityShowType == 2) {
      return Row(
        children: [
          Text(
            "限购",
            style: TextStyle(
              fontSize: 11.sp,
              color: CottiColor.primeColor,
            ),
          ),
          Text(
            "${state.currentSkuData?.specialActivityLimitDTO?.limitAmount}",
            style: TextStyle(fontSize: 15.sp, color: CottiColor.primeColor, fontFamily: 'DDP6'),
          ),
          Text(
            "件",
            style: TextStyle(
              fontSize: 11.sp,
              color: CottiColor.primeColor,
            ),
          ),
        ],
      );
    } else if (state.currentSkuData?.specialActivityLimitDTO?.activityShowType == 3) {
      return Row(
        children: [
          Text(
            "仅剩",
            style: TextStyle(
              fontSize: 11.sp,
              color: CottiColor.primeColor,
            ),
          ),
          Text(
            "${state.currentSkuData?.specialActivityLimitDTO?.limitAmount}",
            style: TextStyle(fontSize: 15.sp, color: CottiColor.primeColor, fontFamily: 'DDP6'),
          ),
          Text(
            "件",
            style: TextStyle(
              fontSize: 11.sp,
              color: CottiColor.primeColor,
            ),
          ),
        ],
      );
    } else if (state.currentSkuData?.specialActivityLimitDTO?.activityShowType == 5) {
      double val = double.parse(
          "${(state.currentSkuData?.specialActivityLimitDTO?.limitProgressBar ?? 0) * 100}");
      return Row(
        children: [
          Text(
            "已抢",
            style: TextStyle(
              fontSize: 11.sp,
              color: CottiColor.primeColor,
            ),
          ),
          Text(
            "${val.toInt()}",
            style: TextStyle(fontSize: 15.sp, color: CottiColor.primeColor, fontFamily: 'DDP6'),
          ),
          Text(
            "%",
            style: TextStyle(
              fontSize: 11.sp,
              color: CottiColor.primeColor,
            ),
          ),
        ],
      );
    } else {
      double? discountRate = state.currentSkuData?.specialActivityLimitDTO?.discountRate;

      return Row(
        children: [
          Text(
            context.read<ConfigBloc>().state.specialActivityLabel,
            style: TextStyle(
              fontSize: 11.sp,
              color: CottiColor.primeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (discountRate != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Container(
                width: 1.w,
                height: 12.h,
                color: CottiColor.primeColor,
              ),
            ),
          if (discountRate != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${Decimal.tryParse('$discountRate')}",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: CottiColor.primeColor,
                    fontFamily: 'DDP6',
                  ),
                ),
                Text(
                  "折",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: CottiColor.primeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      );
    }
  }

  Widget _activeTag(ProductState state) {
    return Row(
      children: [
        Container(
          height: 20.h,
          padding: EdgeInsets.only(left: 4.w, right: 8.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFBE7E5),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(0.w),
              topLeft: Radius.circular(4.w),
              bottomRight: Radius.circular(0.w),
              bottomLeft: Radius.circular(4.w),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            "${state.currentSkuData?.oncePriceStr}",
            style: TextStyle(
              fontSize: 12.sp,
              color: CottiColor.primeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -3.5.w,
              child: Image.asset(
                "assets/images/product/border_active_lighting.png",
                width: 10.w,
                height: 20.h,
              ),
            ),
            Container(
              height: 20.h,
              padding: EdgeInsets.only(left: 2.w, right: 6.w),
              decoration: BoxDecoration(
                color: CottiColor.primeColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.w),
                  topLeft: Radius.circular(0.w),
                  bottomRight: Radius.circular(4.w),
                  bottomLeft: Radius.circular(0.w),
                ),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      '￥',
                      style: TextStyle(
                        height: 1,
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: Text(
                      Decimal.tryParse("${state.currentSkuData?.oncePrice}")?.toString() ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontFamily: 'DDP6',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (state.currentSkuData?.oncePriceDetailStr != null &&
            state.currentSkuData?.oncePriceDetailStr != '')
          GestureDetector(
            onTap: () {
              showControl.value = true;
            },
            child: Container(
              padding: EdgeInsets.only(left: 5.w),
              child: CottiTooltip(
                  child: Icon(
                    IconFont.icon_tanhao,
                    size: 12.sp,
                    color: CottiColor.textHint,
                  ),
                  tooltipDirection: TooltipDirection.up,
                  tip: state.currentSkuData?.oncePriceDetailStr,
                  showControl: showControl),
            ),
          ),
      ],
    );
  }

  Widget _btnGroup(ProductState state) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        children: [
          if (widget.edit == 1) GestureDetector(onTap: _editSku, child: _editBtn()),
          if (widget.edit == 0 && !context.read<ShopMatchBloc>().state.shopToBeOpened)
            Expanded(
              child: GestureDetector(onTap: _buyNow, child: _buyNowBtn()),
            ),
          if (widget.edit == 0 && !context.read<ShopMatchBloc>().state.shopToBeOpened)
            SizedBox(width: 7.w),
          if (widget.edit == 0)
            Expanded(
              child: GestureDetector(onTap: _addCart, child: _addCartBtn()),
            ),
        ],
      ),
    );
  }

  Widget _btnDisable(ProductState state) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          SizedBox(
            width: 16.w,
          ),
          _disableBtn(state.currentSkuData?.noSaleMsg ?? '本店暂时售罄'),
          SizedBox(
            width: 16.w,
          ),
        ],
      ),
    );
  }

  Widget _editBtn() {
    return Container(
      width: 343.w,
      height: 40.h,
      color: CottiColor.primeColor,
      alignment: Alignment.center,
      child: Text("保存修改",
          style: TextStyle(
              color: Colors.white, fontSize: 14.sp, height: 1, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buyNowBtn() {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1.w, color: CottiColor.primeColor),
        borderRadius: BorderRadius.circular(4.r),
      ),
      alignment: Alignment.center,
      child: Text(
        "立即购买",
        style: TextStyle(
          color: CottiColor.primeColor,
          fontSize: 14.sp,
          height: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _addCartBtn() {
    return Container(
      height: 40.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: CottiColor.primeColor,
          border: Border.all(width: 1.w, color: CottiColor.primeColor),
          borderRadius: BorderRadius.circular(4.r)),
      child: Text(
        "加入购物车",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          height: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _disableBtn(btnText) {
    return Container(
      width: 343.w,
      height: 40.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: const Color(0xFFd0d0d0),
          border: Border.all(width: 1.w, color: const Color(0xFFd0d0d0)),
          borderRadius: BorderRadius.circular(2.r)),
      child: Text("$btnText",
          style: TextStyle(
              color: Colors.white, fontSize: 14.sp, height: 1, fontWeight: FontWeight.bold)),
    );
  }
}
