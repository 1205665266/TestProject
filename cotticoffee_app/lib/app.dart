import 'package:abitelogin/router/login_router.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/dialog_show_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotticommon/bloc/user_bloc.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'pages/splash/splash_page.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/8/30 5:28 下午
class CottiCoffeeApp extends StatelessWidget {
  static final RouteObserver<PageRoute> routeObserver = RouteObserver();

  const CottiCoffeeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: () => MaterialApp(
          navigatorObservers: [routeObserver],
          navigatorKey: LoginRouter.navigatorKey,
          title: "库迪咖啡",
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh', 'CN'),
            Locale('en', 'US'),
          ],
          home: const SplashPage(),
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<ConfigBloc>(
                    create: (BuildContext context) =>
                        GlobalBlocs.get(ConfigBloc.blocName)..add(GetConfigEvent()),
                  ),
                  BlocProvider<UserBloc>(
                    create: (BuildContext context) => GlobalBlocs.get(UserBloc.blocName),
                  ),
                  BlocProvider<ShopMatchBloc>(
                    create: (BuildContext context) => ShopMatchBloc(),
                  ),
                  BlocProvider<ShoppingCartBloc>(
                    create: (BuildContext context) => ShoppingCartBloc(),
                  ),
                  BlocProvider<MineBloc>(
                    create: (BuildContext context) => MineBloc(),
                  ),
                  BlocProvider<DialogShowBloc>(
                    create: (BuildContext context) => DialogShowBloc(),
                  ),
                ],
                child: widget!,
              ),
            );
          }),
    );
  }
}
