import 'package:flutter/material.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/8 17:02
class BoxMoveAnimation extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final ValueNotifier<bool>? animationChange;
  final bool initShow;

  const BoxMoveAnimation({
    Key? key,
    required this.child,
    this.duration,
    this.animationChange,
    this.initShow = false,
  }) : super(key: key);

  @override
  State<BoxMoveAnimation> createState() => _BoxMoveAnimationState();
}

class _BoxMoveAnimationState extends State<BoxMoveAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 200),
      vsync: this,
    );
    if (widget.initShow) {
      _animation = Tween(begin: Offset.zero, end: const Offset(0.0, 1.0)).animate(_controller);
    } else {
      _animation = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(_controller);
    }
    widget.animationChange?.addListener(_open);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SlideTransition(
        position: _animation,
        child: widget.child,
      ),
    );
  }

  _open() {
    if (widget.animationChange!.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.animationChange?.removeListener(_open);
    super.dispose();
  }
}
