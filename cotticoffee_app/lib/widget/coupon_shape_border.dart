/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/2 18:21
import 'dart:math';

import 'package:flutter/material.dart';

class CouponShapeBorder extends ShapeBorder {
  double circleSize; // 圆形直径

  CouponShapeBorder({
    this.circleSize = 12,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  _formHoldLeft(Path path, Rect rect) {
    path.addArc(
      Rect.fromCenter(
        center: Offset(0, rect.height / 2),
        width: circleSize,
        height: circleSize,
      ),
      pi * 3 / 2,
      pi,
    );
  }

  _formHoldRight(Path path, Rect rect) {
    path.addArc(
      Rect.fromCenter(
        center: Offset(rect.width, rect.height / 2),
        width: circleSize,
        height: circleSize,
      ),
      pi / 2,
      pi,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    throw UnimplementedError();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    var path = Path();
    path.addRect(rect);

    _formHoldLeft(path, rect);
    _formHoldRight(path, rect);
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    throw UnimplementedError();
  }
}
