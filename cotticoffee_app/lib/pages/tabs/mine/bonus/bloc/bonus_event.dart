part of 'bonus_bloc.dart';


abstract class BonusEvent {}


class BonusInitEvent extends BonusEvent {

}


abstract class BonusRequestEvent extends BonusEvent{
  int? requestTimeStamp;
  BonusRequestEvent({this.requestTimeStamp});
}

class BonusLoadingEvent extends BonusRequestEvent {
  BonusLoadingEvent() : super(requestTimeStamp: DateTime.now().microsecondsSinceEpoch);
}

class BonusRefreshEvent extends BonusRequestEvent {
  BonusRefreshEvent() : super(requestTimeStamp: DateTime.now().microsecondsSinceEpoch);
}

class BonusNoDataTitleDoneEvent extends BonusEvent {
  String? noDataTitle;
  BonusNoDataTitleDoneEvent({this.noDataTitle});
}