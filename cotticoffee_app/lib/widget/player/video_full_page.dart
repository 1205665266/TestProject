import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import 'cotti_video_player.dart';
import 'config.dart';

/// FileName: video_full_page
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/2/16
class VideoFullPage extends StatefulWidget {
  const VideoFullPage({
    Key? key,
    this.url,
    this.controller,
    this.eventName,
  }) : super(key: key);
  final String? url;
  final VideoPlayerController? controller;
  final String? eventName;

  @override
  _VideoFullPageState createState() => _VideoFullPageState();
}

class _VideoFullPageState extends State<VideoFullPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CottiVideoPlayer(
        url: widget.url,
        width: double.infinity,
        height: double.infinity,
        controller: widget.controller,
        config: Config.copy(
          stopWidth: 70.w,
          stopHeight: 70.h,
          voiceWidth: 28.w,
          voiceHeight: 28.h,
          fullWidth: 28.w,
          fullHeight: 28.h,
          uiMargin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 42.h),
        ),
        isFull: true,
      ),
    );
  }
}
