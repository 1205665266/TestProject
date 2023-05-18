import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/entity/config_entity.dart';
import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// Description: 自提/外卖 切换按钮
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/27 18:59
class SwitchButton extends StatelessWidget {
  final int? curTakeFoodMode;
  final VoidCallback click;

  const SwitchButton({
    Key? key,
    required this.curTakeFoodMode,
    required this.click,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? arriveOnTime = context.read<ConfigBloc>().state.configEntity?.arriveOnTime ?? '';
    return BlocBuilder<ConfigBloc, ConfigState>(
      builder: (context, state) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 28.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14.r)),
                color: const Color(0xFFF5F5F5),
              ),
              child: Row(
                children: List.generate(
                  state.serviceMode.length,
                  (index) {
                    ServiceMode serviceMode = state.serviceMode[index];
                    return _buildItem(serviceMode.name ?? '', serviceMode.index == curTakeFoodMode);
                  },
                ),
              ),
            ),
            if (curTakeFoodMode == Constant.takeOutModeCode && arriveOnTime.isNotEmpty)
              Positioned(
                top: -9.h,
                right: -1.w,
                child: SvgPicture.asset('assets/images/menu/icon_arrive.svg'),
              ),
          ],
        );
      },
    );
  }

  _buildItem(String name, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          click();
        }
      },
      child: Container(
        width: 60.w,
        height: 28.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14.r)),
          color: isSelected ? CottiColor.primeColor : const Color(0xFFF5F5F5),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : CottiColor.textGray,
            fontSize: 12.sp,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}
