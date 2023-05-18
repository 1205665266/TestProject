import 'package:cotti_client/pages/product/entity/product_detail_entity.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_item_entity.dart';
import 'package:cotti_client/utils/sku_help.dart';
import 'package:cotti_client/widget/widget_to_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class PosterWidget extends StatefulWidget {
  const PosterWidget(
      {Key? key,
      required this.globalKey,
      this.itemDetail,
      required this.fromPageType,
      this.adImageUrl,
      this.qrcode,
      this.shopName})
      : super(key: key);

  final GlobalKey globalKey;

  //商品详情商品信息
  final ProductDetailEntity? itemDetail;

  final int fromPageType;
  final String? adImageUrl;
  final String? qrcode;
  final String? shopName;

  @override
  State<PosterWidget> createState() => _PosterWidgetState();
}

class _PosterWidgetState extends State<PosterWidget> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetToImage(
        globalKeys: widget.globalKey,
        bgColor: Colors.transparent,
        child: PhysicalModel(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14.w),
          clipBehavior: Clip.antiAlias,
          child: configPoster(),
        ));
  }

  Widget configPoster() {
    if (widget.fromPageType == 1) {
      //来自商品详情
      return Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        width: 311.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  //边框
                  border: Border.all(width: 0, color: Colors.white)),
              padding: EdgeInsets.only(bottom: 8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      _handleProductImageWidget(),
                      _isShowOffice()
                          ? Positioned(
                              child: SvgPicture.asset(
                                "assets/images/product_detail/ic_bargain_price.svg",
                                width: 102.w,
                                height: 40.w,
                                fit: BoxFit.fill,
                              ),
                              left: 0,
                              bottom: 0,
                            )
                          : SizedBox(),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 4.w),
                    height: 34.w,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.itemDetail?.appletShareTitle ?? '',
                      style: TextStyle(
                          color: const Color(0xFF111111),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  widget.itemDetail?.sellPoint != null
                      ? Container(
                          margin: EdgeInsets.only(left: 12.w, right: 12.w),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.itemDetail?.sellPoint ?? '',
                            style: TextStyle(
                                color: const Color(0xFF111111),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                  Container(
                    margin: EdgeInsets.only(left: 12.w, right: 12.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '￥',
                          style: TextStyle(
                              color: const Color(0xFFFF6A39),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          _bigRedPrice(),
                          style: TextStyle(
                              color: const Color(0xFFFF6A39),
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _smallRedPrice(),
                          style: TextStyle(
                              color: const Color(0xFFFF6A39),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          _scratchPrice(),
                          style: TextStyle(
                            color: const Color(0xFFA0A5AA),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                child: SvgPicture.asset(
              'assets/images/share_image/share_poster_white_line.svg',
              width: 311.w,
              height: 12.w,
              fit: BoxFit.cover,
            )),
            Container(
              padding: EdgeInsets.only(left: 12.w, top: 5.w, right: 12.w, bottom: 16.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  //边框
                  border: Border.all(width: 0, color: Colors.white)),
              child: Row(
                children: [
                  PrettyQr(
                    data: widget.qrcode ?? '',
                    size: 64.w,
                    elementColor: Colors.black,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '长按识别二维码',
                        style: TextStyle(
                            color: const Color(0xFF111111),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '立即购买',
                          style: TextStyle(
                              color: const Color(0xFF111111),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        width: 311.w,
        height: 454.w,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.adImageUrl ?? '',
              width: 311.w,
              height: 454.w,
              fit: BoxFit.fill,
            ),
            widget.fromPageType == 2
                ? Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0x00000000), Color(0xFF111111)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      padding: EdgeInsets.only(left: 12.w, top: 5.w, right: 12.w, bottom: 16.w),
                      child: Row(
                        children: [
                          Container(
                            child: PrettyQr(
                              data: widget.qrcode ?? '',
                              size: 74.w,
                              elementColor: Colors.black,
                            ),
                            padding: EdgeInsets.all(5.w),
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.shopName ?? '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 12.w,
                              ),
                              Text(
                                '长按识别二维码',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 6.w,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '立即购买',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ))
                : Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0x00000000), Color(0xFF111111)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      padding: EdgeInsets.only(left: 12.w, top: 5.w, right: 12.w, bottom: 16.w),
                      child: Row(
                        children: [
                          Container(
                            child: PrettyQr(
                              data: widget.qrcode ?? '',
                              size: 74.w,
                              elementColor: Colors.black,
                            ),
                            padding: EdgeInsets.all(5.w),
                            color: Colors.white,
                          ),
                          // ,
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 18.w,
                              ),
                              Text(
                                '长按识别二维码',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 10.w,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '立即购买',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ))
          ],
        ),
      );
    }
  }

  bool _isShowOffice() {
    return SkuHelp.isActivityProduct(widget.itemDetail?.firstSku);
  }

  String _redPrice() {
    if (_isShowOffice()) {
      return widget.itemDetail?.firstSku?.activityPriceStr ?? '';
    } else {
      return widget.itemDetail?.firstSku?.sellPriceStr ?? '';
    }
  }

  String _bigRedPrice() {
    var list = _redPrice().split('.');
    if (list.isNotEmpty) {
      return list.first;
    } else {
      return _redPrice();
    }
  }

  String _smallRedPrice() {
    var list = _redPrice().split('.');
    if (list.length > 1) {
      return '.${list.last}';
    } else {
      return '';
    }
  }

  String _scratchPrice() {
    return '¥${widget.itemDetail?.firstSku?.standardPriceStr ?? ''}';
  }

  Widget _handleProductImageWidget() {
    var imageURl = widget.itemDetail?.appletLitimgUrl ?? '';

    return imageURl == ''
        ? Container(
            width: 311.w,
            height: 234.w,
            color: const Color.fromRGBO(207, 207, 207, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/share_image/share_poster_empty.svg',
                  width: 160.w,
                  height: 160.w,
                  fit: BoxFit.fill,
                )
              ],
            ),
          )
        : Image.network(
            widget.itemDetail?.appletLitimgUrl ?? '',
            width: 311.w,
            height: 234.w,
            fit: BoxFit.fill,
          );
  }
}
