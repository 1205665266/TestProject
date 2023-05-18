import 'package:cotti_client/global/bloc/shop_match_bloc.dart';
import 'package:cotti_client/global/bloc/shop_match_event.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/common/address/edit_address/bloc/edit_address_bloc.dart';
import 'package:cotti_client/pages/common/address/search_address/entity/poi_address_model.dart';
import 'package:cotti_client/pages/common/address/take_address/bloc/take_address_event.dart';
import 'package:cotti_client/pages/common/address/take_address/entity/member_address_entity.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/sensors/address_sensors_constant.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/dialog/common_dialog.dart';
import 'package:cotti_client/widget/mini_label_widget.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import '../take_address/bloc/take_address_bloc.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/9 16:03
class AddressEditPage extends StatefulWidget {
  final bool isEdit;
  MemberAddressEntity? address;

  AddressEditPage({Key? key, this.isEdit = false, this.address}) : super(key: key) {
    logI("AddressEditPage init");
    address ??= MemberAddressEntity.def();
  }

  @override
  _AddressEditPageState createState() {
    return _AddressEditPageState();
  }
}

class _AddressEditPageState extends State<AddressEditPage> {
  late MemberAddressEntity address;

  // late TakeAddressBloc _bloc;
  late EditAddressBloc _bloc;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController houseNumController = TextEditingController();

  final GlobalKey _phoneKey = GlobalKey();
  final GlobalKey _listViewKey = GlobalKey();

  final FocusNode _focusNode = FocusNode();

  _AddressEditPageState();

  @override
  void initState() {
    super.initState();

    /// 为了防止编辑时导致列表数据被修改
    Map<String, dynamic> map = widget.address!.toJson();
    address = MemberAddressEntity.fromJson(map);

    _bloc = EditAddressBloc(address: address, takeAddressBloc: context.read<TakeAddressBloc>());
    nameController.text = address.contact ?? "";
    phoneController.text = address.contactPhone ?? "";
    addressController.text = address.location ?? "";
    houseNumController.text = address.address ?? "";

    _focusNode.addListener(() {
      bool has = _focusNode.hasFocus;
      logI("hasFocus == $has");
      _bloc.add(AddressPhoneEditingEvent(phone: phoneController.text, atEnd: !has));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            _closeKeyboard(context);
          },
          child: CustomPageWidget(
            title: widget.isEdit ? '修改地址' : '新增收货地址',
            child: Column(
              children: [
                _buildContentWidget(),
                widget.isEdit ? _buildBottomWidget() : _buildBottomSaveWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentWidget() {
    return Expanded(
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 16.w,
        ),
        child: BlocProvider(
          create: (context) => _bloc,
          child: BlocBuilder<EditAddressBloc, EditAddressState>(
            builder: (context, state) {
              return Stack(
                children: [
                  ListView(
                    key: _listViewKey,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: _buildItemList(),
                  ),
                  _buildTipList(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTipList() {
    if (_bloc.state.showTipList != null && _bloc.state.showTipList!.isNotEmpty) {
      RenderBox? renderBox = phoneContext?.findRenderObject() as RenderBox?;
      Offset offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
      RenderBox? renderBoxList = _listViewKey.currentContext?.findRenderObject() as RenderBox?;

      Offset listOffset = renderBoxList?.globalToLocal(offset) ?? Offset.zero;

      return Positioned(
        top: listOffset.dy + 48.h,
        left: listOffset.dx,
        child: Offstage(
          offstage: phoneController.text.isEmpty,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                offset: Offset(0, -1),
                blurRadius: 4,
              ),
            ]),
            child: Column(
              children: _buildTipListItems(),
            ),
          ),
        ),
      );
    }

    return const SizedBox();
  }

  List<Widget> _buildTipListItems() {
    List<Widget> list = [];

    for (String str in _bloc.state.showTipList ?? []) {
      Widget item = Container(
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 6.h,
        ),
        child: GestureDetector(
          onTap: () {
            logI("on tap $str");
            phoneController.text = str;
            _bloc.add(AddressPhoneEditingEvent(phone: phoneController.text));
            _closeKeyboard(context);
          },
          child: Text(
            str,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        ),
      );

      list.add(item);
    }
    return list;
  }

  Widget _buildTitleWidget({required String title}) {
    TextStyle titleStyle = TextStyle(
      color: const Color(0xff666666),
      fontSize: 14.sp,
    );
    return SizedBox(
      width: 84.w,
      child: Text(
        title,
        style: titleStyle,
      ),
    );
  }

  Widget _buildNameLine() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      height: 46.h,
      child: Row(
        children: [
          _buildTitleWidget(title: '联系人'),
          Expanded(
            child: TextField(
              controller: nameController,
              cursorColor: CottiColor.primeColor,
              onChanged: (String text) {
                address.contact = text;
                _bloc.add(EditAddressIngEvent(address: address));
              },
              style: _inputStyle(),
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.allow(RegExp("[\u4e00-\u9fa5,A-Z,a-z,0-9]")),
                // FilteringTextInputFormatter.deny(RegExp(r"[\\ud800\\udc00-\\udbff\\udfff\\ud800-\\udfff]")),
              ],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请留下您的姓名',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xffc0c4cc),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSexLine() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      height: 46.h,
      child: Row(
        children: [
          _buildTitleWidget(title: '称谓'),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          logI("先生 ！！！！");
                          _closeKeyboard(context);
                          address.sex = 1;
                          _bloc.add(EditAddressIngEvent(address: address));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://cdn-product-prod.yummy.tech/wechat/cotti/images/mine/${address.sex == 1 ? "ic_mine_address_checked" : "ic_mine_address_check"}.png',
                              width: 14.w,
                              height: 14.w,
                              color: address.sex == 1 ? CottiColor.primeColor : null,
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              '先生',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color:
                                    address.sex == 1 ? CottiColor.primeColor : CottiColor.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          logI("女士 ！！！！");
                          _closeKeyboard(context);
                          address.sex = 2;
                          _bloc.add(EditAddressIngEvent(address: address));
                        },
                        child: Row(
                          children: [
                            Image.network(
                              'https://cdn-product-prod.yummy.tech/wechat/cotti/images/mine/${address.sex == 2 ? "ic_mine_address_checked" : "ic_mine_address_check"}.png',
                              width: 14,
                              height: 14,
                              color: address.sex == 2 ? CottiColor.primeColor : null,
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              '女士',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color:
                                    address.sex == 2 ? CottiColor.primeColor : CottiColor.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BuildContext? phoneContext;
  Offset? poffset;

  Widget _buildPhoneLine() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      height: 46.h,
      child: Row(
        children: [
          _buildTitleWidget(title: '手机号'),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext fcontext, BoxConstraints constraints) {
                phoneContext = fcontext;
                return TextField(
                  focusNode: _focusNode,
                  cursorColor: CottiColor.primeColor,
                  key: _phoneKey,
                  textInputAction: TextInputAction.next,
                  style: _inputStyle(),
                  controller: phoneController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11),
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  keyboardType: TextInputType.phone,
                  onChanged: (String text) {
                    logI("onChanged: (String $text)");
                    setState(() {
                      if (text.length > 11) {
                        String subStr = text.substring(0, 11);
                        phoneController.text = subStr;
                      }
                    });
                    _bloc.add(AddressPhoneEditingEvent(phone: text));
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入11位手机号',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xffc0c4cc),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressLine() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      constraints: BoxConstraints(minHeight: 46.h),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: _buildTitleWidget(title: '收货地址'),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                logI('收货地址 !!!');
                await NavigatorUtils.push(
                  context,
                  MineRouter.addressSearchPage,
                  params: {
                    'lat': address.lat,
                    'lon': address.lng,
                  },
                ).then((value) {
                  if (value == null) {
                    return;
                  }
                  PoiAddressData poi = value as PoiAddressData;
                  logW('addressSearchPage  ${poi.toJson()}');
                  setState(() {
                    address.lng = "${poi.lng}";
                    address.lat = "${poi.lat}";
                    address.location = poi.address;
                    address.location = poi.name;
                    addressController.text = poi.name ?? "";
                  });
                  _bloc.add(EditAddressIngEvent(address: address));
                });
              },
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      style: _inputStyle(),
                      cursorColor: CottiColor.primeColor,
                      controller: addressController,
                      keyboardType: TextInputType.phone,
                      maxLines: null,
                      onChanged: (String text) {
                        address.location = text;
                      },
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        hintText: '请选择收货地址',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xffc0c4cc),
                        ),
                      ),
                    ),
                  ),
                  Image.network(
                    'https://cdn-product-prod.yummy.tech/wechat/cotti/images/address-add-right-arrow.png',
                    width: 20.w,
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseNumLine() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      constraints: BoxConstraints(minHeight: 46.h),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: _buildTitleWidget(title: '门牌号'),
          ),
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 5,
              controller: houseNumController,
              cursorColor: CottiColor.primeColor,
              onChanged: (String text) {
                address.address = text;
                _bloc.add(EditAddressIngEvent(address: address));
              },
              style: _inputStyle(),
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
                FilteringTextInputFormatter.allow(RegExp("[\u4e00-\u9fa5,A-Z,a-z,0-9]")),
              ],
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '例：5号楼508室',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xffc0c4cc),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelsLine() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      height: 46.h,
      child: Row(
        children: [
          _buildTitleWidget(title: '标签'),
          Expanded(
            child: Row(
              children: [
                _buidlLabelItem(index: 1),
                _buidlLabelItem(index: 2),
                _buidlLabelItem(index: 3),
                _buidlLabelItem(index: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buidlLabelItem({required int index}) {
    bool selected = (address.labelId ?? 0) == index;

    String label = '';
    switch (index) {
      case 1:
        label = '家';
        break;
      case 2:
        label = '公司';
        break;
      case 3:
        label = '学校';
        break;
      case 4:
        label = '其他';
        break;
    }
    return GestureDetector(
      onTap: () {
        logI('label item action !!!');
        address.labelName = label;
        address.labelId = index;

        _bloc.add(EditAddressIngEvent(address: address));
      },
      child: MiniLabelWidget(
        label: label,
        textColor: selected ? CottiColor.primeColor : const Color(0xff979797),
        backgroundColor: selected ? const Color(0xffFFEEEC) : const Color(0xfff5f5f5),
        textSize: 12.sp,
        textPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        margin: EdgeInsets.only(right: 8.w),
        isBold: false,
        radius: 3.r,
        minLength: 40.w,
      ),
    );
  }

  Widget _buildDefaultLabelLine() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      height: 46.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitleWidget(title: '默认地址'),
          Transform.scale(
            scale: 0.6,
            alignment: Alignment.centerRight,
            child: CupertinoSwitch(
              value: address.defaultFlag == 1,
              onChanged: (val) {
                address.defaultFlag = val ? 1 : 0;
                _bloc.add(EditAddressIngEvent(address: address));
              },
              activeColor: CottiColor.primeColor,
              trackColor: const Color(0xFFE5E5E5),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildItemList() {
    List<Widget> list = <Widget>[];

    list.add(_buildNameLine());

    list.add(_buildSexLine());

    list.add(_buildPhoneLine());
    list.add(_buildAddressLine());
    list.add(_buildHouseNumLine());
    list.add(_buildLabelsLine());
    list.add(_buildDefaultLabelLine());

    return list;
  }

  TextStyle _inputStyle() {
    return TextStyle(
      fontSize: 14.sp,
      color: const Color(0xff303133),
    );
  }

  /// 底部双按钮
  Widget _buildBottomWidget() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
        horizontal: 16.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                /// 删除
                logI("删除 事件");
                SensorsAnalyticsFlutterPlugin.track(
                    AddressSensorsConstant.addressEditingDeleteClick, {});
                _delAction();
                _closeKeyboard(context);
              },
              child: Container(
                height: 44.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: CottiColor.textHint, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                ),
                child: Text(
                  '删除',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: CottiColor.textHint,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                /// 保存
                logI("保存 事件");
                SensorsAnalyticsFlutterPlugin.track(
                    AddressSensorsConstant.addressEditingSaveClick, {});
                _saveAction();
                _closeKeyboard(context);
              },
              child: Container(
                height: 44.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CottiColor.primeColor,
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                ),
                child: Text(
                  '保存',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 底部保存按钮
  Widget _buildBottomSaveWidget() {
    return BlocConsumer<EditAddressBloc, EditAddressState>(
        listener: (context, state) {},
        bloc: _bloc,
        builder: (context, state) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 16.w,
            ),
            child: GestureDetector(
              onTap: () {
                /// 保存
                logI("保存 事件");
                _saveAction();
                _closeKeyboard(context);
              },
              child: Container(
                height: 44.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CottiColor.primeColor,
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                ),
                child: Text(
                  '保存',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    //释放
    _focusNode.dispose();
  }

  _saveAction() {
    if (!_bloc.state.canSubmit) {
      ToastUtil.show(_bloc.state.subMsg ?? '未完成输入');

      return;
    }
    if (_bloc.state.isSubmit) {
      ToastUtil.show('提交中');
      return;
    }

    _bloc.add(
      EditAddressSaveEvent(
          isEdit: widget.isEdit,
          callBack: (val) {
            if (val) {
              if (widget.isEdit) {
                if (context.read<ShopMatchBloc>().state.address?.id == address.id) {
                  context.read<ShopMatchBloc>().add(DeleteTakeAddressEvent());
                }
              }
              NavigatorUtils.pop(context, result: true);
            }
          }),
    );

    logI("_saveAction !!");
  }

  _delAction() {
    CommonDialog.show(
      context,
      content: '是否确定删除地址？',
      mainButtonName: '删除',
      subButtonName: '取消',
    ).then((value) {
      if (value == 1) {
        context.read<TakeAddressBloc>().add(
              DeleteAddressEvent(address.id, callBack: (val) {
                if (val) {
                  if (context.read<ShopMatchBloc>().state.address?.id == address.id) {
                    context.read<ShopMatchBloc>().add(DeleteTakeAddressEvent());
                  }

                  /// 不需要刷新，删除事件成功后自动刷新
                  NavigatorUtils.pop(context);
                }
              }),
            );
      }
    });
  }

  /// 收起键盘
  void _closeKeyboard(BuildContext context) {
    NavigatorUtils.unfocus();
  }
}
