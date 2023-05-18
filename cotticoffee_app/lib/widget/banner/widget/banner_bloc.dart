import 'package:bloc/bloc.dart';

import '../api/banner_api.dart';
import '../model/banner_model.dart';
import '../model/banner_param.dart';
import '../model/update_frequency_param.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  BannerBloc() : super(BannerState()) {
    on<BannerInitEvent>(_getBannerDate);
    on<LocalBannerEvent>(_localBanner);
    on<ReloadEvent>(_getBannerDate);
    on<UpdateFrequencyEvent>(_updateFrequency);
  }

  void _getBannerDate(BannerEvent event, emit) async {
    await BannerApi.getBannerList(event.bannerParam).then((value) {
      state.bannerList = value;
      emit(state.copy());
    });
  }

  void _localBanner(LocalBannerEvent event, emit) {
    state.bannerList = event.banners;
    emit(state.copy());
  }

  void _updateFrequency(UpdateFrequencyEvent event, emit) {
    UpdateFrequencyParam updateFrequencyParam =
        UpdateFrequencyParam(event.positionCode, event.bannerParam.code);
    BannerApi.updateFrequency(updateFrequencyParam, event.bannerParam);
  }
}
