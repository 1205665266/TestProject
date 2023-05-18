import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/store/entity/shop_detail_entity.dart';
import 'package:cotti_client/sensors/address_sensors_constant.dart';
import 'package:cotti_client/utils/distance_util.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/dialog/common_dialog.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'bloc/take_address_bloc.dart';
import 'bloc/take_address_event.dart';
import 'bloc/take_address_state.dart';
import 'view/address_empty.dart';
import 'view/address_item.dart';
import 'view/bottom_action_bar.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/9 16:02
class AddressListPage extends StatefulWidget {
  final bool isSelectTakeAddress;
  final bool isShopMatch;

  const AddressListPage({
    Key? key,
    this.isSelectTakeAddress = true,
    this.isShopMatch = true,
  }) : super(key: key);

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  final TakeAddressBloc _bloc = TakeAddressBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(TakeAddressListEvent());

    if(widget.isSelectTakeAddress){
      SensorsAnalyticsFlutterPlugin.track(
          AddressSensorsConstant.pickupWayShow, {});
    }else {
      SensorsAnalyticsFlutterPlugin.track(
          AddressSensorsConstant.mineAddressShow, {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<TakeAddressBloc, TakeAddressState>(
        listenWhen: (previous, current) =>
            previous.getShopInfoTimeStamp != current.getShopInfoTimeStamp,
        listener: (context, state) {
          _shopHandle(state.shopInfoEntity, state.curSelectMemberAddress);
        },
        builder: (context, state) {
          return CustomPageWidget(
            title: widget.isSelectTakeAddress ? "请选择收货地址" : "收货地址管理",
            customEmptyWidget: const AddressEmpty(),
            customLoadingColor: Colors.transparent,
            loadingRatio: 0.4,
            showLoading: state.showLoading,
            showEmpty: state.showEmpty,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildAddressList(state),
                    ),
                  ),
                  const BottomActionBar(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildAddressList(state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SlidableAutoCloseBehavior(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: (state.takeAddressEntity?.address?.length ?? 0) > 0 ? 12.h : 0.h,
            ),
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return AddressItem(
                  memberAddress: state.takeAddressEntity!.address[index],
                  isClickAble: widget.isSelectTakeAddress,
                    isSelectTakeAddress: widget.isSelectTakeAddress,
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemCount: state.takeAddressEntity?.address?.length ?? 0,
            ),
            Visibility(
              visible: state.takeAddressEntity?.addressOutOfRange?.isNotEmpty ?? false,
              child: Padding(
                padding: EdgeInsets.only(left: 0.w, top: 20.h, bottom: 8.w),
                child: Text(
                  "以下地址超出配送范围",
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                    color: CottiColor.textHint,
                  ),
                ),
              ),
            ),
            ListView.separated(
              padding: EdgeInsets.only(bottom: 12.h),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return AddressItem(
                  memberAddress: state.takeAddressEntity.addressOutOfRange![index],
                  isClickAble: widget.isSelectTakeAddress,
                  isOutOfRange: true,
                  isSelectTakeAddress: widget.isSelectTakeAddress,
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemCount: state.takeAddressEntity?.addressOutOfRange?.length ?? 0,
            ),
          ],
        ),
      ),
    );
  }

  _shopHandle(ShopInfoEntity? shopInfoEntity, address) {
    if (shopInfoEntity == null) {
      return;
    }
    if (shopInfoEntity.takeOutShopResultType == 0 && address != null) {
      if (widget.isShopMatch) {
        context.read<ShopMatchBloc>().add(ShopInfoByAddressEvent(address));
      }
      NavigatorUtils.pop(context, result: address);
    } else if (shopInfoEntity.takeOutShopResultType == 1) {
      CommonDialog.show(
        context,
        title: "COTTI 暂时还配送不到该地址",
        content: "推荐自提门店:${shopInfoEntity.shopDetail?.shopName}\n\n距所选地址"
            "${DistanceUtil.convertDistance(shopInfoEntity.shopDetail?.distance)}",
        subButtonName: "选择其他地址",
        mainButtonName: "去推荐门店下单",
      ).then((value) {
        if (value == 0) {
          _bloc.add(TakeAddressListEvent());
        } else {
          context
              .read<ShopMatchBloc>()
              .add(ShopInfoByShopMdCodeEvent(shopInfoEntity.shopDetail!.shopMdCode!));
          NavigatorUtils.pop(context, result: {'isGoSelfTake': true});
        }
      });
    } else {
      ToastUtil.show("暂不支持配送到该地址");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }
}
