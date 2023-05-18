import 'package:abitelogin/abitelogin.dart';
import 'package:abitelogin/pages/login/bloc/login_bloc.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/config/env.dart';
import 'package:cotti_client/config/env_config.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_event.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/routers/web_view_router.dart';
import 'package:cotti_client/sensors/mine_sensors_constant.dart';
import 'package:cotti_client/service/push/jpush_wrapper.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/dialog/common_dialog.dart';
import 'package:cotti_client/widget/horizontail_divider.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/12 7:15 PM
class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late List _children;

  @override
  void initState() {
    super.initState();
    _children = _listItem();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      title: '设置',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: Colors.white,
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) => _children[index],
              separatorBuilder: (context, index) => HorizontalDivider(
                dividerColor: CottiColor.dividerGray,
                dividerHeight: .5.h,
                dividerMargin: EdgeInsets.only(left: 22.w, right: 28.w),
              ),
              itemCount: _children.length,
            ),
          ),
          _buildLogout(),
        ],
      ),
    );
  }

  List<Widget> _listItem() {
    List<Widget> list = [];
    list.add(InkWell(
      onTap: () => _toAccountSecurityPage(),
      child: _buildItem("账号与安全"),
    ));
    list.add(InkWell(
      onTap: () {
        SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.priceIllustrateClick, {});
        NavigatorUtils.push(
          context,
          WebViewRouter.webView,
          params: {'url': '${Env.currentEnvConfig.h5}/#/price'},
        );
      },
      child: _buildItem("价格说明"),
    ));
    list.add(InkWell(
      onTap: () {
        SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.aboutusClick, {});
        NavigatorUtils.push(context, MineRouter.aboutPage);
      },
      child: _buildItem("关于我们"),
    ));
    if (Env.currentEnvConfig.envName != EnvConfig.prod) {
      list.add(
        InkWell(
          onTap: () {
            NavigatorUtils.push(context, MineRouter.virtualSettings);
          },
          child: _buildItem("虚拟设置"),
        ),
      );
    }
    return list;
  }

  Widget _buildItem(String name) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 10.w, 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: CottiColor.textBlack,
              fontSize: 14.sp,
            ),
            strutStyle: const StrutStyle(
              leading: 0,
              forceStrutHeight: true,
              leadingDistribution: TextLeadingDistribution.proportional,
            ),
          ),
          Icon(
            IconFont.icon_right,
            size: 20.w,
            color: CottiColor.textGray,
          ),
        ],
      ),
    );
  }

  Widget _buildLogout() {
    return BlocConsumer<UserBloc, UserState>(
      listenWhen: (previous, current) {
        return previous.status == UserStatus.loggedIn && current.status == UserStatus.loggedOut;
      },
      listener: (context, state) {
        context.read<ShopMatchBloc>().add(DeleteTakeAddressEvent());
        context.read<ShoppingCartBloc>().add(ClearCartEvent());
        JPushWrapper().clear();
        NavigatorUtils.pop(context);
      },
      builder: (context, state) {
        if (state.status != UserStatus.loggedIn) {
          return const SizedBox();
        }
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Container(
              height: 64.h,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              child: GestureDetector(
                onTap: () => _showDialog(context),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: CottiColor.primeColor,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4.r)),
                  ),
                  child: Text(
                    '退出登录',
                    style: TextStyle(
                      color: CottiColor.primeColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _toAccountSecurityPage() {
    SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.idSecurityPageClick, {});
    if (Constant.hasLogin) {
      NavigatorUtils.push(context, MineRouter.accountSecurityPage);
    } else {
      LoginUtils.login(context).then((value) {
        if (Constant.hasLogin) {
          NavigatorUtils.push(context, MineRouter.accountSecurityPage);
        }
      });
    }
  }

  _showDialog(context) {
    SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.signoutClick, {});
    CommonDialog.show(
      context,
      content: '退出登录将无法收取到消息通知\n是否确认退出？',
      mainButtonName: '确认',
      subButtonName: '取消',
    ).then((value) {
      if (value == 1) {
        SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.confirmSignoutClick, {});
        LoginBloc().add(LoginOutEvent());
      }
    });
  }
}
