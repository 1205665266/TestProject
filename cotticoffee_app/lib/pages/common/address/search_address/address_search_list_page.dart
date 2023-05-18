import 'package:cotti_client/pages/common/address/search_address/bloc/address_search_list_bloc.dart';
import 'package:cotti_client/pages/common/address/search_address/widget/address_search_list_item.dart';
import 'package:cotti_client/pages/common/address/search_address/widget/city_search_widget.dart';
import 'package:cotti_client/pages/common/city/entity/city_list_data_entity.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:cotticommon/router/fluro_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// FileName: address_search_list_page
///
/// Description: 地址搜索列表
/// Author: zekun.li@abite.com
/// Date: 2022/3/5

class AddressSearchListPage extends StatefulWidget {
  final CityListDataData cityModel;

  const AddressSearchListPage(this.cityModel, {Key? key}) : super(key: key);

  @override
  _AddressSearchListPageState createState() {
    return _AddressSearchListPageState();
  }
}

class _AddressSearchListPageState extends State<AddressSearchListPage> {
  final AddressSearchListBloc _bloc = AddressSearchListBloc();
  final FocusNode _focusNode = FocusNode()..requestFocus();

  @override
  void initState() {
    super.initState();

    // _bloc.add(InitEvent());
    _bloc.state.selectedCityModel = widget.cityModel;
  }

  void buildAComplete() {
    _bloc.state.selectedCityModel = widget.cityModel;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _bloc,
      child: BlocConsumer<AddressSearchListBloc, AddressSearchListState>(
        listener: (BuildContext context, state) {
          logW('in  listener !!!');
        },
        builder: (context, state) {
          logW('in  builder !!!');
          return _buildPage(context);
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    return CustomPageWidget(
      pageBackgroundColor: Colors.white,
      showAppBar: false,
      child: SafeArea(
        child: Container(
          color: const Color(0xFFF9FAFB),
          child: Column(
            children: [
              _headWidget(),
              _buildAddressList(),
            ],
          ),
        ),
      ),
    );
  }

  _headWidget() {
    return Container(
      color: Colors.white,
      // decoration: BoxDecoration(
      //   color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color.fromRGBO(25, 70, 106, 0.6),
        //     offset: Offset(0, 2.h),
        //     blurRadius: 7.h,
        //     spreadRadius: 0,
        //   ),
        // ],
      // ),
      height: 53.h,
      child: Row(
        children: [
          UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                NavigatorUtils.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SvgPicture.asset(
                  'assets/images/ic_back.svg',
                  width: 20.h,
                  height: 20.h,
                  color: const Color(0xFF111111),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchWidget(),
          ),
        ],
      ),
    );
  }

  Widget _searchWidget() {
    return BlocBuilder<AddressSearchListBloc, AddressSearchListState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(right: 24.w),
          child: CitySearchWidget(
            focusNode: _focusNode,
            onChanged: (value) {
              _bloc.add(RequestSearchAddressListEvent(value));
            },
            onClickCancelBtn: () {
              NavigatorUtils.pop(context);
            },
            hintText: '搜索地点',
          ),
        );
      },
    );
  }

  Widget _buildAddressList() {
    logW('in _buildAddressList !! ${_bloc.state.addresses.length}');
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          logW('state.addresses == ${_bloc.state.addresses.length}');
          return AddressSearchListItem(
            model: _bloc.state.addresses[index],
            isSelected: false,
            onTap: () {
              _bloc.add(SelectedPoiAddressEvent(_bloc.state.addresses[index], context));
            },
          );
        },
        itemCount: _bloc.state.addresses.length,
      ),
    );
  }
}
