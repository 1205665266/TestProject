import 'package:bloc/bloc.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/3 14:23
class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  static const String blocName = "globalBloc";

  GlobalBloc() : super(GlobalState()) {
    on<SwitchTabEvent>(_switchTab);
  }

  _switchTab(SwitchTabEvent event, emit) async {
    if (event.tabIndex != state.tabIndex) {
      emit(state.copy(
        tabIndex: event.tabIndex,
        arguments: event.arguments,
        argumentsTimeStamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }
}

abstract class GlobalEvent {}

class SwitchTabEvent extends GlobalEvent {
  final int tabIndex;
  final Map<String, dynamic>? arguments;

  SwitchTabEvent(this.tabIndex, {this.arguments});
}

class GlobalState {
  int tabIndex = 0;
  Map<String, dynamic>? arguments;
  int argumentsTimeStamp = 0;

  GlobalState copy({
    int? tabIndex,
    Map<String, dynamic>? arguments,
    int? argumentsTimeStamp,
  }) {
    return GlobalState()
      ..tabIndex = tabIndex ?? this.tabIndex
      ..arguments = arguments ?? this.arguments
      ..argumentsTimeStamp = argumentsTimeStamp ?? this.argumentsTimeStamp;
  }
}
