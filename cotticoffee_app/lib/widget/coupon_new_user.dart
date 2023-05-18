import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotticommon/bloc/user_bloc.dart';
import 'package:cotticommon/bloc/user_state.dart';
import 'package:cotticommon/utils/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/12 11:22
class CouponNewUser extends StatelessWidget {
  const CouponNewUser({Key? key}) : super(key: key);
  final showNewUserCouponWindow = "key_new_user_coupon_window";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listenWhen: (p, c) => p.status == UserStatus.loggedIn && c.status != UserStatus.loggedIn,
      listener: (context, state) => SpUtil.remove(showNewUserCouponWindow),
      builder: (context, state) {
        bool isNewUser = SpUtil.getBool(showNewUserCouponWindow, defValue: true);
        isNewUser = isNewUser && (state.userModel?.registerFlag ?? false);
        isNewUser = isNewUser && state.userModel?.memberId != null;
        if (isNewUser) {
          return ABiteBanner(
            key: UniqueKey(),
            bannerParam: BannerParam(
              "cotti-mkt-newUser-window",
              viewPage: 'cotti-app-home',
              memberId: state.userModel?.memberId,
            ),
            onBannerChanged: (_) => SpUtil.putBool(showNewUserCouponWindow, false),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
