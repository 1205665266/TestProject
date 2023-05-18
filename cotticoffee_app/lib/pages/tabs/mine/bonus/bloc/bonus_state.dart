part of 'bonus_bloc.dart';

class BonusState {
  bool showLoading = false;

  BonusDetailEntity? detailEntity;

  List<BonusLogEntity>? logList;

  String? noDataTitle;

  bool showEmpty = false;
  int pageNo = 1;
  int requestTimeStamp = 0;
  LoadStatus loadStatus = LoadStatus.idle;
  RefreshStatus refreshStatus = RefreshStatus.idle;

  static BonusState init() {
    return BonusState();
  }

  BonusState copy() {
    return BonusState()
      ..showLoading = showLoading
      ..loadStatus = loadStatus
      ..showEmpty = showEmpty
      ..refreshStatus = refreshStatus
      ..requestTimeStamp = requestTimeStamp
      ..detailEntity = detailEntity
      ..noDataTitle = noDataTitle
      ..logList = logList;
  }
}
