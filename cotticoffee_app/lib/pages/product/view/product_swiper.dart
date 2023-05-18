import 'package:card_swiper/card_swiper.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/product/entity/product_detail_entity.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotti_client/widget/swiper/cotti_swiper.dart';
import 'package:cotti_client/widget/swiper/swiper_item.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cotti_client/pages/product/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cotti_client/pages/product/bloc/product_bloc.dart';

class ProductSwiper extends StatefulWidget {
  const ProductSwiper({Key? key}) : super(key: key);

  @override
  State<ProductSwiper> createState() => _ProductSwiperState();
}

class _ProductSwiperState extends State<ProductSwiper> {
  @override
  Widget build(BuildContext context) {
    // context.read<ProductBloc>().add(QueryProductInfoEvent);
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        List<SwiperItem> banners = [];
        state.productDetailData?.topMedias?.forEach((element) {
          banners.add(SwiperItem(
              element.mediaType == 1 ? SwiperItemEnum.video : SwiperItemEnum.image,
              element.mediaUrl!));
        });
        if (banners.isEmpty) {
          return SizedBox(
            height: 300.h,
          );
        }
        return CottiSwiper(
          height: 300.h,
          swiperList: banners,
          fit: BoxFit.fitWidth,
          // child: Swiper(
          //   pagination: banners.length > 1
          //       ? SwiperPagination(
          //       alignment: Alignment.bottomRight,
          //       margin: EdgeInsets.only(bottom: 12.h, right: 12.w),
          //       builder: RectSwiperPaginationBuilder(
          //           size: Size(10.w, 10.h),
          //           activeSize: Size(20.w, 10.h),
          //           activeColor: Colors.white,
          //           color: Colors.white.withOpacity(0.6)))
          //       : null,
          //   physics:
          //   banners.length > 1 ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
          //   autoplay: banners.length > 1,
          //   itemCount: banners.length,
          //   itemBuilder: (context, index) => _swiperItem(context, banners[index]),
          //   autoplayDelay: 4000,
          //   duration: 550,
          //   onIndexChanged: (index) {
          //     logI("onIndexChanged=$index");
          //     // currentIndex = index;
          //   },
          // ),
        );
      },
    );
  }

  Widget _swiperItem(BuildContext context, ProductDetailTopMedias bannerItem) {
    if (bannerItem.mediaType == 1) {
      // TODO 返回视频展示
      return CottiImageWidget(
        bannerItem.mediaUrl ?? "",
        fit: BoxFit.fitWidth,
        imgW: 375.w,
      );
    }
    // 默认是图片
    return CottiImageWidget(
      bannerItem.mediaUrl ?? "",
      fit: BoxFit.fitWidth,
      imgW: 375.w,
    );
  }
}
