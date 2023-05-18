import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_detail_model.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_detail/bloc/order_detail_state.dart';
import 'package:cotti_client/widget/countdown_timer.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelCountDown extends StatefulWidget {
  OrderDetailModel? orderDetail;

  CancelCountDown({required this.orderDetail, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CancelCountDownState();
}

class CancelCountDownState extends State<CancelCountDown> {
  final ValueNotifier<int> _countNotifier = ValueNotifier(100);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if ((widget.orderDetail?.deadLineSeconds ?? 0) > 0) {
        _countNotifier.value = widget.orderDetail?.deadLineSeconds ?? 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailBloc, OrderDetailState>(builder: (context, state) {

      int deadLineSeconds = state.orderDetail?.deadLineSeconds ?? 0;
      String format = deadLineSeconds > 3600 ? 'HH:mm:ss' : 'mm:ss';


      return Container(
        height: 54.h,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('请于 ', style: TextStyle(fontSize: 14.sp, color: CottiColor.textBlack)),
            CountDownTimer(
              callback: () {},
              notifier: _countNotifier,
              format: format,
              textStyle: TextStyle(
                color: CottiColor.primeColor,
                fontSize: 20.sp,
                fontFamily: 'DDP5',
              ),
            ),
            Text(' 内付款，超时将自动取消', style: TextStyle(fontSize: 14.sp, color: CottiColor.textBlack))
          ],
        ),
      );
    });
  }
}
