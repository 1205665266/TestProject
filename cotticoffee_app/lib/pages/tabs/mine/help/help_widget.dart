import 'package:abitelogin/pages/util/login_utils.dart';
import 'package:abitelogin/router/login_router.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/entity/config_entity.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/help/bloc/help_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/help/offwork_widget.dart';
import 'package:cotti_client/sensors/mine_sensors_constant.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class HelpSheet extends StatelessWidget {
  String? shopPhone;
  ConfigBloc? cBloc;
  OrderDetailModel? orderDetailModel;

  HelpSheet({Key? key, this.shopPhone, this.orderDetailModel}) : super(key: key);

  final HelpBloc _bloc = HelpBloc();

  static show(BuildContext context, {String? shopPhone, OrderDetailModel? orderDetailModel}) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        logI('shopPhone in show $shopPhone');
        return HelpSheet(
          shopPhone: shopPhone,
          orderDetailModel: orderDetailModel,
        );
      },
    );
  }

  @override
  StatelessElement createElement() {
    logI('shopPhone in createElement $shopPhone');
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = context.read<ConfigBloc>();
    ConfigEntity? e = configBloc.state.configEntity;

    cBloc = configBloc;

    logI('ConfigEntity === ${e?.customerServiceHotline}');
    double height = 0;

    List<Widget> list = <Widget>[];

    /// 根据配置判断是否显示客服电话
    if (e?.customerServiceHotline != null) {
      list.add(
        _buildPhoneLine(context: context, configEntity: e),
      );
      height += 55.h;
      list.add(
        SizedBox(
          height: 1.h,
        ),
      );
      height += 1.h;
    }

    list.add(
      _buildServiceLine(context: context),
    );
    height += 55.h;
    list.add(
      SizedBox(
        height: 8.h,
      ),
    );

    height += 8.h;

    list.add(
      _buildCanlceLine(context: context),
    );

    height += 55.h;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.r),
        topRight: Radius.circular(8.r),
      ),
      child: Container(
        height: height,
        color: CottiColor.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: list,
        ),
      ),
    );
  }

  Widget _buildServiceLine({required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        logI('on line Service !!');
        SensorsAnalyticsFlutterPlugin.track(
            MineSensorsConstant.onlineServantServantHelpMineClick, {});
        _hiden(context);
        _toOnlineService();
        SensorsAnalyticsFlutterPlugin.track(
            OrderSensorsConstant.onlineServantServantOrderDetailClick,
            {"order_state": orderDetailModel?.orderStatusStr?.statusStr});
      },
      child: Container(
        color: Colors.white,
        height: 55.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.network(
              'https://cdn-orderupload-prod.yummy.tech:443/mine_service_help.svg',
              width: 24.w,
              height: 24.w,
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              "在线客服",
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: 17.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCanlceLine({required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        logI('on canlce !!');
        _hiden(context);
      },
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        height: 55.h,
        child: Text(
          "取消",
          style: TextStyle(
            color: Color(0xff333333),
            fontSize: 17.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneLine({required BuildContext context, ConfigEntity? configEntity}) {
    return GestureDetector(
      onTap: () {
        logI('on phone !!');

        SensorsAnalyticsFlutterPlugin.track(MineSensorsConstant.servantHelp400MineClick, {});

        ConfigBloc cBloc = GlobalBlocs.get(ConfigBloc.blocName);

        if (shopPhone != null || cBloc.state.judgeInsideServiceTime) {
          PhoneCallEvent phoneCallEvent = PhoneCallEvent(context: context, phoneNum: _showPhone());
          _bloc.add(phoneCallEvent);
          _hiden(context);
        } else {
          logI('//todo:显示 非工作时间');
          _hiden(context);
          OffWorkDialog.show(context);
        }
        SensorsAnalyticsFlutterPlugin.track(
            OrderSensorsConstant.phoneServantServantOrderDetailClick,
            {"order_state": orderDetailModel?.orderStatusStr?.statusStr});
      },
      child: Container(
        color: Colors.white,
        height: 55.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.network(
              'https://cdn-product-prod.yummy.tech/wechat/cotti/images/mine/mine_line_help.svg',
              width: 24.w,
              height: 24.w,
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              _showPhone(),
              style: TextStyle(
                color: const Color(0xff333333),
                fontSize: 17.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _hiden(BuildContext context) {
    Navigator.of(context).pop();
  }

  String _showPhone() {
    if (cBloc?.state.configEntity?.customerServiceHotline != null && (cBloc!.state.judgeInsideServiceTime || shopPhone == null)) {
      return cBloc!.state.configEntity!.customerServiceHotline!;
    }
    return shopPhone??'';
  }

  _toOnlineService() {
    if (LoginRouter.navigatorKey.currentContext != null) {}

    if (Constant.hasLogin) {
      _bloc.add(OnlineServiceEvent(
          context: LoginRouter.navigatorKey.currentContext!, orderDetailModel: orderDetailModel));
    } else {
      LoginUtils.login(LoginRouter.navigatorKey.currentContext!).then((value) {
        if (Constant.hasLogin) {
          _bloc.add(OnlineServiceEvent(
              context: LoginRouter.navigatorKey.currentContext!,
              orderDetailModel: orderDetailModel));
        }
      });
    }
  }
}
