import 'dart:async';

import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/14 10:54
class ScrollDesc extends StatefulWidget {
  final List<Widget> descList;

  const ScrollDesc({Key? key, required this.descList}) : super(key: key);

  @override
  State<ScrollDesc> createState() => _ScrollDescState();
}

class _ScrollDescState extends State<ScrollDesc> with WidgetsBindingObserver {
  double end = 0;
  Timer? _timer;
  final double height = 18.h;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _startPoll();
    });
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.descList.isEmpty) {
      return const SizedBox();
    }
    return SizedBox(
      height: height,
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 450),
        tween: Tween(end: end),
        builder: (BuildContext context, double value, Widget? child) {
          final whole = value ~/ 1;
          final decimal = value - whole;
          int currentIndex = whole % widget.descList.length;
          int nextIndex = (whole + 1) % widget.descList.length;
          return Stack(
            children: [
              Positioned(
                top: -height * decimal,
                child: widget.descList[currentIndex],
              ),
              Positioned(
                top: height * (1 - decimal),
                child: widget.descList[nextIndex],
              ),
            ],
          );
        },
      ),
    );
  }

  _startPoll() {
    if (widget.descList.length > 1) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 2500), (_) {
        if (mounted) {
          setState(() => end++);
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.resumed == state) {
      _startPoll();
    } else if (AppLifecycleState.paused == state) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
