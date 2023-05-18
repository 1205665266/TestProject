

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CottiTabbar extends StatefulWidget {

  final Function(int) onTap;
  final TextStyle labelStyle;
  final TextStyle unselectedLabelStyle;
  final Decoration indicator;
  final TabController tabController;
  final List<String> tabs;
  const CottiTabbar(
      this.onTap,
      this.labelStyle,
      this.unselectedLabelStyle,
      this.indicator,
      this.tabController,
      this.tabs,
      {Key? key}) : super(key: key);

  @override
  State<CottiTabbar> createState() => _CottiTabbarState();
}

class _CottiTabbarState extends State<CottiTabbar> {

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (index) {
        widget.onTap(index);
        setState(() {
          currentIndex = index;
        });
      },
      labelPadding: EdgeInsets.only( bottom: 14.h),
      indicator: widget.indicator,
      controller: widget.tabController,
      tabs: List.generate(
        widget.tabs.length,
            (index) => Text(
          widget.tabs[index],
          style: currentIndex == index ? widget.labelStyle : widget.unselectedLabelStyle,
        ),
      ),
    );
  }
}
