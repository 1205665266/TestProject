import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/address/search_address/bloc/address_search_bloc.dart';
import 'package:cotti_client/pages/common/address/search_address/entity/poi_address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/// FileName: address_search_list_item
///
/// Description: 搜索地址项目
/// Author: zekun.li@abite.com
/// Date: 2021/12/11

class AddressSearchListItem extends StatefulWidget {
  final PoiAddressData model;
  final bool isSelected;
  final Function onTap;

  const AddressSearchListItem(
      {Key? key, required this.model, required this.isSelected, required this.onTap})
      : super(key: key);

  @override
  State<AddressSearchListItem> createState() => _AddressSearchListItemState();
}

class _AddressSearchListItemState extends State<AddressSearchListItem> {
  // late AddressSearchBloc _addressSearchBloc;
  @override
  void initState() {
    super.initState();
    // _addressSearchBloc = context.read<AddressSearchBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                top: 14.h, bottom: 14.h, left: 20.w, right: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.model.name}",
                        style: TextStyle(
                            fontSize: 14.sp, color: const Color(0xFF333333)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        widget.model.address ?? "",
                        style: TextStyle(
                            fontSize: 12.sp, color: const Color(0xFF666666)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.isSelected,
                  child: Padding(
                    padding: EdgeInsets.only(right: 14.w),
                    child: SvgPicture.asset(
                      'assets/images/address/ic_address_selected.svg',
                      height: 24.h,
                      width: 24.w,
                      color: CottiColor.primeColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 1.h,
            indent: 20.w,
            endIndent: 20.w,
            color: const Color(0xFFE5E5E5),
          ),
        ],
      ),
    );
  }
}
