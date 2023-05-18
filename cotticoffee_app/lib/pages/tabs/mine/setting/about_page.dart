import 'dart:io';

import 'package:cotti_client/config/env.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/routers/web_view_router.dart';
import 'package:cotti_client/sensors/mine_sensors_constant.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/12 8:04 PM
class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      packageInfo = await PackageInfo.fromPlatform();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      title: '关于我们',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildVersionInfo(),
            _buildBusinessLicense(),
            SizedBox(height: 12.h),
            _buildAgreement(),
            const Expanded(flex: 1, child: SizedBox()),
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Text(
                  'Copyright © 库迪科技（天津）有限公司',
                  style: TextStyle(
                    color: CottiColor.textHint,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Column(
      children: [
        SizedBox(height: 24.h),
        SvgPicture.asset(
          'assets/images/mine/ic_login_big.svg',
          width: 100.w,
          height: 100.h,
          fit: BoxFit.fill,
        ),
        SizedBox(height: 8.h),
        Text(
          Platform.isIOS
              ? "V${packageInfo?.version}(${packageInfo?.buildNumber})"
              : "V${packageInfo?.version}(${const String.fromEnvironment("BUILDNO", defaultValue: "Run")})",
          style: TextStyle(color: CottiColor.textGray, fontSize: 14.sp),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildAgreement() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.aboutusUseAgreementClick, {});
              NavigatorUtils.push(
                context,
                WebViewRouter.webView,
                params: {'url': '${Env.currentEnvConfig.h5}/#/service'},
              );
            },
            child: _buildItem('用户使用协议'),
          ),
          Container(
            height: 0.5.h,
            color: Colors.white,
            padding: EdgeInsets.only(
              left: 22.w,
              right: 28.w,
            ),
            child: Container(
              color: CottiColor.dividerGray,
            ),
          ),
          InkWell(
            onTap: () {
              SensorsAnalyticsFlutterPlugin.track(
                  MineSensorsConstant.aboutusPrivacyAgreementClick, {});
              NavigatorUtils.push(
                context,
                WebViewRouter.webView,
                params: {'url': '${Env.currentEnvConfig.h5}/#/privacy'},
              );
            },
            child: _buildItem('用户隐私协议'),
          ),
        ],
      ),
    );
  }

  _buildBusinessLicense() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: InkWell(
        onTap: () {
          SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.businessLicenseClick, {});
          NavigatorUtils.push(context, MineRouter.licensePage);
        },
        child: _buildItem("经营证照"),
      ),
    );
  }

  Widget _buildItem(String name) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 14.w,right: 10.w),
      height: 55.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(color: CottiColor.textBlack, fontSize: 14.sp),
            strutStyle: const StrutStyle(
              leading: 0,
              forceStrutHeight: true,
              leadingDistribution: TextLeadingDistribution.proportional,
            ),
          ),
          Icon(
            IconFont.icon_right,
            size: 20.w,
          ),
        ],
      ),
    );
  }
}
