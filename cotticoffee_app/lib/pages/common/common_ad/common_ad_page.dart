import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common_ad_bloc.dart';

/// Description: 通用广告位
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/26 09:30
class CommonAdPage extends StatefulWidget {
  final String adCode;
  final String shareCode;

  const CommonAdPage({Key? key, required this.adCode, required this.shareCode}) : super(key: key);

  @override
  State<CommonAdPage> createState() => _CommonAdPageState();
}

class _CommonAdPageState extends State<CommonAdPage> {
  final CommonAdBloc _bloc = CommonAdBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(CommonAdEvent(widget.adCode, widget.shareCode));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommonAdBloc, CommonAdState>(
      bloc: _bloc,
      builder: (context, state) {
        return CustomPageWidget(
          showAppBar: false,
          showLoading: state.showLoading,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    state.adList.length,
                    (index) => ABiteBanner(
                      width: MediaQuery.of(context).size.width,
                      banners: [state.adList[index]],
                      resize: true,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 17.w,
                top: 50.h,
                child: GestureDetector(
                  onTap: () => NavigatorUtils.pop(context),
                  child: Container(
                    width: 34.w,
                    height: 34.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25.r)),
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: const Color(0xFF979797).withOpacity(0.2)),
                    ),
                    child: Icon(
                      IconFont.icon_close,
                      size: 24.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }
}
