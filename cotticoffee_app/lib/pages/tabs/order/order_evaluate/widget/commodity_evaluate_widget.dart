import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/bloc/commodity_evaluate_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/entity/evaluate_config_entity.dart';
import 'package:cotti_client/sensors/evaluate_sensors_constant.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'evaluate_chip.dart';
import 'evaluate_star_rating.dart';
import 'evaluate_textfield_photo.dart';

/// ////////////////////////////////////////////
/// @Author: Jianzhong Cai
/// @Date: 2022/3/5 下午4:33
/// @Email: jianzhong.cai@ucarinc.com
/// @Description:
/// /////////////////////////////////////////////

class CommodityEvaluateWidget extends StatefulWidget {
  const CommodityEvaluateWidget({Key? key, required this.bloc}) : super(key: key);

  final CommodityEvaluateBloc bloc;

  @override
  _CommodityEvaluateWidgetState createState() => _CommodityEvaluateWidgetState();
}

class _CommodityEvaluateWidgetState extends State<CommodityEvaluateWidget> {
  late EvaluateConfigOrderItemList? _data;
  late CommodityEvaluateBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = widget.bloc;
    _data = widget.bloc.state.data;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommodityEvaluateBloc, CommodityEvaluateState>(
      bloc: _bloc,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: 13.h),
          child: Column(
            children: [
              _buildHeaderContent(),
              _buildBottomContent(),
            ],
          ),
        );
      },
    );
  }

  /// 构建头部视图
  Widget _buildHeaderContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CottiImageWidget(
          _data?.thumbnail ?? '',
          imgH: 56.w,
          imgW: 56.w,
          borderRadius: BorderRadius.circular(3.r),
          fit: BoxFit.fill,
        ),
        SizedBox(
          width: 14.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _data?.name ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF111111),
                ),
              ),
              Text(
                _data?.skuProps ?? '',
                style: TextStyle(
                  color: const Color(0xFF979797),
                  fontSize: 12.sp,
                ),
                strutStyle: StrutStyle(
                  forceStrutHeight: true,
                  fontSize: 12.sp,
                  height: 1.3,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              RatingBar.builder(
                minRating: 1,
                itemCount: 5,
                itemSize: 16.w,
                initialRating: 0,
                tapOnlyMode: true,
                itemPadding: EdgeInsets.only(right: 12.w),
                itemBuilder: (context, index) {
                  return Image.asset(
                    "assets/images/order/order_evaluate/ic_star_rating_selected.png",
                    width: 16.w,
                    height: 16.w,
                  );
                },
                unselectedItemBuilder: (context, index) {
                  return Image.asset(
                    "assets/images/order/order_evaluate/ic_star_rating_unselected.png",
                    width: 16.w,
                    height: 16.w,
                  );
                },
                onRatingUpdate: (rating) {
                  Map<String, dynamic> map = {
                    'ranting': rating,
                    'name': _data?.name ?? '',
                    'code': _data?.skuCode ?? '',
                  };
                  SensorsAnalyticsFlutterPlugin.track(
                      EvaluateSensorsConstant.commodityEvaluateStarClick, map);
                  _closeKeyboard(context);
                  _bloc.add(CommodityRantingSelectedEvent(rating.toInt()));
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  /// 构建底部视图
  Widget _buildBottomContent() {
    return Offstage(
      offstage: _bloc.state.ranting == 0,
      child: Column(
        children: [
          Offstage(
            offstage: _bloc.state.ranting >= _bloc.state.goodsSatisfiedMinStarCount
                ? _bloc.state.satisfiedOptions.isEmpty
                : _bloc.state.unsatisfiedOptions.isEmpty,
            child: ChipsChoice<String>.multiple(
              value: _bloc.state.selectedSatisfiedOptions,
              onChanged: (val) {
                SensorsAnalyticsFlutterPlugin.track(
                    EvaluateSensorsConstant.commodityEvaluateLabelClick, {'label': '$val'});

                _closeKeyboard(context);
                _bloc.add(CommoditySatisfiedOptionsSelectedEvent(val));
              },
              choiceItems: C2Choice.listFrom<String, String>(
                source: _bloc.state.ranting >= _bloc.state.goodsSatisfiedMinStarCount
                    ? _bloc.state.satisfiedOptions
                    : _bloc.state.unsatisfiedOptions,
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
                  style: EvaluateChoiceStyle.buildC2ChoiceStyle(
                      false, _bloc.state.ranting >= _bloc.state.goodsSatisfiedMinStarCount),
                  activeStyle: EvaluateChoiceStyle.buildC2ChoiceStyle(
                      true, _bloc.state.ranting >= _bloc.state.goodsSatisfiedMinStarCount),
                );
              },
            ),
          ),
          EvaluateTextFieldPhoto(
            textFieldHeight: 120.h,
            hintText: '您对产品质量满意嘛？',
            text: _bloc.state.evaluateMessage,
            selectedAssets: _bloc.state.selectAssets,
            orderEvaluateEditType: OrderEvaluateEditType.commodity,
            inputCallBack: (String value) => _bloc.add(CommodityEditEvaluateMessageEvent(value)),
            editAssetsCallBack: (List<AssetEntity>? assets) =>
                widget.bloc.add(CommodityEditAssetsEvent(assets ?? [])),
          ),
        ],
      ),
    );
  }

  /// 收起键盘
  void _closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    /// 键盘是否是弹起状态
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }
}

class EvaluateChoiceStyle {
  /// 构建卡片样式
  static C2ChoiceStyle buildC2ChoiceStyle(bool isActive, bool isSatisfied) {
    return C2ChoiceStyle(
      showCheckmark: false,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(top: 12.h),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      borderRadius: BorderRadius.circular(1.r),
      color: isActive ? const Color(0xFFFDF3F2) : CottiColor.backgroundColor,
      borderShape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: isActive ? CottiColor.primeColor : CottiColor.backgroundColor,
        ),
        borderRadius: BorderRadius.circular(3.r),
      ),
      labelStyle: TextStyle(
        fontSize: 12.sp,
        color: isActive
            ? (isSatisfied ? const Color(0xFFEE5857) : const Color(0xFFEE5857))
            : CottiColor.textBlack,
      ),
      labelPadding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: -4.5.h,
      ),
    );
  }
}
