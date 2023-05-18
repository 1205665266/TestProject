import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/sensors/address_sensors_constant.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/dialog/common_dialog.dart';
import 'package:cotti_client/widget/mini_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import '../../edit_address/address_edit_page.dart';
import '../bloc/take_address_bloc.dart';
import '../bloc/take_address_event.dart';
import '../entity/member_address_entity.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/9 17:02
class AddressItem extends StatefulWidget {
  final MemberAddressEntity memberAddress;
  final bool isOutOfRange;
  final bool isClickAble;

  final bool isSelectTakeAddress;

  const AddressItem({
    Key? key,
    required this.memberAddress,
    this.isOutOfRange = false,
    this.isClickAble = false,
    this.isSelectTakeAddress = false,
  }) : super(key: key);

  @override
  State<AddressItem> createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3.r),
      child: Slidable(
        key: Key("${widget.memberAddress.id}"),
        groupTag: 0,
        closeOnScroll: true,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (context) => _deleteItem(),
              backgroundColor: CottiColor.primeColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
              label: '删除',
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                if (widget.isClickAble) {
                  context.read<TakeAddressBloc>().add(SelectAddressEvent(widget.memberAddress));
                }

                SensorsAnalyticsFlutterPlugin.track(
                    AddressSensorsConstant.addressListItemClick, {'usable': !widget.isOutOfRange});
              },
              child: _buildContent(),
            ),
            Positioned(right: -0.4.w, child: _buildDefault()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    bool memberDefaultSelect =
        context.read<ShopMatchBloc>().state.address?.id == widget.memberAddress.id &&
            widget.isClickAble;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.r),
        border: memberDefaultSelect
            ? Border.all(
          color: CottiColor.primeColor,
          width: .5.w,
        )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPoi(),
          ),
          GestureDetector(
            onTap: () {
              if (widget.isSelectTakeAddress) {
                SensorsAnalyticsFlutterPlugin.track(
                    AddressSensorsConstant.addressListItemModifyClick, {});
              } else {
                SensorsAnalyticsFlutterPlugin.track(
                    AddressSensorsConstant.mineAddressListItemUpdateClick, {});
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider<TakeAddressBloc>.value(
                    value: context.read<TakeAddressBloc>(),
                    child: AddressEditPage(
                      isEdit: true,
                      address: widget.memberAddress,
                    ),
                  ),
                ),
              ).then((value) {
                if (value != null && value) {
                  context.read<TakeAddressBloc>().add(TakeAddressListEvent());
                }
              });
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.only(left: 15.w, top: 12.h, bottom: 12.h),
              child: SvgPicture.asset(
                'assets/images/mine/icon_edit_address.svg',
                width: 14.w,
                height: 14.w,
                color: widget.isOutOfRange ? CottiColor.textHint : CottiColor.textBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoi() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(height: 1.4),
            children: [
              WidgetSpan(
                child: Offstage(
                  offstage: widget.memberAddress.labelName == null,
                  child: Container(
                    alignment: Alignment.center,
                    width: 36.w,
                    decoration: BoxDecoration(
                      color:
                      widget.isOutOfRange ? const Color(0xFFF5F6F7) : const Color(0xFFFFEEEC),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    height: 19.h,
                    child: MiniLabelWidget(
                      label: widget.memberAddress.labelName,
                      textColor: widget.isOutOfRange ? CottiColor.textHint : CottiColor.primeColor,
                      textSize: 12.sp,
                      radius: 3.r,
                      backgroundColor:
                      widget.isOutOfRange ? const Color(0xFFF5F6F7) : const Color(0xFFFFEEEC),
                      isBold: false,
                      textPadding: EdgeInsets.symmetric(vertical: 1.h),
                    ),
                  ),
                ),
              ),
              WidgetSpan(
                child: SizedBox(width: widget.memberAddress.labelName != null ? 8.w : 0),
              ),
              TextSpan(
                style: TextStyle(
                  color: widget.isOutOfRange ? CottiColor.textHint : CottiColor.textBlack,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                text:
                '${widget.memberAddress.city ?? ''}${widget.memberAddress.location}${widget.memberAddress.address}',
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              widget.memberAddress.contact ?? '',
              style: TextStyle(
                color: widget.isOutOfRange ? CottiColor.textHint : const Color(0xFF666666),
                fontSize: 14.sp,
                height: 1,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              StringUtil.mobilePhoneEncode(widget.memberAddress.contactPhone),
              style: TextStyle(
                color: widget.isOutOfRange ? CottiColor.textHint : const Color(0xFF666666),
                fontSize: 14.sp,
                fontFamily: 'DDP4',
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefault() {
    return Offstage(
      offstage: widget.memberAddress.defaultFlag != 1,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4.r),
        ),
        child: MiniLabelWidget(
          label: '默认',
          textColor: Colors.white,
          backgroundColor: CottiColor.primeColor,
          textSize: 11.sp,
          textPadding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.h),
        ),
      ),
    );
  }

  _deleteItem() {
    CommonDialog.show(
      context,
      content: '是否确定删除地址？',
      mainButtonName: '删除',
      subButtonName: '取消',
    ).then((value) {
      if (value == 1) {
        SensorsAnalyticsFlutterPlugin.track(
            AddressSensorsConstant.mineAddressListDeleteDialogConfirmClick, {});
        context.read<TakeAddressBloc>().add(DeleteAddressEvent(widget.memberAddress.id));
        if (context.read<ShopMatchBloc>().state.address?.id == widget.memberAddress.id) {
          context.read<ShopMatchBloc>().add(DeleteTakeAddressEvent());
        }
      } else {
        SensorsAnalyticsFlutterPlugin.track(
            AddressSensorsConstant.mineAddressListDeleteDialogCancelClick, {});
      }
    });
  }
}
