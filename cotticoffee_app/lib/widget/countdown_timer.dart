import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/3/9 10:21 上午
class CountDownTimer extends StatefulWidget {
  const CountDownTimer({
    Key? key,
    this.notifier,
    this.callback,
    this.format = "mm:ss",
    this.textStyle,
  }) : super(key: key);
  final VoidCallback? callback;
  final ValueNotifier<int>? notifier;

  ///"HH:mm:ss" | "mm:ss" | "ss"
  final String format;
  final TextStyle? textStyle;

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> with WidgetsBindingObserver {
  Timer? _countdownTimer;
  int _seconds = 0;
  late TextStyle _textStyle;
  int pauseTime = 0;

  @override
  void initState() {
    super.initState();
    _textStyle = widget.textStyle ??
        TextStyle(
          color: const Color(0xFFFF6A39),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        );
    widget.notifier?.addListener(_notifier);
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _durationTransform(_seconds),
      // strutStyle: const StrutStyle(forceStrutHeight: true),
      style: _textStyle,
    );
  }

  _notifier() {
    _seconds = widget.notifier?.value ?? 0;
    _countdown();
  }

  _countdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds--;
      if (_seconds < 0) {
        _seconds = 0;
      }
      if (_seconds == 0) {
        _countdownTimer?.cancel();
        if (widget.callback != null) {
          widget.callback!();
        }
      }
      setState(() {});
    });
    setState(() {});
  }

  String _durationTransform(int seconds) {
    if (seconds < 0){
      seconds = 0;
    }
    Duration d = Duration(seconds: seconds);
    return _comFormat(d, widget.format);
  }

  String _comFormat(Duration d, String format) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    if (format.contains("s")) {
      if (format.contains("m")) {
        format =
            format.replaceAll("ss", twoDigits(d.inSeconds.remainder(Duration.secondsPerMinute)));
      } else {
        format = format.replaceAll("ss", twoDigits(d.inSeconds));
      }
    }
    if (format.contains("m")) {
      if (format.contains("H")) {
        format = format.replaceAll("mm", twoDigits(d.inMinutes.remainder(Duration.minutesPerHour)));
      } else {
        format = format.replaceAll("mm", twoDigits(d.inMinutes));
      }
    }
    if (format.contains("H")) {
      format = format.replaceAll("HH", twoDigits(d.inHours));
    }
    return format;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      int nowTime = DateTime.now().millisecondsSinceEpoch;
      if (pauseTime > 0) {
        int diff = (nowTime - pauseTime) ~/ 1000;
        _seconds -= diff;
        if(_seconds < 0){
          _seconds = 0;
        }
        pauseTime = 0;
      }
      _countdown();
    }
    if (state == AppLifecycleState.paused) {
      _countdownTimer?.cancel();
      pauseTime = DateTime.now().millisecondsSinceEpoch;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _countdownTimer?.cancel();
    widget.notifier?.removeListener(_notifier);
    WidgetsBinding.instance?.removeObserver(this);
  }
}
