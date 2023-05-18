import 'dart:math';

import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_confirm_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/order_coupon.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/bloc/order_voucher_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/widget/voucher_list_view.dart';
import 'package:cotti_client/widget/cotti_tabbar.dart';
import 'package:cotti_client/widget/my_underline_indicator.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class OrderVoucher extends StatefulWidget {
  final VoucherSkuModelEntity skuModelEntity;

  const OrderVoucher({Key? key,
    required this.skuModelEntity}) : super(key: key);

  @override
  _OrderVoucherState createState() {
    return _OrderVoucherState();
  }
}

class _OrderVoucherState extends State<OrderVoucher> with SingleTickerProviderStateMixin {
  final List<String> tabs = ["可用代金券", "不可用代金券"];

  late OrderVoucherBloc _bloc;
  late PageController _pageController;
  late OrderConfirmBloc _confirmBloc;
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _pageController = PageController();
    _confirmBloc = context.read<OrderConfirmBloc>();
    _bloc = context.read<OrderVoucherBloc>();
    logI("OrderVoucherBloc ovbloc = $_bloc");

    _bloc.add(VoucherTabChangeEvent(tabIndex: 0, context: context, skuModel: widget.skuModelEntity));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<OrderConfirmBloc, OrderConfirmState>(
        builder: (context, state) {
          logI("in BlocBuilder OrderConfirmBloc !!!");
          return BlocBuilder<OrderVoucherBloc, OrderVoucherState>(
            builder: (context, state) {
              logI("in BlocBuilder OrderVoucherBloc !!!");

              return ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: _buildContent(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<OrderVoucherBloc, OrderVoucherState>(
      builder: (context, state) {

        /*
        List<CashCouponEntity> temp = [];
        int count = state.voucherList.length;
        count = count > 5 ? 5 : count;
        for(int i = 0; i < count; i++){
          CashCouponEntity item = state.voucherList[i];
          temp.add(item);
        }
        state.voucherList = temp;
        */

        double height = 85.h;

        int itemCount = state.voucherList.length > 2 ? state.voucherList.length : 2;

        height = height + itemCount * (12.h + 75.h + 12.h);

        if(state.tabIndex == 0){
          height = height + 24.h + 26.h;
        }

        final MediaQueryData data = MediaQuery.of(context);
        double bottom = data.padding.bottom;

        height = height + bottom;

        double maxHeight = data.size.height - 88.h;

        height = height > maxHeight ? maxHeight : height;

        height = height < 482.h ? 482.h:height;

        return Container(
          decoration: const BoxDecoration(
            color: CottiColor.backgroundColor,
          ),
          child: SafeArea(
            bottom: false,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      top: 85.h,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _buildList(),
                    ),
                    Positioned(
                      top: 48.h,
                      left: 0,
                      right: 0,
                      child: _buildTab(),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: _buildTitle(),
                    ),
                    if (state.showLoading)
                      Positioned(
                        top: 85.h,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: _buildLoading(),
                      )
                    // Expanded(child: _buildList()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 48.h,
      alignment: Alignment.center,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.centerRight,
        textDirection: TextDirection.rtl,
        children: [
          Center(
            child: Text(
              "选择代金券",
              style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              pop();
            },
            child: UnconstrainedBox(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: SvgPicture.asset(
                  'assets/images/ic_back.svg',
                  width: 16.h,
                  height: 16.h,
                  color: const Color(0xFF111111),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          ),
          Positioned(
            right: 16.w,
            child: IconButton(
              icon: Icon(IconFont.icon_close, size: 20.sp, color: CottiColor.textGray),
              alignment: Alignment.centerRight,
              onPressed: () {
                logI("_bloc === $_bloc");
                Navigator.of(context).pop();
                },
          ),
          ),

        ],
      ),
    );
  }

  Widget _buildList() {
    return BlocBuilder<OrderVoucherBloc, OrderVoucherState>(
      builder: (context, state) {
        return PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: tabs.length,
          itemBuilder: (context, pageIndex) {
            return VoucherListView(
              type: pageIndex,
              skuModelEntity: widget.skuModelEntity,
            );
          },
        );
      },
    );
  }

  Widget _buildTab() {
    return BlocBuilder<OrderVoucherBloc, OrderVoucherState>(builder: (context, state) {
      return Container(
        width: double.infinity,
        // color: Colors.white,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(25, 70, 106, 0.06),
              offset: Offset(0, 2.h),
              blurRadius: 7.r,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: CottiTabbar(
                (index) => _changeTab(index),
            TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'DDP6',
              color: CottiColor.primeColor,
            ),
            TextStyle(
              fontSize: 14.sp,
              fontFamily: 'DDP4',
              color: const Color(0xFF5E5E5E),
            ),
            MyUnderlineTabIndicator(
              width: 62.w,
              borderSide: BorderSide(
                width: 2.h,
                color: CottiColor.primeColor,
              ),
            ),
            _tabController,
            List.generate(tabs.length, (index) =>
            "${tabs[index]}(${index == 0 ? state.voucherCountDto?.availableCount ?? 0 : state.voucherCountDto?.unAvailableCount ?? 0})"),
          ),
        ),
      );
    });
  }

  _buildLoading() {
    return Container(
      color: CottiColor.backgroundColor,
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
    );
  }

  _changeTab(int index) {
    // _bloc.add(assembleCouponListEvent(_confirmBloc.state.orderConfirmModelEntity, shopMdCode, index + 1, takeFoodMode));

    if(_bloc.state.tabIndex == index){
      _bloc.add(VoucherRefreshEvent(context: context, skuModel: widget.skuModelEntity));
      return;
    }

    _bloc.add(VoucherTabChangeEvent(tabIndex: index, context: context, skuModel: widget.skuModelEntity));

    Future.delayed(const Duration(milliseconds: 200), () {
      // _pageController.jumpToPage(index);
    });
  }

  pop() {
    logI("in pop !!!");

    Navigator.of(context).pop();

    if (_bloc.state.source == OrderVoucherSource.goodsList) {
      _bloc.add(ShowVoucherRootPopupEvent(
          context: context,));
    }
  }
}
