import 'package:cotti_client/pages/common/activity/red_block/red_envelop_bloc.dart';
import 'package:cotti_client/widget/banner/model/banner_param.dart';
import 'package:cotti_client/widget/banner/widget/abite_banner.dart';
import 'package:cotti_client/widget/new_stamps_container.dart';
import 'package:cotti_client/widget/share_widget/bottom_share_dialog.dart';
import 'package:cotticommon/bloc/user_bloc.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:cotticommon/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// FileName: red_envelope_widget
///
/// Description:
/// Author: hongtao.li@abite.com
/// Date: 2022/2/14
class RedEnvelopeWidget extends StatefulWidget {
  final String bannerCode;
  final String viewPage;
  final String? orderId;
  final ValueNotifier<bool>? animationNotifier;

  const RedEnvelopeWidget({
    Key? key,
    required this.bannerCode,
    required this.viewPage,
    this.orderId,
    this.animationNotifier,
  }) : super(key: key);

  @override
  _RedEnvelopeWidgetState createState() => _RedEnvelopeWidgetState();
}

class _RedEnvelopeWidgetState extends State<RedEnvelopeWidget> {
  final RedEnvelopBloc _bloc = RedEnvelopBloc();

  @override
  void initState() {
    if (widget.orderId != null) {
      _bloc.add(SharingShareEvent(widget.orderId!));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RedEnvelopBloc, RedEnvelopState>(
      bloc: _bloc,
      builder: (context, redState) {
        if (!(redState.shareModel?.canSharing ?? false)) {
          return const SizedBox();
        }
        return Positioned(
          right: 12.w,
          bottom: 84.h + MediaQuery.of(context).padding.bottom,
          child: NewStampsContainer(
            animationNotifier: widget.animationNotifier,
            child: ABiteBanner(
              width: 64.h,
              resize: true,
              fit: BoxFit.fitWidth,
              bannerParam: BannerParam(
                widget.bannerCode,
                viewPage: widget.viewPage,
                isLoginRetry: true,
              ),
              onTapItemCallBack: (model) => _tapItem(redState),
            ),
          ),
        );
      },
    );
  }

  _tapItem(RedEnvelopState redState) {
    if (widget.orderId?.isEmpty ?? true) {
      logI("orderId isEmpty!");
      return;
    }
    if (redState.shareModel != null) {
      var shareContent = '';
      var shareImgUrl = redState.shareModel?.weChatSharingCard?.bannerimgUrl ?? '';
      var memberId = GlobalBlocs.get(UserBloc.blocName).state.userModel?.memberId;
      var query = "orderId=${widget.orderId}&shareMemberId=$memberId&activityNo=${redState.shareModel?.activityNo}"
          "&fissionCode=${redState.shareModel?.fissionCode}";
      var minPath =
          "/packages/activity/collectCoupons/collectCoupons?$query";
      var shareTitle = redState.shareModel?.weChatSharingCard?.title ?? '';

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => BottomShareDialog(
          title: "分享",
          maxHeight: 222.h,
          isVisibilityCancel: true,
          shareContent: shareContent,
          litimgUrl: shareImgUrl,
          shareWebTitle: shareTitle,
          path: minPath,
          fromPageType: 4,
          posterBaseImgList: redState.shareModel?.posterBaseImgList,
          qrCodeUrl: minPath,
          activityNo: redState.shareModel?.activityNo,
          orderId: widget.orderId,
        ),
      );
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
