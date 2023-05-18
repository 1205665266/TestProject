import 'package:abitelogin/abitelogin.dart';
import 'package:cotticommon/bloc/user_event.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:dio/dio.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/6/7 4:13 下午
class LoginHeaderInterceptor extends Interceptor {
  bool isShowLogin = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String token = GlobalBlocs.get<UserBloc>(UserBloc.blocName).token;
    if (token.isNotEmpty) {
      options.headers.addAll({"token": token});
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final dynamic responseData = response.data;
    final int code = responseData['code'];
    if ([-110, -111].contains(code)) {
      if (!isShowLogin && LoginRouter.navigatorKey.currentContext != null) {
        GlobalBlocs.get(UserBloc.blocName).add(UserLogoutEvent());
        isShowLogin = true;
        LoginUtils.login(LoginRouter.navigatorKey.currentContext!)
            .then((value) => isShowLogin = false)
            .catchError((onError) => isShowLogin = false);
      }
    }
    handler.next(response);
  }
}
