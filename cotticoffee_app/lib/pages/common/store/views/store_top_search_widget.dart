import 'package:cotti_client/pages/common/address/search_address/widget/city_conditions_search_widget.dart';
import 'package:cotti_client/sensors/store_sensors_constant.dart';
import 'package:cotticommon/router/fluro_navigator.dart';
import 'package:cotticommon/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import '../../../../global/icon_font.dart';
import '../../../../routers/common_page_router.dart';
import '../../city/entity/city_list_data_entity.dart';
import '../bloc/store_bloc.dart';

class StoreTopSearchWidget extends StatefulWidget {
  const StoreTopSearchWidget({Key? key, this.cityDataEntity, this.isFromConfirm = false})
      : super(key: key);
  final CityListDataData? cityDataEntity;
  final bool isFromConfirm;

  @override
  State<StoreTopSearchWidget> createState() => _StoreTopSearchWidgetState();
}

class _StoreTopSearchWidgetState extends State<StoreTopSearchWidget> {
  FocusNode myFocusCode = FocusNode();
  int inputTextLength = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 监听焦点变化
    myFocusCode.addListener(() {
      logI('焦点状态：${myFocusCode.hasFocus}');
      if (myFocusCode.hasFocus) {
        context.read<StoreBloc>().add(StoreListFocusCodeChagneEvent(true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool atBottom = context.read<StoreBloc>().state.atBottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.04),
            offset: Offset(0, 1.h),
            blurRadius: 2.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/shop/${atBottom ? 'shop_list_list_top_arrow.svg' : 'shop_list_top_down_arrow.svg'}',
            width: 28.w,
            height: 16.w,
            fit: BoxFit.fill,
          ),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.all(Radius.circular(2.w))),
            height: 32.w,
            margin: EdgeInsets.only(left: 16.w, top: 0, right: 16.w, bottom: 12.w),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      logI('fromConfirm = ==== topSearch ${widget.isFromConfirm}');

                      Map<String, dynamic> params = {
                        "fromConfirm": widget.isFromConfirm ? 'true' : 'false'
                      };
                      NavigatorUtils.push(context, CommonPageRouter.cityListPage, params: params)
                          .then((value) {
                        StoreBloc bloc = context.read<StoreBloc>();
                        logI('city page pop !!!');
                        if (value != null) {
                          logI('选择的城市：${value.toJson()}');
                          bool isFromHaveStore =
                              bloc.state.storeListEntity?.nearbyShopList != null &&
                                  bloc.state.storeListEntity!.nearbyShopList!.isNotEmpty;
                          if (!isFromHaveStore) {
                            isFromHaveStore =
                                bloc.state.storeListEntity?.oftenUsedShopList != null &&
                                    bloc.state.storeListEntity!.oftenUsedShopList!.isNotEmpty;
                          }

                          SensorsAnalyticsFlutterPlugin.track(
                              StoreSensorsConstant.storeListCitySelectedClick,
                              {'isFromHaveStore': isFromHaveStore});

                          context.read<StoreBloc>().add(StoreListChangeCityEvent(value,context: context));
                        }
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 12.w, right: 2.w),
                            child: Text(
                              configCityName(),
                              style: TextStyle(
                                  color: const Color(0xFF3A3B3C),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.sp),
                            )),
                        SvgPicture.asset(
                          'assets/images/shop/shop_list_list_top_city_arrow.svg',
                          width: 16.w,
                          height: 16.w,
                          fit: BoxFit.fill,
                        ),
                      ],
                    )),
                Container(
                  alignment: Alignment.center,
                  color: const Color(0xFFCFCFCF),
                  margin: EdgeInsets.only(left: 4.w, right: 8.w, top: 9.h, bottom: 9.h),
                  width: 1.w,
                ),
                Expanded(
                  child: Container(
                    // height: 48.h,
                    alignment: Alignment.centerLeft,
                    // color: Colors.yellow,
                    child: TextField(
                      onTap: () {
                        logI('onTap action !!!');
                        SensorsAnalyticsFlutterPlugin.track(
                            StoreSensorsConstant.storeListSearchTextFieldClick,
                            {'cityName': widget.cityDataEntity?.cityName ?? ''});
                      },
                      keyboardAppearance: Brightness.light,
                      controller: _controller,
                      // autofocus: widget.autofocus,
                      onChanged: (value) {

                        String searchCode = value.replaceAll(" ", "");

                        setState(() {
                          inputTextLength = searchCode.length;
                        });
                        logI('onChanged:$searchCode');

                        context.read<StoreBloc>().add(StoreListSearchShopEvent(searchCode));
                      },
                      focusNode: myFocusCode,
                      textInputAction: TextInputAction.done,
                      textAlignVertical: TextAlignVertical.center,

                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.25,
                        color: const Color(0xFF111111),
                      ),
                      // controller: _controller,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF979797)),
                        counterText: "",
                        // isCollapsed: true,
                        border: InputBorder.none,
                        hintText: '搜索门店',
                      ),
                      // inputFormatters: [
                      //   CustomizedTextInputFormatter(
                      //       filterPattern: RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]")), //只能输入汉字或者字母或数字
                      //   LengthLimitingTextInputFormatter(14),
                      // ],
                      onSubmitted: (val) => _searchCall(val),
                    ),
                  ),
                ),
                Visibility(
                  visible: inputTextLength > 0,
                  child: GestureDetector(
                    onTap: () {
                      _controller.clear();
                      //取消键盘
                      NavigatorUtils.unfocus();
                      setState(() {
                        inputTextLength = 0;
                      });

                      context
                          .read<StoreBloc>()
                          .add(StoreListSearchShopEvent('', isClearShopMdName: true));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        child: Icon(
                          IconFont.icon_clean,
                          size: 16.w,
                          color: const Color(0xFFcfcfcf),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String configCityName() {
    if (widget.cityDataEntity?.cityName != null) {
      return widget.cityDataEntity!.cityName!;
    } else {
      return "请选择";
    }
  }

  void _searchCall(val) {}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myFocusCode.dispose();
  }
}
