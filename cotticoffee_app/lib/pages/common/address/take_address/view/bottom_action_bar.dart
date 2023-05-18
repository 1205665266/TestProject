import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/address/take_address/bloc/take_address_event.dart';
import 'package:cotti_client/sensors/address_sensors_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import '../../edit_address/address_edit_page.dart';
import '../bloc/take_address_bloc.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/9 17:03
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SensorsAnalyticsFlutterPlugin.track(
            AddressSensorsConstant.commonAddressListAddClick, {});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider<TakeAddressBloc>.value(
              value: context.read<TakeAddressBloc>(),
              child: AddressEditPage(isEdit: false),
            ),
          ),
        ).then((value) {
          if (value != null && value) {
            context.read<TakeAddressBloc>().add(TakeAddressListEvent());
          }
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44.h,
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5.w, color: CottiColor.primeColor),
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/address/icon_add_address.svg',
              width: 18.w,
              height: 18.w,
            ),
            SizedBox(width: 7.w),
            Text(
              '新建收货地址',
              style: TextStyle(
                color: CottiColor.primeColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              strutStyle: const StrutStyle(
                forceStrutHeight: true,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
