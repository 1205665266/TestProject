import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/product/detail_pop.dart';
import 'package:cotti_client/pages/shopping_cart/entity/shopping_cart_entity.dart';
import 'package:cotti_client/pages/shopping_cart/view/cart_item_simmer.dart';
import 'package:cotti_client/pages/shopping_cart/view/good_line_cart_spec.dart';
import 'package:cotti_client/pages/tabs/menu/entity/sku_entity.dart';
import 'package:cotti_client/sensors/cart_sensors_constant.dart';
import 'package:cotti_client/widget/add_sub_product.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotti_client/widget/product_price.dart';
import 'package:cotti_client/widget/special_price/lightning.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import '../bloc/shopping_cart_bloc.dart';
import '../bloc/shopping_cart_event.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/21 20:43
class CartItem extends StatefulWidget {
  final GoodsItem item;
  final int index;

  ///不可售卖
  final bool noSale;

  const CartItem({
    Key? key,
    required this.item,
    required this.noSale,
    required this.index,
  }) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  SkuEntity? skuEntity;

  @override
  Widget build(BuildContext context) {
    skuEntity = _cartGoodsItemCovert();
    return Opacity(
      opacity: widget.noSale ? 0.5 : 1,
      child: Slidable(
        key: Key(widget.item.skuCode),
        groupTag: 0,
        endActionPane: _buildActionPane(),
        child: widget.item.salePrice == null ? _buildSimmer() : _buildContent(),
      ),
    );
  }

  _buildActionPane() {
    return ActionPane(
      motion: const ScrollMotion(),
      extentRatio: 0.14,
      children: [
        CustomSlidableAction(
          onPressed: (context) => _deleteItem(),
          backgroundColor: CottiColor.primeColor,
          padding: EdgeInsets.zero,
          child: Center(
            child: Text(
              '删除',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildSimmer() {
    return Row(
      children: [
        _selectStatus(),
        const Expanded(
          child: CartItemSimmer(),
        ),
      ],
    );
  }

  _deleteItem() {
    context.read<ShoppingCartBloc>().add(SubSkuCartEvent(
          widget.item.itemNo!,
          widget.item.skuCode,
          isDelete: true,
        ));
    SensorsAnalyticsFlutterPlugin.track(CartSensorsConstant.shoppingCartLeftSwipeProductDelete, {
      "product_name": widget.item.title,
      "product_spu_id": widget.item.itemNo,
    });
  }

  _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _selectStatus(),
            GestureDetector(
              onTap: () => _openProductDetail(),
              child: _buildLitImg(),
            ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _openProductDetail(),
            child: Container(
              constraints: BoxConstraints(
                minHeight: 80.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTitle(),
                  _goodLinePrice(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _openProductDetail() {
    if (!widget.noSale) {
      ProductDetailPopup.show(context, widget.item.itemNo!);
      SensorsAnalyticsFlutterPlugin.track(
        CartSensorsConstant.shoppingCartSkuClick,
        {"product_name": widget.item.title, "product_spu_id": widget.item.itemNo},
      );
    }
  }

  Widget _buildLitImg() {
    return SizedBox(
      width: 80.w,
      height: 80.w,
      child: Stack(
        children: [
          CottiImageWidget(
            widget.item.image ?? '',
            imgW: 80.w,
            imgH: 80.w,
            borderRadius: BorderRadius.circular(3.r),
            resize: "w_${400},h_${400}",
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildSaleOutTips(),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleOutTips() {
    return Visibility(
      visible: widget.noSale,
      child: Container(
        alignment: Alignment.center,
        height: 21.h,
        color: Colors.black.withOpacity(0.55),
        child: Text(
          widget.item.notSaleableReason ?? '',
          maxLines: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.item.title ?? "",
          style: TextStyle(
            color: CottiColor.textBlack,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: GoodLineCartSpec(
            skuShowName: widget.item.skuShowName,
            isEatIn: widget.item.mealType == 1,
            onTap: () {
              if (widget.noSale) {
                return;
              }
              ProductDetailPopup.show(
                context,
                widget.item.itemNo!,
                edit: 1,
                sku: widget.item.skuCode,
                skuBuyNum: widget.item.buyNum,
              );
            },
          ),
        ),
        if ((widget.item.saleable != 1 || widget.item.soldOut != 0) && !widget.noSale)
          Text(
            "请重新选择商品规格",
            style: TextStyle(
              color: const Color(0xFFFF1600),
              fontSize: 12.sp,
            ),
          ),
      ],
    );
  }

  _goodLinePrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductPrice(
              skuEntity: skuEntity,
              showActivityPrice: !widget.noSale,
            ),
            if (skuEntity?.specialActivityLimit != null && !widget.noSale)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Lightning(
                  special: skuEntity!.specialActivityLimit!,
                  quantity: widget.item.stockNum ?? 0,
                ),
              ),
            _buildLimitCouponNumMsg(),
          ],
        ),
        _buildAddProduct(),
      ],
    );
  }

  _buildAddProduct() {
    if (widget.noSale) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if ((widget.item.buyNum ?? 0) >= widget.item.stockNum!)
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text(
              "仅剩${widget.item.stockNum}件",
              style: TextStyle(
                color: const Color(0xFFFF1600),
                fontSize: 12.sp,
              ),
            ),
          ),
        AddSubProduct(
          widget.item.buyNum ?? 0,
          countSize: 18.sp,
          contentPadding: EdgeInsets.only(top: 4.h, left: 5.w, right: 16.w),
          btnSize: 20.w,
          addBtnClickable: (widget.item.buyNum ?? 0) < (widget.item.stockNum ?? 0),
          onTapSub: () {
            context.read<ShoppingCartBloc>().add(SubSkuCartEvent(
                  widget.item.itemNo!,
                  widget.item.skuCode,
                ));
          },
          onTapAdd: () {
            context.read<ShoppingCartBloc>().add(AddSkuCartEvent(
                  widget.item.itemNo!,
                  widget.item.skuCode,
                  activityNo: widget.item.specialPriceActivity?.activityNo,
                ));
          },
        ),
      ],
    );
  }

  Widget _selectStatus() {
    Icon icon;
    bool isNotClick = widget.item.saleable != 1 || widget.item.soldOut != 0 || widget.noSale;
    if (isNotClick) {
      icon = Icon(IconFont.icon_bukexuan, size: 18.w, color: CottiColor.textHint);
    } else {
      bool isSelect = widget.item.selectedStatus == 1;
      icon = Icon(
        isSelect ? IconFont.icon_xuanzhong : IconFont.icon_weixuanzhong1,
        size: 18.w,
        color: isSelect ? CottiColor.primeColor : CottiColor.textGray,
      );
    }
    return GestureDetector(
      onTap: () {
        if (isNotClick) {
          return;
        }
        context.read<ShoppingCartBloc>().add(SelectCartEvent(widget.index));
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 12.w),
        child: icon,
      ),
    );
  }

  _buildLimitCouponNumMsg() {
    if (widget.item.showLimitCouponNumMsg == null || widget.item.showLimitCouponNumMsg == false) {
      return const SizedBox();
    }
    String limitCouponNumMsg = '';
    String processPriceSpecialNumMsg = '';
    // if (widget.item.processPriceSpecialNum != null) {
    //   processPriceSpecialNumMsg =
    //       "第${widget.item.processPriceSpecialNum! + 1}件起恢复原售价¥${widget.item.salePrice}";
    // }
    // if (widget.item.processPriceSpecialNum != null && widget.item.processPriceCounponNum != null) {
    //   limitCouponNumMsg = "${widget.item.processPriceCounponNum!}件享受优惠券价";
    // }
    if (limitCouponNumMsg.isEmpty && processPriceSpecialNumMsg.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: processPriceSpecialNumMsg.isNotEmpty,
            child: Text(
              processPriceSpecialNumMsg,
              style: TextStyle(
                color: const Color(0xFF918072),
                fontSize: 11.sp,
              ),
            ),
          ),
          Visibility(
            visible: limitCouponNumMsg.isNotEmpty,
            child: Text(
              limitCouponNumMsg,
              style: TextStyle(
                color: const Color(0xFF918072),
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SkuEntity _cartGoodsItemCovert() {
    return SkuEntity()
      ..saleOut = widget.item.soldOut == 1
      ..noSale = widget.item.saleable == 1 ? 0 : 1
      ..sellPrice = coverPrice(widget.item.salePrice)
      ..activityPrice = coverPrice(widget.item.specialPriceActivity?.specialPrice)
      ..standardPrice = coverPrice(widget.item.lineThroughPrice)
      ..skusSpecs = widget.item.skusSpecs
      ..skuNo = widget.item.skuCode
      ..specialPriceActivity = widget.item.specialPriceActivity
      ..specialActivityLimit = widget.item.specialActivityLimit
      ..skuName = widget.item.skuShowName;
  }

  int coverPrice(String? value) {
    return (Decimal.parse(value ?? '0') * Decimal.parse("100")).toBigInt().toInt();
  }
}
