import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/bloc/order_evaluate_detail_bloc.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/entity/order_comment_entity_entity.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/widget/dotted_line.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/widget/goods_evaluate_item_widget.dart';
import 'package:cotti_client/sensors/evaluate_sensors_constant.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

class OrderEvaluateDetailPage extends StatefulWidget {
  final String orderNo;

  final bool showPopup;

  const OrderEvaluateDetailPage({Key? key, required this.orderNo, this.showPopup = false})
      : super(key: key);

  @override
  _OrderEvaluateDetailPageState createState() {
    return _OrderEvaluateDetailPageState();
  }
}

class _OrderEvaluateDetailPageState extends State<OrderEvaluateDetailPage> {
  final OrderEvaluateDetailBloc _bloc = OrderEvaluateDetailBloc();

  @override
  void initState() {
    super.initState();
    SensorsAnalyticsFlutterPlugin.track(EvaluateSensorsConstant.orderEvaluateDetailView, {});
    _bloc.add(OrderEvaluateDetailInitEvent(orderId: widget.orderNo));
    if (widget.showPopup) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        _showPopup();
      });
    }
  }

  Future<bool> _back() async {
    NavigatorUtils.pop(context, result: true);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: WillPopScope(onWillPop: _back, child: buildContent()),
    );
  }

  Widget buildContent() {
    return BlocBuilder<OrderEvaluateDetailBloc, OrderEvaluateDetailState>(
      builder: (context, state) {
        return CustomPageWidget(
          title: '评价详情',
          appBarBackgroundColor: Colors.white,
          showLoading: state.showLoading,
          extendBodyBehindAppBar: false,
          clickLeading: () {
            NavigatorUtils.pop(context, result: true);
          },
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F6F7),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 16.w,
                ),
                child: Column(
                  children: [
                    _buildOrderEvaluate(state),
                    _buildCommodityEvaluate(state),
                    _buildShopWidget(state)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageGridView(List<String> imageUrls) {
    bool offstage = imageUrls.isEmpty;
    return Offstage(
      offstage: offstage,
      child: GridView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 12.h),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 9.w,
        ),
        children: List.generate(
            imageUrls.length,
            (index) => CottiImageWidget(
                  imageUrls[index],
                  imgW: 64.w,
                  imgH: 64.h,
                  fit: BoxFit.fill,
                  borderRadius: BorderRadius.circular(3.r),
                )),
      ),
    );
  }

  List<Widget> labelList(List<String> labels) {
    List<Widget> list = [];

    for (String label in labels) {
      Widget item = Container(
        decoration: BoxDecoration(
          border: Border.all(color: CottiColor.primeColor, width: 1.sp),
          color: const Color(0xffFBE7E5),
          borderRadius: BorderRadius.circular(3.r),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 7.h,
          horizontal: 6.w,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: CottiColor.primeColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

      list.add(item);
    }

    return list;
  }

  Widget _buildLabelGridView(List<String> labels) {
    bool offstage = labels.isEmpty;
    return Offstage(
      offstage: offstage,
      child: Container(
        padding: EdgeInsets.only(
          top: 16.h,
        ),
        alignment: Alignment.center,
        width: double.infinity,
        child: Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          textDirection: TextDirection.ltr,
          direction: Axis.horizontal,
          children: labelList(labels),
        ),
      ),
    );
  }

  /// 订单评价视图
  Widget _buildOrderEvaluate(OrderEvaluateDetailState state) {
    var iconName = state.data?.orderSatisfaction == 1
        ? "assets/images/order/order_evaluate/ic_satisfied_selected.svg"
        : "assets/images/order/order_evaluate/ic_unsatisfied_selected.svg";
    String evaluateTips = state.data?.orderSatisfaction == 1 ? "太赞了" : "不满意";
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        children: [
          /// 标题
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Text(
              '订单评价',
              style: titleTextStyle,
            ),
          ),

          /// 图片
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: SvgPicture.asset(
              iconName,
              width: 30.w,
              height: 30.w,
            ),
          ),

          /// 文字
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10.h),
            child: Text(
              evaluateTips,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: CottiColor.primeColor,
              ),
            ),
          ),

          /// 评价标签
          _buildLabelGridView(state.data?.orderEvaluateLabels ?? []),

          /// 评价文字
          if ((state.data?.content ?? "").isNotEmpty)
            Container(
              width: double.infinity,
              // height: 30.h,
              padding: EdgeInsets.only(top: 16.h),
              child: Text(
                state.data?.content ?? "",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xff666666),
                    fontWeight: FontWeight.w400,
                    height: 1.3),
              ),
            ),

          /// 订单评价图
          _buildImageGridView(state.data?.imageUrls ?? [])
        ],
      ),
    );
  }

  /// 商品评价视图
  Widget _buildCommodityEvaluate(OrderEvaluateDetailState state) {
    bool? off = state.data?.orderItemCommentList?.isEmpty;
    return Offstage(
      // offstage: false,
      offstage: off ?? true,
      child: Container(
        padding: EdgeInsets.only(
          top: 12.h,
          bottom: 17.h,
        ),
        margin: EdgeInsets.only(
          top: 12.h,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Column(
          children: [
            _buildCommodityEvaluateTitle(),
            _buildGoodsItemList(),
          ],
        ),
      ),
    );
  }

  /// 商品评价(${num})
  Widget _buildCommodityEvaluateTitle() {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 12.w),
      child: Text(
        "商品评价(${_bloc.state.data?.orderItemCommentList?.length ?? 0})",
        style: titleTextStyle,
      ),
    );
  }

  /// 商品列表
  Widget _buildGoodsItemList() {
    List<Widget> list = [];

    Widget? lastLine;

    for (OrderCommentEntityOrderItemCommentList item
        in _bloc.state.data?.orderItemCommentList ?? []) {
      list.add(GoodsEvaluateItemWidget(item: item));

      Widget line = Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: DottedLine(
          count: 40,
          dashedWidth: 4.w,
          dashedHeight: 0.5.h,
          color: const Color(0xFFE5E5E5),
        ),
      );
      lastLine = line;
      list.add(line);
    }

    if (lastLine != null) {
      list.remove(lastLine);
    }

    return Column(
      children: list,
    );
  }

  Widget _buildShopWidget(OrderEvaluateDetailState state) {
    OrderCommentEntityEntity? data = state.data;
    var offstage = data != null &&
        data.shopName != null &&
        data.orderCreateTime != null &&
        data.evaluateCreateTime != null;

    TextStyle textHint = TextStyle(
      fontSize: 14.sp,
      color: const Color(0xff979797),
    );

    TextStyle textBlack = TextStyle(
      fontSize: 14.sp,
      color: const Color(0xff351B0B),
    );

    return Offstage(
      offstage: !offstage,
      child: Container(
        margin: EdgeInsets.only(
          top: 12.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data?.shopName ?? '',
              style: titleTextStyle,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 16.h,
                bottom: 8.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '下单时间',
                      style: textHint,
                    ),
                  ),
                  Text(
                    data?.orderCreateTime ?? '',
                    style: textBlack,
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '评价时间',
                    style: textHint,
                  ),
                ),
                Text(
                  data?.evaluateCreateTime ?? '',
                  style: textBlack,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showPopup() {
    showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.55)),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://cdn-product-prod.yummy.tech/wechat/cotti/images/comment/img_thanks.png',
                            width: 140.w,
                            height: 166.h,
                          ),
                          Text(
                            '评价完成',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16.sp,
                              color: const Color(0xff111111),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              '感谢您的反馈，我们会继续努力给您带来更好地服务体验！',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 12.sp,
                                color: const Color(0xff666666),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
