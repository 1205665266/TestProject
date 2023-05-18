import 'package:cotti_client/pages/common/address/search_address/bloc/address_search_bloc.dart';
import 'package:cotti_client/pages/common/address/search_address/entity/city_list_model.dart';
import 'package:cotti_client/pages/common/address/search_address/widget/city_conditions_search_widget.dart';
import 'package:cotti_client/pages/common/city/entity/city_list_data_entity.dart';
import 'package:cotti_client/routers/common_page_router.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// FileName: address_search_bar
///
/// Description: 地址搜索条
/// Author: zekun.li@abite.com
/// Date: 2021/12/14

class AddressSearchBar extends StatefulWidget {
  const AddressSearchBar({Key? key}) : super(key: key);

  @override
  State<AddressSearchBar> createState() => _AddressSearchBarState();
}

class _AddressSearchBarState extends State<AddressSearchBar> {
  late AddressSearchBloc _addressListBloc;

  @override
  void initState() {
    super.initState();
    _addressListBloc = context.read<AddressSearchBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressSearchBloc, AddressSearchState>(
      builder: (context, state) {
        return Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.06),
                  offset: Offset(0, 2.h),
                  blurRadius: 4.r,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: CityConditionsSearchWidget(
              cityName: state.selectedCityModel.cityName ?? "",
              focusNode: FocusNode(),
              hintText: '搜索地点',
              onClickTextField: () {
                Map<String, dynamic> params = {};
                params["selectedCityModel"] = _addressListBloc.state.selectedCityModel;
                NavigatorUtils.push(context, CommonPageRouter.addressSearchListPage,
                        arguments: params)
                    .then((value) {
                      logW('valuevaluevaluevalue == $value');
                  _addressListBloc.add(SelectedPoiAddressEvent(value));
                });
              },
              onChanged: (text) {},
              onEditing: (editing) {
                logW("obj");
              },
              onSwitchCity: () {
                Map<String, dynamic> params = {"isAll":'true'};
                NavigatorUtils.push(context, CommonPageRouter.cityListPage, params: params)
                    .then((value) {
                  if (value == null) return;
                  CityListDataData city = value as CityListDataData;
                  _addressListBloc.state.selectedCityModel = city;
                  _addressListBloc.state.hasLocationCityCenter = true;
                  logW("${city.toJson()} popStore");
                  _addressListBloc.add(SwitchCityEvent(city));
                  _addressListBloc.add(RequestSearchAddressList());
                  logW("${_addressListBloc.state.selectedCityModel.cityMdCode}_storeListBloc");
                });
              },
            ));
      },
    );
  }
}
