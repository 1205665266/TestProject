import 'dart:async';

import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/menu/search/entity/search_label.dart';
import 'package:cotticommon/router/fluro_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'customized_length_text_input_formatter.dart';

/// FileName: search_widget
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/15
class SearchItemWidget extends StatefulWidget {
  final String hideText;
  final String? value;
  final Function(String)? searchCallBack;
  final Function()? searchHideBack;
  final Function()? clearCallback;
  final InstallValue? installValue;
  final bool autofocus;

  const SearchItemWidget(
      {Key? key,
      required this.hideText,
      this.searchCallBack,
      this.searchHideBack,
      this.clearCallback,
      this.value,
      this.installValue,
      this.autofocus = false})
      : super(key: key);

  @override
  _SearchItemWidgetState createState() => _SearchItemWidgetState();
}

class _SearchItemWidgetState extends State<SearchItemWidget> {
  final TextEditingController _controller = TextEditingController();
  int inputTextLength = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.installValue?.addListener(_installValue);
  }

  void _installValue() {
    String input = widget.installValue?.value.labelText ?? "";
    _controller.value = TextEditingValue(
        text: input,
        selection: TextSelection.fromPosition(
            TextPosition(affinity: TextAffinity.downstream, offset: input.length)));
    setState(() {
      inputTextLength = widget.installValue?.value.labelText?.length ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 32.h,
      padding: EdgeInsets.only(left: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Icon(
              IconFont.icon_search,
              size: 16.w,
              color: inputTextLength == 0 ? CottiColor.textHint : CottiColor.textBlack,
            ),
          ),
          Expanded(child: _searchFrame()),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }

  Widget _searchFrame() {
    return Row(
      children: [
        SizedBox(width: 8.w),
        Expanded(
          child: TextField(
            keyboardAppearance: Brightness.light,
            autofocus: widget.autofocus,
            onChanged: (value) {
              if (_controller.value.isComposingRangeValid) {
                return;
              }
              setState(() {
                inputTextLength = value.length;
              });
              _inputChangeSync(value);
            },
            cursorColor: CottiColor.primeColor,
            textInputAction: TextInputAction.search,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF111111)),
            controller: _controller,
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFF979797)),
              counterText: "",
              isCollapsed: true,
              border: InputBorder.none,
              hintText: widget.hideText,
            ),
            inputFormatters: [
              CustomizedTextInputFormatter(filterPattern: RegExp(r'[a-zA-Z\u4e00-\u9fa5\d\s]+')),
              LengthLimitingTextInputFormatter(20),
            ],
            onSubmitted: (val) => _searchCall(val),
          ),
        ),
        Visibility(
          visible: inputTextLength > 0,
          child: GestureDetector(
            onTap: () {
              widget.clearCallback!();
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                child: Icon(
                  IconFont.icon_clean,
                  size: 16.w,
                  color: CottiColor.textHint,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _inputChangeSync(String val) {
    _timer?.cancel();
    if (val.isEmpty) {
      widget.clearCallback!();
      return;
    }
    _timer = Timer(const Duration(milliseconds: 500), () {
      if (widget.searchCallBack == null) {
        return;
      }
      widget.searchCallBack!(val);
    });
  }

  void _searchCall(String val) {
    NavigatorUtils.unfocus();
    if (widget.searchCallBack == null) {
      return;
    }
    if (val.isNotEmpty) {
      widget.searchCallBack!(val);
      return;
    }
    var hideText = widget.hideText;
    if (hideText.isNotEmpty && widget.searchHideBack != null) {
      widget.searchHideBack!();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.installValue?.removeListener(_installValue);
    super.dispose();
  }
}

class InstallValue extends ValueNotifier<SearchLabel> {
  InstallValue() : super(SearchLabel());

  void install(SearchLabel newValue) {
    value = newValue;
  }

  void clear() {
    value = SearchLabel();
  }
}
