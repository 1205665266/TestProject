import 'dart:async';

import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_head.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/bloc/menu_state.dart';
import 'package:cotti_client/sensors/menu_sensors_constant.dart';
import 'package:cotti_client/widget/mini_label_widget.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import '../bloc/menu_bloc.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/15 10:15 AM
class MenuLeftWidget extends StatefulWidget {
  final Function(num) clickItemCallBack;
  final ValueNotifier? selectIndexNotifier;

  const MenuLeftWidget({Key? key, required this.clickItemCallBack, this.selectIndexNotifier})
      : super(key: key);

  @override
  State<MenuLeftWidget> createState() => _MenuLeftWidgetState();
}

class _MenuLeftWidgetState extends State<MenuLeftWidget> {
  int selectIndex = 0;
  late List<MenuHead> menuHeads;
  int argumentsTimeStamp = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.selectIndexNotifier?.addListener(_selectIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MenuBloc, MenuState>(
      listenWhen: (previous, current) {
        GlobalState state = GlobalBlocs.get<GlobalBloc>(GlobalBloc.blocName).state;
        return state.argumentsTimeStamp != argumentsTimeStamp &&
            previous.menuUpdateTimeStamp != current.menuUpdateTimeStamp;
      },
      listener: (context, state) {
        Map? map = GlobalBlocs.get<GlobalBloc>(GlobalBloc.blocName).state.arguments;
        if (map != null) {
          String? jumpCode = map['code'];
          if (jumpCode != null) {
            argumentsTimeStamp =
                GlobalBlocs.get<GlobalBloc>(GlobalBloc.blocName).state.argumentsTimeStamp;
            _jumpSecondLevel(jumpCode, state.menuHeads);
          }
        }
      },
      buildWhen: (previous, current) => previous.menuUpdateTimeStamp != current.menuUpdateTimeStamp,
      builder: (context, state) {
        menuHeads = state.menuHeads;
        return Container(
          width: 75.w,
          color: Colors.white,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: _buildLine(),
              ),
              _buildList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 58.h),
      itemCount: menuHeads.length,
      itemBuilder: (context, index) {
        return _buildItem(index);
      },
    );
  }

  Widget _buildItem(int index) {
    String name = (menuHeads[index].headInfo.name?.replaceAll(r"\n", "\n") ?? '').trim();
    return InkWell(
      onTap: () => setState(() {
        MenuHead menuHead = menuHeads[index];
        widget.selectIndexNotifier?.value = menuHead.key;
        widget.clickItemCallBack(menuHead.key);
        SensorsAnalyticsFlutterPlugin.track(MenuSensorsConstant.menuSecondListItemClick, {
          "second_name": name,
          "second_code": menuHeads[index].headInfo.id,
        });
      }),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: index == selectIndex
                  ? Border(right: BorderSide(width: 1.5.w, color: CottiColor.primeColor))
                  : Border(right: BorderSide(width: 1.5.w, color: Colors.transparent)),
            ),
            padding: name.contains("\n") && (menuHeads[index].headInfo.tagUrl ?? '').isNotEmpty
                ? EdgeInsets.fromLTRB(5.w, 22.h, 5.w, 10.h)
                : EdgeInsets.symmetric(horizontal: 5.w, vertical: 16.h),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: index == selectIndex ? FontWeight.bold : FontWeight.normal,
                color: index == selectIndex ? CottiColor.textBlack : CottiColor.textGray,
              ),
            ),
          ),
          Positioned(
            right: 1.w,
            child: MiniLabelWidget(
              label: menuHeads[index].headInfo.tagUrl,
              textPadding: EdgeInsets.symmetric(horizontal: 2.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      width: 1.w,
      height: double.infinity,
      color: const Color(0xFFE9E9E9),
    );
  }

  _selectIndex() {
    int value = widget.selectIndexNotifier?.value;
    int? indexWhere = menuHeads.indexWhere((element) => element.key == value);
    if (indexWhere > -1) {
      selectIndex = indexWhere;
      setState(() {});
    }
  }

  _jumpSecondLevel(String jumpCode, List<MenuHead> menuHeads) {
    List<String> params = jumpCode.split(r'/');
    if (params.length > 1 && params.first == '2') {
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 10), () {
        int index = 0;
        for (var element in menuHeads) {
          if (element.headInfo.id == params[1]) {
            break;
          }
          index++;
        }
        if (index < menuHeads.length) {
          MenuHead menuHead = menuHeads[index];
          widget.selectIndexNotifier?.value = menuHead.key;
          widget.clickItemCallBack(menuHead.key);
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.selectIndexNotifier?.removeListener(_selectIndex);
    _timer?.cancel();
  }
}
