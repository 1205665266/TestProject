import 'dart:math';

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/entity/config_entity.dart';
import 'package:cotti_client/widget/new_install_activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cotti_client/widget/banner/banner.dart';

class NewInstallCoupon extends StatefulWidget {
  const NewInstallCoupon({Key? key}) : super(key: key);

  @override
  _NewInstallCouponState createState() {
    return _NewInstallCouponState();
  }
}

class _NewInstallCouponState extends State<NewInstallCoupon> {

  bool showDialog = false;
  bool isLoading = false;
  Key bannerKey = UniqueKey();

  int? couponNum;

  int limitNum = 1;

  String? bannerCode;

  String? activityNo;

  static const String _keyNewInstallCoupon = "key_new_install_coupon";
  static const String _keyLoginDialogState = "key_login_dialog_state";

  @override
  void initState() {
    super.initState();

    _getActivityNo();

    _loginDialogState();
  }

  @override
  Widget build(BuildContext context) {

    logI('in new build  showDialog ---- $showDialog');

    return BlocListener<UserBloc, UserState>(
      listenWhen: (p, c) => p.status != UserStatus.loggedIn && c.status == UserStatus.loggedIn,
      listener: (context, state) => _getActivityNo(),
      child: BlocListener<ConfigBloc, ConfigState>(
        listenWhen: (p, c) => true,
        listener: (context, state) => _getActivityNo(),
        child: Column(
          children: [
            /// 登录提示的广告位
            _loginDialog(),

            /// 领取成功提示的广告位们
            ..._buildActivityList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActivityList() {
    List<Widget> list = [];

    if (activityList == null || activityList!.isEmpty || !Constant.hasLogin) {
      return list;
    }

    for (InstallationActivity activity in activityList!) {
      NewInstallActivity activityWidget = NewInstallActivity(activity: activity);
      list.add(activityWidget);
    }
    return list;
  }

  Widget _loginDialog() {
    if (showDialog) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _changeDialogState();
      });
    }

    return showDialog
        ? ABiteBanner(
            key: UniqueKey(),
            bannerParam: BannerParam(
              'cotti-app-firstLaunch',
              isNoCache: true,
              viewPage: "cotti-app-home",
              memberId: GlobalBlocs.get<UserBloc>(UserBloc.blocName).state.userModel?.memberId,
            ),
          )
        : const SizedBox();
  }

  List<InstallationActivity>? activityList;

  _getActivityNo() {
    activityList = GlobalBlocs.get<ConfigBloc>(ConfigBloc.blocName)
        .state
        .configEntity
        ?.installationActivityList;

    // _loginDialogState();
    setState(() {});
  }

  _loginDialogState() async {
    await SharedPreferences.getInstance().then((prefs) {
      if (!prefs.containsKey(_keyLoginDialogState)) {
        showDialog = true;
      } else {
        showDialog = prefs.getBool(_keyLoginDialogState) ?? true;
      }

      logI('in _loginDialogState showDialog === $showDialog');

      setState(() {});
    });
  }

  _changeDialogState() async {
    logI('in _changeDialogState !!!!!');
    showDialog = false;
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(_keyLoginDialogState, false);
    });
  }
}
