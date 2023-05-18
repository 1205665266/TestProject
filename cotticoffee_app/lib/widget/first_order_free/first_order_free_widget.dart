import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/pages/tabs/tab_page.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'first_order_free_bloc.dart';
import 'first_order_free_event.dart';
import 'first_order_free_state.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/27 10:57
class FirstOrderFreeWidget extends StatefulWidget {
  final TabEnum? tabEnum;
  final double contextSize;
  final Function(bool)? showCallBack;
  final bool display;
  final EdgeInsets? padding;
  final String iconTriangle;

  const FirstOrderFreeWidget({
    Key? key,
    this.tabEnum,
    required this.contextSize,
    required this.iconTriangle,
    this.showCallBack,
    this.display = true,
    this.padding,
  }) : super(key: key);

  @override
  State<FirstOrderFreeWidget> createState() => _FirstOrderFreeWidgetState();
}

class _FirstOrderFreeWidgetState extends State<FirstOrderFreeWidget> {
  final FirstOrderFreeBloc _bloc = FirstOrderFreeBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _update());
  }

  void _update() {
    UserState userState = context.read<UserBloc>().state;
    if (userState.status == UserStatus.loggedIn && userState.userModel?.isNewMember == true) {
      _bloc.add(CheckMemberFirstOrderFree());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalBloc, GlobalState>(
      bloc: GlobalBlocs.get(GlobalBloc.blocName),
      listener: (context, globalState) {
        if (widget.tabEnum?.index == globalState.tabIndex) {
          _update();
        }
      },
      child: BlocBuilder<FirstOrderFreeBloc, FirstOrderFreeState>(
        bloc: _bloc,
        builder: (context, firstOrderFreeState) {
          return BlocConsumer<UserBloc, UserState>(
            listenWhen: (p, c) =>
                p.status != UserStatus.loggedIn &&
                c.status == UserStatus.loggedIn &&
                c.userModel?.isNewMember == true,
            listener: (context, state) => _bloc.add(CheckMemberFirstOrderFree()),
            builder: (context, state) {
              return BlocBuilder<ConfigBloc, ConfigState>(
                builder: (context, configState) {
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    if (widget.showCallBack != null) {
                      widget.showCallBack!(isShow(state, configState));
                    }
                  });
                  return Offstage(
                    offstage: !(isShow(state, configState) && widget.display),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: widget.padding,
                          decoration: BoxDecoration(
                            color: const Color(0xFFBDAB9A),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(2.w),
                              topRight: Radius.circular(2.w),
                              bottomLeft: Radius.circular(2.w),
                            ),
                          ),
                          child: Text(
                            configState.firstOrderFreeShippingMsg,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.contextSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5.w,
                            ),
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                              height: 1,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: -4.w,
                          child: SvgPicture.asset(
                            widget.iconTriangle,
                            width: 4.w,
                            height: 4.w,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  bool isShow(UserState state, ConfigState configState) {
    if (!configState.freeSwitch || configState.firstOrderFreeShippingMsg.isEmpty) {
      return false;
    }
    if (state.status != UserStatus.loggedIn) {
      return true;
    }
    if (state.userModel?.isNewMember == false) {
      return false;
    }
    return _bloc.state.firstOrderFreeDeliveryFee;
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }
}
