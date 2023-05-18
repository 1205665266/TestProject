import 'dart:io';

import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


/// FileName: city_conditions_search_widget
///
/// Description: 城市条件搜索组件
/// Author: zekun.li@abite.com
/// Date: 2021/12/9

class CityConditionsSearchWidget extends StatefulWidget {
  final String cityName;

  final FocusNode focusNode;

  final String hintText;

  final Function onChanged;

  final Function? onSwitchCity;

  final Function? onEditing;

  final Function? onClickTextField;

  const CityConditionsSearchWidget(
      {Key? key,
      required this.focusNode,
      required this.hintText,
      required this.onChanged,
      this.onSwitchCity,
      required this.cityName,
      this.onEditing,
      this.onClickTextField})
      : super(key: key);

  @override
  State<CityConditionsSearchWidget> createState() =>
      _CityConditionsSearchWidgetState();
}

class _CityConditionsSearchWidgetState
    extends State<CityConditionsSearchWidget> {
  //搜索内容
  String searchContent = '';

  //输入框的控制器
  final TextEditingController _editingController = TextEditingController();

  //是否显示叉号
  bool isClearShow = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        widget.onEditing!(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 52.h,
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(top: 8.h, bottom: 8.h, left: 16.w, right: 16.w),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 30.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: Row(
                  children: [
                    _buildSelectCity(),
                    SizedBox(width: 9.w),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: 28.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildTextField(),
                            SizedBox(width: 5.w),
                            _buildClearKey(),
                            SizedBox(width: 12.w),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   width: 9.w,
            // ),
            _buildCancel()
          ],
        ),
      ),
    );
  }

  Widget _buildSelectCity() {
    return GestureDetector(
      onTap: () async {
        if (widget.onSwitchCity != null) {
          widget.onSwitchCity!();
        }
      },
      child: Container(
        color: Colors.transparent,
        height: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 12.w),
            Container(
              constraints: BoxConstraints(maxWidth: 72.w),
              child: Text(widget.cityName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      height: Platform.isAndroid ? 1.2 : 1.4,
                      decoration: TextDecoration.none,
                      fontSize: 13.sp,
                      color: const Color(0xFF3A3B3C),
                  ),
              ),
            ),
            SizedBox(width: 4.w),
            SvgPicture.asset('assets/images/ic_search_down.svg',
                width: 16.w, height: 16.h),
            SizedBox(width: 4.w),
            Container(
              width: .5.w,
              height: 14.h,
              color: const Color(0xFFBABBBB),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (widget.onClickTextField != null) {
            widget.onClickTextField!();
          }
        },
        child: TextField(
          enabled: widget.onClickTextField == null,
          controller: _editingController,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.text,
          textAlignVertical: TextAlignVertical.center,
          onChanged: _getEditeInputTextFunction,
          inputFormatters: [LengthLimitingTextInputFormatter(20)],
          decoration: InputDecoration(
            isCollapsed: true,
            border: InputBorder.none, // 去掉下滑线
            hintText: widget.hintText,
            hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF979797)),
            // hintStyle: TextStyle(
            //   fontSize: 12.sp,
            //   color: CottiColor.textBlack,
            //   height: 1,
            // ),
          ),
          style: TextStyle(
            fontSize: 13.sp,
            color: CottiColor.textBlack,
          ),
        ),
      ),
    );
  }

  Widget _buildClearKey() {
    return isClearShow == false
        ? Container()
        : GestureDetector(
            onTap: _clearEditeInputTextFunction,
            child: SvgPicture.asset(
              'assets/images/city/ic_city_search_delete.svg',
              width: 20.w,
              height: 20.h,
              fit: BoxFit.fill,
            ),
          );
  }

  Widget _buildCancel() {
    return widget.focusNode.hasFocus
        ? InkWell(
            onTap: _cancelEditeInputTextFunction,
            child: Row(
              children: [
                SizedBox(
                  width: 9.w,
                ),
                Text(
                  "取消",
                  style: TextStyle(color: const Color(0xFF5e5e5e), fontSize: 13.sp),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  /// 获取TextField中输入的内容
  void _getEditeInputTextFunction(String content) {
    widget.onChanged(content);
    content = content.trim();
    searchContent = content;
    // log(content);
    if (searchContent != "") {
      isClearShow = true;
      setState(() {});
    } else {
      isClearShow = false;
      setState(() {});
    }
  }

  /// 清除TextField中显示的内容
  void _clearEditeInputTextFunction() {
    _editingController.clear();
    widget.onChanged("");
    setState(() {
      isClearShow = false;
    });
  }

  /// 取消TextField编辑
  void _cancelEditeInputTextFunction() {
    FocusManager.instance.primaryFocus?.unfocus();
    widget.onEditing!(false);
    _clearEditeInputTextFunction();
  }
}
