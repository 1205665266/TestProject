part of 'store_bloc.dart';

@immutable
class StoreState {
  StoreListDataEntity? storeListEntity;

  ///定位到的信息
  LocationResult? locationResult;
  bool showLoading = false;

  ///是否有定位权限 true 有
  bool locationStatus = false;

  ///底部门店列表距离顶部的距离
  double shopListTop = 0;

  ///搜索的门店
  String? shopMdName;

  ///中心点
  double? centerLatitude;
  double? centerLongitude;

  /// 标记箭头朝向
  bool atBottom = true;

  /// m门店列表显示 加载中
  bool shopListLoading = false;

  bool isChangeCity = false;

  bool isFromConfirm = false;

  /// 标记当前选中门店
  int? shopMdCode;

  int moveMapEventTimeStamp = 0;

  StoreState copy() {
    return StoreState()
      ..storeListEntity = storeListEntity
      ..locationResult = locationResult
      ..showLoading = showLoading
      ..locationStatus = locationStatus
      ..shopListTop = shopListTop
      ..shopMdName = shopMdName
      ..centerLatitude = centerLatitude
      ..atBottom = atBottom
      ..centerLongitude = centerLongitude
      ..shopListLoading = shopListLoading
      ..isChangeCity = isChangeCity
      ..isFromConfirm = isFromConfirm
      ..moveMapEventTimeStamp = moveMapEventTimeStamp
      ..shopMdCode = shopMdCode;
  }
}
