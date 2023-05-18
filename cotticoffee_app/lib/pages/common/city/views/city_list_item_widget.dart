import 'package:cotti_client/pages/common/city/entity/city_list_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CityListItemWidget extends StatelessWidget {
  const CityListItemWidget({
    Key? key,
    required this.model,
    this.onTap,
    this.textColor = const Color(0xFF3A3B3C),
  }) : super(key: key);

  final CityListDataData model;
  final Color textColor;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 44.h,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: InkWell(
        child: SizedBox(
          width: double.infinity,
          child: Text(
            model.cityName ?? '',
            maxLines: 1,
            style: TextStyle(
              color: textColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  static Widget cityListDivider({double? honValue}) {
    return Divider(
      indent: honValue ?? 12.w,
      endIndent: honValue ?? 12.w,
      height: 1.h,
      color: const Color(0xFFD8D8D8),
    );
  }
}
