import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/cash_coupon_template/bloc/cash_coupon_template_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_template_entity.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/entity/cash_coupon_template_sub_entity.dart';
import 'package:cotti_client/utils/scheme_dispatcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'cash_coupon_template_sub_item.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/8 11:23
class CashCouponTemplateItem extends StatefulWidget {
  final VoucherTemplateInfo voucherTemplateInfo;

  const CashCouponTemplateItem(this.voucherTemplateInfo, {Key? key}) : super(key: key);

  @override
  State<CashCouponTemplateItem> createState() => _CashCouponTemplateItemState();
}

class _CashCouponTemplateItemState extends State<CashCouponTemplateItem> {
  final ValueNotifier<bool> _valueNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  _buildContent() {
    String key = "${widget.voucherTemplateInfo.templateTypeNo}${widget.voucherTemplateInfo.value}";
    Map map = context.read<CashCouponTemplateBloc>().state.cashCouponTemplateSubMap;
    bool isContains = map.containsKey(key);
    if (isContains) {
      CashCouponTemplateSubEntity cashCouponTemplateSubEntity = map[key];
      return StickyHeader(
        header: Container(
          padding: EdgeInsets.only(top: 12.h),
          color: CottiColor.backgroundColor,
          child: ValueListenableBuilder<bool>(
            valueListenable: _valueNotifier,
            builder: (BuildContext context, value, Widget? child) {
              return ClipRRect(
                borderRadius: value
                    ? BorderRadius.circular(4.r)
                    : BorderRadius.only(
                        topLeft: Radius.circular(4.r),
                        topRight: Radius.circular(4.r),
                      ),
                child: Container(
                  color: Colors.white,
                  child: _buildCouponInfo(isContains),
                ),
              );
            },
          ),
        ),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4.r),
              bottomRight: Radius.circular(4.r),
            ),
          ),
          child: _buildSubItemList(cashCouponTemplateSubEntity),
        ),
        callback: (double stuckAmount) {
          Future.delayed(const Duration(milliseconds: 100), () {
            _valueNotifier.value = stuckAmount == -1;
          });
        },
      );
    } else {
      return StickyHeader(
        header: Container(height: 12.h),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: Container(
            color: Colors.white,
            child: _buildCouponInfo(isContains),
          ),
        ),
      );
    }
  }

  _buildCouponInfo(bool isContains) {
    return GestureDetector(
      onTap: () {
        context.read<CashCouponTemplateBloc>().add(CashCouponSubTemplateEvent(
              "${widget.voucherTemplateInfo.templateTypeNo}",
              "${widget.voucherTemplateInfo.templateTypeName}",
              "${widget.voucherTemplateInfo.value}",
            ));
      },
      child: Container(
        height: 73.h,
        decoration: BoxDecoration(
          image: (widget.voucherTemplateInfo.pictureUrl ?? '').isEmpty
              ? null
              : DecorationImage(
                  image: CachedNetworkImageProvider(widget.voucherTemplateInfo.pictureUrl!),
                  fit: BoxFit.fill,
                ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _buildCouponCash(isContains),
              Expanded(child: _buildInfo()),
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  _buildCouponCash(bool isContains) {
    return SizedBox(
      width: 75.h,
      child: Column(
        children: [
          FittedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Text(
                    '¥',
                    style: TextStyle(
                      color: const Color(0xFFED4E18),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    strutStyle: const StrutStyle(
                      forceStrutHeight: true,
                      height: 1,
                    ),
                  ),
                ),
                SizedBox(width: 1.w),
                Flexible(
                  child: Text(
                    '${widget.voucherTemplateInfo.strValue}',
                    maxLines: 1,
                    style: TextStyle(
                      color: const Color(0xFFED4E18),
                      fontSize: 30.sp,
                      fontFamily: 'DDP6',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          FittedBox(
            child: Container(
              height: 18.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8F9),
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "剩",
                    style: TextStyle(
                      color: CottiColor.textBlack,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      "${widget.voucherTemplateInfo.nums ?? ''}",
                      style: TextStyle(
                        color: CottiColor.textBlack,
                        fontSize: 12.sp,
                        fontFamily: "DDP6",
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "张",
                    style: TextStyle(
                      color: CottiColor.textBlack,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Transform.rotate(
                    angle: isContains ? 0 : pi,
                    child: SvgPicture.asset(
                      "assets/images/mine/icon_coupon_drop_down.svg",
                      width: 11.w,
                      height: 11.h,
                      color: CottiColor.textBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 11.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${widget.voucherTemplateInfo.templateTypeName}",
            style: TextStyle(
              color: CottiColor.textBlack,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                "最近到期：",
                style: TextStyle(
                  color: CottiColor.textBlack,
                  fontSize: 10.sp,
                ),
              ),
              Text(
                widget.voucherTemplateInfo.recentlyExpiredDateDesc ?? '',
                style: TextStyle(
                  color: (widget.voucherTemplateInfo.specialDisplay ?? false)
                      ? CottiColor.primeColor
                      : CottiColor.textBlack,
                  fontSize: 10.sp,
                  fontWeight: (widget.voucherTemplateInfo.specialDisplay ?? false)
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildActionButton() {
    return GestureDetector(
      onTap: () => SchemeDispatcher.dispatchPath(context, "cottitab://coffee?tabIndex=1"),
      child: Container(
        height: 24.h,
        width: 56.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: const Color(0xFFED4E18), width: 1.w),
        ),
        child: Text(
          '立即使用',
          style: TextStyle(
            color: const Color(0xFFED4E18),
            fontWeight: FontWeight.w500,
            fontSize: 11.sp,
          ),
        ),
      ),
    );
  }

  _buildSubItemList(CashCouponTemplateSubEntity subTemplate) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: CottiColor.backgroundColor, width: 1.h),
        ),
      ),
      child: Column(
        children: [
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CashCouponTemplateSubItem(subTemplate.cashCouponTemplateSubList![index]);
            },
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemCount: subTemplate.cashCouponTemplateSubList?.length ?? 0,
          ),
          if (subTemplate.tip?.isNotEmpty ?? false)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Text(
                subTemplate.tip ?? '',
                style: TextStyle(
                  color: CottiColor.textGray,
                  fontSize: 11.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
