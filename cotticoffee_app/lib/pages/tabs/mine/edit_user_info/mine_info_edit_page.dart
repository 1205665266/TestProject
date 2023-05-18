import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_event.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_state.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/customized_length_text_input_formatter.dart';
import 'package:cotti_client/widget/dialog/common_dialog.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// @ClassName: MineInfoEditPage
///
/// @Description: 编辑昵称页面
/// @author: hailin.ma
/// @date: 2022-03-04
class MineInfoEdit extends StatefulWidget {
  const MineInfoEdit({Key? key}) : super(key: key);

  @override
  State<MineInfoEdit> createState() => _MineInfoEditState();
}

class _MineInfoEditState extends State<MineInfoEdit> {
  late TextEditingController _controller;
  late String _currentInput;
  late MineBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<MineBloc>();
    String nickName = _bloc.state.userInfoEntity?.nickname ?? '';
    if (nickName.length > 15) {
      nickName = nickName.substring(0, 15);
    }
    _currentInput = nickName;
    _bloc.add(UpdateNickNameInitEvent());
    _controller = TextEditingController(text: _currentInput);
  }

  ///对用户点击物理返回键的处理
  Future<bool> _back() async {
    if (_currentInput == _bloc.state.userInfoEntity?.nickname) {
      NavigatorUtils.pop(context);
    } else {
      showConfirmDialog();
    }
    return false;
  }

  void showConfirmDialog() {
    CommonDialog.show(
      context,
      content: '昵称尚未保存，确认暂不修改吗？',
      mainButtonName: '确认',
      subButtonName: '取消',
    ).then((value) {
      if (value == 1) {
        NavigatorUtils.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _back,
      child: BlocConsumer<MineBloc, MineState>(
        listener: (context, state) {
          if (state.isUpdateNickNamed) {
            state.isUpdateNickNamed = false;
            NavigatorUtils.pop(context);
          }
        },
        builder: (context, state) {
          return CustomPageWidget(
            title: "编辑昵称",
            clickLeading: _back,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                    padding: EdgeInsets.only(left: 16.w, right: 16.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r), color: Colors.white),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          keyboardAppearance: Brightness.light,
                          cursorColor: CottiColor.primeColor,
                          controller: _controller,
                          inputFormatters: <TextInputFormatter>[
                            /// 限制长度
                            LengthLimitingTextInputFormatter(15),

                            /// 只能输入汉字或者字母或数字
                            // CustomizedTextInputFormatter(filterPattern: RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]"))
                          ],
                          decoration: InputDecoration(
                            // hintText: _currentInput,
                            hintText: '请设置您的昵称',
                            hintStyle: TextStyle(fontSize: 14.sp),
                            border: InputBorder.none,
                          ),
                          onChanged: (v) {
                            setState(() {
                              _currentInput = v;
                            });
                          },
                        )),
                        Visibility(
                            visible: _currentInput.isNotEmpty,
                            child: Offstage(
                              offstage: false,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _controller.text = "";
                                    _currentInput = "";
                                  });
                                },
                                child: SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                    size: 17,
                                  ),
                                ),
                              ),
                            ))
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: Text(
                    "请输入昵称，昵称不能超过15个汉字且不可以为空",
                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF979798)),
                  ),
                ),
                const Expanded(child: SizedBox()),
                _buildBottom(),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildBottom() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (_currentInput.isNotEmpty) {
              if (_currentInput == _bloc.state.userInfoEntity?.nickname) {
                /// 昵称未改变直接pop；
                NavigatorUtils.pop(context);
                return;
              }
              _bloc.add(UpdatePersonInfoEvent(
                _currentInput,
                _bloc.state.userInfoEntity?.sex,
                _bloc.state.userInfoEntity?.birthday,
                _bloc.state.userInfoEntity?.appMessageSwitch,
              ));
            } else {
              ToastUtil.show('昵称不能为空');
            }
          },
          child: Container(
            height: 44.h,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: CottiColor.primeColor, width: 0.5.w),
              borderRadius: BorderRadius.circular(4.r),
              color: _currentInput.isEmpty ? Colors.white : CottiColor.primeColor,
            ),
            child: Text(
              '保存',
              style: TextStyle(
                color: _currentInput.isEmpty ? CottiColor.primeColor : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
