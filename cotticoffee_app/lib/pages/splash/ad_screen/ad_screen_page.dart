import 'dart:async';

import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/pages/splash/ad_screen/ad_screen_bloc.dart';
import 'package:cotti_client/routers/tab_router.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/24 22:26
class AdScreenWidget extends StatefulWidget {
  const AdScreenWidget({Key? key}) : super(key: key);

  @override
  State<AdScreenWidget> createState() => _AdScreenWidgetState();
}

class _AdScreenWidgetState extends State<AdScreenWidget> {
  final AdScreenBloc _bloc = AdScreenBloc();
  Timer? _timer;
  late int countDown = 3;
  late ConfigBloc configBloc;
  bool isSkip = false;

  @override
  void initState() {
    super.initState();
    configBloc = context.read<ConfigBloc>();
    _bloc.add(AdScreenEvent('cotti-launch-page-banner'));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      showAppBar: false,
      child: BlocConsumer<AdScreenBloc, AdScreenState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state.isSkip) {
            _skip();
          }
          countDown = configBloc.state.configEntity?.openingScreenCountdown ?? 3;
          _startContDown();
        },
        builder: (context, state) {
          if (state.banners.isEmpty) {
            return const SizedBox();
          }
          return Stack(
            children: [
              ABiteBanner(
                banners: state.banners,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
              ),
              _buildSkip(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSkip() {
    return Positioned(
      bottom: 24.h,
      right: 24.w,
      child: SafeArea(
        child: GestureDetector(
          onTap: _skip,
          child: Container(
            height: 27.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
              color: const Color(0xFFCBCBCB).withOpacity(0.3),
            ),
            child: Row(
              children: [
                Container(
                  constraints: BoxConstraints(minWidth: 9.w),
                  child: Text(
                    '$countDown',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                    ),
                    strutStyle: const StrutStyle(forceStrutHeight: true),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '跳过',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                  ),
                  strutStyle: const StrutStyle(forceStrutHeight: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _startContDown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countDown--;
      setState(() {});
      if (countDown == 0) {
        _skip();
      }
    });
  }

  _skip() {
    if (!isSkip) {
      isSkip = true;
      NavigatorUtils.pop(context);
      NavigatorUtils.push(
        context,
        TabRouter.tabPage,
        transition: TransitionType.custom,
        transitionDuration: const Duration(milliseconds: 600),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _bloc.close();
    _timer?.cancel();
    super.dispose();
  }
}
