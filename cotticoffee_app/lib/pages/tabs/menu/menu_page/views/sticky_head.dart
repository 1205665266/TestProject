import 'dart:convert';

import 'package:cotti_client/pages/tabs/menu/entity/menu_head.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/views/first_head.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/views/sub_head_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rect_getter/rect_getter.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/16 14:59
class StickyHead extends StatefulWidget {
  final Widget child;
  final ValueNotifier<FirstHeadInfo?> valueNotifier;
  final ValueNotifier subHeadFirstKeyNotifier;
  final GlobalKey<RectGetterState> listKey;
  final Function(int?, int?)? onTapCallBack;
  final ScrollController controller;

  const StickyHead({
    Key? key,
    required this.child,
    required this.valueNotifier,
    required this.listKey,
    required this.subHeadFirstKeyNotifier,
    required this.controller,
    this.onTapCallBack,
  }) : super(key: key);

  @override
  State<StickyHead> createState() => _StickyHeadState();
}

class _StickyHeadState extends State<StickyHead> {
  final stickyHeadKey = RectGetter.createGlobalKey();
  final headKey = RectGetter.createGlobalKey();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.valueNotifier,
      builder: (BuildContext context, value, Widget? child) {
        MenuHead? head = widget.valueNotifier.value?.firstMenu;
        double top = 0;
        bool showSubHead = false;
        if (widget.valueNotifier.value?.firstHeadKey != null) {
          //一级item
          Rect? listHeadRect = RectGetter.getRectFromKey(widget.valueNotifier.value!.firstHeadKey!);
          //整个列表尺寸
          Rect? listRect = RectGetter.getRectFromKey(widget.listKey);
          //一级item底部，距离列表顶部的高度
          top = (listHeadRect?.bottom ?? 0) - (listRect?.top ?? 0);
          //当前整个粘性头部高度
          Rect? stickyHeadRect = RectGetter.getRectFromKey(stickyHeadKey);
          double headHeight = (stickyHeadRect?.bottom ?? 0) - (stickyHeadRect?.top ?? 0);
          if (widget.valueNotifier.value?.subHeadListKey != null) {
            //粘性头head
            Rect? headRect = RectGetter.getRectFromKey(headKey);
            Rect? subListHeadRect =
                RectGetter.getRectFromKey(widget.valueNotifier.value!.subHeadListKey!);
            showSubHead = (subListHeadRect?.top ?? 0) < (headRect?.bottom ?? 0);
          }
          if (top > headHeight) {
            top = 0;
          } else {
            top = top - headHeight;
          }
          double scrollViewOffset = widget.controller.offset;
          if (scrollViewOffset < 0) {
            top = scrollViewOffset.abs();
          }
        }
        return Stack(
          children: [
            widget.child,
            Visibility(
              visible: head != null,
              child: Positioned(
                top: top,
                child: Container(
                  color: Colors.white,
                  width: 300.w,
                  padding: EdgeInsets.only(left: 12.w, right: 4.w),
                  child: Column(
                    key: stickyHeadKey,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FirstHead(key: headKey, menuHead: head),
                      Visibility(
                        visible: showSubHead,
                        child: SubHeadList(
                          menuHead: head,
                          onTapCallBack: widget.onTapCallBack,
                          subHeadFirstKeyNotifier: widget.subHeadFirstKeyNotifier,
                          isNotSelect: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -1.h,
              child: Container(
                color: Colors.white,
                width: 300.w,
                height: 1.5.h,
              ),
            ),
          ],
        );
      },
    );
  }
}

class FirstHeadInfo {
  GlobalKey<RectGetterState>? subHeadListKey;
  GlobalKey<RectGetterState>? firstHeadKey;
  MenuHead? firstMenu;

  FirstHeadInfo(this.firstHeadKey, this.firstMenu, this.subHeadListKey);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
