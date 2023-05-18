import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/cash_coupon/cash_coupon_template/bloc/cash_coupon_template_bloc.dart';
import 'package:cotti_client/widget/shimmer_widget/custom_simmer_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/14 13:35
class CouponExplainDialog extends StatefulWidget {
  final String templateCode;
  final String? partnerName;
  final String? startTime;

  const CouponExplainDialog(
    this.templateCode, {
    Key? key,
    this.partnerName,
    this.startTime,
  }) : super(key: key);

  @override
  State<CouponExplainDialog> createState() => _CouponExplainDialogState();

  static Future show(context, String templateCode, String? partnerName, String? startTime) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CouponExplainDialog(
          templateCode,
          partnerName: partnerName,
          startTime: startTime,
        );
      },
    );
  }
}

class _CouponExplainDialogState extends State<CouponExplainDialog> {
  final CashCouponTemplateBloc _bloc = CashCouponTemplateBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(SubTemplateInfoEvent(widget.templateCode));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashCouponTemplateBloc, CashCouponTemplateState>(
      bloc: _bloc,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.r),
              topRight: Radius.circular(8.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              if (_bloc.state.vocherTemplateInfo != null) _buildSubTitle(),
              if (_bloc.state.vocherTemplateInfo != null) _buildContent(),
              if (_bloc.state.vocherTemplateInfo == null) _buildSkeleton(),
              _buildButton(),
            ],
          ),
        );
      },
    );
  }

  _buildTitle() {
    return Container(
      height: 48.h,
      alignment: Alignment.center,
      child: Text(
        '代金券说明',
        style: TextStyle(
          color: CottiColor.textBlack,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _buildSubTitle() {
    if ((widget.partnerName ?? "").isEmpty) {
      return const SizedBox();
    }
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: CottiColor.backgroundColor,
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${widget.partnerName}",
            style: TextStyle(
              color: const Color(0xFF6E6E6E),
              fontSize: 12.sp,
            ),
          ),
          Text(
            "${widget.startTime} 发放",
            style: TextStyle(
              color: const Color(0xFF6E6E6E),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: 496.h,
        minHeight: 120.h,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 12.h),
        child: Text(
          "${_bloc.state.vocherTemplateInfo!.voucherDesc}",
          style: TextStyle(
            color: CottiColor.textBlack,
            fontSize: 13.sp,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  _buildButton() {
    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          height: 48.h,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: CottiColor.primeColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            '我知道了',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  _buildSkeleton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          6,
          (index) {
            double scale = 1.0;
            if (index == 2) {
              scale = 0.6;
            }
            if (index == 5) {
              scale = 0.5;
            }
            return Padding(
              padding: EdgeInsets.only(top: index == 3 ? 8.h : 4.h),
              child: CustomSimmerHolder.rectangular(
                width: MediaQuery.of(context).size.width * scale,
                height: 18.h,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }
}
