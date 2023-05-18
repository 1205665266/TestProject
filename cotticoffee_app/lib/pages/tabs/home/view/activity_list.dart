import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/home/bloc/home_bloc.dart';
import 'package:cotti_client/pages/tabs/home/bloc/home_state.dart';
import 'package:cotti_client/pages/tabs/home/view/effect_widget.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/31 19:12
class AcitvityList extends StatefulWidget {
  const AcitvityList({Key? key}) : super(key: key);

  @override
  State<AcitvityList> createState() => _AcitvityListState();
}

class _AcitvityListState extends State<AcitvityList> {
  Map<String, ValueNotifier<BannerModel>> map = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            List<BannerModel> _banners = state.adSortList[index].list ?? [];
            if (_banners.isNotEmpty && _banners.first.bannerType == 1) {
              return _buildOnceItem(state.adSortList[index].code ?? '', _banners);
            }
            if (_banners.isNotEmpty && _banners.first.bannerType == 2) {
              return _buildTowItem(_banners);
            }
            if (_banners.isNotEmpty && _banners.first.bannerType == 3) {
              return _buildLeftRightItem(_banners);
            }
            if (_banners.isNotEmpty && _banners.first.bannerType == 4) {
              return _buildRightLeftItem(_banners);
            }
            return const SizedBox();
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 14.h);
          },
          itemCount: state.adSortList.length,
        );
      },
    );
  }

  _buildOnceItem(String code, List<BannerModel> banners) {
    if (!map.containsKey(code)) {
      map[code] = ValueNotifier(banners.first);
    }
    return EffectWidget(
      child: ValueListenableBuilder<BannerModel>(
        valueListenable: map[code]!,
        builder: (BuildContext context, value, Widget? child) {
          return ClipRRect(
            borderRadius: ((value.title?.isEmpty ?? true) && (value.subTitle1?.isEmpty ?? true))
                ? BorderRadius.only(
                    topLeft: Radius.circular(4.r),
                    topRight: Radius.circular(6.r),
                    bottomLeft: Radius.circular(4.r),
                    bottomRight: Radius.circular(4.r),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(4.r),
                    bottomRight: Radius.circular(4.r),
                  ),
            child: ABiteBanner(
              width: 343.w,
              banners: banners,
              fit: banners.length > 1 ? BoxFit.fill : BoxFit.fitWidth,
              resize: true,
              onBannerChanged: (model) => map[code]!.value = model,
            ),
          );
        },
      ),
    );
  }

  _buildTowItem(List<BannerModel> banners) {
    return Row(
      children: [
        Expanded(
          child: EffectWidget(
            child: Column(
              children: [
                ABiteBanner(
                  banners: [banners.first],
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                ),
                _buildTowTitle(banners.first.title, banners.first.subTitle1),
              ],
            ),
          ),
        ),
        Visibility(
          visible: banners.length > 1,
          child: SizedBox(width: 9.w),
        ),
        if (banners.length > 1)
          Expanded(
            child: EffectWidget(
              child: Column(
                children: [
                  ABiteBanner(
                    banners: [banners[1]],
                    borderRadius: BorderRadius.all(Radius.circular(4.r)),
                  ),
                  _buildTowTitle(banners[1].title, banners[1].subTitle1),
                ],
              ),
            ),
          ),
      ],
    );
  }

  _buildTitle(String? title, String? subTitle, String? redirectUrl) {
    if (title == null && subTitle == null) {
      return const SizedBox();
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.r),
          topRight: Radius.circular(4.r),
        ),
      ),
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title?.isNotEmpty ?? false)
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: CottiColor.textBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(
                    height: ((title?.isEmpty ?? true) && (subTitle?.isEmpty ?? true)) ? 0 : 3.h),
                if (subTitle?.isNotEmpty ?? false)
                  Text(
                    subTitle!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: CottiColor.textBlack,
                    ),
                  ),
              ],
            ),
          ),
          if (redirectUrl?.isNotEmpty ?? false)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Icon(
                IconFont.icon_youjiantou1,
                size: 18.w,
              ),
            ),
        ],
      ),
    );
  }

  _buildTowTitle(String? title, String? subTitle) {
    if (title == null && subTitle == null) {
      return const SizedBox();
    }
    return Column(
      children: [
        SizedBox(height: 8.h),
        if (title?.isNotEmpty ?? false)
          Text(
            title ?? '',
            style: TextStyle(
              fontSize: 15.sp,
              color: CottiColor.textBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
        SizedBox(height: (subTitle?.isEmpty ?? true) ? 0 : 4.h),
        Text(
          subTitle ?? '',
          style: TextStyle(
            fontSize: 13.sp,
            color: CottiColor.primeColor,
          ),
        ),
      ],
    );
  }

  _buildLeftRightItem(List<BannerModel> banners) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: EffectWidget(
              child: ABiteBanner(
                banners: [banners.first],
                borderRadius: BorderRadius.all(Radius.circular(4.r)),
              ),
            ),
          ),
          Visibility(
            visible: banners.length > 1,
            child: SizedBox(width: 9.w),
          ),
          if (banners.length > 1)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EffectWidget(
                    child: ABiteBanner(
                      banners: [banners[1]],
                      borderRadius: BorderRadius.all(Radius.circular(4.r)),
                    ),
                  ),
                  if (banners.length > 2)
                    EffectWidget(
                      child: ABiteBanner(
                        banners: [banners[2]],
                        borderRadius: BorderRadius.all(Radius.circular(4.r)),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  _buildRightLeftItem(List<BannerModel> banners) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EffectWidget(
                  child: ABiteBanner(
                    banners: [banners.first],
                    borderRadius: BorderRadius.all(Radius.circular(4.r)),
                  ),
                ),
                if (banners.length > 1)
                  EffectWidget(
                    child: ABiteBanner(
                      banners: [banners[1]],
                      borderRadius: BorderRadius.all(Radius.circular(4.r)),
                    ),
                  ),
              ],
            ),
          ),
          Visibility(
            visible: banners.length > 2,
            child: SizedBox(width: 9.w),
          ),
          if (banners.length > 2)
            Expanded(
              child: EffectWidget(
                child: ABiteBanner(
                  banners: [banners[2]],
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
