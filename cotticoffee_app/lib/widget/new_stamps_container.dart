import 'package:flutter/material.dart';

/// FileName: new_stamps_container
///
/// Description: 新人券容器
/// Author: yapeng.zhu@abite.com
/// Date: 2022/1/17
class NewStampsContainer extends StatefulWidget {
  final Widget child;
  final ValueNotifier<bool>? animationNotifier;

  const NewStampsContainer({
    Key? key,
    required this.child,
    required this.animationNotifier,
  }) : super(key: key);

  @override
  _NewStampsContainerState createState() => _NewStampsContainerState();
}

class _NewStampsContainerState extends State<NewStampsContainer> with TickerProviderStateMixin {
  /// 平移动画 controller
  late AnimationController _translationController;

  /// 透明度动画 controller
  late AnimationController _fadeTransitionController;

  /// 透明度动画
  late Animation<double> _fadeTransitionAnimation;

  /// 平移动画
  late Animation<Offset> _translationAnimation;

  @override
  void initState() {
    super.initState();
    widget.animationNotifier?.addListener(animationChange);
    _initAni();
  }

  void _initAni() {
    _fadeTransitionController =
        AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fadeTransitionAnimation = Tween(begin: 1.0, end: 0.5)
        .animate(CurvedAnimation(parent: _fadeTransitionController, curve: Curves.easeInOutBack));

    _translationController =
        AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _translationAnimation = Tween(begin: Offset.zero, end: const Offset(0.9, 0))
        .animate(CurvedAnimation(parent: _translationController, curve: Curves.easeInOutBack));
  }

  void animationChange() {
    if (widget.animationNotifier!.value) {
      _translationController.forward();
      _fadeTransitionController.forward();
    } else {
      _translationController.reverse();
      _fadeTransitionController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _translationAnimation,
      child: FadeTransition(
        opacity: _fadeTransitionAnimation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    widget.animationNotifier?.removeListener(animationChange);
    _translationController.dispose();
    _fadeTransitionController.dispose();
    super.dispose();
  }
}
