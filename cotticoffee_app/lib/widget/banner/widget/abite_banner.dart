import 'dart:async';
import 'dart:io';

import 'package:abitelogin/abitelogin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cotti_client/config/constant.dart';
import 'package:cotti_client/utils/scheme_dispatcher.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import '../model/banner_model.dart';
import '../model/banner_param.dart';
import 'banner_bloc.dart';

/// FileName: abite_banner
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/7
class ABiteBanner extends StatefulWidget {
  final BannerParam? bannerParam;

  ///banner的宽 如果不传，则会默认按最大宽度算
  final double? width;

  ///banner的高度 如果不传，则会默认按父容器最大高度算
  final double? height;

  /// 指示器高度
  final EdgeInsets? pointEdgeInsets;

  /// 圆角
  final BorderRadius? borderRadius;

  final BoxFit? fit;

  ///轮播间隔时间(ms)
  final int? durationDelayMs;

  final Color? bgColor;

  ///是否重复播放lottie动画，仅在当前是lottie的情况下生效,默认false
  final bool repeat;

  ///点击banner回调函数
  final Function(BannerModel)? onTapItemCallBack;
  final Function(Size)? bannerSizeCallBack;

  /// 广告轮播切换时回调
  final Function(BannerModel)? onBannerChanged;
  final BannerController? bannerController;

  ///广告位padding
  final EdgeInsetsGeometry? padding;

  ///广告位margin
  final EdgeInsetsGeometry? margin;

  ///外部传来的广告位数据，@bannerParam 参数为null时 此参数生效
  final List<BannerModel>? banners;

  ///是否自动弹窗
  final bool isShowDialog;

  ///是否重新计算宽高
  final bool resize;

  const ABiteBanner({
    Key? key,
    this.bannerParam,
    this.width,
    this.height,
    this.borderRadius,
    this.fit,
    this.pointEdgeInsets,
    this.durationDelayMs,
    this.bannerSizeCallBack,
    this.bannerController,
    this.onBannerChanged,
    this.isShowDialog = true,
    this.onTapItemCallBack,
    this.padding,
    this.margin,
    this.bgColor,
    this.banners,
    this.resize = false,
    this.repeat = false,
  }) : super(key: key);

  @override
  _ABiteBannerState createState() => _ABiteBannerState();
}

class _ABiteBannerState extends State<ABiteBanner> with TickerProviderStateMixin {
  final BannerBloc _bloc = BannerBloc();
  Function? onTapCallback;
  bool swiperInit = false;
  double? width;
  double? height;
  late bool resize;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;
    resize = widget.resize;
    _controller = AnimationController(vsync: this);
    if (widget.bannerParam != null) {
      _bloc.add(BannerInitEvent(widget.bannerParam!));
      widget.bannerController?.addListener(_reload);
    } else if (widget.banners != null) {
      _bloc.add(LocalBannerEvent(widget.banners!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BannerBloc, BannerState>(
      bloc: _bloc,
      builder: (context, state) {
        return Visibility(
          visible: state.banners.isNotEmpty,
          child: Container(
            margin: widget.margin,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: widget.borderRadius,
            ),
            child: state.banners.length == 1
                ? _buildSingleItem(state.banners[0])
                : _buildSwiper(state.banners),
          ),
        );
      },
      listener: (context, state) {
        if (widget.onBannerChanged != null && !swiperInit && state.bannerList.isNotEmpty) {
          swiperInit = true;
          widget.onBannerChanged!(state.bannerList[0]);
        }
        if (state.popups.isNotEmpty) {
          _showBannerDialog(state.popups.first);
        }
      },
    );
  }

  Widget _buildSingleItem(BannerModel model) {
    if (resize) {
      resize = false;
      swiperResize(model.url ?? '');
    }
    return _swiperItem(context, model);
  }

  Widget _buildSwiper(List<BannerModel> banners) {
    if (resize && banners.length > 1) {
      resize = false;
      swiperResize(banners[0].url ?? '');
    }
    return SizedBox(
      width: width ?? 0,
      height: height ?? 0,
      child: Swiper(
        pagination: _buildSwiperPagination(),
        autoplay: true,
        itemBuilder: (context, index) => _swiperItem(context, banners[index]),
        autoplayDelay: widget.durationDelayMs ?? 4000,
        duration: 550,
        onIndexChanged: (index) {
          if (widget.onBannerChanged != null) {
            widget.onBannerChanged!(banners[index]);
          }
        },
        itemCount: banners.length,
      ),
    );
  }

  Widget _swiperItem(BuildContext ctx, BannerModel bannerModel, {onTapCallback}) {
    String url = bannerModel.url ?? '';
    bool isJson = url.endsWith(".json");
    return GestureDetector(
      onTap: () => onTapItem(ctx, bannerModel, onTapCallback: onTapCallback),
      child: isJson
          ? Lottie.network(
              url,
              height: height,
              width: width,
              fit: widget.fit,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox();
              },
            )
          : CottiImageWidget(
              url,
              imgH: height,
              imgW: width,
              borderRadius: widget.borderRadius,
              fit: widget.fit,
            ),
    );
  }

  Widget _buildLottiDialogWidget(BuildContext ctx, File file, BannerModel bannerModel,
      {onTapCallback}) {
    return GestureDetector(
      onTap: () => onTapItem(ctx, bannerModel, onTapCallback: onTapCallback),
      child: Lottie.file(
        file,
        height: height,
        width: width,
        fit: widget.fit,
        repeat: widget.repeat,
        onLoaded: (LottieComposition composition) {
          _controller.duration = composition.duration;
          _controller.reset();
          _controller.forward();
        },
      ),
    );
  }

  void onTapItem(BuildContext ctx, BannerModel bannerModel, {onTapCallback}) {
    if (widget.onTapItemCallBack == null &&
        onTapCallback != null &&
        (bannerModel.redirectUrl?.isNotEmpty ?? false)) {
      onTapCallback();
    }
    if (widget.onTapItemCallBack != null) {
      widget.onTapItemCallBack!(bannerModel);
    } else if ((bannerModel.popup?.loginRequired == true ||
            bannerModel.floatWindow?.loginRequired == true) &&
        !Constant.hasLogin) {
      LoginUtils.login(context).then((value) {
        if (bannerModel.redirectUrl != null) {
          SchemeDispatcher.dispatchPath(context, bannerModel.redirectUrl!);
        }
      });
    } else {
      if (bannerModel.redirectUrl != null) {
        SchemeDispatcher.dispatchPath(context, bannerModel.redirectUrl!);
      }
    }
    var sensorProperties = {
      'activityId': bannerModel.popup != null ? bannerModel.popup!.activityId : '',
      'activityNumber': bannerModel.popup != null ? bannerModel.popup!.activityNumber : '',
      "positionCode": bannerModel.positionCode,
      "positionType": bannerModel.positionType,
      "viewPage": widget.bannerParam?.viewPage,
      "positionName": bannerModel.positionName,
      "banner_sort": bannerModel.sort,
    };

    ///埋点 通用广告弹窗-点击
    ///埋点 通用广告Banner-点击 弹窗，banner 都是同一事件，通过 positionType 区分 ：广告位类型 1 banner 2 弹窗 3 浮窗
    SensorsAnalyticsFlutterPlugin.track('generic_ad_banner_click_event', sensorProperties);
  }

  SwiperPlugin _buildSwiperPagination() {
    return SwiperPagination(
      alignment: Alignment.bottomRight,
      margin: widget.pointEdgeInsets ?? EdgeInsets.only(bottom: 10.h, right: 10.w),
      builder: RectSwiperPaginationBuilder(
        size: Size(7.w, 3.h),
        activeSize: Size(21.w, 3.5.h),
        space: 0,
        activeColor: Colors.white,
        color: Colors.white.withOpacity(0.6),
      ),
    );
  }

  void _showBannerDialog(BannerModel bannerModel) async {
    String url = bannerModel.url ?? '';
    bool isJson = url.endsWith(".json");
    File? file;
    if (bannerModel.updateFrequency ?? false) {
      _bloc.add(UpdateFrequencyEvent(bannerModel.positionCode ?? "", widget.bannerParam!));
    }
    if (isJson) {
      file = await DefaultCacheManager().getSingleFile(url);
    } else {
      Image imageNetwork = Image(image: CachedNetworkImageProvider(url));
      Completer<ImageInfo> completer = Completer<ImageInfo>();
      ImageStreamListener listener = ImageStreamListener((ImageInfo info, _) {
        if (!completer.isCompleted) {
          completer.complete(info);
        }
      }, onError: (exception, __) {
        if (completer.isCompleted) {
          completer.completeError(exception);
        }
      });
      imageNetwork.image.resolve(const ImageConfiguration()).addListener(listener);
      await completer.future;
      imageNetwork.image.resolve(const ImageConfiguration()).removeListener(listener);
    }
    if (isJson && file == null) {
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Container(
            color: Colors.transparent,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isJson
                    ? _buildLottiDialogWidget(
                        context,
                        file!,
                        bannerModel,
                        onTapCallback: () => _popDialog(context, bannerModel),
                      )
                    : _swiperItem(
                        context,
                        bannerModel,
                        onTapCallback: () => _popDialog(context, bannerModel),
                      ),
                SizedBox(height: 30.h),
                GestureDetector(
                  onTap: () => _popDialog(context, bannerModel),
                  child: Opacity(
                    opacity: 0.77,
                    child: SvgPicture.asset(
                      "assets/images/ic_btn_close.svg",
                      width: 30.w,
                      height: 30.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    ///埋点 通用广告弹窗-弹出
    var sensorProperties = {
      'activityId': bannerModel.popup != null ? bannerModel.popup!.activityId : '',
      'activityNumber': bannerModel.popup != null ? bannerModel.popup!.activityNumber : '',
      "positionCode": bannerModel.positionCode,
      "positionType": bannerModel.positionType,
      "viewPage": widget.bannerParam?.viewPage,
      "positionName": bannerModel.positionName,
      "banner_sort": bannerModel.sort,
    };
    SensorsAnalyticsFlutterPlugin.track('generic_ad_popup_show_event', sensorProperties);
  }

  _popDialog(BuildContext context, BannerModel bannerModel) {
    ///埋点 通用广告弹窗-关闭
    var sensorProperties = {
      'activityId': bannerModel.popup != null ? bannerModel.popup!.activityId : '',
      'activityNumber': bannerModel.popup != null ? bannerModel.popup!.activityNumber : '',
      "positionCode": bannerModel.positionCode,
      "positionType": bannerModel.positionType,
      "viewPage": widget.bannerParam?.viewPage,
      "positionName": bannerModel.positionName,
      "banner_sort": bannerModel.sort,
    };
    SensorsAnalyticsFlutterPlugin.track('generic_ad_popup_close_click_event', sensorProperties);
    Navigator.of(context).pop(true);
  }

  void _reload() {
    if (widget.bannerParam != null) {
      _bloc.add(ReloadEvent(widget.bannerParam!));
    }
  }

  //重新计算swiper的宽高
  void swiperResize(String url) async {
    int imageWidth;
    int imageHeight;
    Image imageNetwork = Image(image: CachedNetworkImageProvider(url));
    Completer<ImageInfo> completer = Completer<ImageInfo>();
    ImageStreamListener listener = ImageStreamListener((ImageInfo info, _) {
      if (!completer.isCompleted) {
        completer.complete(info);
      }
    }, onError: (exception, __) {
      if (completer.isCompleted) {
        completer.completeError(exception);
      }
    });
    imageNetwork.image.resolve(const ImageConfiguration()).addListener(listener);
    ImageInfo info = await completer.future;
    imageNetwork.image.resolve(const ImageConfiguration()).removeListener(listener);
    imageWidth = info.image.width;
    imageHeight = info.image.height;
    if (width != null) {
      height = imageHeight * width! / imageWidth;
    } else if (height != null) {
      width = imageWidth * height! / imageHeight;
    }
    if (widget.bannerSizeCallBack != null) {
      widget.bannerSizeCallBack!(Size(width ?? 0, height ?? 0));
    }
    setState(() {});
  }

  @override
  void dispose() {
    _bloc.close();
    _controller.dispose();
    widget.bannerController?.removeListener(_reload);
    super.dispose();
  }
}

class BannerController extends ValueNotifier<int> {
  BannerController() : super(0);

  void reload() {
    value++;
  }
}
