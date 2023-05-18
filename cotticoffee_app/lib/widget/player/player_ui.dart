import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
import 'package:video_player/video_player.dart';

import '../cotti_image_widget.dart';
import 'config.dart';
import 'video_full_page.dart';

/// FileName: PlayerUi
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/2/15
class PlayerUi extends StatefulWidget {
  const PlayerUi(
      {Key? key,
      required this.config,
      required this.controller,
      required this.isFull,
      this.switchCallBack,
      this.fullStopCallBack,
      this.eventName})
      : super(key: key);

  final Config config;
  final VideoPlayerController controller;
  final bool isFull;
  final String? eventName;
  final Function()? switchCallBack;
  final Function(bool)? fullStopCallBack;

  @override
  _PlayerUiState createState() => _PlayerUiState();
}

class _PlayerUiState extends State<PlayerUi> {
  final String videoStop = "assets/images/my_video_player/ic_video_stop.png";
  final String videoStart = "assets/images/my_video_player/ic_video_start.png";
  final String fullScreen = "assets/images/my_video_player/ic_video_full_screen.svg";
  final String shrink = "assets/images/my_video_player/ic_video_shrink.svg";
  final String voice = "assets/images/my_video_player/ic_video_voice.svg";
  final String closeVoice = "assets/images/my_video_player/ic_video_close_voice.svg";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayControl,
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Align(child: _cover()),
            _videoControlIcon(),
            _bottomControl(),
          ],
        ),
      ),
    );
  }

  Widget _cover() {
    return Visibility(
      visible: widget.controller.value.position == const Duration(seconds: 0) &&
          !widget.controller.value.isPlaying &&
          widget.config.coverUrl != null,
      child: CottiImageWidget(
        widget.config.coverUrl ?? '',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _videoControlIcon() {
    return Offstage(
      offstage: widget.controller.value.isPlaying,
      child: Center(
        child: SizedBox(
          width: widget.config.stopWidth,
          height: widget.config.stopHeight,
          child: IconButton(
            onPressed: _togglePlayControl,
            icon: Image.asset(
              widget.controller.value.isPlaying ? videoStart : videoStop,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomControl() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: widget.config.uiMargin ?? EdgeInsets.zero,
            child: InkWell(
              onTap: () {
                if (widget.controller.value.volume == 0) {
                  widget.controller.setVolume(1);
                } else {
                  widget.controller.setVolume(0);
                }
                setState(() {});
                SensorsAnalyticsFlutterPlugin.track(
                    "${widget.eventName}_${widget.isFull ? 'IsFull' : 'Small'}_Volume",
                    {"volume": widget.controller.value.volume});
              },
              child: Padding(
                padding: widget.config.uiPadding ?? EdgeInsets.zero,
                child: SvgPicture.asset(
                  widget.controller.value.volume == 0 ? closeVoice : voice,
                  width: widget.config.voiceWidth,
                  height: widget.config.voiceHeight,
                ),
              ),
            ),
          ),
          Container(
            margin: widget.config.uiMargin ?? EdgeInsets.zero,
            child: InkWell(
              onTap: () {
                SensorsAnalyticsFlutterPlugin.track(
                    "${widget.eventName}_${widget.isFull ? 'Small' : 'Large'}_Full", null);
                if (widget.isFull) {
                  Navigator.pop(context);
                } else {
                  if (widget.fullStopCallBack != null &&
                      (widget.config.secondUrl?.isEmpty ?? true)) {
                    widget.fullStopCallBack!(false);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoFullPage(
                        url: widget.config.secondUrl,
                        controller: (widget.config.secondUrl?.isNotEmpty ?? false)
                            ? null
                            : widget.controller,
                        eventName: widget.eventName,
                      ),
                    ),
                  ).then((value) {
                    if (widget.fullStopCallBack != null) {
                      widget.fullStopCallBack!(true);
                    }
                    setState(() {});
                  });
                }
              },
              child: Padding(
                padding: widget.config.uiPadding ?? EdgeInsets.zero,
                child: SvgPicture.asset(
                  widget.isFull ? shrink : fullScreen,
                  width: widget.config.fullWidth,
                  height: widget.config.fullHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _togglePlayControl() async {
    if (widget.controller.value.isPlaying) {
      await widget.controller.pause();
    } else {
      await widget.controller.play();
    }
    if (widget.switchCallBack != null) {
      widget.switchCallBack!();
    }
    setState(() {});
  }
}
