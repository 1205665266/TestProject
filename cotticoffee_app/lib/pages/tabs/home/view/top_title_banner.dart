import 'package:cotti_client/pages/tabs/home/bloc/home_bloc.dart';
import 'package:cotti_client/pages/tabs/home/bloc/home_state.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/2 16:40
class TopTitleBanner extends StatefulWidget {
  final ValueNotifier<double> notifier;

  const TopTitleBanner({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  @override
  State<TopTitleBanner> createState() => _TopTitleBannerState();
}

class _TopTitleBannerState extends State<TopTitleBanner> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return _buildContent(state.headerBanner);
      },
    );
  }

  Widget _buildContent(List<BannerModel> headerBanner) {
    if (headerBanner.isEmpty) {
      return const SizedBox();
    }
    return ValueListenableBuilder<double>(
      valueListenable: widget.notifier,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0, 1),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            height: MediaQuery.of(context).padding.top + 44.h,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 20.w),
            child: ABiteBanner(
              banners: headerBanner,
              height: 32.h,
              fit: BoxFit.fitHeight,
              resize: true,
            ),
          ),
        );
      },
    );
  }
}
