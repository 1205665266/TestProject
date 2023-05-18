import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/cash_coupon_list/view/action_enum.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/cash_coupon_list/view/cash_coupon_item.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/bloc/order_voucher_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/entity/voucher_sku_model_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/voucher/widget/radio_widget.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/utils/height_layout_widget.dart';
import 'package:cotti_client/widget/cotti_tooltip.dart';
import 'package:cotti_client/widget/custom_smart_footer.dart';
import 'package:cotti_client/widget/custom_smart_header.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class VoucherListView extends StatefulWidget {
  final int type;
  final VoucherSkuModelEntity skuModelEntity;


  const VoucherListView({Key? key, required this.type, required this.skuModelEntity})
      : super(key: key);

  @override
  _VoucherListViewState createState() {
    return _VoucherListViewState();
  }
}

class _VoucherListViewState extends State<VoucherListView> {
  late RefreshController _refreshController;
  late OrderVoucherBloc _bloc;
  late OrderConfirmBloc _orderConfirmBloc;

  late ShopMatchBloc _shopMatchBloc;

  final ValueNotifier<bool> showControl = ValueNotifier(false);

  int? shopMdCode;

  bool canUseVoucher = true;

  @override
  void initState() {
    super.initState();

    _refreshController = RefreshController();
    _bloc = BlocProvider.of<OrderVoucherBloc>(context);
    _orderConfirmBloc = BlocProvider.of<OrderConfirmBloc>(context);

    shopMdCode = _orderConfirmBloc.state.orderConfirmModelEntity?.shopMdCode ??
        context.read<ShopMatchBloc>().state.shopMdCode;
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<OrderVoucherBloc, OrderVoucherState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.noMore) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
        if (state.refreshStatus == RefreshStatus.completed) {
          _refreshController.refreshCompleted();
        }
      },
      builder: (context, state) {
        if(state.voucherList.isNotEmpty){
          /// 优惠券优惠金额大于0 则不能使用代金券；
          canUseVoucher = (widget.skuModelEntity.couponDiscountMoney??0) == 0;

        }

        return SmartRefresher(
          enablePullUp: true,
          header: const CustomSmartHeader(),
          footer: CustomSmartFooter(),
          controller: _refreshController,
          onLoading: () {
            _bloc.add(VoucherLoadMoreEvent(context: context, skuModel: widget.skuModelEntity));
          },
          onRefresh: () {
            _bloc.add(VoucherRefreshEvent(context: context, skuModel: widget.skuModelEntity));
          },
          child: Visibility(
            // visible: false,
            visible: state.voucherList.isEmpty && state.loadStatus != LoadStatus.loading,
            child: _buildEmptyView(),
            replacement: _buildListView(),
          ),
        );
      },
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 73.h),
        child: Column(
          children: [
            Image.asset(
              "assets/images/mine/ic_coupon_none.png",
              width: 141.w,
              height: 121.h,
            ),
            Text(
              "暂时没有代金券",
              style: TextStyle(fontSize: 14.sp, color: CottiColor.textGray),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return BlocBuilder<OrderVoucherBloc, OrderVoucherState>(builder: (context, state) {

      int itemCount = state.voucherList.length;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.tabIndex == 0 && state.voucherList.isNotEmpty)
            _buildTopWidget(),
          if (state.tabIndex == 1)
            SizedBox(
              height: 9.h,
            ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemBuilder: (BuildContext context, int index) {
              CashCouponEntity voucher = _bloc.state.voucherList[index];

              ActionEnum actionEnum = ActionEnum.none;

              if (state.tabIndex == 0) {
                actionEnum = ActionEnum.notSelected;
                if ((widget.skuModelEntity.voucherNo?.isNotEmpty ?? false) &&
                    voucher.couponNo == widget.skuModelEntity.voucherNo) {
                  actionEnum = ActionEnum.selected;
                } else if ((widget.skuModelEntity.couponDiscountMoney ?? 0) > 0) {
                  actionEnum = ActionEnum.replaceWith;
                }
              }

              return CashCouponItem(
                available: state.tabIndex == 0,
                isEmploy: (voucher.occupied??0) == 1 && actionEnum != ActionEnum.selected,
                actionEnum: actionEnum,
                unavailableDes: voucher.couponRestrict?.isNotEmpty??false?voucher.couponRestrict:null,
                unavailableTextColor: voucher.couponRestrict?.isNotEmpty??false?const Color(0xffC67F06):null,
                actionCallBack: () {
                  logI("in actionCallBack action !!");

                  if(actionEnum == ActionEnum.replaceWith){
                    var map = {
                      "skuNo":widget.skuModelEntity.skuNo,
                      "skuShowName":widget.skuModelEntity.skuShowName,
                      "voucherName":voucher.couponName,
                      "voucherNo":voucher.couponNo,
                      "value":voucher.strValue,
                    };

                    SensorsAnalyticsFlutterPlugin.track(
                        OrderSensorsConstant.confirmOrderVoucherReplaceClick, map);
                  }

                  _bloc.add(OrderVoucherChangeEvent(context: context, goodsItem: widget.skuModelEntity, voucherModel: voucher));
                },
                cashCouponEntity: voucher,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 12.h,
              );
            },
            itemCount: itemCount,
          ),
        ],
      );
    });
  }

  Widget _buildTopWidget() {
    if (canUseVoucher) {
      bool hasVoucher = (widget.skuModelEntity.voucherDiscountMoney??0) > 0;
      String voucherName = widget.skuModelEntity.voucherName??"";

      String voucherVal = "${widget.skuModelEntity.voucherDiscountMoney??0}";

      return Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 28.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Visibility(
                visible: hasVoucher,
                child:
                Wrap(
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "使用",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: CottiColor.textGray,
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                      strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      constraints: BoxConstraints(
                        maxWidth: 190.w,
                      ),
                      child: Text(
                        voucherName,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: CottiColor.primeColor,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          height: 1,
                        ),
                        strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,),
                      ),
                    ),
                    Text(
                      "优惠",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: CottiColor.textGray,
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                      strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Text(
                        "￥",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: CottiColor.primeColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: "DDP5",
                          letterSpacing: -5,
                          height: 1,
                        ),
                        strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,),
                      ),
                    ),
                    Text(
                      voucherVal,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: CottiColor.primeColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "DDP5",
                        height: 1,
                      ),
                      strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,),
                    ),
                  ],
                ),
                /*
                Text.rich(
                  TextSpan(
                      children: [
                        WidgetSpan(
                          child:Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "使用",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: CottiColor.textGray,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                WidgetSpan(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                                    constraints: BoxConstraints(
                                      maxWidth: 190.w,
                                    ),
                                    child: Text(
                                      voucherName,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: CottiColor.primeColor,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            maxLines: 1,
                          ),
                        ),
                        WidgetSpan(
                          child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: Text(
                                "优惠",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: CottiColor.textGray,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: "￥",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: CottiColor.primeColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "DDP5",
                                letterSpacing: -5,
                              ),
                            ),
                            TextSpan(
                              text: voucherVal,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: CottiColor.primeColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "DDP5",
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                      ),
                        ),
                      ],
                  ),
                ),
                */
                replacement: const SizedBox(),
              ),
            ),
            GestureDetector(
              onTap: () {

                var map = {
                  "skuNo":widget.skuModelEntity.skuNo,
                  "skuShowName":widget.skuModelEntity.skuShowName,
                  "availableCount":_bloc.state.voucherCountDto?.availableCount,
                };

                SensorsAnalyticsFlutterPlugin.track(
                    OrderSensorsConstant.confirmOrderVoucherNotUseClick, map);

                _bloc.add(OrderVoucherNoUseEvent(context: context,skuModelEntity: widget.skuModelEntity));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Text(
                      "不使用代金券",
                      style: TextStyle(fontSize: 13.sp, color: CottiColor.textGray),
                    ),
                  ),
                  RadioWidget(
                    checked: widget.skuModelEntity.chooseNotUseCashCoupon ??
                        false,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      String tip = "「${widget.skuModelEntity.title}」已使用「${_bloc.state.usedCouponName}」优惠券，共优惠￥${widget.skuModelEntity.couponDiscountMoney??0}";
      return Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 28.w),
        child: Row(
          children: [
            Text(
              "不可与优惠券叠加使用",
              style: TextStyle(
                fontSize: 13.sp,
                color: CottiColor.textGray,
              ),
            ),
            GestureDetector(
              onTap: () {
                showControl.value = true;
              },
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                height: 18.w,
                width: 16.w,
                child: CottiTooltip(
                  child: Icon(
                    IconFont.icon_tanhao,
                    size: 10.w,
                    color: CottiColor.textGray,
                  ),
                  tip: tip,
                  showControl: showControl,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
