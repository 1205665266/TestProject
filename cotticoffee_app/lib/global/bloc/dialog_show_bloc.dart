import 'package:bloc/bloc.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/15 17:54

class DialogShowBloc extends Bloc<DialogShowEvent, DialogShowState> {
  DialogShowBloc() : super(DialogShowState()) {
    on<AddDialogNameEvent>(_addDialogName);
    on<RemoveDialogNameEvent>(_removeDialogName);
  }

  _addDialogName(AddDialogNameEvent event, emit) {
    int index = state.dialogNames.indexOf(event.dialogName);
    if (index == -1) {
      state.dialogNames.add(event.dialogName);
      emit(state.copy());
    }
  }

  _removeDialogName(RemoveDialogNameEvent event, emit) {
    int index = state.dialogNames.indexOf(event.dialogName);
    if (index > -1) {
      state.dialogNames.removeAt(index);
      emit(state.copy());
    }
  }
}

abstract class DialogShowEvent {}

class AddDialogNameEvent extends DialogShowEvent {
  final String dialogName;

  AddDialogNameEvent(this.dialogName);
}

class RemoveDialogNameEvent extends DialogShowEvent {
  final String dialogName;

  RemoveDialogNameEvent(this.dialogName);
}

class DialogShowState {
  List<String> dialogNames = [];

  DialogShowState copy() {
    return DialogShowState()..dialogNames = dialogNames;
  }
}
