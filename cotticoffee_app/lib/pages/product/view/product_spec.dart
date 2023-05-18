import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';
import 'package:cotti_client/pages/product/bloc/product_bloc.dart';
import 'package:cotti_client/pages/product/bloc/product_event.dart';
import 'package:cotti_client/pages/product/bloc/product_state.dart';
import 'package:cotti_client/pages/product/entity/product_spec_entity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rect_getter/rect_getter.dart';

class ProductSpec extends StatefulWidget {
  final GlobalKey<RectGetterState> listViewKey;
  final GlobalKey<RectGetterState> toolBarKey;
  final ScrollController listViewCtr;

  const ProductSpec(
      {Key? key, required this.listViewKey, required this.toolBarKey, required this.listViewCtr})
      : super(key: key);

  @override
  State<ProductSpec> createState() => _ProductSpecState();
}

class _ProductSpecState extends State<ProductSpec> {
  Map<String, GlobalKey<RectGetterState>> btnKeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      var toolBarRect = RectGetter.getRectFromKey(widget.toolBarKey);
      double scrollTop = calcListScroll(toolBarRect?.top ?? 0.0);
      if (scrollTop > 0.0) {
        widget.listViewCtr
            .animateTo(scrollTop, duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
    });
  }

  double calcListScroll(double viewHeight) {
    List<double> topCache = [];
    List<double> bottomCache = [];
    double scrollTop = -1.0;
    btnKeys.forEach((key, value) {
      if (scrollTop >= 0.0) {
        // 已经有结果了，无需继续循环判断
        return;
      }
      var rect = RectGetter.getRectFromKey(value);
      if (rect == null) {
        return;
      }
      double btnTop = rect.top;
      double btnBottom = rect.bottom;
      if (topCache.contains(btnTop) && bottomCache.contains(btnBottom)) {
        // 如果按钮在同一行，则无需判断
        return;
      }
      topCache.add(btnTop);
      bottomCache.add(btnBottom);

      if (viewHeight > btnBottom) {
        // 该按钮已经完全展示，继续判断是否有未展示的按钮
        return;
      }
      if (btnTop < viewHeight && viewHeight < btnBottom) {
        // 该按钮正好展示一部分，符合展示逻辑
        scrollTop = 0.0;
        return;
      }
      if (btnTop > viewHeight) {
        // 按钮没有展示，则滚动到按钮的一半
        scrollTop = btnTop - viewHeight + (btnBottom - btnTop) / 2.0;
      }
    });
    return scrollTop;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        bool showSuggest = state.productSpecData?.firstSkuFlag == 1 &&
            state.productSpecData!.skuCombinList!.length > 1 &&
            state.recommendType >= 0;
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 1.h,
                color: CottiColor.dividerGray,
                margin: EdgeInsets.only(bottom: 12.h, top: 5.h),
              ),
              if (showSuggest) _suggestSpec(state),
              _specItem(state)
            ],
          ),
        );
      },
    );
  }

  Widget _suggestSpec(ProductState state) {
    List<String> suggestText = ["已按您上次口味偏好自动选择", "已选择上次口味偏好", "选择上次口味偏好"];
    List<String> skus = state.productSpecData?.firstSku?.spuShowName?.split(r"/") ?? [];
    return Container(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                state.recommendType == 2 ? IconFont.icon_kongxin : IconFont.icon_shixin,
                size: 17.w,
                color: CottiColor.primeColor,
              ),
            ),
            TextSpan(
              text: "${suggestText[state.recommendType]}：",
              style: TextStyle(fontSize: 12.sp, color: CottiColor.textGray),
            ),
            TextSpan(
              children: List.generate(
                skus.length,
                (index) => TextSpan(
                  text: skus[index] + (skus.length - 1 == index ? '' : "/"),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      state.recommendType == 2 ? _setCommend() : null;
                    },
                ),
              ),
              style: state.recommendType == 2
                  ? TextStyle(
                      fontSize: 12.sp,
                      color: CottiColor.primeColor,
                      decoration: TextDecoration.underline,
                    )
                  : TextStyle(
                      fontSize: 12.sp,
                      color: CottiColor.textGray,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _setCommend() {
    ProductBloc productBloc = context.read<ProductBloc>();
    productBloc.add(ResetSpecEvent());
  }

  Widget _specItem(ProductState state) {
    List<ProductSpecSpecItems>? specItems = state.productSpecData?.specItems;
    ShopDetail? shopDetail = context.read<ShopMatchBloc>().state.currentShopDetail;
    int curTakeFoodMode = context.read<ShopMatchBloc>().state.curTakeFoodMode;
    int? shopMdCode = shopDetail?.shopMdCode;
    int takeFoodMode = curTakeFoodMode;
    List? businessTypes = shopDetail?.mealTakeModeCodes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        specItems?.length ?? 0,
        (index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12.h, top: index > 0 ? 16.h : 0.h),
              child: Text(
                "${specItems![index].specItemName}",
                textAlign: TextAlign.left,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.w,
              children: List.generate(
                specItems[index].specValueList?.length ?? 0,
                (idx) {
                  String btnStatus = 'normal'; // 未选中效果
                  String key =
                      "${(specItems[index].specItemNo)}-${(specItems[index].specValueList![idx].value)}";

                  if (state.sellingList?.contains(key) == false) {
                    btnStatus = 'disabled'; // 禁止选中效果
                  } else if (specItems[index].specValueList![idx].selected == true) {
                    btnStatus = 'selected'; // 选中效果
                  }
                  String btnText = (specItems[index].specValueList![idx].recommendFlag == 1)
                      ? "${(specItems[index].specValueList![idx].name)} (推荐)"
                      : "${(specItems[index].specValueList![idx].name)}";
                  String tagText = '';
                  if (state.noSaleList?.contains(key) == true && btnStatus != 'disabled') {
                    tagText = "停售";
                  }
                  if (state.saleOutList?.contains(key) == true && btnStatus != 'disabled') {
                    tagText = "售罄";
                  }
                  String keyName = "btn-$index-$idx";
                  btnKeys[keyName] = RectGetter.createGlobalKey();
                  return Container(
                    key: btnKeys[keyName],
                    child: _specBtn(() {
                      ProductBloc productBloc = context.read<ProductBloc>();
                      productBloc.add(
                        SelectSpecItemEvent(
                          index,
                          "${specItems[index].specValueList![idx].value}",
                          shopMdCode!,
                          takeFoodMode,
                          businessTypes,
                        ),
                      );
                    }, btnStatus, btnText, tagText),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _specBtn(callback, String status, String text, String tag) {
    const Color normalColor = Color(0xFFF5F6F7);
    const Color disableColor = Color(0xFFF9FAF9);
    Map<String, Map<String, Color>> colorMap = {
      "normal": {
        "bgColor": normalColor,
        "textColor": CottiColor.textBlack,
        "borderColor": normalColor,
      },
      "selected": {
        "bgColor": CottiColor.primeColor.withOpacity(0.05),
        "textColor": CottiColor.primeColor,
        "borderColor": CottiColor.primeColor,
      },
      "disabled": {
        "bgColor": disableColor,
        "textColor": const Color(0xFFD5D5D5),
        "borderColor": disableColor,
      },
    };
    return GestureDetector(
      onTap: callback,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            constraints: BoxConstraints(
              minWidth: 70.w,
            ),
            height: 28.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
                color: colorMap[status]!['bgColor'],
                border: Border.all(width: 1.h, color: colorMap[status]!['borderColor']!),
                borderRadius: BorderRadius.circular(3.r)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    //UI要求字体加粗不会导致背景宽度变化，所以先拿一个东西占位
                    Text(
                      text,
                      style: TextStyle(
                        color: Colors.transparent,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        color: colorMap[status]!['textColor']!,
                        fontSize: 12.sp,
                        fontWeight: status == 'selected' ? FontWeight.bold : FontWeight.normal,
                      ),
                      strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (tag.isNotEmpty)
            Positioned(
              top: -7.h,
              right: 0,
              height: 14.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
                color: status == 'normal' ? CottiColor.textHint : CottiColor.primeColor,
                child: Text(
                  tag,
                  style: TextStyle(fontSize: 9.sp, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
