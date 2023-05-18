import 'dart:async';

import 'package:cotti_client/global/bloc/global_bloc.dart';
import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/bloc/shopping_cart_state.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_classify.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_head.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_item_entity.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/bloc/menu_event.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/views/first_head.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/views/lately_buy_item.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/views/simple_menu_item.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/views/sticky_head.dart';
import 'package:cotti_client/pages/tabs/menu/menu_page/views/sub_head_list.dart';
import 'package:cotti_client/utils/scheme_dispatcher.dart';
import 'package:cotti_client/utils/string_util.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:cotticommon/global/global_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rect_getter/rect_getter.dart';

import '../../../../../widget/no_scroll_behavior_widget.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_state.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/16 9:48 PM
class MenuRight extends StatefulWidget {
  final ValueNotifier? toIndexNotifier;
  final Function(int)? firstItemIndexCallBack;
  final ScrollController controller;

  const MenuRight({
    Key? key,
    this.toIndexNotifier,
    this.firstItemIndexCallBack,
    required this.controller,
  }) : super(key: key);

  @override
  State<MenuRight> createState() => _MenuRightState();
}

class _MenuRightState extends State<MenuRight> {
  final Map<int, GlobalKey<RectGetterState>> _keys = {};
  final Map<int, GlobalKey<RectGetterState>> _subProductListKey = {};
  late GlobalKey<RectGetterState> _listViewKey;
  bool notifierSelectIndex = true;
  late ValueNotifier<FirstHeadInfo?> _valueNotifier;
  late ValueNotifier _subHeadFirstKeyNotifier;
  late final ScrollController _controller;
  final subHeadListHeight = 30.h;
  late MenuState _menuState;
  int argumentsTimeStamp = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _listViewKey = RectGetter.createGlobalKey();
    _valueNotifier = ValueNotifier(null);
    _subHeadFirstKeyNotifier = ValueNotifier(null);
    widget.toIndexNotifier?.addListener(_scrollToIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MenuBloc, MenuState>(
      listenWhen: (previous, current) {
        GlobalState state = GlobalBlocs.get<GlobalBloc>(GlobalBloc.blocName).state;
        return state.argumentsTimeStamp != argumentsTimeStamp &&
            previous.menuUpdateTimeStamp != current.menuUpdateTimeStamp;
      },
      listener: (context, state) {
        Map? map = GlobalBlocs.get<GlobalBloc>(GlobalBloc.blocName).state.arguments;
        if (map != null) {
          String? jumpCode = map['code'];
          if (jumpCode != null) {
            argumentsTimeStamp =
                GlobalBlocs.get<GlobalBloc>(GlobalBloc.blocName).state.argumentsTimeStamp;
            _jumpThreeLevel(jumpCode, state.menuHeads);
          }
        }
      },
      buildWhen: (previous, current) => previous.menuUpdateTimeStamp != current.menuUpdateTimeStamp,
      builder: (context, state) {
        _menuState = state;
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) => _scrollUpdate());
        _keys.clear();
        _subProductListKey.clear();
        return Column(
          children: [
            Expanded(child: _buildContent()),
            _buttomSize(),
          ],
        );
      },
    );
  }

  Widget _buildContent() {
    return Container(
      color: Colors.white,
      alignment: Alignment.topLeft,
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          _scrollUpdate();
          return true;
        },
        child: StickyHead(
          valueNotifier: _valueNotifier,
          listKey: _listViewKey,
          onTapCallBack: (int? jumpKey, int? firstHeadKey) =>
              _jumpToSecondHead(jumpKey, firstHeadKey),
          subHeadFirstKeyNotifier: _subHeadFirstKeyNotifier,
          controller: _controller,
          child: ScrollConfiguration(
            behavior: NoScrollBehaviorWidget(),
            child: SingleChildScrollView(
              key: _listViewKey,
              controller: _controller,
              padding: EdgeInsets.only(left: 12.w, right: 4.w, bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  _menuState.menuHeads.length,
                  (index) => _buildItem(_menuState.menuHeads[index], index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttomSize() {
    return BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
      builder: (context, state) {
        return SizedBox(height: state.getAllCartCount > 0 ? 38.h : 0);
      },
    );
  }

  Widget _buildItem(MenuHead menuHead, index) {
    _keys[menuHead.key] = RectGetter.createGlobalKey();
    _keys[menuHead.headInfo.key!] = RectGetter.createGlobalKey();
    return Column(
      key: _keys[menuHead.key],
      children: [
        FirstHead(key: _keys[menuHead.headInfo.key!], menuHead: menuHead),
        if (menuHead.headInfo.adPicUrl != null) _buildBanner(menuHead),
        _buildGoods(menuHead),
      ],
    );
  }

  Widget _buildGoods(MenuHead menuHead) {
    if (isLatelyBuy(menuHead.headInfo.id)) {
      return _buildLatelyBuyList(menuHead.items);
    } else {
      return _simpleList(menuHead);
    }
  }

  bool isLatelyBuy(String? id) {
    if (_menuState.menuConfig?.recentOrderMenuCode?.isNotEmpty ?? false) {
      return _menuState.menuConfig?.recentOrderMenuCode == id;
    }
    return false;
  }

  _simpleList(MenuHead menuHead) {
    return Column(
      children: [
        _buildSubHeadList(menuHead),
        //带二级标题的商品列表
        _buildSubProductList(menuHead.secondHead),
        //不带二级标题的商品列表
        _buildProductList(
          menuHead.items,
          padding: EdgeInsets.only(top: menuHead.secondHead.isEmpty ? 12.h : 28.h),
        ),
        //已售罄的商品
        _buildSaleOutProductList(menuHead),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildSubProductList(List<MenuHead> subHeads) {
    return Column(
      children: List.generate(subHeads.length, (index) {
        MenuHead subHead = subHeads[index];
        MenuClassify classify = subHead.headInfo;
        final myKey = RectGetter.createGlobalKey();
        _keys[subHead.key] = myKey;
        _subProductListKey[subHead.key] = myKey;
        return Column(
          key: myKey,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            index == 0
                ? SizedBox(height: 12.h)
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Text(
                      StringUtil.removeWrap(classify.name),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: CottiColor.textHint,
                      ),
                    ),
                  ),
            _buildProductList(subHead.items, padding: EdgeInsets.only(bottom: 20.h)),
          ],
        );
      }),
    );
  }

  Widget _buildSaleOutProductList(MenuHead menuHead) {
    List<MenuItemEntity> saleOutItems = menuHead.saleOutItems;
    if (saleOutItems.isEmpty) {
      return const SizedBox();
    }
    bool isOpen = _menuState.saleOutOpenStateList.any((element) => menuHead.headInfo.id == element);
    return Column(
      children: [
        SizedBox(height: menuHead.items.isEmpty ? 12.h : 28.h),
        _buildProductList(isOpen ? menuHead.saleOutItems : menuHead.saleOutItems.sublist(0, 1)),
        if (menuHead.saleOutItems.length > 1)
          _buildSaleOutTip(menuHead.headInfo.id!, isOpen, menuHead.saleOutItems.length),
      ],
    );
  }

  _buildSaleOutTip(String id, bool isOpen, int length) {
    return GestureDetector(
      onTap: () => context.read<MenuBloc>().add(SaleOutOpenStateEvent(id, !isOpen)),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 26.h,
        margin: EdgeInsets.only(top: 20.h, right: 6.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F2F5),
          borderRadius: BorderRadius.all(Radius.circular(2.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isOpen ? '点击收起' : "展开更多已售罄商品(${length - 1})",
              style: TextStyle(
                color: CottiColor.textGray,
                fontSize: 11.sp,
              ),
              strutStyle: const StrutStyle(forceStrutHeight: true),
            ),
            Icon(
              isOpen
                  ? IconFont.icon_caidan_zhankaishouqingshangjiantou
                  : IconFont.icon_caidan_zhankaishouqingxiajiantou,
              color: CottiColor.textGray,
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatelyBuyList(List<MenuItemEntity> menuItems) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 12.h),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => LatelyBuyItem(menuItem: menuItems[index]),
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemCount: menuItems.length,
    );
  }

  Widget _buildProductList(List<MenuItemEntity> menuItems, {EdgeInsets? padding}) {
    if (menuItems.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        children: List.generate(menuItems.length, (index) {
          MenuItemEntity menuItemEntity = menuItems[index];
          _keys[menuItemEntity.key!] = RectGetter.createGlobalKey();
          return Container(
            padding: EdgeInsets.only(bottom: index == menuItems.length - 1 ? 0 : 28.h),
            child: SimpleMenuItem(
              key: _keys[menuItemEntity.key!],
              menuItem: menuItemEntity,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBanner(MenuHead menuHead) {
    int? adType = menuHead.headInfo.adType;
    String? adInfo = menuHead.headInfo.adInfo;
    String? url = menuHead.headInfo.adPicUrl;
    return GestureDetector(
      onTap: () {
        if (adType == 1 && (adInfo?.isNotEmpty ?? false)) {
          int target = -1;
          int index = menuHead.items.indexWhere((element) => element.itemNo == adInfo);
          if (index != -1) {
            target = menuHead.items[index].key!;
          } else {
            for (var element in menuHead.secondHead) {
              index = element.items.indexWhere((element) => element.itemNo == adInfo);
              if (index != -1) {
                target = element.items[index].key!;
                break;
              }
            }
          }
          if (target != -1) {
            Rect? headSize = RectGetter.getRectFromKey(_keys[menuHead.headInfo.key]!);
            double offset = (headSize?.bottom ?? 0) - (headSize?.top ?? 0);
            if (menuHead.secondHead.isNotEmpty) {
              offset += subHeadListHeight;
            }
            jumpTo(target, offset, notify: true);
          }
        } else if (adType == 2 && (adInfo?.isNotEmpty ?? false)) {
          SchemeDispatcher.dispatchPath(context, adInfo!);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.h, right: 12.w),
        child: CottiImageWidget(
          url ?? '',
          imgW: double.infinity,
          fit: BoxFit.fill,
          imgH: 64.h,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  Widget _buildSubHeadList(MenuHead menuHead) {
    if (menuHead.secondHead.isEmpty && menuHead.secondHeadKey != null) {
      return const SizedBox();
    }
    _keys[menuHead.secondHeadKey!] = RectGetter.createGlobalKey();
    return SubHeadList(
      key: _keys[menuHead.secondHeadKey!],
      menuHead: menuHead,
      onTapCallBack: (int? jumpKey, int? firstHeadKey) => _jumpToSecondHead(jumpKey, firstHeadKey),
      subHeadFirstKeyNotifier: _subHeadFirstKeyNotifier,
    );
  }

  //一级标题可见性
  List<int> getVisible() {
    var listRect = RectGetter.getRectFromKey(_listViewKey);
    List<int> _items = [];
    _keys.forEach((index, key) {
      var itemRect = RectGetter.getRectFromKey(key);
      if (listRect != null &&
          itemRect != null &&
          !(itemRect.top > listRect.bottom || itemRect.bottom < listRect.top)) {
        _items.add(index);
      }
    });
    return _items;
  }

  //二级标题可见性
  List<int> getSecondVisible(int firstHeadKey) {
    var firstHeadRect = RectGetter.getRectFromKey(_keys[firstHeadKey]!);
    var listRect = RectGetter.getRectFromKey(_listViewKey);
    double firstBottom = (listRect?.top ?? 0) +
        (firstHeadRect?.bottom ?? 0) -
        (firstHeadRect?.top ?? 0) +
        subHeadListHeight;
    List<int> _items = [];
    _subProductListKey.forEach((index, key) {
      var itemRect = RectGetter.getRectFromKey(key);
      if (listRect != null &&
          itemRect != null &&
          (itemRect.top < firstBottom && itemRect.bottom > firstBottom)) {
        _items.add(index);
      }
    });
    return _items;
  }

  void _jumpToSecondHead(int? jumpKey, int? firstHeadKey) {
    if (jumpKey != null && firstHeadKey != null) {
      Rect? firstHeadRect = RectGetter.getRectFromKey(_keys[firstHeadKey]!);
      double firstHeadHeight = (firstHeadRect?.bottom ?? 0) - (firstHeadRect?.top ?? 0);
      jumpTo(jumpKey, firstHeadHeight + subHeadListHeight, notify: true);
    }
  }

  void jumpTo(int target, double offset, {bool notify = false}) async {
    var listRect = RectGetter.getRectFromKey(_listViewKey);
    if (listRect != null) {
      notifierSelectIndex = notify;
      await scrollLoop(target, listRect, offset);
      notifierSelectIndex = true;
    }
  }

  Future<void> scrollLoop(int target, Rect listRect, double offset) async {
    Rect? _rect;
    if (_keys.containsKey(target)) {
      _rect = RectGetter.getRectFromKey(_keys[target]!);
      double distance = _controller.offset + _rect!.top - listRect.top - offset + 0.1;
      distance = distance > _controller.position.maxScrollExtent
          ? _controller.position.maxScrollExtent
          : distance;
      await _controller.animateTo(
        distance,
        duration: const Duration(milliseconds: 100),
        curve: Curves.ease,
      );
    }
  }

  _scrollToIndex() {
    int index = widget.toIndexNotifier?.value;
    if (index != -1) {
      jumpTo(index, 0);
    }
  }

  _scrollUpdate() {
    List<int> visibleList = getVisible();
    if (widget.firstItemIndexCallBack != null && visibleList.isNotEmpty) {
      if (notifierSelectIndex) {
        widget.firstItemIndexCallBack!(visibleList.first);
      }
      MenuHead? menuHead = findMenu(_menuState.menuHeads, visibleList.first);
      _valueNotifier.value =
          FirstHeadInfo(_keys[visibleList.first], menuHead, _keys[menuHead?.secondHeadKey]);
      if (menuHead?.headInfo.key != null) {
        List<int> secondVisibleList = getSecondVisible(menuHead!.headInfo.key!);
        if (secondVisibleList.isNotEmpty && notifierSelectIndex) {
          _subHeadFirstKeyNotifier.value = secondVisibleList.first;
        }
      }
    }
  }

  MenuHead? findMenu(List<MenuHead> menuHeads, int key) {
    for (var element in menuHeads) {
      if (element.key == key) {
        return element;
      }
    }
    return null;
  }

  _jumpThreeLevel(jumpCode, List<MenuHead> menuHeads) {
    List<String> params = jumpCode.split(r'/');
    int? jumpKey;
    int? firstHeadKey;
    if (params.length > 1 && params.first == '3') {
      for (var element in menuHeads) {
        for (var subElement in element.secondHead) {
          if (subElement.headInfo.id == params[1]) {
            firstHeadKey = element.headInfo.key;
            jumpKey = subElement.key;
          }
        }
      }
    }
    if (jumpKey != null) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        _jumpToSecondHead(jumpKey, firstHeadKey);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    widget.toIndexNotifier?.removeListener(_scrollToIndex);
  }
}
