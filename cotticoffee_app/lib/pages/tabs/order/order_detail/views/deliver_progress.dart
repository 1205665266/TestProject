

import 'dart:math';

import 'package:cotti_client/global/style.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

class DeliverProgress extends StatefulWidget {

  double radius;
  double progress = 0;

  DeliverProgress({Key? key, required this.radius, required this.progress}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DeliverProgressState();

}

class DeliverProgressState extends State<DeliverProgress> {


  ui.Image? startImage;

  CustomPaint? customPaint;

  @override
  void initState() {
    super.initState();


    load("assets/images/order/order_detail/icon_order_progress_end.png").then((value) {
      startImage = value;
      logI("加载完毕$value");
      setState(() {

      });
    });


  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: startImage == null ? Container() : CustomPaint(
        painter: _CircularProgressIndicatorPainter(startImage: startImage!, radius: widget.radius, progress: widget.progress),
      ),
    );
  }

  Future<ui.Image> load(String path) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),targetWidth: 300,targetHeight: 300);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

}

class _CircularProgressIndicatorPainter extends CustomPainter {

  double radius;
  double progress;

  ui.Image startImage;

  _CircularProgressIndicatorPainter({required this.startImage, required this.radius, required this.progress});


  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = CottiColor.primeColor..style = PaintingStyle.stroke..strokeWidth = 5.w;
    Paint backgroundPaint = Paint()..color = const Color(0xFFFBE7E5)..style = PaintingStyle.stroke..strokeWidth = 5.w;


    canvas.drawCircle(Offset(radius, radius), radius, backgroundPaint);


    var angle = progress * 360.0;
    double radians = angle * (pi / 180.0);
    double dx = radius - radius * sin(radians) - 14.w;
    double dy = radius + radius * cos(radians) - 14.w;
    // 绘制当前进度
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), pi / 2, radians, false, paint);

    Paint startCircleOutPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    Paint startCircleInnerPaint = Paint()..color = CottiColor.primeColor..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, 110.w), 7.w, startCircleOutPaint);
    canvas.drawCircle(Offset(radius, 110.w), 5.w, startCircleInnerPaint);
    // 绘制图片
    var src = Rect.fromLTWH(0, 0, startImage.width.toDouble(), startImage.height.toDouble());


    canvas.drawImageRect(startImage, src, Rect.fromLTWH(dx, dy, 28.w, 28.w), paint);


  }



  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {

    return true;
  }

}