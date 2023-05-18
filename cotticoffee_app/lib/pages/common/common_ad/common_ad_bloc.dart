import 'package:bloc/bloc.dart';
import 'package:cotti_client/widget/banner/api/banner_api.dart';
import 'package:cotti_client/widget/banner/banner.dart';

class CommonAdBloc extends Bloc<CommonAdEvent, CommonAdState> {
  CommonAdBloc() : super(CommonAdState()) {
    on<CommonAdEvent>(_getCommonAd);
  }

  _getCommonAd(CommonAdEvent event, emit) async {
    state.showLoading = true;
    emit(state.copy());
    state.adList = await BannerApi.getBannerList(BannerParam(event.adCode));
    state.showLoading = false;
    emit(state.copy());
  }
}

class CommonAdState {
  bool showLoading = false;
  List<BannerModel> adList = [];

  CommonAdState copy() {
    return CommonAdState()
      ..showLoading = showLoading
      ..adList = adList;
  }
}

class CommonAdEvent {
  String adCode;
  String shareCode;

  CommonAdEvent(this.adCode, this.shareCode);
}
