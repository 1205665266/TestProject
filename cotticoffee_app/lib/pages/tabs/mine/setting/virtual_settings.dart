import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/service/push/jpush_wrapper.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/x_number_text_input_formatter.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/2/2 10:43
class VirtualSettings extends StatefulWidget {
  static String keyCustomerLatitude = "key_customerLatitude";
  static String keyCustomerLongitude = "key_customerLongitude";
  static String keyIp = "keyIp";
  static String keyPort = "keyPort";

  const VirtualSettings({Key? key}) : super(key: key);

  @override
  State<VirtualSettings> createState() => _VirtualSettingsState();
}

class _VirtualSettingsState extends State<VirtualSettings> {
  late final TextEditingController controller1;
  late final TextEditingController controller2;
  late final TextEditingController controller3;
  late final TextEditingController controller4;
  late String registerId;

  @override
  void initState() {
    super.initState();
    String customerLatitude = SpUtil.getString(VirtualSettings.keyCustomerLatitude);
    String customerLongitude = SpUtil.getString(VirtualSettings.keyCustomerLongitude);
    String ip = SpUtil.getString(VirtualSettings.keyIp);
    String port = SpUtil.getString(VirtualSettings.keyPort);
    registerId = SpUtil.getString(JPushWrapper.keyRegistrationID);
    controller1 = TextEditingController(text: customerLatitude);
    controller2 = TextEditingController(text: customerLongitude);
    controller3 = TextEditingController(text: ip);
    controller4 = TextEditingController(text: port);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      title: "虚拟设置",
      actions: [
        GestureDetector(
          onTap: () => _save(),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 50.w,
            alignment: Alignment.center,
            child: Text(
              "保存",
              style: TextStyle(
                fontSize: 14.sp,
                color: CottiColor.textBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
      child: Column(
        children: [
          Row(
            children: [
              const Text("customerLatitude:"),
              Expanded(
                child: TextField(
                  controller: controller1,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    XNumberTextInputFormatter(
                        maxIntegerLength: 10, maxDecimalLength: 10, isAllowDecimal: true),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("customerLongitude:"),
              Expanded(
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: controller2,
                  inputFormatters: [
                    XNumberTextInputFormatter(
                        maxIntegerLength: 10, maxDecimalLength: 10, isAllowDecimal: true),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("代理IP:"),
              Expanded(
                child: TextField(controller: controller3),
              ),
            ],
          ),
          Row(
            children: [
              const Text("代理端口:"),
              Expanded(
                child: TextField(
                  controller: controller4,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    XNumberTextInputFormatter(
                        maxIntegerLength: 10, maxDecimalLength: 10, isAllowDecimal: true),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              const Text("极光ID:"),
              Expanded(
                child: Text("  $registerId"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _save() {
    SpUtil.putString(VirtualSettings.keyCustomerLatitude, controller1.value.text);
    SpUtil.putString(VirtualSettings.keyCustomerLongitude, controller2.value.text);
    SpUtil.putString(VirtualSettings.keyIp, controller3.value.text);
    SpUtil.putString(VirtualSettings.keyPort, controller4.value.text);
    ToastUtil.show("保存成功！");
    NavigatorUtils.pop(context);
  }
}
