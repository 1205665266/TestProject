abstract class MineEvent {}

class InitUserInfoEvent extends MineEvent {}

class UpdatePersonInfoEvent extends MineEvent {
  final String? nickname;
  final int? sex;
  final String? birthday;
  final int? appMessageSwitch;

  UpdatePersonInfoEvent(this.nickname, this.sex, this.birthday, this.appMessageSwitch);
}

class UpdateNickNameInitEvent extends MineEvent {}
