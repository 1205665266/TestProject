import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/activity/red_model/share_get_coupon_model_entity.dart';
import 'package:cotti_client/pages/product/entity/product_detail_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_item_entity.dart';
import 'package:cotti_client/widget/share_widget/model/share_param.dart';
import 'package:cotti_client/widget/share_widget/poster_widget.dart';
import 'package:cotti_client/widget/share_widget/share.dart';
import 'package:cotti_client/widget/share_widget/share_bloc/share_bloc.dart';
import 'package:cotti_client/widget/share_widget/share_poster.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

/// FileName: share_sheet_dialog
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/20
class BottomShareDialog extends StatefulWidget {
  const BottomShareDialog({
    Key? key,
    required this.title,
    required this.maxHeight,
    this.isVisibilityCancel = false,
    this.shareContent,
    this.litimgUrl,
    this.shareUrl,
    this.shareWebTitle,
    this.productId,
    this.productName,
    this.path,
    this.shareChannels = const [1, 2],
    this.itemDetail,
    required this.fromPageType,
    this.orderId,
    this.activityNo,
    this.posterBaseImgList,
    this.qrCodeUrl
  }) : super(key: key);

  final String title;
  final bool isVisibilityCancel;
  final double maxHeight;

  //分享相关数据
  final String? shareContent;
  final String? litimgUrl;
  final String? shareUrl;
  final String? shareWebTitle;
  final String? productId;
  final String? productName;
  final String? path;
  final List? shareChannels;

  //商品详情商品信息
  final ProductDetailEntity? itemDetail;
  final int fromPageType;
  final String? orderId;
  final String? activityNo;
  final List<ShareGetCouponModelPosterBaseImgList>? posterBaseImgList;
  final String? qrCodeUrl;

  @override
  _BottomShareDialogState createState() => _BottomShareDialogState();
}

class _BottomShareDialogState extends State<BottomShareDialog> {
  final GlobalKey _globalKey = GlobalKey();
  final ShareBloc _bloc = ShareBloc();
  var configPath = '';
  var qrcodePath = '';
  var shopName = '';
  var viewPage = '';

  @override
  void initState() {
    _handleViewPage();
    super.initState();
  }

  _handleViewPage() {
    if (widget.fromPageType == 1) {
      viewPage = '商品详情';
    } else if (widget.fromPageType == 2) {
      viewPage = '特价专区';
    } else if (widget.fromPageType == 3) {
      viewPage = '邀新活动';
    } else if (widget.fromPageType == 4) {
      viewPage = '订单详情';
    } else if (widget.fromPageType == 5) {
      viewPage = '主题专区';
    }
  }

  _handleConfigPath() {
    logE('进入_handleConfigPath函数了:');
    logE('widget.path:${widget.path}');
    if (widget.path != null) {
      var shopMdCode = context.read<ShopMatchBloc>().state.shopMdCode ?? '';

      var takeFoodMode = context.read<ShopMatchBloc>().state.curTakeFoodMode;

      // var shareMemberId = Constant.memberId;
      var shareMemberId = "";

      configPath = widget.path ?? '';

      var lastStr = '';

      if (widget.path!.contains('?')) {
        if (widget.path!.contains('shopMdCode')) {
          lastStr = '&shareMemberId=$shareMemberId';
        } else {
          if (widget.path!.split('?').length > 1) {
            if (widget.fromPageType != 4) {
              lastStr =
                  '&shopMdCode=$shopMdCode&takeFoodMode=$takeFoodMode&shareMemberId=$shareMemberId';
            } else {
              lastStr = '&shareMemberId=$shareMemberId';
            }
          } else {
            if (widget.fromPageType != 4) {
              lastStr =
                  'shopMdCode=$shopMdCode&takeFoodMode=$takeFoodMode&shareMemberId=$shareMemberId';
            } else {
              lastStr = 'shareMemberId=$shareMemberId';
            }
          }
        }
      } else {
        if (widget.fromPageType != 4) {
          lastStr =
              '?shopMdCode=$shopMdCode&takeFoodMode=$takeFoodMode&shareMemberId=$shareMemberId';
        } else {
          lastStr = '?shareMemberId=$shareMemberId';
        }
      }
      configPath = configPath + lastStr;

      var list = [
        'https://dj-marketingtest1.abite.com/#/productdetail',
        'https://dj-marketingtest1.abite.com/#/offprice',
        'https://dj-marketingtest1.abite.com/#/invitee',
        'https://dj-marketingtest1.abite.com/#/sharegetcoupon',
        'https://dj-marketingtest1.abite.com/#/themeArea',
      ];

      if (widget.fromPageType == 5) {
        qrcodePath =
            list[widget.fromPageType - 1] + '?' + Uri.decodeComponent(configPath.split('?').last);
      } else {
        qrcodePath = list[widget.fromPageType - 1] + '?' + configPath.split('?').last;
      }

      //添加分享标志
      var oldConfigPath = configPath;
      var shareTag = '';
      if (oldConfigPath.contains('?')) {
        if (oldConfigPath.split('?').length > 1) {
          shareTag = '&sampshare=1';
        } else {
          shareTag = 'sampshare=1';
        }
      } else {
        shareTag = '?sampshare=1';
      }
      configPath = configPath + shareTag;
    }

    shopName = context.read<ShopMatchBloc>().state.currentShopDetail?.shopName ?? "";
  }

  String _handleAdImage() {
    var adImageURL = '';
    if (_bloc.state.bannerList.isNotEmpty) {
      return adImageURL = _bloc.state.bannerList[0].url ?? '';
    } else {
      return '';
    }
  }

  Widget showWidget() {
    return _bloc.state.isShowShare
        ? Share(
            shareContent: widget.shareContent,
            litimgUrl: widget.litimgUrl,
            shareUrl: widget.shareUrl,
            shareWebTitle: widget.shareWebTitle,
            path: configPath,
            productId: widget.productId,
            productName: widget.productName,
            shareChannels: widget.shareChannels ?? [1, 2],
            viewPage: viewPage,
            generatePoster: () {
              if (widget.fromPageType == 1) {
                _bloc.add(ShareProductEvent(
                    ShareParam('Ad-sjgf-order-detail-poster-V2-2', fromPage: widget.fromPageType)));
              } else {
                _handleNetWork();
                // import 'package:connectivity/connectivity.dart';

              }
            },
            shareWeChat: () {
              if (widget.fromPageType == 4) {
                _bloc.add(RecordShareGetCouponEvent(ShareParam('Ad-sjgf-order-detail-poster-V2-2',
                    fromPage: widget.fromPageType,
                    orderId: widget.orderId,
                    activityNo: widget.activityNo)));
              }
            },
            posterBaseImgList: widget.posterBaseImgList?.map((e) => e.url??"").toList(),
            qrCodeUrl: widget.qrCodeUrl,
          )
        : SharePoster(
            shareContent: widget.shareContent,
            litimgUrl: widget.litimgUrl,
            shareUrl: widget.shareUrl,
            shareWebTitle: widget.shareWebTitle,
            path: configPath,
            productId: widget.productId,
            productName: widget.productName,
            globalKey: _globalKey,
            itemDetail: widget.itemDetail,
            fromPageType: widget.fromPageType,
            viewPage: viewPage,
            hidePoster: () {
              _bloc.add(HidePosterEvent(
                  ShareParam('Ad-sjgf-order-detail-poster-V2-2', fromPage: widget.fromPageType)));
            },
            recordShareGetCoupon: () {
              if (widget.fromPageType == 4) {
                _bloc.add(RecordShareGetCouponEvent(ShareParam('Ad-sjgf-order-detail-poster-V2-2',
                    fromPage: widget.fromPageType,
                    orderId: widget.orderId,
                    activityNo: widget.activityNo)));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    _handleConfigPath();
    return BlocConsumer<ShareBloc, ShareState>(
      listener: (context, shareState) {},
      bloc: _bloc,
      builder: (context, state) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (_bloc.state.isShowShare) {
                // SensorsAnalyticsFlutterPlugin.track(SensorsConstant.shareCancel, {
                //   "product_spu_id": widget.productId ?? '',
                //   "viewPage": viewPage,
                // });
                Navigator.pop(context);
              } else {
                // SensorsAnalyticsFlutterPlugin.track(
                //     SensorsConstant.sharePyqPyqCancel, {
                //   "product_spu_id": widget.productId ?? '',
                //   "viewPage": viewPage,
                // });
                _bloc.add(HidePosterEvent(
                    ShareParam('Ad-sjgf-order-detail-poster-V2-2', fromPage: widget.fromPageType)));
              }
            },
            child: SizedBox(
              height: double.infinity,
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    state.isShowShare
                        ? SizedBox()
                        : Container(
                            child: PosterWidget(
                              globalKey: _globalKey,
                              fromPageType: widget.fromPageType,
                              itemDetail: widget.itemDetail,
                              qrcode: qrcodePath,
                              adImageUrl: _handleAdImage(),
                              shopName: shopName,
                            ),
                            margin: EdgeInsets.only(bottom: 28.h),
                          ),
                    Stack(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                          child: SizedBox(
                            height: 190.h,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(child: showWidget()),
                                Visibility(
                                  visible: widget.isVisibilityCancel,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_bloc.state.isShowShare) {
                                        // SensorsAnalyticsFlutterPlugin.track(SensorsConstant.shareCancel, {
                                        //   "product_spu_id": widget.productId ?? '',
                                        //   "viewPage": viewPage,
                                        // });
                                        Navigator.pop(context);
                                      } else {
                                        // SensorsAnalyticsFlutterPlugin.track(
                                        //     SensorsConstant.sharePyqPyqCancel, {
                                        //   "product_spu_id": widget.productId ?? '',
                                        //   "viewPage": viewPage,
                                        // });
                                        _bloc.add(HidePosterEvent(ShareParam(
                                            'Ad-sjgf-order-detail-poster-V2-2',
                                            fromPage: widget.fromPageType)));
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 18.h),
                                      width: 168.w,
                                      height: 40.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: CottiColor.primeColor,
                                          width: 1.w,
                                        ),
                                      ),
                                      child: Text(
                                        "取消",
                                        style: TextStyle(
                                          color: CottiColor.primeColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(child: _buildLoadingWidget())
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ///透明组件
  Widget _opacityBg(Color bgColor, Widget childWidget) {
    return Container(
      margin: EdgeInsets.only(top: 0),
      color: bgColor,
      child: childWidget,
    );
  }

  ///加载中
  Widget _buildLoadingWidget() {
    if (_bloc.state.isShowLoading) {
      var loadingWidget = Container(
        padding: EdgeInsets.only(top: 0.h),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            width: 105.w,
            height: 105.h,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.all(Radius.circular(9.r))),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/loading_data.json',
                  width: 52.w,
                  height: 52.h,
                ),
                Text(
                  '加载中',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                )
              ],
            )),
          ),
        ),
      );
      return _opacityBg(Colors.black.withOpacity(0), loadingWidget);
    }
    return const SizedBox();
  }

  void _handleNetWork() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult != ConnectivityResult.none) {
    //   //接入移动网络
    //   _bloc.add(ShareInitEvent(
    //       ShareParam('Ad-sjgf-order-detail-poster-V2-2', fromPage: widget.fromPageType)));
    // }else{
    //   ToastUtil.show('网络不给力');
    //
    // }
  }
}
