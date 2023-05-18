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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/13 16:17
class LatelyBuyItem extends StatefulWidget {
  final MenuItemEntity menuItem;

  const LatelyBuyItem({Key? key, required this.menuItem}) : super(key: key);

  @override
  State<LatelyBuyItem> createState() => _LatelyBuyItemState();
}

class _LatelyBuyItemState extends State<LatelyBuyItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ProductDetailPopup.show(
        context,
        widget.menuItem.itemNo!,
        sku: widget.menuItem.firstSku?.skuNo,
      ),
      child: Row(
        children: [
          _buildLitImg(),
          SizedBox(width: 8.w),
          Expanded(child: _buildName()),
          _buildPrice(),
          _buildAdd(),
        ],
      ),
    );
  }

  _buildLitImg() {
    return CottiImageWidget(
      widget.menuItem.litimgUrl ?? '',
      imgW: 32.w,
      imgH: 32.w,
      borderRadius: BorderRadius.circular(3.r),
      resize: "w_${400},h_${400}",
    );
  }

  _buildName() {
    int? sales = widget.menuItem.sales;
    return Row(
      children: [
        Flexible(
          child: Text(
            widget.menuItem.title ?? '',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: CottiColor.textBlack,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        if (sales != null)
          MiniLabelWidget(
            label: sales > 2 ? "多次" : "$sales次",
            backgroundColor: const Color(0xFFF4F4F4),
            textColor: const Color(0xFF5E5E5E),
            textPadding: EdgeInsets.symmetric(horizontal: 4.w),
            isBold: false,
            textSize: 10.sp,
          ),
      ],
    );
  }

  Widget _buildPrice() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ProductPrice(
          symbolSize: 10.sp,
          productPriceSize: 14.sp,
          skuEntity: widget.menuItem.firstSku,
          showActivityPrice: widget.menuItem.skuAllSaleOut != 0,
        ),
        if (widget.menuItem.firstSku?.specialActivityLimit != null)
          MiniLabelWidget(
            label: context.read<ConfigBloc>().state.specialActivityLabel,
            textPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0),
            textSize: 9.sp,
            textHeight: 1,
          ),
      ],
    );
  }

  Widget _buildAdd() {
    return BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
      builder: (context, state) {
        int buyNum = state.getProductNumByItemNo(widget.menuItem.itemNo!);
        int skuNum = widget.menuItem.skuNum ?? 0;
        return AddSubProduct(
          buyNum,
          contentPadding: EdgeInsets.all(8.w),
          redPointMarginBottom: 17.5.h,
          addBtnClickable: buyNum < (widget.menuItem.firstSku?.quantity ?? 0),
          btnSize: 18.w,
          showSubBtn: false,
          onTapAdd: () {
            if (skuNum > 1) {
              ProductDetailPopup.show(
                context,
                widget.menuItem.itemNo!,
                sku: widget.menuItem.firstSku?.skuNo,
              );
            } else {
              context.read<ShoppingCartBloc>().add(AddSkuCartEvent(
                    widget.menuItem.itemNo!,
                    (widget.menuItem.firstSku?.skuNo)!,
                    activityNo: widget.menuItem.firstSku?.specialPriceActivity?.activityNo,
                  ));
            }
          },
        );
      },
    );
  }
}
