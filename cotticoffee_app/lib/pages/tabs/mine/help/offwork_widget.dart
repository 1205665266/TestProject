import 'package:abitelogin/router/login_router.dart';
import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OffWorkDialog extends StatelessWidget {
  const OffWorkDialog({Key? key}) : super(key: key);

  static show(BuildContext context) {
    showDialog(
      context: LoginRouter.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return const OffWorkDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ConfigBloc cBloc = GlobalBlocs.get(ConfigBloc.blocName);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 28.h,horizontal: 20.w),
            child: Column(
              children: [
                Image.network(
                  'https://cdn-product-prod.yummy.tech/wechat/cotti/images/mine/ic_mine_offwork.png',
                  width: 159,
                  height: 107,
                ),
                SizedBox(
                  height: 25.h,
                ),
                Text(
                  cBloc.state.configEntity?.customerServiceCase ?? "",
                  style: TextStyle(
                    fontSize: 12.sp,
                    decoration: TextDecoration.none,
                    color: CottiColor.textHint,
                    fontWeight: FontWeight.w400,
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              logI('onTap offWorkDialog');
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Image.network(
                'https://cdn-product-prod.yummy.tech/wechat/cotti/images/mine/ic_mine_close.png',
                width: 11.w,
                height: 11.w,
              ),
            ),
          )
        ],
      ),
    );
  }
}
