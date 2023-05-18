import 'dart:io';

import 'package:abitelogin/login_registrar.dart';
import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/routers/main_router.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:cotticommon/module/module_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'global/bloc/config_bloc.dart';

void main() {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ));
  }
  realRunApp();
}

void realRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  MainRouter.init();
  GlobalBlocs.add({ConfigBloc.blocName: ConfigBloc()});
  GlobalBlocs.add({UserBloc.blocName: UserBloc()});
  GlobalBlocs.add({GlobalBloc.blocName: GlobalBloc()});
  ModuleManager().register(LoginRegistrar()..setClient(CottiNetWork()));
  runApp(const CottiCoffeeApp());
}
