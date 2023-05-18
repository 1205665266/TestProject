import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cotti_client/pages/tabs/menu/search/entity/search_label.dart';

/// FileName: quick_search
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/16
class QuickSearch extends StatelessWidget {
  const QuickSearch({
    Key? key,
    required this.title,
    required this.data,
    this.onPressedItem,
    required this.type,
  }) : super(key: key);

  final String title;
  final List<SearchLabel> data;
  final int type;
  final Function(SearchLabel, int)? onPressedItem;
  final Color _red = const Color(0xFFFF6A39);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: data.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(),
          SizedBox(height: 8.h),
          _content(),
        ],
      ),
    );
  }

  Widget _title() {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: CottiColor.textBlack,
      ),
    );
  }

  Widget _content() {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 12.w,
        runSpacing: 8.h,
        runAlignment: WrapAlignment.start,
        children: List.generate(
          data.length,
          (index) {
            SearchLabel searchLabel = data[index];
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    if (onPressedItem != null) {
                      onPressedItem!(searchLabel, type);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    margin: EdgeInsets.only(top: 6.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.w),
                      color: const Color(0xFFf5f5f5),
                    ),
                    child: Text(
                      searchLabel.labelText ?? "",
                      style: TextStyle(
                        color: CottiColor.textBlack,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: searchLabel.type?.isNotEmpty ?? false,
                  child: Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 1.h),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFBE7E5),

                      ),
                      child: Text(
                        searchLabel.type ?? '',
                        style: TextStyle(
                          color: CottiColor.primeColor,
                          fontSize: 10.sp,
                          height: 1,
                          fontWeight: FontWeight.w500,
                          leadingDistribution: TextLeadingDistribution.even
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
