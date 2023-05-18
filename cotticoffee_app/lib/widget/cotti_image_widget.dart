import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// FileName: ABiteImageWidget
///
/// Description: 图片组件，支持默认占位，圆角，不同质量的压缩
/// Author: yapeng.zhu@abite.com
/// Date: 2021/12/4
class CottiImageWidget extends StatelessWidget {
  ///网络图片地址，必传参数
  final String url;

  ///图片的宽度
  final double? imgW;

  ///图片的高度
  final double? imgH;

  ///占位图本地路径
  final String? defImagePath;

  ///图片显示模式
  final BoxFit? fit;

  ///调整图片大小， resize = "w_500"
  String? resize;

  ///调整图片质量
  final String? quality;

  ///图片格式
  final String? format;

  ///图片的圆角
  final BorderRadius? borderRadius;

  ///默认的图片显示模式
  BoxFit defaultFit;

  ///默认圆角
  final BorderRadius defaultRadius = const BorderRadius.all(Radius.circular(0));

  ///是否需要压缩图片
  final bool isCompress;

  final Duration fadeInDuration;

  final Duration fadeOutDuration;

  CottiImageWidget(
    this.url, {
    Key? key,
    this.defaultFit = BoxFit.fill,
    this.imgW,
    this.imgH,
    this.defImagePath,
    this.fit,
    this.borderRadius,
    this.quality = "q_50", //默认压缩50%
    this.format = "webp", //默认图片格式为webp
    this.fadeInDuration = const Duration(milliseconds: 0),
    this.fadeOutDuration = const Duration(milliseconds: 0),
    this.isCompress = true,
    this.resize,
  }) : super(key: key);

  Widget _placeHolderWidget(BuildContext context, String url) {
    return Container(
      height: imgH,
      width: imgW,
      decoration: BoxDecoration(
        color: const Color(0xF0F0F0F0),
        borderRadius: borderRadius ?? defaultRadius,
      ),
    );
  }

  ///图片加载错误组件，显示默认占位
  ///
  Widget _errorWidget(_, __, ___) {
    return _bg(_, __);
  }

  ///处理图片质量，大小，格式
  ///
  /// [url] 图片地址
  String _compress(String url) {
    bool isSvg = url.endsWith('svg');
    if (!isCompress || isSvg) {
      return url;
    } else if (resize != null) {
      ///判断是否需要长宽压缩
      return "$url?x-image-process=image/resize,$resize,limit_0/quality,$quality/format,$format";
    } else {
      ///默认使用质量压缩
      return "$url?x-image-process=image/quality,$quality/format,$format";
    }
  }

  Widget _bg(_, __) {
    return Container(
      height: imgH,
      width: imgW,
      decoration: BoxDecoration(
        color: const Color(0xF0F0F0F0),
        borderRadius: borderRadius ?? defaultRadius,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? defaultRadius,
      child: url.isEmpty ? _bg(null, null) : _buildCacheImage(),
    );
  }

  _buildCacheImage() {
    String newUrl = _compress(url);
    if (newUrl.endsWith('.svg')) {
      return SvgPicture.network(newUrl);
    }
    return CachedNetworkImage(
      imageUrl: newUrl,
      height: imgH,
      width: imgW,
      fit: fit ?? defaultFit,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      placeholder: _bg,
      errorWidget: _errorWidget,
    );
  }
}
