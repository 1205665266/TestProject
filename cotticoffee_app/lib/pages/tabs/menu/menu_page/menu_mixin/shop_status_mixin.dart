import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/utils/distance_util.dart';
import 'package:cotti_client/widget/dialog/common_dialog.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/6 14:27
mixin ShopStatusMixin {
  List<int> shopMdCodeList = [];

  void showSelfTakeDialog(BuildContext context, ShopMatchState current) {
    ShopDetail? shopInfo = current.currentShopDetail;
    if (shopMdCodeList.any((element) => shopInfo?.shopMdCode == element)) {
      return;
    }
    if (current.shopForceClosed) {
      _add(shopInfo);
      CommonDialog.show(
        context,
        title: "本店闭店升级中",
        content: "可切换至其他门店选购",
        mainButtonName: "切换门店",
        subButtonName: '留在当前',
      ).then((value) {
        if (value == 1) {
          NavigatorUtils.push(context, CommonPageRouter.storeListPage);
        }
      });
    } else if (current.shopClosed) {
      _add(shopInfo);
      String? shopOperateStr = shopInfo?.shopOperateStr?.replaceAll("#", " ");
      CommonDialog.show(
        context,
        title: "休息中，可切换其他门店选购",
        content: (shopOperateStr?.isNotEmpty ?? false) ? "本店营业时间\n$shopOperateStr" : "今日门店休息",
        mainButtonName: "切换门店",
        subButtonName: '留在当前',
        contentTextHeight: 1.5,
      ).then((value) {
        if (value == 1) {
          NavigatorUtils.push(context, CommonPageRouter.storeListPage);
        }
      });
    }
  }

  void showTakeoutDialog(BuildContext context, ShopMatchState current, int? takeOutShopResultType) {
    ShopDetail? shopInfo = current.currentShopDetail;
    if (shopMdCodeList.any((element) => shopInfo?.shopMdCode == element)) {
      return;
    }
    if (takeOutShopResultType == 1) {
      _add(shopInfo);
      CommonDialog.show(
        context,
        title: "COTTI 暂时配送不到当前地址",
        contentChild: recommendShop(shopInfo?.shopName ?? '', shopInfo?.distance ?? 0),
        mainButtonName: "去推荐门店下单",
        subButtonName: "我再看看",
      ).then((value) {
        if (value == 1) {
          context.read<ShopMatchBloc>().add(ShopInfoByShopMdCodeEvent(shopInfo!.shopMdCode!));
        }
      });
    } else if (takeOutShopResultType == 2) {
      ///情况特殊，这种不支持配送地址的，放在menu_page 上了
    } else if (current.shopForceClosed) {
      _add(shopInfo);
      CommonDialog.show(
        context,
        title: "配送门店闭店升级中",
        content: "可切换至自取门店选购",
        mainButtonName: "选择自取门店",
        subButtonName: "留在当前",
      ).then((value) {
        if (value == 1) {
          NavigatorUtils.push(context, CommonPageRouter.storeListPage);
        }
      });
    } else if (current.shopClosed) {
      _add(shopInfo);
      CommonDialog.show(
        context,
        title: "配送门店休息中",
        content: "可切换至自取门店选购",
        mainButtonName: "选择自取门店",
        subButtonName: "留在当前",
      ).then((value) {
        if (value == 1) {
          NavigatorUtils.push(context, CommonPageRouter.storeListPage);
        }
      });
    }
  }

  Widget recommendShop(String shopName, int distance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          "推荐自取门店:",
          style: TextStyle(
            color: CottiColor.textBlack,
            fontSize: 14.sp,
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 6.h, bottom: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2.r)),
            color: CottiColor.backgroundColor,
          ),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                shopName,
                style: TextStyle(
                  color: CottiColor.textBlack,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "距当前收货地址  ${DistanceUtil.convertDistance(distance)}",
                style: TextStyle(
                  color: CottiColor.textBlack,
                  fontSize: 12.sp,
                  fontFamily: "DDP5",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _add(shopInfo) {
    shopMdCodeList.add(shopInfo?.shopMdCode ?? 0);
  }

  void selectTakeAddress(BuildContext context) {
    NavigatorUtils.push(context, CommonPageRouter.takeAddressListPage).then((value) {
      ShopMatchState state = context.read<ShopMatchBloc>().state;
      if (state.curTakeFoodMode == Constant.takeOutModeCode) {
        ///如果当前是外卖模式，但是地址或外卖门店信息都是空，自动降级到自提
        if (state.address == null) {
          context.read<ShopMatchBloc>().add(SelfTakeMatchShopEvent());
        }
      }
    });
  }
}
