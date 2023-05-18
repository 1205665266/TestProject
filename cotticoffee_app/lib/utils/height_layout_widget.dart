

import 'package:flutter/cupertino.dart';

class HeightLayoutWidget extends StatefulWidget {

  final Widget child;

  final ValueChanged<double> heightCallBack;

  const HeightLayoutWidget({Key? key, required this.child,required this.heightCallBack}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HeightLayoutWidgetState();
  }

}

class _HeightLayoutWidgetState extends State<HeightLayoutWidget> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        double height = renderBox.size.height;
        widget.heightCallBack(height);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

}