

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/service/pay/abite_pay.dart';
import 'package:cotti_client/service/pay/model/pay_type_model.dart';
import 'package:cotti_client/service/pay/pay_list_view.dart';
import 'package:cotti_client/widget/common_box.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPayType extends StatefulWidget {
  const OrderPayType({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderPayTypeState();

}

class _OrderPayTypeState extends State<OrderPayType> {


  @override
  void initState() {
    super.initState();

    ShopMatchBloc shopMatchBloc = context.read<ShopMatchBloc>();
    int curTakeFoodMode = shopMatchBloc.state.curTakeFoodMode;

    int? shopMdCode = context.read<ShopMatchBloc>().state.shopMdCode;

    int takeFoodMode = context.read<OrderConfirmBloc>().state.currentTakeTypeMode;
    // 如果当前是外卖
    if (curTakeFoodMode == Constant.takeOutModeCode) {
      takeFoodMode = curTakeFoodMode;
    }

    context.read<OrderConfirmBloc>().add(OrderConfirmGetPayFormListEvent(shopMdCode, takeFoodMode));

  }
  @override
  Widget build(BuildContext context) {

    return BlocListener<ShopMatchBloc, ShopMatchState>(
      listenWhen: (previous, current) {
        return previous.shopMdCode != current.shopMdCode || previous.currentTime != current.currentTime || previous.curTakeFoodMode != current.curTakeFoodMode;
      },
      listener: (context, state) {
        int curTakeFoodMode = state.curTakeFoodMode;
        int takeFoodMode = context.read<OrderConfirmBloc>().state.currentTakeTypeMode;
        // 如果当前是外卖
        if (curTakeFoodMode == Constant.takeOutModeCode) {
          takeFoodMode = curTakeFoodMode;
        }
        context.read<OrderConfirmBloc>().add(OrderConfirmGetPayFormListEvent(state.shopMdCode, takeFoodMode));
      },
      child: _buildContent(context),
    );

  }

  void showSelectPayTypeSheet(List<PayTypeModel>? payTypeList, PayTypeModel? currentPayType, Function(PayTypeModel)? callback) {

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 48.h,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      textDirection: TextDirection.rtl,
                      children: [
                        Center(
                          child: Text(
                            "支付方式",
                            style: TextStyle(
                                color: CottiColor.textBlack,
                                fontSize: 16.sp
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20.w),
                          child: IconButton(
                            icon:
                            Icon(IconFont.icon_close, size: 20.sp, color: CottiColor.textGray),
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  PayListWidget(payTypeList: payTypeList, currentPayType: currentPayType, itemSeparator: Container(),callBack: callback)
                ],
              ),
            ),
          );
        }
    );

  }

  Widget _buildContent(BuildContext context) {

    return BlocConsumer<OrderConfirmBloc, OrderConfirmState>(
        listenWhen: (previous, current) {
          return previous.currentTakeTypeMode != current.currentTakeTypeMode;
        },
        listener: (context, state) {
          int? shopMdCode = context.read<ShopMatchBloc>().state.shopMdCode;
          context.read<OrderConfirmBloc>().add(OrderConfirmGetPayFormListEvent(shopMdCode, state.currentTakeTypeMode));
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              if((state.payTypeList?.length??0) <= 1) {
                return;
              }
              showSelectPayTypeSheet(state.payTypeList, state.currentPayTypeModel, (payTypeModel) {
                NavigatorUtils.pop(context);
                context.read<OrderConfirmBloc>().add(OrderConfirmPayTypeEvent(payTypeModel: payTypeModel));
              });
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: CommonBox(
                  margin: EdgeInsets.zero,
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '支付方式',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: CottiColor.textBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Visibility(
                              visible: state.currentPayTypeModel?.showIcon != null && (state.currentPayTypeModel?.showIcon?.isNotEmpty?? false),
                              child: CottiImageWidget(
                                state.currentPayTypeModel?.showIcon ?? '',
                                imgW: 18.w,
                                imgH: 18.h,
                                fit: BoxFit.fill,
                              ),
                              replacement: SvgPicture.asset(
                                'assets/images/order/comment/icon_default_pay.svg',
                                height: 14.w,
                                width: 14.h,
                                fit: BoxFit.fill,
                              ),
                            ),

                            SizedBox(width: 8.w),
                            Text(
                              state.currentPayTypeModel?.showName ?? '',
                              style: TextStyle(
                                color: CottiColor.textGray,
                                fontSize: 14.sp,
                              ),
                            ),
                            Visibility(
                              visible: (state.payTypeList?.length?? 0) > 1,
                              child: SvgPicture.asset(
                                "assets/images/icon_more.svg",
                                width: 14.w,
                                height: 14.h,
                                color: CottiColor.textGray,
                              )
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

}