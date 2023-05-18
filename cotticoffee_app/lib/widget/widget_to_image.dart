import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

/// FileName widget_to_image
///
/// Description:组件转图片
/// 返回3种类型  1.Uint8List流 2.Base64编码
/// Author: 乔
/// Date: 2022/4/6
class WidgetToImage extends StatefulWidget {
  // 自定义水印
  final Widget? waterText;

  //  一般是图片
  final Widget? child;

  // 水印的位置 - child不为空时失效 默认右下角
  final Alignment alignment;

  // 图片路径 - child不为空时失效 默认为空
  final String imagePath;

  // 水印文本 - waterText不为空时失效
  final String imageStr;

  // 水印文本颜色 - waterText不为空时失效 默认红色
  final Color stringColor;

  // 水印文本大小 - waterText不为空时失效 默认14
  final double stringSize;

  // 组件的key
  final GlobalKey globalKeys;

  //  图片背景色 - 默认白色
  final Color bgColor;

  final BoxFit boxFit;

  const WidgetToImage({
    Key? key,
    this.boxFit = BoxFit.cover,
    this.alignment = Alignment.bottomRight,
    this.waterText,
    this.child,
    this.imagePath = '',
    required this.globalKeys,
    this.imageStr = '',
    this.stringColor = Colors.red,
    this.stringSize = 14,
    this.bgColor = Colors.white,
  }) : super(key: key);

  @override
  _WidgetToImageState createState() => _WidgetToImageState();
}

class _WidgetToImageState extends State<WidgetToImage> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.globalKeys,
      child: Container(
        color: widget.bgColor,
        child: Stack(
          alignment: widget.alignment,
          children: <Widget>[
            widget.child ?? imageWidget(widget.imagePath),
            widget.waterText ??
                Text(
                  widget.imageStr,
                  style: TextStyle(fontSize: widget.stringSize, color: widget.stringColor),
                ),
          ],
        ),
      ),
    );
  }

  Widget imageWidget(String imagePath) {
    if (imagePath.startsWith("http://") || imagePath.startsWith("https://")) {
      return Image.network(
        imagePath,
        fit: widget.boxFit,
      );
    } else if (imagePath.startsWith("file:")) {
      return Image.file(
        File(imagePath),
        fit: widget.boxFit,
      );
    } else {
      return Image.asset(
        imagePath,
        fit: widget.boxFit,
      );
    }
  }
}

// 单例 用于获取图片
class GetWidgetToImage {
  GetWidgetToImage._();

  // 获取unit8
  static Future<Uint8List> getUint8List(GlobalKey globalKeys) async {
    RenderRepaintBoundary? boundary =
        globalKeys.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    ui.Image? image = await boundary?.toImage(
      pixelRatio: window.devicePixelRatio,
    );
    ByteData? byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List() ?? Uint8List.fromList([]);
  }

  // 返回Base64流
  static Future<String> getByte64(GlobalKey globalKeys) async {
    return base64Encode(await getUint8List(globalKeys));
  }

  static Future<String> createFileFromString(String base64Str) async {
    Uint8List bytes = base64.decode(base64Str);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
