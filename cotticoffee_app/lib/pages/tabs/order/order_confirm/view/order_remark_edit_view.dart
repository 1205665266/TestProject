import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/sensors/order_sensors_constant.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/bloc/order_confirm_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_confirm/view/confirm_remark_tag_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class OrderRemarkEditView extends StatefulWidget {
  const OrderRemarkEditView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderRemarkEditView();
}

class _OrderRemarkEditView extends State<OrderRemarkEditView> {
  late TextEditingController _controller;

  var inputLength = 0;

  late OrderConfirmBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<OrderConfirmBloc>();
    _controller = TextEditingController.fromValue(TextEditingValue(
        text: _bloc.state.remark,
        selection: TextSelection.fromPosition(
            TextPosition(affinity: TextAffinity.downstream, offset: _bloc.state.remark.length))));
    _controller.addListener(() {
      setState(() {
        inputLength = _controller.text.characters.length;
      });
    });
    inputLength = _bloc.state.remark.characters.length;

    _bloc.add(OrderConfirmRemarkListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderConfirmBloc, OrderConfirmState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: 16.w, right: 16.w),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: CottiColor.backgroundColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              height: 124.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: TextField(
                    onChanged: (input) {
                      setState(() {
                        inputLength = input.characters.length;
                      });
                    },
                    cursorColor: CottiColor.primeColor,
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: '请填写备注内容（口味选项不支持备注更改）',
                        hintStyle: TextStyle(fontSize: 12.sp),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero),
                    style: TextStyle(color: CottiColor.textBlack, fontSize: 14.sp, height: 1.4),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(50),
                    ],
                    controller: _controller,
                    autofocus: true,
                  )),
                  Container(
                    color: CottiColor.backgroundColor,
                    height: 1.h,
                  ),
                  Text(
                    "$inputLength/50",
                    style: TextStyle(
                        color: inputLength >= 50 ? CottiColor.primeColor : CottiColor.textGray,
                        fontSize: 12.sp,
                        fontFamily: 'DD4'),
                  )
                ],
              ),
            ),
            if (state.remarkList.isNotEmpty)
              ConfirmRemarkTagWidget(state.remarkList, (tag) {
                if (_controller.text.isNotEmpty) {
                  if (_controller.text.contains(tag)) {
                    return;
                  }
                  String input = _controller.text + ' $tag';
                  if (input.characters.length > 50) {
                    ToastUtil.show('最多可输入50个字');
                  } else {
                    _controller.value = TextEditingValue(
                        text: input,
                        selection: TextSelection.fromPosition(
                            TextPosition(affinity: TextAffinity.downstream, offset: input.length)));
                  }
                } else {
                  String input = tag;
                  _controller.value = TextEditingValue(
                      text: input,
                      selection: TextSelection.fromPosition(
                          TextPosition(affinity: TextAffinity.downstream, offset: input.length)));
                }
              }),
            GestureDetector(
              onTap: () {
                _bloc.add(OrderConfirmRemarkEvent(remark: _controller.text));
                SensorsAnalyticsFlutterPlugin.track(
                    OrderSensorsConstant.confirmOrderRemarkDoneClick, {});
                Navigator.of(context).pop();
              },
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: CottiColor.primeColor,
                ),
                margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                alignment: Alignment.center,
                child: Text(
                  "提交",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white, fontFamily: 'DDP5'),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
