import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/bloc/order_evaluate_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/widget/commodity_evaluate_widget.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/widget/dotted_line.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/widget/evaluate_chip.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/widget/evaluate_textfield_photo.dart';
import 'package:cotti_client/sensors/evaluate_sensors_constant.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class OrderEvaluatePage extends StatefulWidget {
  final String orderNo;

  const OrderEvaluatePage({Key? key, required this.orderNo}) : super(key: key);

  @override
  _OrderEvaluatePageState createState() {
    return _OrderEvaluatePageState();
  }
}

class _OrderEvaluatePageState extends State<OrderEvaluatePage> {
  final OrderEvaluateBloc _bloc = OrderEvaluateBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(OrderEvaluateGetConfigEvent(orderId: widget.orderNo));

    SensorsAnalyticsFlutterPlugin.track(EvaluateSensorsConstant.orderEvaluateView, {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: buildContent(),
    );
  }

  Widget buildContent() {
    return BlocBuilder<OrderEvaluateBloc, OrderEvaluateState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            _onPressLeft();
            return false;
          },
          child: CustomPageWidget(
            title: '订单评价',
            appBarBackgroundColor: Colors.white,
            showLoading: state.showLoading,
            pageBackgroundColor: Colors.white,
            customLoadingColor: Colors.transparent,
            extendBodyBehindAppBar: false,
            clickLeading: _onPressLeft,
            child: SafeArea(
              top: false,
              child: GestureDetector(
                onTap: () {
                  _closeKeyboard(context);
                },
                child: Container(
                  color: const Color(0xFFF5F6F7),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF5F6F7),
                            ),
                            padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
                            child: Column(
                              children: [
                                _buildOrderEvaluate(state),
                                _buildCommodityEvaluate(state),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _buildBottomButton(state),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 构建订单评价视图
  Widget _buildOrderEvaluate(OrderEvaluateState state) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 12.h),
      padding: EdgeInsets.only(top: 14.h, bottom: 12.h, left: 12.w, right: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        children: [
          _buildOrderEvaluateHeader(),
          _buildOrderEvaluateCenter(state),
          _buildOrderEvaluateFooter(state),
        ],
      ),
    );
  }

  /// 构建订单评价顶部视图
  Widget _buildOrderEvaluateHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: SizedBox(
                width: 14.w,
                child: const Divider(
                  color: Color(0xFF111111),
                ),
              ),
            ),
            Text(
              "写下真实体验，让我们倾听您的声音",
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF666666),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: SizedBox(
                width: 14.w,
                child: const Divider(
                  color: Color(0xFF111111),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: const Divider(
            height: 0.5,
            color: Color(0xFFE5E5E5),
          ),
        ),
      ],
    );
  }

  /// 构建订单评价中心视图
  Widget _buildOrderEvaluateCenter(OrderEvaluateState state) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 13.h),
          child: Row(
            children: [
              Text(
                '订单评价',
                style: TextStyle(
                  color: const Color(0xff111111),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderEvaluateSatisfiedButton(state),
              _buildOrderEvaluateUnsatisfiedButton(state),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建订单评价底部视图
  Widget _buildOrderEvaluateFooter(OrderEvaluateState state) {
    debugPrint(
        'state.configEntity?.orderSatisfiedLabels = ${state.configEntity?.orderSatisfiedLabels}');

    return Offstage(
      offstage: !state.hasBeenOperating,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 14.h, bottom: 2.h),
            child: Text(
              state.isSelectedSatisfied ? '真不错，接受我的表扬吧~' : '我要吐槽，尽快改进！',
              style: TextStyle(
                color: state.isSelectedSatisfied ? CottiColor.textBlack : CottiColor.primeColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Offstage(
            // offstage: false,
            offstage: state.isSelectedSatisfied
                ? state.configEntity?.orderSatisfiedLabels == null
                : state.configEntity?.orderDissatisfiedLabels == null,
            child: ChipsChoice<String>.multiple(
              value: state.selectedSatisfiedOptions,
              onChanged: (val) {
                debugPrint('onChanged: ($val)');
                _closeKeyboard(context);

                String key = state.isSelectedSatisfied
                    ? EvaluateSensorsConstant.orderEvaluateSatisfiedLabelClick
                    : EvaluateSensorsConstant.orderEvaluateUnsatisfiedLabelClick;

                SensorsAnalyticsFlutterPlugin.track(key, {'label': '$val'});

                _bloc.add(SatisfiedOptionsSelectedEvent(val));
              },
              choiceItems: C2Choice.listFrom<String, String>(
                source: state.isSelectedSatisfied
                    ? state.configEntity?.orderSatisfiedLabels ?? []
                    : state.configEntity?.orderDissatisfiedLabels ?? [],
                // source: ['1234','4567'],
                value: (i, v) => v,
                label: (i, v) => v,
              ),
              wrapped: true,
              spacing: 12.w,
              padding: EdgeInsets.zero,
              alignment: WrapAlignment.center,
              choiceStyle: const C2ChoiceStyle(
                color: Color(0xffffffff),
              ),
              choiceBuilder: (item) {
                return EvaluateC2Chip(
                  data: item,
                  style: EvaluateChoiceStyle.buildC2ChoiceStyle(false, state.isSelectedSatisfied),
                  activeStyle:
                  EvaluateChoiceStyle.buildC2ChoiceStyle(true, state.isSelectedSatisfied),
                );
              },
            ),
          ),
          EvaluateTextFieldPhoto(
            textFieldHeight: 124.h,
            text: state.evaluateMessage,
            selectedAssets: state.selectAssets,
            hintText: '请在此输入您的建议，以帮助我们进行改进~',
            inputCallBack: (String value) => _bloc.add(EditEvaluateMessageEvent(value)),
            editAssetsCallBack: (List<AssetEntity>? assets) =>
                _bloc.add(EditAssetsEvent(assets ?? [])),
          )
        ],
      ),
    );
  }

  /// 构建订单评价满意按钮
  Widget _buildOrderEvaluateSatisfiedButton(OrderEvaluateState state) {
    return GestureDetector(
      onTap: () {
        SensorsAnalyticsFlutterPlugin.track(
            EvaluateSensorsConstant.orderEvaluateSatisfiedClick, {});

        _closeKeyboard(context);
        _bloc.add(SatisfiedSelectedEvent(true));
      },
      child: Column(
        children: [
          state.hasBeenOperating && state.isSelectedSatisfied
              ? SvgPicture.asset(
            'assets/images/order/order_evaluate/ic_satisfied_selected.svg',
            width: 30.w,
            height: 30.w,
            fit: BoxFit.fill,
          )
              : SvgPicture.asset(
            "assets/images/order/order_evaluate/ic_satisfied_unselected.svg",
            width: 30.w,
            height: 30.w,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            '太赞了',
            style: TextStyle(
              color: state.hasBeenOperating && state.isSelectedSatisfied
                  ? CottiColor.primeColor
                  : CottiColor.textGray,
              fontSize: 14.sp,
              fontWeight: state.hasBeenOperating && state.isSelectedSatisfied
                  ? FontWeight.w500
                  : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建订单评价不满意按钮
  Widget _buildOrderEvaluateUnsatisfiedButton(OrderEvaluateState state) {
    return GestureDetector(
      onTap: () {
        SensorsAnalyticsFlutterPlugin.track(
            EvaluateSensorsConstant.orderEvaluateUnsatisfiedClick, {});
        _closeKeyboard(context);
        _bloc.add(SatisfiedSelectedEvent(false));
      },
      child: Column(
        children: [
          state.hasBeenOperating && !state.isSelectedSatisfied
              ? SvgPicture.asset(
            'assets/images/order/order_evaluate/ic_unsatisfied_selected.svg',
            width: 30.w,
            height: 30.w,
            fit: BoxFit.fill,
          )
              : SvgPicture.asset(
            "assets/images/order/order_evaluate/ic_unsatisfied_unselected.svg",
            width: 30.w,
            height: 30.w,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            '不满意',
            style: TextStyle(
              color: state.hasBeenOperating && !state.isSelectedSatisfied
                  ? CottiColor.primeColor
                  : CottiColor.textGray,
              fontSize: 14.sp,
              fontWeight: state.hasBeenOperating && !state.isSelectedSatisfied
                  ? FontWeight.w500
                  : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建商品评价视图
  Widget _buildCommodityEvaluate(OrderEvaluateState state) {
    return Offstage(
      offstage: _bloc.state.commodityBlocs.isEmpty,
      child: Container(
          margin: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 20.h),
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 7.h),
                child: Row(
                  children: [
                    Text(
                      '商品评价(${_bloc.state.commodityBlocs.length})',
                      style: TextStyle(
                        color: const Color(0xff111111),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _bloc.state.commodityBlocs.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 14.h),
                    child: DottedLine(
                      count: 40,
                      dashedWidth: 4.w,
                      dashedHeight: 0.5.h,
                      color: const Color(0xFFE5E5E5),
                    ),
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return CommodityEvaluateWidget(bloc: _bloc.state.commodityBlocs[index]);
                },
              )
            ],
          )),
    );
  }

  Widget _buildBottomButton(OrderEvaluateState state) {
    bool isEnable = state.hasBeenOperating && state.selectedSatisfiedOptions.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      height: 68.h,
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          if (isEnable) {
            SensorsAnalyticsFlutterPlugin.track(
                EvaluateSensorsConstant.orderEvaluateSubmitClick, {});

            _bloc.add(SubmitEvaluateEvent(context: context));
          } else {
            if (!state.hasBeenOperating) {
              ToastUtil.show("请填写订单评价");
            } else if (state.selectedSatisfiedOptions.isEmpty) {
              ToastUtil.show(state.isSelectedSatisfied ? '请选择满意原因' : '请选择不满意原因');
            }
          }
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: isEnable ? CottiColor.primeColor : const Color(0xffE0e0e0)),
            color: isEnable ? CottiColor.primeColor : const Color(0xffE0e0e0),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            '提交评价',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  /// 自定义[返回按钮]点击事件
  _onPressLeft() async {
    var res = await showDialog(
        context: context,
        builder: (logContext) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 335.w,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Column(
                  children: [
                    // SizedBox(height: 1.h),
                    Text(
                      '确定退出评价吗？',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3A3B3C)),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      '退出后，您精心填写的内容将无法保存',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF111111)),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(logContext, 'pop'),
                          child: Container(
                            width: 149.w,
                            height: 48.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: CottiColor.textHint),
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                            child: Text(
                              '确定退出',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                  decoration: TextDecoration.none,
                                  color: CottiColor.textGray),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(logContext);
                          },
                          child: Container(
                            width: 149.w,
                            height: 46.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: CottiColor.primeColor,
                              borderRadius: BorderRadius.circular(3.r),
                              border: Border.all(width: 1, color: CottiColor.primeColor),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xFF470800).withOpacity(0.10),
                                    offset: const Offset(0, 7.5), //阴影y轴偏移量
                                    blurRadius: 12, //阴影模糊程度
                                    spreadRadius: -5 //阴影扩散程度
                                ),
                                BoxShadow(
                                    color: const Color(0xFF470800).withOpacity(0.10),
                                    offset: const Offset(0, 12), //阴影y轴偏移量
                                    blurRadius: 8, //阴影模糊程度
                                    spreadRadius: -20 //阴影扩散程度
                                )
                              ],
                            ),
                            child: Text(
                              '继续评价',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        });

    if (res != null && res == 'pop') {
      Navigator.pop(context);
    }
  }

  /// 收起键盘
  void _closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    /// 键盘是否是弹起状态
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
