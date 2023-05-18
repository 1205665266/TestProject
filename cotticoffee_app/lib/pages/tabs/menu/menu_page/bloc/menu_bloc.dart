import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_classify.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_head.dart';
import 'package:cotti_client/pages/tabs/menu/entity/menu_item_entity.dart';
import 'package:cotti_client/pages/tabs/menu/menu_api.dart';
import 'package:cotticommon/utils/log_util.dart';

import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuState()) {
    on<MenuListEvent>(_menuList);
    on<SaleOutOpenStateEvent>(_saleOutOpenState);
    on<ShowLoadingEvent>(_showLoading);
  }

  _menuList(MenuListEvent event, emit) async {
    if (event.shopMdCode == null) {
      return;
    }
    if (event.showLoading) {
      emit(state.copy(showLoading: event.showLoading));
    }
    if (state.menuConfig == null) {
      await MenuApi.getMenuConfig().then((value) {
        state.menuConfig = value;
      });
    }
    await MenuApi.getMenu(event.takeFoodModes, event.shopMdCode!).then((menus) {
      int index = -1;
      List<MenuHead> menuHeads = [];
      for (var element in menus) {
        for (MenuClassify subItem in (element.subList ?? [])) {
          subItem.key = ++index;
          //一级头部
          MenuHead firstHead = MenuHead(++index, subItem, secondHeadKey: ++index);
          for (MenuClassify triItem in (subItem.triList ?? [])) {
            index++;
            //二级头部
            MenuHead secondHead = MenuHead(index, triItem);
            firstHead.secondHead.add(secondHead);
            for (MenuItemEntity itemEntity in (triItem.items ?? [])) {
              index++;
              itemEntity.key = index;
              secondHead.items.add(itemEntity);
            }
          }
          for (MenuItemEntity itemEntity in (subItem.items ?? [])) {
            itemEntity.key = ++index;
            firstHead.items.add(itemEntity);
          }
          for (MenuItemEntity itemEntity in (subItem.saleOutItems ?? [])) {
            itemEntity.key = ++index;
            firstHead.saleOutItems.add(itemEntity);
          }
          menuHeads.add(firstHead);
        }
      }
      state.menuHeads = menuHeads;
      state.goodsEmpty = menuHeads.isEmpty;
      emit(state.copy(
        showLoading: false,
        menuUpdateTimeStamp: DateTime.now().millisecondsSinceEpoch,
        showLoadingBackground: false,
      ));
    }).catchError((onError) {
      logI("获取菜单异常$onError");
      emit(state.copy(showLoading: false, showLoadingBackground: false));
    });
  }

  _showLoading(ShowLoadingEvent event, emit) {
    if (state.showLoading != event.showLoading) {
      if (event.firstGetShopInfo) {
        emit(state.copy(
          showLoading: event.showLoading,
          showLoadingBackground: true,
        ));
      } else {
        emit(state.copy(
          showLoading: event.showLoading,
          showLoadingBackground: false,
        ));
      }
    }
  }

  _saleOutOpenState(SaleOutOpenStateEvent event, emit) {
    if (event.isOpen) {
      int index = state.saleOutOpenStateList.indexWhere((element) => element == event.id);
      if (index == -1) {
        state.saleOutOpenStateList.add(event.id);
      }
    } else {
      state.saleOutOpenStateList.removeWhere((element) => element == event.id);
    }
    emit(state.copy(
      menuUpdateTimeStamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }
}
