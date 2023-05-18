import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/2 15:59
class CustomShapePainter extends CustomPainter {
  final List<Offset>? points;
  final Color paintColor;
  Paint? _paint;

  CustomShapePainter({
    this.points,
    this.paintColor = Colors.white,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    int index = 0;
    points?.forEach((element) {
      if (index == 0) {
        path.moveTo(element.dx, element.dy);
      } else if(index == 1){
        path.arcToPoint(element,radius: Radius.circular(4.r),);
      }else {
        path.lineTo(element.dx, element.dy);
      }
      index++;
    });
    _paint ??= Paint()
      ..color = paintColor //画笔颜色
      ..strokeCap = StrokeCap.round //画笔笔触类型（butt、round、square）
      ..isAntiAlias = true //是否启动抗锯齿
      ..style = PaintingStyle.fill //绘画风格，默认为填充
      ..filterQuality = FilterQuality.high;
    canvas.drawPath(path, _paint!);
  }
}
