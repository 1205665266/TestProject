import 'package:cotti_client/global/entity/config_entity.dart';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/widget/banner/model/banner_param.dart';
import 'package:cotti_client/widget/banner/widget/abite_banner.dart';
import 'package:cotticommon/bloc/user_bloc.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cotti_client/widget/banner/banner.dart';

class NewInstallActivity extends StatefulWidget {
  final InstallationActivity activity;

  const NewInstallActivity({Key? key, required this.activity}) : super(key: key);

  @override
  _NewInstallActivityState createState() {
    return _NewInstallActivityState();
  }
}

class _NewInstallActivityState extends State<NewInstallActivity> {
  bool showBanner = false;
  bool isLoading = false;
  int? couponNum;
  int limitNum = 1;
  Key bannerKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    // _getNewInstallCoupon();
  }

  @override
  Widget build(BuildContext context) {

    limitNum = widget.activity.installationActivityTimes??1;

    _getNewInstallCoupon();

    return BlocListener<UserBloc, UserState>(
      listenWhen: (p, c) => p.status != UserStatus.loggedIn && c.status == UserStatus.loggedIn,
      // listener: (context, state) => _getNewInstallCoupon(),
      listener: (context, state) {},
      child: _newInstallCoupon(),
    );
  }

  Widget _newInstallCoupon() {
    return (showBanner && widget.activity.installationActivityAdId != null && widget.activity.installationActivityAdId!.isNotEmpty)
        ? ABiteBanner(
            key: bannerKey,
            bannerParam: BannerParam(
              widget.activity.installationActivityAdId ?? '',
              viewPage: "cotti-app-home",
              memberId: GlobalBlocs.get<UserBloc>(UserBloc.blocName).state.userModel?.memberId,
            ),
          )
        : const SizedBox();
  }

  _getNewInstallCoupon() async {
    int? memberId = GlobalBlocs.get<UserBloc>(UserBloc.blocName).state.userModel?.memberId;
    if (memberId == null || isLoading) {
      return;
    }
    if (widget.activity.installationActivityNo == null ||
        widget.activity.installationActivityNo!.isEmpty) {
      return;
    }

    isLoading = true;

    await SharedPreferences.getInstance().then((prefs) {
      couponNum = prefs.getInt(widget.activity.installationActivityNo!);
    });

    if (couponNum != null && couponNum! >= limitNum) {
      /// 已经领过了，不再继续执行；
      /// 未获取代activityNo，不再继续执行；
      return;
    }

    String? mobile = GlobalBlocs.get<UserBloc>(UserBloc.blocName).state.userModel?.mobile;

    Map<String, dynamic> data = {
      /// 17663322786832384
      'activityNo': widget.activity.installationActivityNo!,
      'mobile': mobile ?? '',

      /// comeFrom 默认传4
      'comeFrom': '4',
      'openid': '',
    };

    await CottiNetWork()
        .post("/universal/coupon/receiveRewardH5", data: data, showToast: false)
        .then((value) {
      showBanner = value["status"] == 1;
      bannerKey = UniqueKey();

      if (showBanner) {
        setState(() {});
        setCouponNewAppNum();
      }
    }).catchError((onError) => logE(onError));

    isLoading = false;
  }

  setCouponNewAppNum() async {
    couponNum = (couponNum ?? 0) + 1;
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(widget.activity.installationActivityNo!, couponNum!);
    });
  }
}
