import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_state.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/menu_mixin/shop_status_mixin.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/widget/dialog/common_dialog_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Description: 配送地址不可用并且无推荐的自提门店
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/6 17:10
class TakeAddressNotAvailable extends StatefulWidget {
  const TakeAddressNotAvailable({Key? key}) : super(key: key);

  @override
  State<TakeAddressNotAvailable> createState() => _TakeAddressNotAvailableState();
}

class _TakeAddressNotAvailableState extends State<TakeAddressNotAvailable> with ShopStatusMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopMatchBloc, ShopMatchState>(
      builder: (context, state) {
        return Visibility(
          visible: state.takeOutShopInfo?.takeOutShopResultType == 2 &&
              state.curTakeFoodMode == Constant.takeOutModeCode,
          child: CommonDialogWidget(
            title: "COTTI 暂时还配送不到该地址",
            content: "可切换至自取门店选购",
            subButtonName: "选择其他地址",
            mainButtonName: "选择自取门店",
            coverBackground: true,
            clickButtonCallBack: (result) {
              if (result == 0) {
                selectTakeAddress(context);
              }
              if (result == 1) {
                NavigatorUtils.push(context, CommonPageRouter.storeListPage);
              }
            },
          ),
        );
      },
    );
  }
}
