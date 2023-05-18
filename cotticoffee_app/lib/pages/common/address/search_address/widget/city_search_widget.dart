import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/address/search_address/bloc/city_search_bloc.dart';
import 'package:cotti_client/pages/tabs/menu/search/bloc/search_bloc.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// FileName city_search_widget
///
/// Description:城市动态搜索Widget组件
/// Author: 乔
/// Date: 2022/4/6

class CitySearchWidget extends StatefulWidget {
  ///暂时无用
  final String cityName;
  final FocusNode focusNode;
  final String hintText;

  ///输入框内容变化回调  void Function(String item)
  final Function onChanged;

  ///输入框编辑状态回调  void Function(bool item)
  final Function? onEditing;

  ///输入框点击回调 void Function()
  final Function? onClickTextField;

  ///取消按钮点击回调 void Function()
  final Function? onClickCancelBtn;

  ///输入框圆角弧度 默认22.5.r
  final double? borderRadius;

  ///输入框边框 默认InputBorder.none（无边框）
  final BoxBorder? border;

  ///输入框是否只读（不可编辑状态，可长按复制），默认 否 false
  final bool readOnly;

  ///输入框是否有效输入框（不可操作）
  final bool enabled;

  ///输入框边距，默认纵向（上下）边距8.h
  final EdgeInsets? margin;

  const CitySearchWidget(
      {Key? key,
      required this.focusNode,
      required this.hintText,
      required this.onChanged,
      this.cityName = '',
      this.onEditing,
      this.onClickTextField,
      this.borderRadius,
      this.readOnly = false,
      this.enabled = true,
      this.border,
      this.margin,
      this.onClickCancelBtn})
      : super(key: key);

  @override
  State<CitySearchWidget> createState() => _CitySearchWidgetState();
}

class _CitySearchWidgetState extends State<CitySearchWidget> {
  //输入框的控制器
  final TextEditingController _editingController = TextEditingController();

  final CitySearchBloc _bloc = CitySearchBloc();

  // final EventBus _bus = EventBus();

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        if (widget.onEditing != null) {
          widget.onEditing!(true);
        }
      }
    });
    _addEventBus();
  }

  @override
  void dispose() {
    super.dispose();
    // _bus.off(EventKeyHelper.kEventBusCitySearchCancel);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bloc,
      child: BlocBuilder<CitySearchBloc, CitySearchState>(builder: (context, state) {
        if (state is CitySearchStateUpdate) {
          return Container(
            width: double.infinity,
            height: 52.h,
            color: Colors.white,
            child: Container(
              margin: widget.margin ?? EdgeInsets.only(top: 8.h, bottom: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        border: widget.border,
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? 22.5.r),
                      ),
                      child: SizedBox(
                        // width: double.infinity,
                        height: 28.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 1.h,left: 10.w,right: 10.w,),
                              child: Icon(
                                IconFont.icon_search,
                                size: 16.w,
                                color: state.isClearShow ? CottiColor.textBlack : CottiColor.textHint,
                              ),
                            ),
                            _buildTextField(),
                            SizedBox(width: 5.w),
                            _buildClearKey(state),
                            SizedBox(width: 12.w),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildCancel(state.isCancelShow)
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      }),
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
          cursorColor: CottiColor.primeColor,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          controller: _editingController,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.text,
          textAlignVertical: TextAlignVertical.center,
          onChanged: _getEditInputTextFunction,
          onTap: () {
            if (widget.onClickTextField != null) {
              widget.onClickTextField!();
            }
          },
          inputFormatters: [LengthLimitingTextInputFormatter(20)],
          decoration: InputDecoration(
            isCollapsed: true,
            border: InputBorder.none, // 去掉下滑线
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: CottiColor.textHint,
              // height: 1,
            ),
          ),
          style: TextStyle(
            fontSize: 12.sp,
            color: CottiColor.textBlack,
          ),
        ),
      ),
    );
  }

  Widget _buildClearKey(CitySearchStateUpdate state) {
    return state.isClearShow
        ? GestureDetector(
            onTap: _clearEditInputTextFunction,
            child: SvgPicture.asset(
              'assets/images/city/ic_city_search_delete.svg',
              width: 20.w,
              height: 20.h,
              color: CottiColor.textHint,
              fit: BoxFit.fill,
            ),
          )
        : Container();
  }

  Widget _buildCancel(bool isCancelShow) {
    return isCancelShow
        ? InkWell(
            onTap: _cancelEditInputTextFunction,
            child: SizedBox(
              width: 39.sp,
              child: Text(
                "取消",
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: CottiColor.textBlack,
                  fontSize: 14.sp,
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  /// 获取TextField中输入的内容
  void _getEditInputTextFunction(String content) {
    if (_editingController.value.isComposingRangeValid) {
      return;
    }
    widget.onChanged(content);
    content = content.trim();
    // log(content);
    _bloc.add(SearchEventUpdate(
      searchContent: content,
      isClearShow: content.isNotEmpty,
      isCancelShow: widget.focusNode.hasFocus,
    ));
  }

  /// 清除TextField中显示的内容
  void _clearEditInputTextFunction({bool isCancelShow = true}) {
    _editingController.clear();
    widget.onChanged('');
    _bloc.add(SearchEventUpdate(searchContent: '', isClearShow: false, isCancelShow: isCancelShow));
  }

  /// 取消TextField编辑
  void _cancelEditInputTextFunction() {
    if (widget.onClickCancelBtn != null) {
      widget.onClickCancelBtn!();
    }
    NavigatorUtils.unfocus();

    if (widget.onEditing != null) {
      widget.onEditing!(false);
    }
    _clearEditInputTextFunction(isCancelShow: false);
  }

  void _addEventBus() {
    // _bus.on(EventKeyHelper.kEventBusCitySearchCancel, (event) async {
    //   _cancelEditInputTextFunction();
    // });
  }
}
