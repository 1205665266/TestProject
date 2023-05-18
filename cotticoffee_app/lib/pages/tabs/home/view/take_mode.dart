import 'package:abitelogin/abitelogin.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/global/entity/config_entity.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';
import 'package:cotti_client/pages/tabs/home/bloc/home_bloc.dart';
import 'package:cotti_client/pages/tabs/tab_page.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/cotti_vertical_divider.dart';
import 'package:cotti_client/widget/first_order_free/first_order_free_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/home_state.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/31 13:42
class TakeMode extends StatefulWidget {
  const TakeMode({Key? key}) : super(key: key);

  @override
  State<TakeMode> createState() => _TakeModeState();
}

class _TakeModeState extends State<TakeMode> {
  final String fromHome = "homePage";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 6.h),
            blurRadius: 12.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: BlocListener<ShopMatchBloc, ShopMatchState>(
        listenWhen: (p, c) =>
            p.takeOutTimeStamp != c.takeOutTimeStamp && c.adapterAddressFromTag == fromHome,
        listener: (context, state) {
          if (state.address != null) {
            _switchTakeOut(state.address!, true);
          } else {
            NavigatorUtils.push(
              context,
              CommonPageRouter.takeAddressListPage,
              params: {"isShopMatch": false},
            ).then((value) {
              if (value is MemberAddressEntity) {
                _switchTakeOut(value, false);
              } else if (value != null && value["isGoSelfTake"]) {
                GlobalBlocs.get<GlobalBloc>(GlobalBloc.blocName).add(
                  SwitchTabEvent(TabEnum.menu.index),
                );
              }
            });
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Visibility(
              visible: state.isInit,
              child: Container(
                height: 76.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                ),
                child: _buildAd(state.getTakeModeList),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildAd(List<BannerModel> list) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          children: List.generate(
            list.length,
            (index) => Expanded(
              child: ABiteBanner(
                banners: [list[index]],
                width: (375.w - 32.w) / 2,
                borderRadius: BorderRadius.only(
                  topLeft: index == 0 ? Radius.circular(4.r) : Radius.zero,
                  bottomLeft: index == 0 ? Radius.circular(4.r) : Radius.zero,
                  topRight: index == 1 ? Radius.circular(4.r) : Radius.zero,
                  bottomRight: index == 1 ? Radius.circular(4.r) : Radius.zero,
                ),
                fit: BoxFit.fitWidth,
                onTapItemCallBack: (model) => onTakeMode(index),
              ),
            ),
          ),
        ),
        Positioned(
          top: -9.h,
          right: -4.w,
          child: FirstOrderFreeWidget(
            tabEnum: TabEnum.home,
            contextSize: 11.sp,
            padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 3.h, bottom: 2.h),
            iconTriangle: 'assets/images/home/icon_first_order_free_home.svg',
          ),
        ),
      ],
    );
  }

  onTakeMode(int index) {
    List<ServiceMode> serviceModes = context.read<ConfigBloc>().state.serviceMode;
    if (index >= serviceModes.length) {
      return;
    }
    if (serviceModes[index].index == Constant.takeOutModeCode) {
      if (Constant.hasLogin) {
        _getMemberAddress();
      } else {
        LoginUtils.login(context).then((value) {
          if (Constant.hasLogin) {
            _getMemberAddress();
          }
        });
      }
    } else {
      GlobalBlocs.get<GlobalBloc>(GlobalBloc.blocName).add(
        SwitchTabEvent(TabEnum.menu.index, arguments: {'takeFoodMode': serviceModes[index].index}),
      );
    }
  }

  void _getMemberAddress() {
    ShopMatchState state = context.read<ShopMatchBloc>().state;
    //当前是否匹配过收货地址
    if (state.address == null) {
      context.read<ShopMatchBloc>().add(TakeOutAdapterEvent(fromHome));
    } else {
      _switchTakeOut(state.address!, false);
    }
  }

  void _switchTakeOut(MemberAddressEntity memberAddressEntity, bool isAutoMatchShop) {
    Map<String, dynamic> arguments = {
      "takeFoodMode": Constant.takeOutModeCode,
      "address": memberAddressEntity,
      "isAutoMatchShop": isAutoMatchShop
    };
    GlobalBlocs.get<GlobalBloc>(GlobalBloc.blocName).add(
      SwitchTabEvent(TabEnum.menu.index, arguments: arguments),
    );
  }
}
