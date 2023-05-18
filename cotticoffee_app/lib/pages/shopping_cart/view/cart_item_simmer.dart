import 'package:cotti_client/widget/shimmer_widget/custom_simmer_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/1/13 10:15
class CartItemSimmer extends StatefulWidget {
  const CartItemSimmer({Key? key}) : super(key: key);

  @override
  State<CartItemSimmer> createState() => _CartItemSimmerState();
}

class _CartItemSimmerState extends State<CartItemSimmer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSimmerHolder.rectangular(height: 80.w, width: 80.w),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSimmerHolder.rectangular(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 16.h,
              ),
              SizedBox(height: 14.h),
              CustomSimmerHolder.rectangular(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 16.h,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
