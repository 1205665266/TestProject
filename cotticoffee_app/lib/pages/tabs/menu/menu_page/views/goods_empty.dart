import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/bloc/menu_bloc.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/bloc/menu_state.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description: 没有商品时占位页面
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/8 14:23
class GoodsEmpty extends StatelessWidget {
  const GoodsEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        return Visibility(
          visible: state.goodsEmpty,
          child: Container(
            margin: EdgeInsets.only(top: 175.h),
            color: CottiColor.backgroundColor,
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(height: 110.h),
                Image.asset(
                  'assets/images/menu/icon_goods_empty.png',
                  width: 142.w,
                  height: 120.h,
                ),
                SizedBox(height: 32.h),
                Text(
                  '商品优化中，敬请期待！',
                  style: TextStyle(
                    color: CottiColor.textBlack,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 44.h),
                GestureDetector(
                  onTap: () => NavigatorUtils.push(context, CommonPageRouter.storeListPage),
                  child: Container(
                    width: 144.w,
                    height: 39.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CottiColor.primeColor,
                      borderRadius: BorderRadius.all(Radius.circular(2.r)),
                    ),
                    child: Text(
                      '更换门店下单',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
