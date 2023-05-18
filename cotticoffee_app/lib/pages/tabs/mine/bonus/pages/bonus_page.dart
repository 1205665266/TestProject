import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/mine/bonus/bloc/bonus_bloc.dart';
import 'package:cotti_client/pages/tabs/mine/bonus/entity/bonus_detail_entity.dart';
import 'package:cotti_client/pages/tabs/mine/bonus/entity/bonus_log_entity.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/routers/web_view_router.dart';
import 'package:cotti_client/sensors/bonus_sensors_constant.dart';
import 'package:cotti_client/sensors/store_sensors_constant.dart';
import 'package:cotti_client/utils/scheme_dispatcher.dart';
import 'package:cotti_client/widget/banner/banner.dart';
import 'package:cotti_client/widget/banner/widget/abite_banner.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/custom_smart_footer.dart';
import 'package:cotti_client/widget/custom_smart_header.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class BonusPage extends StatefulWidget {
  const BonusPage({Key? key}) : super(key: key);

  @override
  _BonusBonusPageState createState() {
    return _BonusBonusPageState();
  }
}

class _BonusBonusPageState extends State<BonusPage> {
  final RefreshController _controller = RefreshController(initialRefresh: false);
  final BonusBloc _bloc = BonusBloc();

  @override
  void initState() {
    super.initState();

    _bloc.add(BonusInitEvent());

    SensorsAnalyticsFlutterPlugin.track(
        BonusSensorsConstant.bonusListView, {});

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<BonusBloc, BonusState>(
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.noMore) {
            _controller.loadNoData();
          } else {
            _controller.loadComplete();
          }
          if (state.refreshStatus == RefreshStatus.completed) {
            _controller.refreshCompleted();
          }
        },
        builder: (context, state) {
          return CustomPageWidget(
            title: '奖励金',
            appBarBackgroundColor: Colors.white,
            showLoading: state.showLoading,
            extendBodyBehindAppBar: false,
            child: SafeArea(
              child: SmartRefresher(
                enablePullUp: true,
                controller: _controller,
                header: const CustomSmartHeader(),
                footer: CustomSmartFooter(),
                onLoading: () => context.read<BonusBloc>().add(BonusLoadingEvent()),
                onRefresh: () => context.read<BonusBloc>().add(BonusRefreshEvent()),
                child: _buildListWidget(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
        child: Container(
      color: const Color(0xfff5f5f5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/mine/no_bounty_bg.png',
            width: 141.w,
            height: 121.h,
          ),
          SizedBox(
            height: 12.h,
          ),
          Text(
            _bloc.state.noDataTitle ?? "",
            style: TextStyle(color: Color(0xff666666), fontSize: 13.sp),
          ),
          SizedBox(
            height: 40.h,
          ),
          SizedBox(
            width: 144.w,
            height: 39.h,
            child: ABiteBanner(
              bannerParam: BannerParam("cotti-my-bonus-noBonus-Banner"),
              onBannerChanged: (BannerModel model) {
                _bloc.add(BonusNoDataTitleDoneEvent(noDataTitle: model.title));
              },
              onTapItemCallBack: (BannerModel? model){
                SensorsAnalyticsFlutterPlugin.track(
                    BonusSensorsConstant.toGetBonusListClick, {});
              },
            ),
          )
        ],
      ),
    ));
  }

  Widget _buildListWidget() {
    if (_bloc.state.logList == null || _bloc.state.logList!.isEmpty) {
      return _buildEmptyWidget();
    }

    logW('_bloc.state.refresh ${_bloc.state.refreshStatus}');

    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _buildLogItem(index: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return _buildSeparator(index: index);
      },
      itemCount: (_bloc.state.logList?.length ?? 0) + 1,
    );
  }

  Widget _buildHeader() {
    BonusDetailEntity? detailEntity = _bloc.state.detailEntity;

    return Column(
      children: [
        SizedBox(
          height: 164.w,
          width: double.infinity,
          child: Stack(
            children: [
              SvgPicture.asset(
                "assets/images/mine/mine_bounty_bg.svg",
                height: 164.w,
                width: double.infinity,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.h,
                    ),
                    child: Text(
                      "奖励金",
                      style: TextStyle(fontSize: 12.sp, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 6.h,
                    ),
                    height: 56.h,
                    child: Text(
                      "${detailEntity?.balance ?? 0}",
                      style: TextStyle(
                        fontSize: 40.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 12.h,
                      left: 39.w,
                      right: 39.w,
                    ),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${detailEntity?.income ?? 0}",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 4.h,
                              ),
                              child: Text(
                                "收入",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 0.5.w,
                          height: 18.h,
                          color: Colors.white,
                        ),
                        Column(
                          children: [
                            Text(
                              "${detailEntity?.expenditure ?? 0}",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 4.h,
                              ),
                              child: Text(
                                "支出",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 0.5.w,
                          height: 18.h,
                          color: Colors.white,
                        ),
                        Column(
                          children: [
                            Text(
                              "${detailEntity?.expired ?? 0}",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 4.h,
                              ),
                              child: Text(
                                "过期",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 12.h,
                right: 0,
                child: GestureDetector(
                  onTap: _gotoRules,
                  child: Container(
                    alignment: Alignment.center,
                    height: 28.h,
                    width: 82.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.h),
                        bottomLeft: Radius.circular(14.h),
                      ),
                      color: const Color.fromARGB(76, 255, 255, 255),
                    ),
                    padding: EdgeInsets.only(left: 8.w),
                    child: Row(
                      children: [
                        Image(
                          image: const AssetImage("assets/images/mine/mine_bounty_jg.png"),
                          width: 15.h,
                          height: 15.h,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          '规则说明',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Offstage(
          offstage: !(detailEntity?.expiring != null && (detailEntity?.expiring ?? 0) > 0),
          child: Container(
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            color: const Color(0xfffff2ed),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${detailEntity?.expiring??''}个奖励金将于${detailEntity?.expiringDate??''}过期',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: CottiColor.textBlack,
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    logI('on tap !!!!!');

                    SensorsAnalyticsFlutterPlugin.track(
                        BonusSensorsConstant.toUseBonusListClick, {'expired': (detailEntity?.expired ?? 0)});

                    SchemeDispatcher.dispatchPath(context, 'cottitab://coffee?tabIndex=1&takeFoodMode=100');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '去使用',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: CottiColor.primeColor,
                        ),
                      ),
                      Icon(
                        IconFont.icon_right,
                        size: 12.sp,
                        color: CottiColor.primeColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogItem({required int index}) {
    if (index == 0) {
      return _buildHeader();
    }

    BonusLogEntity logEntity = _bloc.state.logList![index - 1];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      height: 80.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                logEntity.businessName ?? "",
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
              Offstage(
                offstage: logEntity.orderNo == null,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 5.h,
                  ),
                  child: Text(
                    "订单号${logEntity.orderNo}",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xff979797),
                    ),
                  ),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${(logEntity.operationValue ?? 0) > 0 ? "+${logEntity.operationValue}" : logEntity.operationValue}",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: (logEntity.operationValue ?? 0) >= 0
                      ? CottiColor.primeColor
                      : const Color(0xff111111),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 5.h,
                  right: 3.w,
                ),
                child: Text(
                  logEntity.operationDate ?? "",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xff979797),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator({required int index}) {
    if (index == 0) {
      return const SizedBox();
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      height: 0.5.h,
      color: const Color(0xffEEEEEE),
    );
  }

  void _gotoRules() {
    logI('_gotoRules');

    // NavigatorUtils.push(
    //   context,
    //   WebViewRouter.webView,
    //   params: {'url': 'http://10.132.20.244:8000/'},
    // );

    NavigatorUtils.push(
      context,
      MineRouter.bonusRulesPage,
      params: {"rules": _bloc.state.detailEntity?.pointRuleDesc ?? ""},
    );
  }
}
