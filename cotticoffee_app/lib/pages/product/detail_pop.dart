import 'dart:async';

import 'package:cotti_client/global/bloc/dialog_show_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';
import 'package:cotti_client/pages/product/bloc/product_bloc.dart';
import 'package:cotti_client/pages/product/bloc/product_event.dart';
import 'package:cotti_client/pages/product/bloc/product_state.dart';
import 'package:cotti_client/pages/product/view/product_content.dart';
import 'package:cotti_client/pages/product/view/product_header.dart';
import 'package:cotti_client/pages/product/view/product_spec.dart';
import 'package:cotti_client/pages/product/view/product_swiper.dart';
import 'package:cotti_client/pages/product/view/product_toolbar.dart';
import 'package:cotti_client/sensors/product_sensors_constant.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class ProductDetailPopup extends StatefulWidget {
  static const String popName = "ProductDetailPopup";
  final String itemNo;
  final int edit;
  final String sku;
  final int skuBuyNum;
  final double totalHeight;

  // 有sku、edit=1，是购物车编辑
  // 有sku，无edit或者不等于1，是最近购买
  // 无sku，正常进入（不含判断分享逻辑）
  const ProductDetailPopup({
    Key? key,
    required this.itemNo,
    required this.edit,
    required this.sku,
    required this.skuBuyNum,
    required this.totalHeight,
  }) : super(key: key);

  @override
  State<ProductDetailPopup> createState() => _ProductDetailPopupState();

  static show(context, String itemNo, {int? edit, String? sku, int? skuBuyNum}) {
    SensorsAnalyticsFlutterPlugin.track(ProductSensorsConstant.productDetailView, {});
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setModalBottomSheetState) {
            double totalHeight = MediaQuery.of(context).size.height * 0.94;
            return ProductDetailPopup(
              itemNo: itemNo,
              edit: edit ?? 0,
              sku: sku ?? '',
              skuBuyNum: skuBuyNum ?? 1,
              totalHeight: totalHeight,
            );
          },
        );
      },
    );
  }
}

class _ProductDetailPopupState extends State<ProductDetailPopup> {
  final ProductBloc _bloc = ProductBloc();
  late DialogShowBloc _dialogShowBloc;
  final ValueNotifier<double> opacity = ValueNotifier(0.0);
  late final GlobalKey<RectGetterState> _listViewKey = RectGetter.createGlobalKey();
  late final GlobalKey<RectGetterState> _toolBarKey = RectGetter.createGlobalKey();
  final StreamController<double> _streamController = StreamController<double>.broadcast();
  double _pointerDy = 0;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _updateProductInfo();
    _bloc.add(InitBuyNumberEvent(widget.skuBuyNum));
    _dialogShowBloc = context.read<DialogShowBloc>();
    _dialogShowBloc.add(AddDialogNameEvent(ProductDetailPopup.popName));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: StreamBuilder<double>(
        stream: _streamController.stream,
        initialData: widget.totalHeight,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          double currentHeight = snapshot.data ?? widget.totalHeight;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 30),
            height: currentHeight,
            child: _buildContent(currentHeight),
          );
        },
      ),
    );
  }

  _updateProductInfo() {
    ShopDetail? shopDetail = context.read<ShopMatchBloc>().state.currentShopDetail;
    int curTakeFoodMode = context.read<ShopMatchBloc>().state.curTakeFoodMode;
    int? shopMdCode = shopDetail?.shopMdCode;
    int takeFoodMode = curTakeFoodMode;
    List? businessTypes = shopDetail?.mealTakeModeCodes;
    _bloc.add(QueryProductInfoEvent(widget.itemNo, shopMdCode!, takeFoodMode, businessTypes!,
        defaultSkuCode: widget.sku == '' ? null : widget.sku));
  }

  Widget _buildContent(double currentHeight) {
    return BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
        child: Listener(
          onPointerDown: (PointerDownEvent e) {
            _pointerDy = e.position.dy + _scrollController.offset;
          },
          onPointerMove: (PointerMoveEvent e) {
            if (_scrollController.offset != 0) {
              return;
            }
            double distance = e.position.dy - _pointerDy;
            if (distance.abs() > 0) {
              double _currentHeight = widget.totalHeight - distance;
              if (_currentHeight > widget.totalHeight) {
                return;
              }
              _streamController.sink.add(_currentHeight);
            }
          },
          onPointerUp: (PointerUpEvent e) {
            if (currentHeight < widget.totalHeight * 0.8) {
              Navigator.pop(context);
            } else {
              if (widget.totalHeight != currentHeight) {
                _streamController.sink.add(widget.totalHeight);
              }
            }
          },
          child: CustomPageWidget(
            showAppBar: false,
            pageBackgroundColor: Colors.white,
            showLoading: !(state.productSpecData != null && state.productDetailData != null),
            extendBodyBehindAppBar: true,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  transform: Matrix4.translationValues(0, -0.5.h, 0),
                  child: NotificationListener(
                    onNotification: (notification) {
                      const double transparentThreshold = 320.0;
                      double scrollTop = _scrollController.offset;
                      opacity.value =
                          (scrollTop < transparentThreshold) ? scrollTop / transparentThreshold : 1;
                      return true;
                    },
                    child: ListView(
                      key: _listViewKey,
                      controller: _scrollController,
                      padding: EdgeInsets.only(bottom: 120.h),
                      shrinkWrap: false,
                      physics: currentHeight != widget.totalHeight
                          ? const NeverScrollableScrollPhysics()
                          : const ClampingScrollPhysics(),
                      // 沿竖直方向上布局
                      scrollDirection: Axis.vertical,
                      children: [
                        const ProductSwiper(),
                        _buildTitle(),
                        if (state.productSpecData?.specItems != null &&
                            state.productSpecData!.specItems!.isNotEmpty)
                          ProductSpec(
                              listViewKey: _listViewKey,
                              toolBarKey: _toolBarKey,
                              listViewCtr: _scrollController),
                        const ProductContent()
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    transform: Matrix4.translationValues(0, -0.5.h, 0),
                    child: ProductHeader(opacity: opacity),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ProductToolbar(
                      key: _toolBarKey,
                      edit: widget.edit,
                      sku: widget.sku,
                      skuBuyNum: widget.skuBuyNum,
                      refresh: () {
                        _updateProductInfo();
                      }),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTitle() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(right: 15.w, left: 15.w, top: 16.h, bottom: 12.h),
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${_bloc.state.productDetailData?.title}",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
          ),
          if (_bloc.state.productDetailData?.sellPoint != null)
            SizedBox(
              height: 6.h,
            ),
          if (_bloc.state.productDetailData?.sellPoint != null)
            Text(
              "${_bloc.state.productDetailData?.sellPoint}",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 13.sp, height: 1.4),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dialogShowBloc.add(RemoveDialogNameEvent(ProductDetailPopup.popName));
    _streamController.close();
    super.dispose();
  }
}
