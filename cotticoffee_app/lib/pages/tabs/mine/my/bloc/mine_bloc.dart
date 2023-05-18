import 'package:bloc/bloc.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/pages/tabs/mine/my/api/mine_api.dart';
import 'package:cotti_client/widget/banner/api/banner_api.dart';
import 'package:cotti_client/widget/banner/model/banner_param.dart';
import 'package:cotticommon/bloc/user_event.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';

import 'mine_event.dart';
import 'mine_state.dart';

class MineBloc extends Bloc<MineEvent, MineState> {
  MineBloc() : super(MineState()) {
    on<InitUserInfoEvent>(_initUserInfo);
    on<UpdatePersonInfoEvent>(_updatePersonInfo);
    on<UpdateNickNameInitEvent>(_updateNickNameInit);
  }

  _initUserInfo(_, emit) async {
    if (Constant.hasLogin) {
      await Future.wait([
        MineApi.getPersonalInfo()
            .then((value) => state.userInfoEntity = value)
            .catchError((onError) {}),
        MineApi.getCouponAndBounty()
            .then((value) => state.couponBountyEntity = value)
            .catchError((onError) {}),
        MineApi.getHomeLoginPrompt()
            .then((value) => state.promptStr = value)
            .catchError((onError) {}),
      ]);
    }

    if(state.actionList.isEmpty) {
      /// 不要重复请求
      await BannerApi.getBannerSortList(BannerParam('cotti-my-menu'))
          .then((value) => state.actionList = value);
    }

    state.couponExchangeStatement ??= await MineApi.getCouponExchange();
    emit(state.copy());
  }

  _updatePersonInfo(UpdatePersonInfoEvent event, emit) async {
    await MineApi.updatePersonalInfo(
            event.nickname, event.sex, event.birthday, event.appMessageSwitch)
        .then((value) {
      if (value) {
        ToastUtil.show("保存成功");
      }
    }).catchError((onError) {});
    if (state.userInfoEntity?.nickname != event.nickname) {
      state.isUpdateNickNamed = true;
    }
    state.userInfoEntity = await MineApi.getPersonalInfo();
    UserModel? user = GlobalBlocs.get<UserBloc>(UserBloc.blocName).state.userModel;
    if (user != null) {
      user.nickName = state.userInfoEntity?.nickname;
      user.headPortrait = state.userInfoEntity?.headPortrait;
      GlobalBlocs.get(UserBloc.blocName).add(UserInfoUpdateEvent(user));
    }
    emit(state.copy());
  }

  _updateNickNameInit(_, emit) {
    state.isUpdateNickNamed = false;
    emit(state.copy());
  }
}
