import 'package:cotti_client/config/env.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/routers/web_view_router.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/12 10:27 PM
class LicensePage extends StatefulWidget {
  const LicensePage({Key? key}) : super(key: key);

  @override
  State<LicensePage> createState() => _LicensePageState();
}

class _LicensePageState extends State<LicensePage> {
  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      title: '经营证照',
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => NavigatorUtils.push(
                  context,
                  WebViewRouter.webView,
                  params: {'url': '${Env.currentEnvConfig.h5}/#/platform'},
                ),
                child: _buildItem("平台资质"),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: 22.w,
                  right: 28.w,
                ),
                child: Container(
                  height: 0.5.h,
                  color: CottiColor.dividerGray,
                ),
              ),
              InkWell(
                onTap: () => NavigatorUtils.push(
                  context,
                  MineRouter.shopLicensePage,
                ),
                child: _buildItem("门店资质"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String name) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 14.w, right: 10.w),
      height: 55.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              color: CottiColor.textBlack,
              fontSize: 14.sp,
              height: 1,
            ),
            strutStyle: const StrutStyle(
              leading: 0,
              forceStrutHeight: true,
              leadingDistribution: TextLeadingDistribution.proportional,
              // leading: 1,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '查看',
                strutStyle: const StrutStyle(
                  leading: 0,
                  forceStrutHeight: true,
                  leadingDistribution: TextLeadingDistribution.proportional,
                  // leading: 1,
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.2,
                  color: CottiColor.textGray,
                ),
              ),
              SvgPicture.asset(
                'assets/images/mine/ic_right_arrow.svg',
                height: 20.w,
                width: 20.w,
                color: CottiColor.textGray,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
