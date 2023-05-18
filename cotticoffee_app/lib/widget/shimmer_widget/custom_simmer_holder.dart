import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/1/13 09:33
class CustomSimmerHolder extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const CustomSimmerHolder.rectangular({
    Key? key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(),
  }) : super(key: key);

  const CustomSimmerHolder.circular({
    Key? key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CottiColor.dividerGray,
      highlightColor: Colors.grey[300]!,
      period: const Duration(seconds: 2),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[400]!,
          shape: shapeBorder,
        ),
      ),
    );
  }
}
