import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/edit_user_info/sex_dialog.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_event.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_state.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/horizontail_divider.dart';
import 'package:cotti_client/widget/mine_picker.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/7 20:04
class EditUserPage extends StatefulWidget {
  const EditUserPage({Key? key}) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  DateTime? currentSelectedDateTime;
  late MineState state;

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      title: '编辑个人信息',
      child: BlocBuilder<MineBloc, MineState>(
        builder: (context, mineState) {
          state = mineState;
          if (state.userInfoEntity?.birthday != null) {
            currentSelectedDateTime = DateTime.tryParse(state.userInfoEntity!.birthday!);
          }
          String sexStr = state.userInfoEntity?.sex == null
              ? ''
              : (state.userInfoEntity!.sex! == 1 ? '男' : '女');
          return Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.w),
                _buildHead(state.userInfoEntity?.headPortrait ??
                    'https://cdn-product-prod.yummy.tech/wechat/cotti/images/mine/ic_user_no_login.png'),
                SizedBox(height: 32.h),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(CottiColor.circular),
                    topRight: Radius.circular(CottiColor.circular),
                  ),
                  child: _buildItem('昵称', state.userInfoEntity?.nickname ?? '', _editNickname),
                ),
                _buildLine(),
                _buildItem('性别', sexStr, _editSex),
                _buildLine(),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(CottiColor.circular),
                    bottomRight: Radius.circular(CottiColor.circular),
                  ),
                  child: _buildItem('出生日期', state.userInfoEntity?.birthday ?? '', _openModalPicker),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildLine() {
    return Container(
      color: Colors.white,
      child: HorizontalDivider(dividerMargin: EdgeInsets.symmetric(horizontal: 18.w)),
    );
  }

  _buildHead(String url) {
    return SizedBox(
      width: 70.w,
      height: 70.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CottiImageWidget(
            url,
            borderRadius: BorderRadius.circular(35.r),
          ),
          Positioned(
            left: -13.w,
            bottom: -13.w,
            child: ABiteBanner(
              bannerParam: BannerParam('cotti-common-avatar-easterEgg'),
              resize: true,
              width: 96.w,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }

  _buildItem(String title, String? value, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: 54.h,
        color: Colors.white,
        padding: EdgeInsets.only(left: 12.w, right: 4.w),
        child: Row(
          children: [
            Container(
              constraints: BoxConstraints(minWidth: 72.w),
              child: Text(
                title,
                style: TextStyle(
                  color: CottiColor.textGray,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Expanded(
              child: Text(
                (value?.isEmpty ?? true) ? '未设置' : value!,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: (value?.isEmpty ?? true) ? CottiColor.textHint : CottiColor.textBlack,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Icon(
              IconFont.icon_right,
              size: 20.w,
              color: CottiColor.textHint,
            ),
          ],
        ),
      ),
    );
  }

  _editSex() {
    SexDialog.show(context, state.userInfoEntity?.sex ?? 1, (sex) {
      // if (sex == state.userInfoEntity?.sex) {
      //   return;
      // }
      context.read<MineBloc>().add(UpdatePersonInfoEvent(
            state.userInfoEntity?.nickname,
            sex,
            state.userInfoEntity?.birthday,
            state.userInfoEntity?.appMessageSwitch,
          ));
    });
  }

  _editNickname() {
    NavigatorUtils.push(context, MineRouter.mineInfoEdit);
  }

  _openModalPicker() {
    return MinePicker(
      adapter: DateTimePickerAdapter(
        type: PickerDateTimeType.kYMD,
        isNumberMonth: true,
        yearSuffix: "年",
        monthSuffix: "月",
        daySuffix: "日",
        maxValue: DateTime.now(),
        minValue: DateTime(1900, 1, 1, 00, 00),
        value: currentSelectedDateTime ?? DateTime.now(),
      ),
      title: Text(
        "请选择出生日期",
        style:
            TextStyle(color: const Color(0xFF111111), fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
      cancelText: '取消',
      confirmText: "确定",
      cancelTextStyle: TextStyle(color: const Color(0xFFCFCFCF), fontSize: 16.sp),
      confirmTextStyle: TextStyle(color: CottiColor.primeColor, fontSize: 16.sp),
      textStyle: TextStyle(color: const Color(0xFFCFCFCF), fontSize: 16.sp),
      selectedTextStyle: TextStyle(color: const Color(0xFF3A3B3C), fontSize: 16.sp),
      textAlign: TextAlign.right,
      itemExtent: 45.h,
      height: 160.h,
      headerDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFEEEEEE), width: 0.5.w),
        ),
      ),
      onConfirm: (picker, list) {
        var time = (picker.adapter as DateTimePickerAdapter).value ?? DateTime.now();
        var timeStr =
            time.year.toString() + "-" + time.month.toString() + "-" + time.day.toString();
        context.read<MineBloc>().add(UpdatePersonInfoEvent(
              state.userInfoEntity?.nickname,
              state.userInfoEntity?.sex,
              timeStr,
              state.userInfoEntity?.appMessageSwitch,
            ));
      },
    ).showModal(context);
  }
}
