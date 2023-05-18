import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/bloc/exchange_event.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/entity/coupon_exchange_entity.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/entity/validate_entity.dart';
import 'package:cotti_client/pages/tabs/mine/exchange_coupon/view/bottom_banner.dart';
import 'package:cotti_client/pages/tabs/mine/my/bloc/mine_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/my/entity/coupon_exchange_statement_entity.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/utils/f_toast_util.dart';
import 'package:cotti_client/utils/scheme_dispatcher.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/dialog/common_dialog.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bloc/exchange_bloc.dart';
import 'bloc/exchange_state.dart';
import 'entity/error_tips_info.dart';
import 'view/coupon_info_dialog.dart';
import 'view/rule_dialog.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2023/2/9 09:52
class ExchangeCouponPage extends StatefulWidget {
  final String title;

  const ExchangeCouponPage({Key? key, required this.title}) : super(key: key);

  @override
  State<ExchangeCouponPage> createState() => _ExchangeCouponPageState();
}

class _ExchangeCouponPageState extends State<ExchangeCouponPage> with WidgetsBindingObserver {
  late double keyBordMarginTopConst;

  //输入框按钮距离顶部的距离
  late double keyBordMarginTop;

  //兑换按钮底部距离顶部的距离
  late double changeButtonMarginTop;
  final TextEditingController _inputController = TextEditingController();
  late CouponExchangeStatementEntity? couponExchangeStatement;
  final ExchangeBloc _bloc = ExchangeBloc();
  final ValueNotifier<String> inputNotifier = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    keyBordMarginTopConst = 374.h;
    keyBordMarginTop = keyBordMarginTopConst;
    changeButtonMarginTop = keyBordMarginTop + 108.h;
    couponExchangeStatement = context.read<MineBloc>().state.couponExchangeStatement;
    WidgetsBinding.instance?.addObserver(this);
    _inputController.addListener(() => inputNotifier.value = _inputController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return BlocConsumer<ExchangeBloc, ExchangeState>(
      listenWhen: (p, c) {
        if (p.validateSuccessTime != c.validateSuccessTime) {
          _secondConfirm(c.validateEntity);
        }
        if (p.exchangeSuccessTime != c.exchangeSuccessTime) {
          _inputController.clear();
          FToastUtil.showToast("兑换成功");
        }
        if (p.errorTipsInfo?.errorTipsTime != c.errorTipsInfo?.errorTipsTime) {
          _showErrorDialog(c.errorTipsInfo);
        }
        return false;
      },
      listener: (context, state) {},
      builder: (context, state) {
        return CustomPageWidget(
          title: widget.title,
          titleColor: Colors.white,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          showLoading: state.showLoading,
          customLoadingColor: Colors.transparent,
          appBarBackgroundColor: Colors.transparent,
          actions: [_buildExchangeRule()],
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/mine/bg_exchange.png'),
              ),
            ),
            child: Stack(
              children: [
                ABiteBanner(
                  bannerParam: BannerParam("cotti-my-coupon-redeem-banner"),
                  width: ScreenUtil().screenWidth,
                  height: 0,
                  resize: true,
                  bannerSizeCallBack: (size) {
                    keyBordMarginTopConst = size.height + 20.h;
                    keyBordMarginTop = keyBordMarginTopConst;
                    changeButtonMarginTop = keyBordMarginTop + 108.h;
                    setState(() {});
                  },
                ),
                Column(
                  children: [
                    _buildInputView(),
                    _buildChangeButton(),
                  ],
                ),
                _buildBottomBanner(),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildExchangeRule() {
    String? title = couponExchangeStatement?.couponExchangeStatement?.title;
    String? content = couponExchangeStatement?.couponExchangeStatement?.content;
    if (title?.isEmpty ?? true) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        NavigatorUtils.unfocus();
        RuleDialog.show(context, title!, content ?? '');
      },
      child: UnconstrainedBox(
        child: Container(
          margin: EdgeInsets.only(right: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          height: 20.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: const Color(0xFF373737).withOpacity(0.4),
          ),
          child: Row(
            children: [
              SvgPicture.asset("assets/images/mine/ic_activity_explain.svg"),
              SizedBox(width: 2.w),
              Text(
                title ?? '',
                style: TextStyle(
                  color: const Color(0xFFF0EED1),
                  fontSize: 10.sp,
                ),
                strutStyle: StrutStyle(forceStrutHeight: true, height: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildInputView() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: EdgeInsets.only(top: keyBordMarginTop, left: 16.w, right: 16.w),
      height: 44.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3.r)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.04),
            offset: Offset(0, 3.h),
            blurRadius: 6.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              controller: _inputController,
              cursorColor: CottiColor.primeColor,
              keyboardType: couponExchangeStatement?.appKeyBoardType == 1
                  ? TextInputType.number
                  : TextInputType.emailAddress,
              inputFormatters: [
                couponExchangeStatement?.appKeyBoardType == 1
                    ? FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    : FilteringTextInputFormatter.allow(RegExp("^[a-z0-9A-Z]+")),
              ],
              maxLength: 50,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请输入抖音团购券号",
                counterText: '',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFCDCDCD),
                  fontWeight: FontWeight.normal,
                ),
              ),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: CottiColor.textBlack,
              ),
            ),
          ),
          ValueListenableBuilder<String>(
            valueListenable: inputNotifier,
            builder: (BuildContext context, value, Widget? child) {
              if (value.isEmpty) {
                return const SizedBox();
              }
              return GestureDetector(
                onTap: () => _inputController.clear(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w, top: 10.h, bottom: 10.h),
                  child: Icon(
                    IconFont.icon_clean,
                    size: 20.w,
                    color: const Color(0xFFCDCDCD),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _buildChangeButton() {
    return GestureDetector(
      onTap: () {
        logI("in tap $_bloc");

        // _bloc.state.couponExchange = CouponExchangeEntity()..couponName="券名称券名称券名称券名称券名称券名称券名称券名称券名称"
        // ..couponSubtitle="副标题副标题副标题副标题副标题副标题副标题副标题副标题"..num="4";

        if (_bloc.state.showLoading) {
          return;
        }
        String codeText = _inputController.value.text;
        if (codeText.isEmpty) {
          ToastUtil.show("请输入抖音团购券号");
          return;
        }
        _bloc.add(ValidateCouponEvent(codeText));
        NavigatorUtils.unfocus();
      },
      child: Container(
        height: 44.h,
        margin: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3.r)),
          color: CottiColor.primeColor,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.04),
              offset: Offset(0, 6.h),
              blurRadius: 6.r,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Text(
          '兑换',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          keyBordMarginTop = keyBordMarginTopConst;
        } else {
          double diff = ScreenUtil().screenHeight - MediaQuery.of(context).viewInsets.bottom;
          if (diff < changeButtonMarginTop) {
            keyBordMarginTop = keyBordMarginTopConst - (changeButtonMarginTop - diff);
          }
        }
      });
    });
  }

  _buildBottomBanner() {
    return const Align(
      alignment: Alignment.bottomCenter,
      child: BottomBanner(),
    );
  }

  _secondConfirm(ValidateEntity? validateEntity) {
    if (validateEntity == null) {
      return;
    }
    CouponInfoDialog.show(
      context,
      validateEntity,
      () => _bloc.add(ExchangeCouponEvent(_inputController.value.text)),
    );
  }

  _showErrorDialog(ErrorTipsInfo? errorTipsInfo) {
    String? code = errorTipsInfo?.errorType;
    if (code == "100") {
      CommonDialog.show(
        context,
        title: '兑换提示',
        content: errorTipsInfo?.errorMessage,
        mainButtonName: '去喝一杯',
        subButtonName: '查看优惠券',
        barrierDismissible: true,
      ).then((value) {
        if (value == 0) {
          NavigatorUtils.push(context, MineRouter.couponListPage);
        } else if (value == 1) {
          SchemeDispatcher.dispatchPath(context, "cottitab://coffee?tabIndex=1");
        }
      });
    } else if (code == "101" || code == "103") {
      CommonDialog.show(
        context,
        title: '兑换提示',
        content: errorTipsInfo?.errorMessage,
        barrierDismissible: true,
        mainButtonName: '我知道了',
      );
    } else if (code == "102") {
      CommonDialog.show(
        context,
        title: '兑换提示',
        content: errorTipsInfo?.errorMessage,
        mainButtonName: '去喝一杯',
        subButtonName: '查看代金券',
        barrierDismissible: true,
      ).then((value) {
        if (value == 0) {
          NavigatorUtils.push(context, MineRouter.cashPackageListPage);
        } else if (value == 1) {
          SchemeDispatcher.dispatchPath(context, "cottitab://coffee?tabIndex=1");
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }
}
