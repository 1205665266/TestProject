import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapCenterIcon extends StatefulWidget {
  final IconController iconController;

  const MapCenterIcon({Key? key, required this.iconController}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MapCenterIconState();
  }
}

class _MapCenterIconState extends State<MapCenterIcon> with TickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.ease);

    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    _animationController.addListener(() {
      // logW("_animation --- ${_animation.value}");
      if (mounted) {
        setState(() {});
      }
    });

    _animationController.addStatusListener((status) {
      logW("status 111 ---- $status");
      if (AnimationStatus.completed == status) {
        if (mounted) {
          setState(() {});
        }
      }
    });
    widget.iconController.animationController = _animationController;
    widget.iconController.callback = () {
      logW("in iconController callback -- ${widget.iconController.moved}");
      if (mounted) {
        // setState(() {});
      }
    };
  }

  @override
  void dispose() {
    logW("dispose dispose !!!!");
    if (_animationController != null) {
      widget.iconController.animationController = null;
      _animationController.removeListener(() {});
      _animationController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double radius = 11.w;
    double ovalWidth = 22.w * 0.8;
    double ovalHeight = ovalWidth / 2;
    double moveD = (0 - (37.h - radius * 2) * 2 - ovalHeight) * 0.5;
    double progress = _animation.value;
    double dropLen = moveD * progress;
    double riseLen = moveD * (1 - progress);

    double y = progress < -0.5 ? dropLen : riseLen;
    y = dropLen;

    y = _animationController.isAnimating ? y : (widget.iconController.moved ? moveD : 0);

    // y = widget.iconController.moved? moveD:y;

    return Transform.translate(
      offset: Offset(0.0, y),
      child: SvgPicture.network(
        'https://cdn-product-prod.yummy.tech/wechat/cotti/images/CD4444/map_center_lon_1.svg',
        width: 22.w,
        height: 37.h,
      ),
    );
  }
}

class IconController {
  AnimationController? animationController;

  bool moved = false;

  IconController();

  VoidCallback? callback;

  void begain() {
    moved = false;
    animationController?.reset();
    animationController?.forward();
  }

  void moveUp() {
    if (animationController?.isAnimating ?? false) {
      return;
    }
    moved = true;

    if (callback != null) {
      callback!();
    }
  }
}
