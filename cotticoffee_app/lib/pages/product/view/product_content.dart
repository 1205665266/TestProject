import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/product/bloc/product_bloc.dart';
import 'package:cotti_client/pages/product/bloc/product_state.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductContent extends StatefulWidget {
  const ProductContent({Key? key}) : super(key: key);

  @override
  State<ProductContent> createState() => _ProductContentState();
}

class _ProductContentState extends State<ProductContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              if (state.productDetailData?.productTipsInfo != null ||
                  state.productDetailData?.introMedias != null ||
                  state.productDetailData?.productDesc != null)
                SizedBox(
                  height: 20.h,
                ),
              if (state.productDetailData?.productTipsInfo?.content != null) _buildTips(state),
              if (state.productDetailData?.introMedias != null) _buildImages(state),
              if (state.productDetailData?.productDesc != null) _buildIntroduce(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTips(ProductState state) {
    return Container(
      padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Icon(
            IconFont.icon_dengpao,
            size: 16.sp,
            color: CottiColor.textGray,
          ),
          SizedBox(
            width: 4.w,
          ),
          Text(
            "${state.productDetailData?.productTipsInfo?.content}",
            style: TextStyle(
              fontSize: 12.sp,
              color: CottiColor.textGray,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImages(ProductState state) {
    return Column(
      children: List.generate(
        state.productDetailData?.introMedias?.length ?? 0,
        (index) => CottiImageWidget(
          state.productDetailData?.introMedias![index].mediaUrl ?? "",
          fit: BoxFit.fitWidth,
          imgW: 375.w,
        ),
      ),
    );
  }

  Widget _buildIntroduce(ProductState state) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 32.h),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _introduceItem(state.productDetailData?.productDesc![index].descName?.trim(),
            state.productDetailData?.productDesc![index].descContent);
      },
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemCount: state.productDetailData?.productDesc?.length ?? 0,
    );
  }

  Widget _introduceItem(title, content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "",
          style: TextStyle(
            fontSize: 13.sp,
            height: 1.33,
            fontWeight: FontWeight.bold,
            color: CottiColor.textBlack,
          ),
        ),
        SizedBox(
          height: 6.h,
        ),
        Text(
          content ?? "",
          style: TextStyle(
            height: 1.33,
            fontSize: 12.sp,
            color: CottiColor.textGray,
          ),
        ),
      ],
    );
  }
}
