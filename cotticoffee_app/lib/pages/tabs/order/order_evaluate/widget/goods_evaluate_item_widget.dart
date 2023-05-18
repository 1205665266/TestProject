import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/entity/order_comment_entity_entity.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoodsEvaluateItemWidget extends StatelessWidget {
  final OrderCommentEntityOrderItemCommentList item;

  const GoodsEvaluateItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 13.h,
        left: 12.w,
        right: 12.w,
      ),
      child: Column(
        children: [
          _buildOverview(),
          _buildLabelsView(),
          _buildContentWidget(),
          _buildImageGridView(),
        ],
      ),
    );
  }

  /// 上平评价文字
  Widget _buildContentWidget() {
    return Offstage(
      offstage: item.content == null || item.content!.isEmpty,
      child: Container(
        padding: EdgeInsets.only(top: 16.h),
        width: double.infinity,
        child: Text(
          item.content ?? '',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xff666666),
            fontWeight: FontWeight.w400,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  /// 商品评价图片
  Widget _buildImageGridView() {
    var offstage = item.imageUrls != null && item.imageUrls!.isNotEmpty;
    return Offstage(
      offstage: !offstage,
      child: GridView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 12.h),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 9.w,
        ),
        children: List.generate(
            item.imageUrls?.length ?? 0,
            (index) => Container(
                  child: CottiImageWidget(
                    item.imageUrls![index],
                    imgW: 64.w,
                    imgH: 64.h,
                    fit: BoxFit.fill,
                  ),
                )),
      ),
    );
  }

  /// 商品评价标签视图
  Widget _buildLabelsView() {
    var offstage = item.evaluateLabels != null && item.evaluateLabels!.isNotEmpty;
    return Offstage(
      offstage: !offstage,
      child: Container(
        padding: EdgeInsets.only(
          top: 16.h,
        ),
        alignment: Alignment.center,
        width: double.infinity,
        child: Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          textDirection: TextDirection.ltr,
          direction: Axis.horizontal,
          children: labelList(item.evaluateLabels ?? []),
        ),
      ),
    );
  }

  /// 商品评价标签数组
  List<Widget> labelList(List<String> labels) {
    List<Widget> list = [];

    for (String label in labels) {
      Widget item = Container(
        decoration: BoxDecoration(
          border: Border.all(color: CottiColor.primeColor, width: 1.sp),
          color: const Color(0xffFBE7E5),
          borderRadius: BorderRadius.circular(4.r),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 7.h,
          horizontal: 6.w,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: CottiColor.primeColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

      list.add(item);
    }

    return list;
  }

  /// 图片、名称、规格、⭐️
  Widget _buildOverview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CottiImageWidget(
          item.thumbnail ?? '',
          imgH: 56.h,
          imgW: 56.h,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              left: 12.w,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? '',
                  maxLines: 100,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xff351B0B),
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                Text(
                  item.skuProps ?? '',
                  maxLines: 100,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xff979797),
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                _buildStarsWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ⭐️⭐️⭐️⭐️⭐️
  Widget _buildStarsWidget() {
    List<Widget> stars = [];

    /// 选中的⭐️
    for (int i = 0; i < (item.startCount ?? 0); i++) {
      Widget start = Container(
        padding: EdgeInsets.only(
          right: 12.w,
        ),
        child: SvgPicture.asset(
          "assets/images/order/order_evaluate/ic_star_rating_selected.svg",
          width: 16.w,
          height: 16.w,
          fit: BoxFit.fill,
        ),
      );
      stars.add(start);
    }

    /// 未选中的⭐️
    for (int i = 0; i < 5 - (item.startCount ?? 0); i++) {
      Widget start = Container(
        padding: EdgeInsets.only(
          right: 12.w,
        ),
        child: SvgPicture.asset(
          "assets/images/order/order_evaluate/ic_star_rating_unselected.svg",
          width: 16.w,
          height: 16.w,
          fit: BoxFit.fill,
        ),
      );
      stars.add(start);
    }

    return Container(
      padding: EdgeInsets.only(
        top: 5.h,
      ),
      child: Row(
        children: stars,
      ),
    );
  }
}
