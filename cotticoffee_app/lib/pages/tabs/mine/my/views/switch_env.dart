import 'dart:io';

import 'package:abitelogin/pages/login/bloc/login_bloc.dart';
import 'package:cotti_client/config/env.dart';
import 'package:cotti_client/config/env_config.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/19 2:47 PM
class SwitchEnvWidget extends StatefulWidget {
  const SwitchEnvWidget({Key? key}) : super(key: key);

  @override
  State<SwitchEnvWidget> createState() => _SwitchEnvWidgetState();
}

class _SwitchEnvWidgetState extends State<SwitchEnvWidget> {
  List<Map> envs = [
    {'envTitle': "开发", 'env': EnvConfig.debug},
    {'envTitle': "测试", 'env': EnvConfig.test},
    {'envTitle': "预生产", 'env': EnvConfig.pre},
    {'envTitle': "生产", 'env': EnvConfig.prod},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CottiColor.circular),
      ),
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.only(left: 7.w),
      child: _buildItem(Icons.alternate_email, '切换环境'),
    );
  }

  Widget _buildItem(IconData iconData, String title) {
    return InkWell(
      onTap: () => show(),
      child: Container(
        height: 54.h,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 10.w, right: 4.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  size: 16.w,
                ),
                Container(
                  margin: EdgeInsets.only(left: 12.w),
                  child: Text(
                    title,
                    style: TextStyle(color: CottiColor.textBlack, fontSize: 14.sp),
                    strutStyle: StrutStyle(
                      forceStrutHeight: true,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
            Icon(
              IconFont.icon_right,
              size: 20.w,
              color: CottiColor.textGray,
            ),
          ],
        ),
      ),
    );
  }

  show() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(24.w),
          height: 320.h,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: const Text('切换环境'),
              ),
              Container(color: CottiColor.dividerGray, height: 1.h),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    String currEnv = Env.currentEnvConfig.envName;
                    bool isSelected = envs[index]['env'] == currEnv;
                    return ListTile(
                      onTap: () => _switch(index),
                      leading: Icon(
                        isSelected ? IconFont.icon_select : IconFont.icon_unselect,
                        size: 16.w,
                        color: isSelected ? CottiColor.primeColor : Colors.grey.shade500,
                      ),
                      title: Text(envs[index]['envTitle']),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(color: CottiColor.dividerGray, height: 1.h);
                  },
                  itemCount: envs.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _switch(int index) async {
    String currEnv = Env.currentEnvConfig.envName;
    if (currEnv != envs[index]['env']) {
      bool isLogin = GlobalBlocs.get<UserBloc>(UserBloc.blocName).isLogin;
      if (isLogin) {
        LoginBloc().add(LoginOutEvent());
      }
      SpUtil.clear();
      await SpUtil.putString(Env.keyEnv, envs[index]['env']);
      await Future.delayed(const Duration(milliseconds: 200));
      exit(0);
    }
  }
}
