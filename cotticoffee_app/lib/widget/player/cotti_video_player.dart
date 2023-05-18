import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'config.dart';
import 'loading.dart';
import 'player_ui.dart';
import 'video_full_page.dart';

/// FileName: abite_video_player
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/2/15
class CottiVideoPlayer extends StatefulWidget {
  final String? url;
  final double width;
  final double height;
  final VideoPlayerController? controller;

  ///是否打开声音，false关闭 true打开
  final bool isVolume;

  ///是否自动播放，默认自动播放
  final bool isPlaying;

  ///是否是全屏，true 是，默认不是
  final bool isFull;

  Config? config;
  SeekToNotifier? seekToNotifier;

  final Function(bool)? isPlayingCallBack;

  CottiVideoPlayer({
    Key? key,
    this.url,
    required this.width,
    required this.height,
    this.controller,
    this.config,
    this.isVolume = false,
    this.isPlaying = true,
    this.isFull = false,
    this.seekToNotifier,
    this.isPlayingCallBack,
  }) : super(key: key);

  @override
  _CottiVideoPlayerState createState() => _CottiVideoPlayerState();
}

class _CottiVideoPlayerState extends State<CottiVideoPlayer> with WidgetsBindingObserver {
  final UniqueKey _localKey = UniqueKey();
  bool _videoInit = false;
  bool _videoError = false;
  bool lifeChangeStop = false;
  bool _isVisibilityPlay = true;

  ///全屏时检测不到组件是否暂停
  bool isFullStop = true;
  VideoPlayerController? _controller;
  late Config _config;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    widget.seekToNotifier?.addListener(_seekTo);
    _config = widget.config ?? Config.defaultConfig();
    if (widget.url?.isNotEmpty ?? false || widget.controller != null) {
      _initUrl();
    }
    super.initState();
  }

  void _initUrl() async {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    setState(() {
      _videoInit = false;
      _videoError = false;
    });
    if (widget.controller == null) {
      _controller = VideoPlayerController.network(widget.url!);
      _controller!.initialize().then(
            (value) => setState(
              () {
                _videoInit = true;
                _videoError = false;
                if (!widget.isVolume) {
                  _controller!.setVolume(0);
                }
              },
            ),
          );
    } else {
      _controller = widget.controller;
      _videoInit = true;
      _videoError = false;
    }
    _controller!.addListener(_videoListener);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_config.radius ?? 0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          color: _config.videoColor ?? Colors.black,
          child: _isVideoInit(),
        ),
      ),
    );
  }

  Widget _isVideoInit() {
    ///如果没有视频地址，直接展示封面图
    if (widget.url?.isEmpty ?? true && widget.controller == null) {
      return InkWell(
        onTap: () {
          if (widget.config?.secondUrl?.isNotEmpty ?? false) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoFullPage(
                  url: widget.config?.secondUrl ?? '',
                ),
              ),
            );
          }
        },
        child: CottiImageWidget(
          widget.config?.coverUrl ?? '',
        ),
      );
    }
    if (_videoInit) {
      return Stack(
        alignment: Alignment.center,
        children: [
          VisibilityDetector(
            key: _localKey,
            onVisibilityChanged: (VisibilityInfo info) {
              if (info.visibleFraction == 0 && mounted) {
                _isVisibilityPlay = true;
                if (isFullStop) {
                  _controller?.pause();
                  setState(() {});
                }
              }
              if (info.visibleFraction == 1 && mounted) {
                if (widget.isPlaying && (!_controller!.value.isPlaying) && _isVisibilityPlay) {
                  _isVisibilityPlay = false;
                  _controller?.play();
                  setState(() {});
                }
              }
            },
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ),
          PlayerUi(
            controller: _controller!,
            config: _config,
            isFull: widget.isFull,
            fullStopCallBack: (call) => isFullStop = call,
          ),
        ],
      );
    } else if (_videoError) {
      return const Text(
        '加载出错',
        style: TextStyle(color: Colors.white),
      );
    } else {
      return SizedBox(
        width: _config.loadingWidth,
        height: _config.loadingHeight,
        child: Loading(),
      );
    }
  }

  void _videoListener() async {
    if (_controller!.value.hasError) {
      setState(() {
        _videoError = true;
      });
    } else {
      Duration? res = _controller!.value.position;
      if (res >= _controller!.value.duration &&
          _controller!.value.duration != const Duration(seconds: 0)) {
        await _controller!.seekTo(const Duration(seconds: 0));
        if (_controller!.value.isPlaying) {
          await _controller!.pause();
        }
        setState(() {});
      }
    }
    if (widget.isPlayingCallBack != null) {
      widget.isPlayingCallBack!(_controller?.value.isPlaying ?? false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (_controller?.value.isPlaying ?? false) {
        _controller?.pause();
        lifeChangeStop = true;
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null && !_controller!.value.isPlaying && lifeChangeStop) {
        _controller?.play();
        lifeChangeStop = false;
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  _seekTo() {
    if (widget.seekToNotifier?.value != -1) {
      if ((widget.seekToNotifier?.value ?? 0) > (_controller!.value.duration.inSeconds)) {
        _controller!.seekTo(_controller!.value.duration);
      } else {
        _controller!.seekTo(Duration(seconds: widget.seekToNotifier?.value ?? 0));
      }
    }
  }

  @override
  void dispose() async {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    widget.seekToNotifier?.removeListener(_seekTo);
    _controller?.removeListener(_videoListener);
    if (widget.controller == null) {
      _controller?.dispose();
    }
  }
}

class SeekToNotifier extends ValueNotifier<int> {
  SeekToNotifier(int value) : super(value);

  void seekTo(int seconds) {
    if (value == seconds) {
      value = -1;
    }
    value = seconds;
  }
}
