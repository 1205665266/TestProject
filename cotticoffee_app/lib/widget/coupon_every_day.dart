import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/12 11:22
class CouponEveryDay extends StatefulWidget {
  const CouponEveryDay({Key? key}) : super(key: key);

  @override
  State<CouponEveryDay> createState() => _CouponEveryDayState();
}

class _CouponEveryDayState extends State<CouponEveryDay> {
  bool sendSuccess = false;
  bool isLoading = false;
  Key bannerKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _getEveryDayCoupon());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listenWhen: (p, c) => p.status != UserStatus.loggedIn && c.status == UserStatus.loggedIn,
      listener: (context, state) => _getEveryDayCoupon(),
      child: sendSuccess
          ? ABiteBanner(
              key: bannerKey,
              bannerParam: BannerParam(
                "cotti-mkt-daily-window",
                viewPage: "cotti-app-home",
                memberId: GlobalBlocs.get<UserBloc>(UserBloc.blocName).state.userModel?.memberId,
              ),
            )
          : const SizedBox(),
    );
  }

  _getEveryDayCoupon() async {
    int? memberId = GlobalBlocs.get<UserBloc>(UserBloc.blocName).state.userModel?.memberId;
    if (memberId == null || isLoading) {
      return;
    }
    isLoading = true;
    await CottiNetWork()
        .post("/wechat/coupons/getCouponsEveryDay", data: {"memberId": memberId}, showToast: false)
        .then((value) {
      sendSuccess = value["status"] == 1;
      bannerKey = UniqueKey();
      setState(() {});
    }).catchError((onError) => logE(onError));
    isLoading = false;
  }
}
