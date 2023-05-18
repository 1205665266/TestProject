import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/bloc/order_voucher_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/widget/radio_widget.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/widget/voucher_goods_item.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class VoucherGoodsPage extends StatefulWidget {
  final List<VoucherSkuModelEntity> goodsItems;

  const VoucherGoodsPage({Key? key, required this.goodsItems}) : super(key: key);

  @override
  _VoucherGoodsPageState createState() {
    return _VoucherGoodsPageState();
  }
}

class _VoucherGoodsPageState extends State<VoucherGoodsPage> {
  late OrderVoucherBloc _bloc;

  /// 用于显示的列表
  List<VoucherSkuModelEntity>? _showItems;

  final double horMargin = 12.h;

  bool resume = false;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<OrderVoucherBloc>();

    var map = {
      "num":widget.goodsItems.length,
    };

    SensorsAnalyticsFlutterPlugin.track(
        OrderSensorsConstant.confirmOrderVoucherSkuListView, map);

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<OrderVoucherBloc, OrderVoucherState>(
        builder: (context, state) {

          List<VoucherSkuModelEntity> showItems = [];
          for(VoucherSkuModelEntity i in state.showItems??[]){
            logI("VoucherSkuModelEntity i == no:${i.voucherNo}, name:${i.voucherName}");
            if(i.show){
              showItems.add(i);
            }
          }

          _showItems = showItems;
          /// 计算高度，
          int count = showItems.length;

          /// 缺省页面按照两个item的高度计算
          if(count == 0){
            count = 2;
          }

          double itemHeight = 24.w + 70.w + 8.h + 18.h;

          final MediaQueryData data = MediaQuery.of(context);
          double bottom = data.padding.bottom;

          double height = 48.h +
              40.h +
              16.h +
              14.h +
              24.h +
              count * itemHeight +
              (count - 1).h +
              bottom +
              12.h;
          double maxHeight = data.size.height - 88.h;

          height = height > maxHeight ? maxHeight : height;

          return BlocBuilder<OrderConfirmBloc, OrderConfirmState>(
            builder: (cContext, cState) {
              return SizedBox(
                height: height,
                width: double.infinity,
                child: Column(
                  children: [
                    _buildTitle(),
                    SizedBox(
                      height: height-48.h,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                Visibility(
                                  visible: _showItems?.isNotEmpty??false,
                                  child: _buildGoodsList(),
                                  replacement: _emptyWidget(),
                                ),
                                SafeArea(
                                  child: _buildBottomBtn(),
                                ),
                              ],
                            ),
                          ),
                          if(state.showLoading)
                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: _buildLoading(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
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
            right: 16.w,
            child: IconButton(
              icon: Icon(IconFont.icon_close, size: 20.sp, color: CottiColor.textGray),
              alignment: Alignment.centerRight,
              onPressed: () {
                logI("_bloc === $_bloc");
                _bloc.add(VoucherSkuListCloseEvent(context: context));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {

    // ConfirmCalEntity? confirmCalEntity = _bloc.state.confirmCalEntity;

    int voucherNum = 0;

    int voucherVal = 0;

    /// 计算当前列表使用代金券的数量;
    for(VoucherSkuModelEntity sku in _bloc.state.showItems??[]){
      if(sku.show && (sku.voucherDiscountMoney??0)>0){
        voucherNum += 1;
        /// *100 转int计算防止double精度丢失；
        voucherVal = voucherVal + ((sku.voucherDiscountMoney??0)*100).toInt();
      }
    }

    bool hasVoucher = voucherNum != 0;

    bool noUseVoucher = _bloc.state.chooseNotUseCashCoupon??false;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horMargin,
        vertical: 12.h,
      ),
      height: 14.h,
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Visibility(
              visible: hasVoucher,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "使用",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: CottiColor.textGray,
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                    WidgetSpan(
                      child: SizedBox(
                        width: 4.w,
                      ),
                    ),
                    TextSpan(
                      text: "$voucherNum",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: CottiColor.primeColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "DDP5",
                        height: 1,
                      ),
                    ),
                    WidgetSpan(
                      child: SizedBox(
                        width: 4.w,
                      ),
                    ),
                    TextSpan(
                      text: "张代金券，共优惠",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: CottiColor.textGray,
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                    WidgetSpan(
                      child: SizedBox(
                        width: 0.w,
                      ),
                    ),
                    TextSpan(
                      text: "￥${voucherVal/100}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: CottiColor.primeColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "DDP5",
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              replacement: const SizedBox(),
            ),
          ),
          InkWell(
            onTap: () {
              logI("in no vo action ");
              _bloc.add(OrderVoucherNoUseEvent(context: context));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "不使用代金券",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: CottiColor.textGray,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 4.w,
                  ),
                  child:RadioWidget(checked: noUseVoucher,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoodsList() {

    int itemCount = _showItems?.length??0;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horMargin),
        color: CottiColor.backgroundColor,
        child: ListView.separated(
          padding: EdgeInsets.only(bottom: 12.h),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildTopBar();
            } else if(index == 1 && index == itemCount){
              VoucherSkuModelEntity sku = _showItems![index-1];
              return ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: VoucherGoodsItem(
                  goodsItem: _showItems![index-1],
                ),
              );
            }else if (index == 1) {
              VoucherSkuModelEntity sku = _showItems![index-1];
              return ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.r),
                  topLeft: Radius.circular(4.r),
                ),
                child: VoucherGoodsItem(
                  goodsItem: _showItems![index-1],
                ),
              );
            } else if (index == itemCount) {
              return ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4.r),
                  bottomRight: Radius.circular(4.r),
                ),
                child: VoucherGoodsItem(
                  goodsItem: _showItems![index-1],
                ),
              );
            } else {
              VoucherSkuModelEntity sku = _showItems![index-1];
              return VoucherGoodsItem(
                  goodsItem: _showItems![index-1],
              );
            }
          },
          separatorBuilder: (BuildContext context, int index) {
            if(index == 0){
              return const SizedBox();
            }
            return Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              height: 1.h,
              child: Container(
                color: CottiColor.backgroundColor,
              ),
            );
          },
          itemCount: itemCount + 1,
        ),
      ),
    );
  }

  Widget _buildBottomBtn() {
    if(_showItems?.isEmpty??true){
      return const SizedBox();
    }
    bool edit = _bloc.state.edit;
    return edit ? _buildBottomWidget() : _buildBottomSaveWidget();
  }

  /// 底部双按钮
  Widget _buildBottomWidget() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 16.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              /// 恢复
              logI("恢复 事件");
              _bloc.add(OrderVoucherResumeEvent());
            },
            child: Container(
              height: 40.h,
              width: 120.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: CottiColor.primeColor,
                  width: 1,
                ),
              ),
              child: Text(
                '使用推荐优惠',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: CottiColor.primeColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                /// 确定
                logI("确定 事件");
                saveAction();
              },
              child: Container(
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CottiColor.primeColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '确定',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 底部保存按钮
  Widget _buildBottomSaveWidget() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 16.w,
      ),
      child: GestureDetector(
        onTap: () {
          /// 确定
          logI("确定 事件");
          saveAction();
        },
        child: Container(
          height: 40.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: CottiColor.primeColor,
              width: 1.sp,
            ),
          ),
          child: Text(
            '确定',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: CottiColor.primeColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyWidget() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/mine/ic_coupon_none.png",
            width: 141.w,
            height: 121.h,
          ),
          Text(
            "当前订单餐品暂无可用代金券",
            style: TextStyle(fontSize: 14.sp, color: CottiColor.textGray),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      color: Colors.transparent,
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

  /// 确定按钮点击事件，
  saveAction() {
    _bloc.add(OrderVoucherSaveEvent(context: context));
  }
}
