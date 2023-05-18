import 'package:flutter/material.dart';

/// FileName: loading_video
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/25
class Loading extends StatefulWidget {
  Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double angle = 0;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 600));
    _animation = Tween<double>(begin: 0.0, end: 360.0).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      alignment: Alignment.center,
      turns: _animation,
      child: Image.asset("assets/images/my_video_player/ic_loading_video.png"),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
