part of 'help_bloc.dart';


class HelpState {
  LastOrderEntity? lastOrder;

  HelpState copy(){
    return HelpState()..lastOrder = lastOrder;
  }

}
