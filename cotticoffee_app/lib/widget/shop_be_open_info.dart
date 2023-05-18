import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';
import 'package:cotti_client/utils/distance_util.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/box_move_animation.dart';
import 'package:cotti_client/widget/horizontail_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/7 10:13
class ShopBeOpenInfo extends StatefulWidget {
  final Duration duration;
  final Function clickClose;
  final ValueNotifier<bool> animationChange;

  const ShopBeOpenInfo({
    Key? key,
    required this.duration,
    required this.clickClose,
    required this.animationChange,
  }) : super(key: key);

  @override
  State<ShopBeOpenInfo> createState() => _ShopBeOpenInfoState();
}

class _ShopBeOpenInfoState extends State<ShopBeOpenInfo> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.animationChange,
      builder: (BuildContext context, value, Widget? child) {
        return Stack(
          children: [
            if (value)
              GestureDetector(
                onTap: () => widget.clickClose(),
                child: Container(color: Colors.black.withOpacity(0.55)),
              ),
            Align(
              alignment: Alignment.bottomLeft,
              child: _buildToBeOpenWidget(),
            ),
          ],
        );
      },
    );
  }

  _buildToBeOpenWidget() {
    return BoxMoveAnimation(
      animationChange: widget.animationChange,
      duration: widget.duration,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: ScreenUtil().screenHeight * 0.8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F6F6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10.h, left: 14.w, right: 14.w),
          child: Column(
            children: [
              _buildTitle(),
              HorizontalDivider(
                dividerColor: const Color(0xFFEEEEEE),
                dividerMargin: EdgeInsets.only(top: 6.h, bottom: 11.h, left: 6.w, right: 6.w),
              ),
              _buildContent(),
              _buildBottomAd(),
            ],
          ),
        ),
      ),
    );
  }

  _buildTitle() {
    return GestureDetector(
      onTap: () => widget.clickClose(),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Text(
              context.read<ConfigBloc>().state.guidanceToBeOpened,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          SvgPicture.asset(
            "assets/images/menu/icon_close_shop_opened.svg",
            width: 22.w,
            height: 22.w,
          ),
        ],
      ),
    );
  }

  _buildContent() {
    ShopDetail? shopDetail = context.read<ShopMatchBloc>().state.currentShopDetail;
    List<String> shopOperateStrs = shopDetail?.shopOperateStr?.split("\n") ?? [];
    List<List<String>> shopOperateNew = shopOperateStrs.map((e) => e.split("#")).toList();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: Offset(0, 1.h),
            blurRadius: 3.r,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  shopDetail?.shopName ?? '',
                  style: TextStyle(
                    color: CottiColor.textBlack,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              if ((shopDetail?.distance ?? 0) > 0)
                Text(
                  "距您${DistanceUtil.convertDistance(shopDetail?.distance)}",
                  style: TextStyle(
                    color: CottiColor.textGray,
                    fontSize: 12.sp,
                  ),
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                    height: 1,
                  ),
                ),
            ],
          ),
          HorizontalDivider(
            dividerColor: const Color(0xFFEEEEEE),
            dividerMargin: EdgeInsets.only(top: 10.h, bottom: 7.w),
          ),
          _buildItem("门店地址", shopDetail?.address ?? ''),
          SizedBox(height: 10.h),
          _buildItem("开业日期", shopDetail?.planSetUpTimeStr ?? ''),
          SizedBox(height: 10.h),
          _buildTime("营业时间", shopOperateNew),
        ],
      ),
    );
  }

  _buildItem(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: CottiColor.textGray,
            fontSize: 12.sp,
            height: 1.35,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            content,
            style: TextStyle(
              color: CottiColor.textBlack,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  _buildBottomAd() {
    return Container(
      margin: EdgeInsets.only(top: 12.h, bottom: 18.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: Offset(0, 1.h),
            blurRadius: 3.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ABiteBanner(
        bannerParam: BannerParam('cotti-menu-openingSoon-layer'),
        resize: true,
        width: 347.w,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }

  _buildTime(String title, List<List<String>> shopOperateNew) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: CottiColor.textGray,
            fontSize: 12.sp,
          ),
          strutStyle: const StrutStyle(forceStrutHeight: true),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: Column(
            children: List.generate(
              shopOperateNew.length,
              (index) => Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(minWidth: 64.w),
                      child: Text(
                        shopOperateNew[index][0],
                        style: TextStyle(
                          color: CottiColor.textBlack,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        strutStyle: const StrutStyle(forceStrutHeight: true),
                      ),
                    ),
                    if (shopOperateNew[index].length > 1)
                      Expanded(
                        child: Text(
                          shopOperateNew[index][1].replaceAll(r",", r" "),
                          style: TextStyle(
                            color: CottiColor.textBlack,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          strutStyle: const StrutStyle(forceStrutHeight: true),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
