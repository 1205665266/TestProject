import 'package:flutter/material.dart';

/// ////////////////////////////////////////////
/// @Author: Jianzhong Cai
/// @Date: 2022/3/8 下午3:33
/// @Email: jianzhong.cai@ucarinc.com
/// @Description:
/// /////////////////////////////////////////////

class DottedLine extends StatelessWidget {
  const DottedLine({
    Key? key,
    this.axis = Axis.horizontal,
    this.count = 10,
    this.color = Colors.grey,
    this.dashedWidth = 1,
    this.dashedHeight = 1,
  }) : super(key: key);

  final Axis axis;
  final int count;
  final Color color;
  final double dashedWidth;
  final double dashedHeight;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: axis,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(count, (_) {
        return SizedBox(
          width: dashedWidth,
          height: dashedHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color),
          ),
        );
      }),
    );
  }
}
