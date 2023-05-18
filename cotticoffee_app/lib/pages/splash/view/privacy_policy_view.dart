import 'package:cotti_client/config/env.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/splash/view/privacy_util.dart';
import 'package:cotti_client/routers/web_view_router.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/3/6 18:12
class PrivacyPolicyView extends StatefulWidget {
  final Function(bool) callBack;

  const PrivacyPolicyView({Key? key, required this.callBack}) : super(key: key);

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  final double bottomActionHeight = 56.h;
  bool showPrivacyPolicy = false;
  final TextStyle blackStyle = TextStyle(color: CottiColor.textBlack, fontSize: 13.sp, height: 1.6);
  final TextStyle primeStyle =
      TextStyle(color: CottiColor.primeColor, fontSize: 13.sp, height: 1.6);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      PrivacyUtil.isFirstLaunched().then((value) {
        if (value) {
          showPrivacyPolicy = true;
          setState(() {});
        } else {
          widget.callBack(true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return showPrivacyPolicy
        ? SafeArea(
            top: false,
            child: _buildContent(),
          )
        : const SizedBox();
  }

  _buildContent() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: bottomActionHeight),
            child: Column(
              children: [
                _buildTopIcon(),
                _buildTitle(),
                SizedBox(height: 16.h),
                _buildTextContent(),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: _buildBottomAction(),
        ),
      ],
    );
  }

  _buildTopIcon() {
    return Container(
      margin: EdgeInsets.only(top: 118.h, bottom: 36.h),
      alignment: Alignment.topCenter,
      child: SvgPicture.asset(
        "assets/images/splash/bg_splash.svg",
        width: 192.w,
        height: 64.h,
      ),
    );
  }

  _buildTitle() {
    return Text(
      "温馨提示",
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18.sp,
        color: CottiColor.textBlack,
      ),
    );
  }

  _buildTextContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Text(
            "欢迎使用 COTTI COFFEE 库迪咖啡。我们深知个人信息对您的重要性，我们将按相关法律法规要求，尽力保护您的个人信息安全可控。",
            style: blackStyle,
          ),
          SizedBox(height: 8.w),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: "在使用 COTTI COFFEE 库迪咖啡服务前，请您务必审慎阅读",
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Map<String, dynamic> params = {'url': '${Env.currentEnvConfig.h5}/#/privacy'};
                      NavigatorUtils.push(context, WebViewRouter.webView, params: params);
                    },
                  text: "《隐私协议》",
                  style: const TextStyle(
                    color: CottiColor.primeColor,
                  ),
                ),
                const TextSpan(text: "和"),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Map<String, dynamic> params = {'url': '${Env.currentEnvConfig.h5}/#/service'};
                      NavigatorUtils.push(context, WebViewRouter.webView, params: params);
                    },
                  text: "《用户协议》",
                  style: const TextStyle(
                    color: CottiColor.primeColor,
                  ),
                ),
                const TextSpan(text: "，并充分理解相关协议条款。为便于理解协议条款，特向您说明如下："),
              ],
            ),
            style: blackStyle,
          ),
          SizedBox(height: 8.w),
          _buildStep("1、", "为了向您提供订单、交易、会员权益相关的基本服务，我们会收集和使用必要的个人信息；"),
          SizedBox(height: 4.w),
          _buildStep(
              "2、",
              "为了向您提供所在位置附近的门店，和更契合需求的页面展示、产品及服务，需要授权同意我们获取位置权"
                  "限，您有权同意或拒绝授权，拒绝或撤回授权后我们为您提供的各项基础服务将会受到影响；"),
          SizedBox(height: 4.w),
          _buildStep("3、", "我们将严格按照您同意的各项条款使用您的个人信息。未经您同意，我们不会从第三方获取、共享或向其提供您的个人信息；"),
          SizedBox(height: 4.w),
          _buildStep("4、", "我们提供账户注销的渠道，您可以查询、更正、删除个人信息。"),
        ],
      ),
    );
  }

  _buildStep(String num, String content) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: num, style: primeStyle),
          TextSpan(text: content, style: blackStyle),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      height: bottomActionHeight,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => widget.callBack(false),
            child: Container(
              alignment: Alignment.center,
              width: 120.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.r)),
                border: Border.all(
                  color: CottiColor.primeColor,
                  width: 1.w,
                ),
              ),
              child: Text(
                '不同意并退出',
                style: TextStyle(
                  color: CottiColor.primeColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                await PrivacyUtil.saveFirstLaunched();
                widget.callBack(true);
              },
              child: Container(
                alignment: Alignment.center,
                width: 120.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                  color: CottiColor.primeColor,
                ),
                child: Text(
                  '同意',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
