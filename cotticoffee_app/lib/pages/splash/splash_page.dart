import 'dart:io';

import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/pages/splash/init_platform.dart';
import 'package:cotti_client/pages/splash/view/privacy_policy_view.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/8/30 5:36 下午
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      showAppBar: false,
      child: Stack(
        children: [
          CottiImageWidget(
            'https://cdn-product-prod.yummy.tech/wechat/cotti/images/cotti_open_1.jpg',
            imgW: 0,
            imgH: 0,
          ),
          Container(
            color: Colors.white,
            child: PrivacyPolicyView(
              callBack: (result) => _checkPrivacyAgreement(result),
            ),
          ),
        ],
      ),
    );
  }

  _checkPrivacyAgreement(bool result) async {
    if (result) {
      await InitPlatform.initPlatform();
      SensorsAnalyticsFlutterPlugin.trackAppInstall();
      if (Constant.hasLogin) {
        int? memberId = context.read<UserBloc>().state.userModel?.memberId;
        if (memberId != null) {
          SensorsAnalyticsFlutterPlugin.login("$memberId");
        }
      } else {
        SensorsAnalyticsFlutterPlugin.registerSuperProperties({"member_type": '未登录'});
      }
      NavigatorUtils.push(
        context,
        CommonPageRouter.adScreenPage,
        replace: true,
        transition: TransitionType.custom,
        transitionDuration: const Duration(milliseconds: 600),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          if (animation.status == AnimationStatus.reverse) {
            return ScaleTransition(
              scale: Tween<double>(
                begin: 1.5,
                end: 1,
              ).animate(animation),
              child: child,
            );
          } else {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.7, end: 1).animate(animation),
              child: child,
            );
          }
        },
      );
    } else {
      exit(0);
    }
  }
}
