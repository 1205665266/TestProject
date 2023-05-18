import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_event.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_state.dart';
import 'package:cotti_client/sensors/mine_sensors_constant.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/dialog/common_dialog.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/13 5:20 PM
class AccountSecurityPage extends StatefulWidget {
  const AccountSecurityPage({Key? key}) : super(key: key);

  @override
  State<AccountSecurityPage> createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> with WidgetsBindingObserver {
  bool? msgSwitch;

  bool? sysSwitch;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getmsgPer();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  getmsgPer() async {
    //获取当前的权限
    var status = await Permission.notification.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      sysSwitch = true;
    } else {
      sysSwitch = false;
    }
    setState(() {});
    logI('getmsgPer === $status');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MineBloc, MineState>(
      builder: (context, state) {
        return CustomPageWidget(
          title: '账户与安全',
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: Colors.white,
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 55.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '手机号码',
                        style: TextStyle(fontSize: 14.sp, color: CottiColor.textBlack),
                        strutStyle: const StrutStyle(
                          leading: 0,
                          forceStrutHeight: true,
                          leadingDistribution: TextLeadingDistribution.proportional,
                        ),
                      ),
                      Text(
                        StringUtil.mobilePhoneEncode(
                            GlobalBlocs.get<UserBloc>(UserBloc.blocName).state.userModel?.mobile),
                        style: TextStyle(fontSize: 14.sp, color: CottiColor.textBlack),
                        strutStyle: const StrutStyle(
                          leading: 0,
                          forceStrutHeight: true,
                          leadingDistribution: TextLeadingDistribution.proportional,
                        ),
                      ),
                    ],
                  ),
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
                Container(
                  height: 55.h,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '推送通知',
                        style: TextStyle(fontSize: 14.sp, color: CottiColor.textBlack),
                        strutStyle: const StrutStyle(
                          leading: 0,
                          forceStrutHeight: true,
                          leadingDistribution: TextLeadingDistribution.proportional,
                        ),
                      ),
                      Transform.scale(
                        scale: 0.6,
                        alignment: Alignment.centerRight,
                        child: CupertinoSwitch(
                          value: state.userInfoEntity?.appMessageSwitch != 1 && (sysSwitch ?? true),
                          activeColor: CottiColor.primeColor,
                          onChanged: (val) {
                            _appMessageSwitchAction(val, state);
                          },
                        ),
                      ),
                    ],
                  ),
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
                BlocBuilder<ConfigBloc, ConfigState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () => _cancellation(state.configEntity?.customerServiceHotline),
                      child: Container(
                        height: 55.h,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '注销账户',
                              style: TextStyle(fontSize: 14.sp, color: CottiColor.textBlack),
                              strutStyle: const StrutStyle(
                                leading: 0,
                                forceStrutHeight: true,
                                leadingDistribution: TextLeadingDistribution.proportional,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '注销后无法恢复，请谨慎操作',
                                  style: TextStyle(fontSize: 12.sp, color: CottiColor.textHint),
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _cancellation(String? customerServiceHotline) {
    SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.logoutClick, {});
    CommonDialog.show(
      context,
      title: "请联系人工客服，完成注销流程",
      content: "客服电话 $customerServiceHotline\n( 预计3-5个工作日内完成 )",
      mainButtonName: '确认拨号',
      subButtonName: '取消',
    ).then((value) {
      if (value == 1) {
        SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.confirmLogoutClick, {});
        launch('tel:$customerServiceHotline');
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (AppLifecycleState.resumed == state) {
      getmsgPer();
    }
  }

  _appMessageSwitchAction(val, MineState state) async {
    logI('_appMessageSwitchAction val = $val');

    /// 关闭通知，直接请求接口；
    if (!val) {
      context.read<MineBloc>().add(
            UpdatePersonInfoEvent(
              state.userInfoEntity?.nickname,
              state.userInfoEntity?.sex,
              state.userInfoEntity?.birthday,
              val ? 0 : 1,
            ),
          );
    } else {
      /// 系统权限出于关闭状态，请求权限、打开权限页面。
      if (!sysSwitch!) {
        PermissionStatus status = await Permission.notification.request();
        logI('Permission.notification.request === $status');
        if (status != PermissionStatus.granted) {
          /// 请求权限失败，打开设置页面；
          await openAppSettings();
        }
      }

      /// 修改后台开关状态；
      if (state.userInfoEntity?.appMessageSwitch == 1) {
        context.read<MineBloc>().add(
              UpdatePersonInfoEvent(
                state.userInfoEntity?.nickname,
                state.userInfoEntity?.sex,
                state.userInfoEntity?.birthday,
                val ? 0 : 1,
              ),
            );
      }
    }
  }
}
