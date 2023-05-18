import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';
import 'package:cotti_client/pages/product/bloc/product_bloc.dart';
import 'package:cotti_client/pages/product/bloc/product_state.dart';
import 'package:cotti_client/sensors/product_sensors_constant.dart';
import 'package:cotti_client/utils/share_util.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class ProductHeader extends StatefulWidget {
  final ValueNotifier<double> opacity;

  const ProductHeader({Key? key, required this.opacity}) : super(key: key);

  @override
  State<ProductHeader> createState() => _ProductHeaderState();
}

class _ProductHeaderState extends State<ProductHeader> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.opacity,
      builder: (BuildContext context, value, Widget? child) {
        return BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            return Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(value > 0.98 ? value : 0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(value > 0.98 ? 0.08 : 0),
                      offset: const Offset(0.0, 1.0), //阴影y轴偏移量
                      blurRadius: 4, //阴影模糊程度
                      spreadRadius: 0 //阴影扩散程度
                      ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 15.w, left: 15.w, top: 16.w, bottom: 12.w),
                      child: Text(
                        value > 0.98 ? "${state.productDetailData?.title}" : '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: CottiColor.textBlack,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (state.productDetailData?.shareSwitch == true)
                        GestureDetector(
                          onTap: onWechatShare,
                          child: Container(
                            padding: EdgeInsets.only(top: 12.h, right: 12.w, bottom: 12.h),
                            child: SvgPicture.asset(
                              'assets/images/product/icon_header_wechat.svg',
                              width: 28.w,
                              height: 28.h,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: onPopupClose,
                        child: Container(
                          padding: EdgeInsets.only(top: 12.h, right: 12.w, bottom: 12.h),
                          child: SvgPicture.asset(
                            'assets/images/product/icon_header_close.svg',
                            width: 28.w,
                            height: 28.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  onWechatShare() {
    SensorsAnalyticsFlutterPlugin.track(ProductSensorsConstant.productDetailShareClick, {});
    ProductState productState = context.read<ProductBloc>().state;

    int? memberId;

    if (Constant.hasLogin) {
      UserModel? userModel = GlobalBlocs.get<UserBloc>(UserBloc.blocName).state.userModel;
      memberId = userModel?.memberId;
    }

    logW(
        'productState.productDetailData?.appletPageimgUrl === ${productState.productDetailData?.appletPageimgUrl}');
    logW(
        'productState.productDetailData?.appletLitimgUrl === ${productState.productDetailData?.appletLitimgUrl}');

    ShopDetail? shopDetail = context.read<ShopMatchBloc>().state.currentShopDetail;
    int? shopMdCode = shopDetail?.shopMdCode;
    String? shareTitle = productState.productDetailData?.firstSku?.specialPriceActivity != null
        ? productState.productDetailData?.activityShareTitle
        : productState.productDetailData?.appletShareTitle;

    ShareUtil.shareWxMiniProgram(
      productState.productDetailData?.appletShareUrl ?? "https://m.cotticoffee.com/#/download",
      "${productState.productDetailData?.appletPageimgUrl}?itemNo=${productState.productDetailData?.itemNo}&activityNo=${ShareUtil.defaultFissionActivity}&memberId=${memberId ?? ''}&shopMdCode=$shopMdCode",
      title: shareTitle ?? "",
      thumbnail: productState.productDetailData?.appletLitimgUrl,
    );
  }

  onPopupClose() {
    SensorsAnalyticsFlutterPlugin.track(ProductSensorsConstant.productDetailBackClick, {});
    Navigator.pop(context);
  }
}
