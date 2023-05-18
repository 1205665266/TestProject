import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/product/detail_pop.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_event.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_state.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_item_entity.dart';
import 'package:cotti_client/widget/add_sub_product.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotti_client/widget/mini_label_widget.dart';
import 'package:cotti_client/widget/product_price.dart';
import 'package:cotti_client/widget/special_price/cotti_good_line_special_add.dart';
import 'package:cotti_client/widget/special_price/special_price_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/11 14:56
class SimpleMenuItem extends StatefulWidget {
  final MenuItemEntity menuItem;

  Function? itemClickListener;

  SimpleMenuItem({Key? key, required this.menuItem, this.itemClickListener}) : super(key: key);

  @override
  State<SimpleMenuItem> createState() => _SimpleMenuItemState();
}

class _SimpleMenuItemState extends State<SimpleMenuItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ProductDetailPopup.show(context, widget.menuItem.itemNo!);
        if (widget.itemClickListener != null) {
          widget.itemClickListener!();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Opacity(
            opacity: widget.menuItem.skuAllSaleOut == 0 ? 0.5 : 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLitImg(),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildInfo(),
                ),
              ],
            ),
          ),
          if (widget.menuItem.skuAllSaleOut != 0)
            Positioned(
              bottom: 0,
              right: 0,
              child: widget.menuItem.firstSku?.specialActivityLimit?.activityStatus == 0
                  ? _buildSpecialAddBox()
                  : _buildAddSubBox(),
            ),
        ],
      ),
    );
  }

  _buildLitImg() {
    return SizedBox(
      width: 100.w,
      height: 100.w,
      child: Stack(
        children: [
          CottiImageWidget(
            widget.menuItem.litimgUrl ?? '',
            imgW: 100.w,
            imgH: 100.w,
            borderRadius: BorderRadius.circular(4.r),
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
      visible: widget.menuItem.skuAllSaleOut == 0 &&
          (widget.menuItem.firstSku?.noSaleMsg?.isNotEmpty ?? false),
      child: Container(
        alignment: Alignment.center,
        height: 21.h,
        color: Colors.black.withOpacity(0.55),
        child: Text(
          widget.menuItem.firstSku?.noSaleMsg ?? '',
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

  _buildInfo() {
    return Container(
      constraints: BoxConstraints(minHeight: 100.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductTitle(),
                _buildCustomMarketingLabel(),
                _buildEssentials(),
              ],
            ),
          ),
          _buildProductAddBox(),
        ],
      ),
    );
  }

  _buildProductTitle() {
    List<String> titles = widget.menuItem.title?.split("|") ?? [];
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: "${titles[0]}${titles.length > 1 ? '|' : ''}",
        style: TextStyle(
          color: CottiColor.textBlack,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: titles.length > 1 ? titles[1] : '',
            style: TextStyle(
              color: CottiColor.textBlack,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _buildCustomMarketingLabel() {
    List<String> lables = widget.menuItem.customMarketingLabel?.labelList ?? [];
    if (lables.isEmpty) {
      return const SizedBox();
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 6.h),
        child: Wrap(
          spacing: 3.w,
          runSpacing: 4.w,
          children: List.generate(
            lables.length,
            (index) => Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.67.w, color: const Color(0xFF918072)),
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2.r),
                child: MiniLabelWidget(
                  label: lables[index],
                  textPadding: EdgeInsets.symmetric(horizontal: 4.w),
                  textColor: const Color(0xFF918072),
                  isBold: false,
                  textHeight: 1,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  _buildEssentials() {
    return Offstage(
      offstage: widget.menuItem.essentials?.isEmpty ?? true,
      child: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Text(
          widget.menuItem.essentials ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFF5E6164),
            fontSize: 11.sp,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  _buildProductAddBox() {
    return Container(
      padding: EdgeInsets.only(top: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.menuItem.firstSku?.specialActivityLimit?.discountRate != null &&
              widget.menuItem.skuAllSaleOut != 0 &&
              widget.menuItem.firstSku?.specialActivityLimit?.activityStatus == 0)
            SpecialPriceBubble(
              specialText: context.read<ConfigBloc>().state.specialActivityLabel,
              discountRate: widget.menuItem.firstSku!.specialActivityLimit!.discountRate!,
            ),
          ProductPrice(
            skuEntity: widget.menuItem.firstSku,
            showActivityPrice: widget.menuItem.skuAllSaleOut != 0,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialAddBox() {
    return BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
      builder: (context, state) {
        int buyNum = state.getProductNumByItemNo(widget.menuItem.itemNo!);
        int skuNum = widget.menuItem.skuNum ?? 0;
        return CottiGoodLineSpecialAdd(
          quantity: buyNum,
          surplus: widget.menuItem.firstSku?.quantity ?? 0,
          special: widget.menuItem.firstSku!.specialActivityLimit!,
          callback: () => _addSkuCart(skuNum),
        );
      },
    );
  }

  _buildAddSubBox() {
    return BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
      builder: (context, state) {
        int buyNum = state.getProductNumByItemNo(widget.menuItem.itemNo!);
        int skuNum = widget.menuItem.skuNum ?? 0;
        return AddSubProduct(
          buyNum,
          btnSize: 18.w,
          contentPadding: EdgeInsets.only(left: 5.w, right: 8.w, top: 18.w),
          addBtnClickable: buyNum < (widget.menuItem.firstSku?.quantity ?? 0),
          showSubBtn: skuNum <= 1,
          onTapAdd: () => _addSkuCart(skuNum),
          onTapSub: () {
            context.read<ShoppingCartBloc>().add(SubSkuCartEvent(
                  widget.menuItem.itemNo!,
                  (widget.menuItem.firstSku?.skuNo)!,
                ));
          },
        );
      },
    );
  }

  _addSkuCart(int skuNum) {
    if (skuNum > 1) {
      ProductDetailPopup.show(context, widget.menuItem.itemNo!);
    } else {
      context.read<ShoppingCartBloc>().add(AddSkuCartEvent(
            widget.menuItem.itemNo!,
            (widget.menuItem.firstSku?.skuNo)!,
            activityNo: widget.menuItem.firstSku?.specialPriceActivity?.activityNo,
          ));
    }
  }
}
