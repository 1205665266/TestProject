import 'package:cotti_client/global/style.dart';
import 'package:cotticommon/router/fluro_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/9/31 9:46 上午
class CustomPageWidget extends StatefulWidget {
  CustomPageWidget({
    Key? key,
    required this.child,
    this.title,
    this.showAppBar = true,
    this.showLoading = false,
    this.showEmpty = false,
    this.showError = false,
    this.automaticallyImplyLeading = true,
    this.extendBodyBehindAppBar = false,
    this.appBarBackgroundColor = Colors.white,
    this.customEmptyWidget,
    this.customErrorWidget,
    this.customLoadingWidget,
    this.darkThem,
    this.actions,
    this.pageBackgroundColor,
    this.customLoadingColor = Colors.white,
    this.loadingRatio = 0.5,
    this.clickLeading,
    this.titleColor,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  Widget child;
  String? title;
  bool showAppBar;
  bool showError;
  bool showEmpty;
  bool showLoading;
  bool automaticallyImplyLeading;
  bool extendBodyBehindAppBar;
  bool? resizeToAvoidBottomInset;
  Widget? customErrorWidget;
  Widget? customEmptyWidget;
  Widget? customLoadingWidget;
  Function? clickLeading;
  Color appBarBackgroundColor;
  Color? pageBackgroundColor;
  Color? customLoadingColor;
  Color? titleColor;
  List<Widget>? actions;
  double loadingRatio;

  SystemUiOverlayStyle? darkThem;

  @override
  State<CustomPageWidget> createState() => _CustomPageWidgetState();
}

class _CustomPageWidgetState extends State<CustomPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? _buildAppBar() : null,
      backgroundColor: widget.pageBackgroundColor ?? CottiColor.backgroundColor,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: Stack(
        children: [
          widget.child,
          if (widget.showEmpty) _buildEmpty(),
          if (widget.showError) _buildError(),
          if (widget.showLoading) _buildLoading(),
        ],
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(
        widget.title ?? '',
        style: TextStyle(
          fontSize: 16.sp,
          color: widget.titleColor ?? CottiColor.textBlack,
          fontWeight: FontWeight.bold,
        ),
      ),
      toolbarHeight: 42.h,
      centerTitle: true,
      backgroundColor: widget.appBarBackgroundColor,
      systemOverlayStyle: widget.darkThem,
      elevation: 0,
      actions: widget.actions,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      leading: widget.automaticallyImplyLeading
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (widget.clickLeading == null) {
                  NavigatorUtils.pop(context);
                } else {
                  widget.clickLeading!();
                }
              },
              child: UnconstrainedBox(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: SvgPicture.asset(
                    'assets/images/ic_back.svg',
                    width: 20.h,
                    height: 20.h,
                    color: const Color(0xFF111111),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildEmpty() {
    return widget.customEmptyWidget ?? Container();
  }

  Widget _buildError() {
    return widget.customErrorWidget ?? Container();
  }

  Widget _buildLoading() {
    return widget.customLoadingWidget ?? _buildLoadingWidget();
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: widget.customLoadingColor,
      child: Column(
        children: [
          Flexible(
            child: FractionallySizedBox(
              heightFactor: widget.loadingRatio,
              child: const Center(),
            ),
          ),
          LottieBuilder.asset(
            'assets/images/lotti/loading_data.json',
            width: 48.w,
            height: 48.h,
          ),
        ],
      ),
    );
  }
}
