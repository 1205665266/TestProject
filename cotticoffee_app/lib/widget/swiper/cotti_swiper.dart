import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cotti_image_widget.dart';
import '../player/config.dart';
import '../player/cotti_video_player.dart';
import 'swiper_item.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/15 09:41
class CottiSwiper extends StatefulWidget {
  final List<SwiperItem> swiperList;

  ///swiper高度
  final double height;

  /// 指示器高度
  final EdgeInsets? pointEdgeInsets;

  ///轮播间隔时间(ms)
  final int? durationDelayMs;

  ///图片裁剪模式,默认fill
  final BoxFit? fit;

  const CottiSwiper({
    Key? key,
    required this.swiperList,
    required this.height,
    this.pointEdgeInsets,
    this.durationDelayMs,
    this.fit,
  }) : super(key: key);

  @override
  State<CottiSwiper> createState() => _CottiSwiperState();
}

class _CottiSwiperState extends State<CottiSwiper> {
  late SwiperController controller;

  @override
  void initState() {
    super.initState();
    controller = SwiperController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Swiper(
        controller: controller,
        pagination: widget.swiperList.length > 1 ? _buildSwiperPagination() : null,
        autoplay: widget.swiperList.length > 1,
        itemBuilder: (context, index) => _swiperItem(widget.swiperList[index]),
        autoplayDelay: widget.durationDelayMs ?? 4000,
        duration: 550,
        onIndexChanged: (index) => {},
        physics: widget.swiperList.length > 1 ? null : const NeverScrollableScrollPhysics(),
        itemCount: widget.swiperList.length,
      ),
    );
  }

  _swiperItem(SwiperItem item) {
    if (item.type == SwiperItemEnum.image) {
      return _buildImage(item.url);
    } else if (item.type == SwiperItemEnum.video) {
      return _buildVideo(item.url, item.videoCoverUrl ?? '');
    } else {
      return const SizedBox();
    }
  }

  _buildImage(String url) {
    return CottiImageWidget(
      url,
      fit: widget.fit,
    );
  }

  _buildVideo(String mediaUrl, String videoCoverUrl) {
    return CottiVideoPlayer(
      url: mediaUrl,
      width: double.infinity,
      height: double.infinity,
      isPlaying: videoCoverUrl.isEmpty,
      isPlayingCallBack: (isPlaying) {
        if (isPlaying) {
          controller.stopAutoplay();
        } else {
          controller.startAutoplay();
        }
      },
      config: Config.copy(
        voiceWidth: 25.w,
        voiceHeight: 25.w,
        fullWidth: 0,
        fullHeight: 0,
        coverUrl: videoCoverUrl,
      ),
    );
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
}
