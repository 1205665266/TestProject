import 'dart:convert';

import 'package:abitelogin/abitelogin.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/config/env.dart';
import 'package:cotti_client/config/env_config.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/help/help_widget.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_state.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/sensors/mine_sensors_constant.dart';
import 'package:cotti_client/utils/scheme_dispatcher.dart';
import 'package:cotti_client/utils/share_util.dart';
import 'package:cotti_client/widget/banner/model/ad_sort_entity.dart';
import 'package:cotti_client/widget/banner/model/banner_model.dart';
import 'package:cotti_client/widget/horizontail_divider.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/11 6:04 PM
class FunctionList extends StatefulWidget {
  const FunctionList({Key? key}) : super(key: key);

  @override
  State<FunctionList> createState() => _FunctionListState();
}

class _FunctionListState extends State<FunctionList> {

  @override
  void initState() {
    super.initState();

    MineBloc mineBloc = context.read<MineBloc>();

    for(int i = 0;i < mineBloc.state.actionList.length;i++){
      AdSortEntity item = mineBloc.state.actionList[i];
      for(int j = 0;j < (item.list??[]).length;j++){
        BannerModel bannerModel = (item.list??[])[j];

        Map<String, dynamic> map = {
          "code":bannerModel.templateCode,
          "title":bannerModel.title,
          "subTitle":bannerModel.subTitle1,
          "positionCode":bannerModel.positionCode,
        };
        SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.mineMenuView, map);
      }
    }

  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<MineBloc, MineState>(
      builder: (context, state) {
        // logI("actionList == ${state.actionList}");
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){

              AdSortEntity adModel = state.actionList[index];

              return _buildFunctionGroup(adModel: adModel);
            },
          itemCount: state.actionList.length,
        );
      },
    );
  }

  Widget _buildFunctionGroup({required AdSortEntity adModel}) {
    List<Widget> widgets = _actionList(adModel: adModel);

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => widgets[index],
        separatorBuilder: (_, __) =>
            HorizontalDivider(
              dividerColor: CottiColor.dividerGray,
              dividerHeight: .5.h,
              dividerMargin: EdgeInsets.only(left: 42.w, right: 12.w),
            ),
        itemCount: widgets.length,
      ),
    );
  }

  Widget _buildItem({required BannerModel bannerModel}) {

    return Container(
      height: 56.h,
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      child: GestureDetector(
        onTap: () {
          itemAction(bannerModel: bannerModel);
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  bannerModel.url??"",
                  width: 36.w,
                  height: 36.w,
                  errorBuilder: (BuildContext context,Object error,StackTrace? stackTrace,){
                    return SizedBox(
                      width: 36.w,
                      height: 36.w,
                    );
                  },
                ),
                Container(
                  margin: EdgeInsets.only(left: 4.w),
                  child: Text(
                    bannerModel.title??"",
                    style: TextStyle(color: CottiColor.textBlack, fontSize: 14.sp,height: 1,),
                    strutStyle: const StrutStyle(
                      forceStrutHeight: true,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  bannerModel.subTitle1??"",
                  style: TextStyle(color: CottiColor.textGray, fontSize: 12.sp,height: 1,),
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 4.w),
                  child: Icon(
                    IconFont.icon_right,
                    size: 20.w,
                    color: CottiColor.textGray,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }

  List<Widget> _actionList({required AdSortEntity adModel}) {
    List<Widget> list = [];

    for(BannerModel bannerModel in adModel.list??[]){
      Widget item = _buildItem(bannerModel: bannerModel);
      list.add(item);
    }

    return list;
  }

  void itemAction({required BannerModel bannerModel}){

    String? redirectUrl = bannerModel.redirectUrl;

    // CouponInfoDialog.show(
    //   context,
    //   ValidateEntity(),
    //       () {});
    //
    // return;

    var map = {"code": bannerModel.templateCode,"title":bannerModel.title,"subTitle":bannerModel.subTitle1,"positionCode":bannerModel.positionCode};

    SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.mineMenuClick, map);

    if(redirectUrl?.isEmpty ?? true){
      return;
    }

    if(bannerModel.redirectUrl! == "url?popup=customer"){
      _gotoHelp();
    }else {
      SchemeDispatcher.dispatchPath(context, Uri.encodeQueryComponent(redirectUrl!));
    }

  }

  _gotoExchangeCoupon(String title) {
    if (Constant.hasLogin) {
      NavigatorUtils.push(context, MineRouter.exchangeCouponPage, params: {"title": title});
    } else {
      LoginUtils.login(context).then(
            (value) {
          if (Constant.hasLogin) {
            NavigatorUtils.push(context, MineRouter.exchangeCouponPage, params: {"title": title});
          }
        },
      );
    }
  }

  _gotoAddress() {
    SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.addressManageMineClick, {});
    if (Constant.hasLogin) {
      NavigatorUtils.push(
        context,
        CommonPageRouter.takeAddressListPage,
        params: {"isSelectTakeAddress": false},
      );
    } else {
      LoginUtils.login(context).then(
            (value) {
          if (Constant.hasLogin) {
            NavigatorUtils.push(
              context,
              CommonPageRouter.takeAddressListPage,
              params: {"isSelectTakeAddress": false},
            );
          }
        },
      );
    }
  }

  /// 跳转社群福利页面的方法。
  _gotoWelfare() {
    SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.communityBenefitsMineClick, {});
    EnvConfig envConfig = Env.currentEnvConfig;
    var h5url =
        "${envConfig
        .h5}/#/onlineqrcode?codebg=cotti-my-socialGroup-bg-banner-mp&codeqrcode=cotti-my-socialGroup-banner-mp";
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    h5url = stringToBase64Url.encode(h5url);
    logI('h5url === $h5url');
    var path = "/packages/activity/activityView/activityView?comp=1&url=$h5url";
    logI("path == $path");
    ShareUtil.openWeChatMiniProgram(path: path);
  }

  _gotoHelp() {
    logI('click 客服帮助');
    SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.helpMineClick, {});
    HelpSheet.show(context);
  }

  _gotoSystem() {
    SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.setUpMineClick, {});
    NavigatorUtils.push(context, MineRouter.settingPage);
  }

}
