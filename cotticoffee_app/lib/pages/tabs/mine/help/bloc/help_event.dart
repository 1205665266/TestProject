part of 'help_bloc.dart';

@immutable
abstract class HelpEvent {
  final BuildContext context;

  const HelpEvent({required this.context});
}

class OnlineServiceEvent extends HelpEvent {

  OrderDetailModel? orderDetailModel;

  OnlineServiceEvent({required BuildContext context,this.orderDetailModel})
      : super(context: context);
}

class PhoneCallEvent extends HelpEvent {
  final String phoneNum;
  const PhoneCallEvent({required this.phoneNum, required BuildContext context}) : super(context: context);
}
