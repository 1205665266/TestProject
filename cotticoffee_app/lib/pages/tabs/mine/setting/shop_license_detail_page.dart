import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/13 5:03 PM
class ShopLicenseDetailPage extends StatelessWidget {
  final List<String> images;

  const ShopLicenseDetailPage({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      title: '门店资质',
      child: ListView.separated(
        itemBuilder: (context, index) {
          return CottiImageWidget(
            images[index],
            fit: BoxFit.fill,
          );
        },
        itemCount: images.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox();
        },
      ),
    );
  }
}
