/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/12/15 09:42
class SwiperItem {
  late SwiperItemEnum type;

  ///图片或者视频的url
  late String url;

  ///视频的封面图
  String? videoCoverUrl;

  SwiperItem(
    this.type,
    this.url, {
    this.videoCoverUrl,
  });
}

enum SwiperItemEnum { image, video }
