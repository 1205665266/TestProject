import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_head.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rect_getter/rect_getter.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/17 10:27
class SubHeadList extends StatefulWidget {
  final MenuHead? menuHead;
  final Function(int?, int?)? onTapCallBack;
  final ValueNotifier subHeadFirstKeyNotifier;
  final bool isNotSelect;

  const SubHeadList({
    Key? key,
    required this.menuHead,
    required this.subHeadFirstKeyNotifier,
    this.isNotSelect = true,
    this.onTapCallBack,
  }) : super(key: key);

  @override
  State<SubHeadList> createState() => _SubHeadListState();
}

class _SubHeadListState extends State<SubHeadList> {
  late ScrollController _controller;
  late GlobalKey<RectGetterState> _listViewKey;
  final Map<int, GlobalKey<RectGetterState>> _keys = {};

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _listViewKey = RectGetter.createGlobalKey();
    widget.subHeadFirstKeyNotifier.addListener(_keyNotifier);
  }

  _keyNotifier() {
    int index = widget.menuHead?.secondHead
            .indexWhere((element) => element.key == widget.subHeadFirstKeyNotifier.value) ??
        -1;
    if (index > -1) {
      _visiblePosition(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.menuHead != null &&
        widget.menuHead!.secondHead.isEmpty &&
        widget.menuHead!.secondHeadKey != null) {
      return const SizedBox();
    }
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 3.h),
      height: 30.h,
      width: 300.w,
      alignment: Alignment.center,
      child: ListView.separated(
        key: _listViewKey,
        padding: EdgeInsets.zero,
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _buildItem(widget.menuHead!.secondHead[index], index);
        },
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemCount: widget.menuHead?.secondHead.length ?? 0,
      ),
    );
  }

  _buildItem(MenuHead head, int index) {
    bool isSelect = head.key == widget.subHeadFirstKeyNotifier.value && !widget.isNotSelect;
    if (_keys[index] == null) {
      _keys[index] = RectGetter.createGlobalKey();
    }
    return GestureDetector(
      key: _keys[index],
      onTap: () {
        if (widget.onTapCallBack != null) {
          widget.onTapCallBack!(head.key, widget.menuHead?.headInfo.key);
          widget.subHeadFirstKeyNotifier.value = head.key;
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: isSelect ? const Color(0xFFFBE7E5) : Colors.white,
          borderRadius: BorderRadius.circular(2.r),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 7.w),
          decoration: isSelect
              ? null
              : UnderlineTabIndicator(
                  borderSide: BorderSide(width: 0.5.w, color: const Color(0xFF5E6164)),
                  insets: EdgeInsets.symmetric(horizontal: 12.w),
                ),
          child: Text(
            "${StringUtil.removeWrap(head.headInfo.name)} (${head.headInfo.items?.length})",
            style: TextStyle(
                fontSize: 12.sp,
                color: isSelect ? CottiColor.primeColor : const Color(0xFF5E6164),
                fontWeight: isSelect ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'DDP4'),
          ),
        ),
      ),
    );
  }

//检查item是否在可视位置
  _visiblePosition(int index) {
    Rect? listRect = RectGetter.getRectFromKey(_listViewKey);
    Rect? itemRect;
    if (_keys[index] != null) {
      itemRect = RectGetter.getRectFromKey(_keys[index]!);
    }
    if (listRect != null && itemRect != null) {
      double offset = .0;
      if (itemRect.left < listRect.left) {
        offset = itemRect.left - listRect.left;
      }
      if (itemRect.right > listRect.right) {
        offset = itemRect.right - listRect.right;
      }

      offset = _controller.offset + offset;
      offset = offset > _controller.position.maxScrollExtent
          ? _controller.position.maxScrollExtent
          : offset;
      _controller.animateTo(
        offset,
        duration: const Duration(milliseconds: 40),
        curve: Curves.ease,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.subHeadFirstKeyNotifier.removeListener(_keyNotifier);
  }
}
