import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/shopping_cart/entity/cart_goods_item.dart';
import 'package:cotti_client/pages/shopping_cart/entity/shopping_cart_entity.dart';
import 'package:cotticommon/cotticommon.dart';

import '../entity/cart_params.dart';
import '../store/cart_store.dart';
import 'shopping_cart_event.dart';
import 'shopping_cart_state.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  Timer? _timer;

  ShoppingCartBloc() : super(ShoppingCartState()) {
    on<ShopChangeEvent>(_shopChange);
    on<CleanConfirmEvent>(_cleanConfirmChange);
    on<AddSkuCartEvent>(_addSkuCart);
    on<SyncCartEvent>(_syncCart);
    on<SubSkuCartEvent>(_subSkuCart);
    on<ClearCartEvent>(_clearCart);
    on<EditSkuCartEvent>(_editSkuCart);
    on<SelectCartEvent>(_selectCart);
    on<SelectAllCartEvent>(_selectAllCart);
    on<ShowSellOutChangeEvent>(_showSellOutChange);
    on<AddCartListSkuEvent>(_addListSku);
    on<SubCartListSkuEvent>(_subListSku);
  }

  _shopChange(ShopChangeEvent event, emit) {
    state.shopMdCode = event.shopMdCode;
    state.takeFoodModes = event.takeFoodModes;
    add(SyncCartEvent());
  }

  _cleanConfirmChange(CleanConfirmEvent event, emit) async {
    if (event.isCleanConfirm != state.isCleanConfirmation) {
      emit(state.copy(isCleanConfirmation: event.isCleanConfirm));
    }
  }

  _addSkuCart(AddSkuCartEvent event, emit) async {
    if (state.isLoading) {
      return;
    }
    if (event.buyNum + state.getAllCartCount > state.cartMaxCount) {
      ToastUtil.show("购物车已满，请清除部分商品后再试");
      return;
    }
    //如果是特价商品
    if (event.activityNo?.isNotEmpty ?? false) {
      int index = state.selling.indexWhere((item) => item.skuCode == event.skuCode);
      int buyNum = event.buyNum;
      if (index != -1) {
        buyNum = (state.selling[index].buyNum ?? 0) + event.buyNum;
      }
      await CartStore.specialsDailyLimitCheck(
              state.shopMdCode!, event.skuCode, event.activityNo, buyNum)
          .then((value) {
        if (value.displayToastTips ?? false) {
          ToastUtil.show(value.toastTips ?? '');
        }
      }).catchError((onError) {});
    }
    //同步本地数据
    _addCart(event.itemNo, event.skuCode, event.buyNum);
    //同步服务器购物车数据
    _debounceSync();
    emit(state.copy(
      addCartTimeStamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  Future<void> _syncCart(event, emit) async {
    List<CartGoodsItem> localCart = CartStore.getLocalCart();
    if (localCart.isEmpty) {
      logI('本地购物车数据为空');
      return;
    }
    if (state.shopMdCode == null || state.takeFoodModes.isEmpty) {
      logI('门店数据为空！');
      return;
    }
    List<String> unSelectList = CartStore.readUserUnSelect();
    for (var element in localCart) {
      if (unSelectList.any((e) => e == element.skuCode)) {
        element.selectedStatus = 0;
      } else {
        element.selectedStatus = 1;
      }
    }
    CartParams cartParams = CartParams();
    cartParams.tookFoodModes = state.takeFoodModes;
    cartParams.shopMdCode = state.shopMdCode;
    cartParams.shopId = state.shopMdCode;
    cartParams.operateType = 1;
    cartParams.cartGoodsItemList = localCart;
    state.isLoading = true;
    await CartStore.getShoppingCart(cartParams).then((value) {
      state.cartEntity = value;
      state.selling.clear();
      state.sellout.clear();
      value.cartGoodsItemList?.forEach((item) {
        if ((item.saleable != 1 || item.soldOut != 0) && !(item.existOtherSku ?? false)) {
          state.sellout.add(item);
        } else {
          state.selling.add(item);
        }
      });
      CartStore.updateCart([...state.selling, ...state.sellout]);
      state.isLoading = false;
      emit(state.copy(syncCarTimeStamp: DateTime.now().millisecondsSinceEpoch));
    }).catchError((onError) {
      logE(onError);
      state.isLoading = false;
    });
  }

  _subSkuCart(SubSkuCartEvent event, emit) async {
    if (state.isLoading && !event.isDelete) {
      return;
    }
    _subtractCart(event.isDelete, event.skuCode, event.buyNum);
    CartStore.updateCart([...state.selling, ...state.sellout]);
    emit(state.copy());
    if (event.isSync) {
      _debounceSync();
    }
  }

  _clearCart(_, emit) async {
    state.cartEntity = ShoppingCartEntity();
    state.selling = [];
    state.sellout = [];
    CartStore.updateCart([]);
    CartStore.clearUserUnSelect();
    emit(state.copy());
  }

  _editSkuCart(EditSkuCartEvent event, emit) async {
    if (event.newItem.skuCode == event.oldItem.skuCode) {
      if (event.newItem.buyNum > event.oldItem.buyNum) {
        add(AddSkuCartEvent(
          event.newItem.itemNo,
          event.newItem.skuCode,
          buyNum: event.newItem.buyNum - event.oldItem.buyNum,
          activityNo: event.activityNo,
        ));
      } else {
        add(SubSkuCartEvent(
          event.newItem.itemNo,
          event.newItem.skuCode,
          buyNum: event.oldItem.buyNum - event.newItem.buyNum,
        ));
      }
    } else {
      add(SubSkuCartEvent(
        event.oldItem.itemNo,
        event.oldItem.skuCode,
        buyNum: event.oldItem.buyNum,
        isDelete: true,
        isSync: false,
      ));
      add(AddSkuCartEvent(
        event.newItem.itemNo,
        event.newItem.skuCode,
        buyNum: event.newItem.buyNum,
        activityNo: event.activityNo,
      ));
    }
  }

  _selectCart(SelectCartEvent event, emit) {
    if (event.index < state.selling.length) {
      GoodsItem item = state.selling[event.index];
      if (item.selectedStatus == 1) {
        CartStore.addUserUnSelect(item.skuCode);
        item.selectedStatus = 0;
      } else {
        CartStore.deleteUserUnSelect(item.skuCode);
        item.selectedStatus = 1;
      }
      emit(state.copy());
      _debounceSync();
    }
  }

  _selectAllCart(SelectAllCartEvent event, emit) {
    for (var item in state.selling) {
      if (item.saleable == 1 && item.soldOut == 0) {
        event.isSelect
            ? CartStore.deleteUserUnSelect(item.skuCode)
            : CartStore.addUserUnSelect(item.skuCode);
        item.selectedStatus = event.isSelect ? 1 : 0;
      }
    }
    emit(state.copy());
    _debounceSync();
  }

  _showSellOutChange(_, emit) {
    emit(state.copy(showSellOut: !state.showSellOutList));
  }

  _addListSku(AddCartListSkuEvent event, emit) async {
    if (event.cleanCart) {
      await _clearCart(event, emit);
    }
    for (var element in event.goodsList) {
      if (element.buyNum + state.getAllCartCount > state.cartMaxCount) {
        logI("添加失败，购物车商品数达到上限");
        break;
      }
      _addCart(element.itemNo, element.skuCode, element.buyNum);
    }
    //同步服务器购物车数据
    add(SyncCartEvent());
    emit(state.copy());
  }

  _subListSku(SubCartListSkuEvent event, emit) {
    for (var element in event.goodsList) {
      _subtractCart(false, element.skuCode, element.buyNum);
    }
    CartStore.updateCart([...state.selling, ...state.sellout]);
    emit(state.copy());
    add(SyncCartEvent());
  }

  _debounceSync() {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () => add(SyncCartEvent()));
  }

  _addCart(String itemNo, String skuCode, int buyNum) {
    int index = state.selling.indexWhere((item) => item.skuCode == skuCode);
    if (index == -1) {
      state.selling.insert(
          0,
          GoodsItem()
            ..itemNo = itemNo
            ..skuCode = skuCode
            ..selectedStatus = 1
            ..buyNum = buyNum
            ..addCartTime = DateTime.now().millisecondsSinceEpoch);
    } else {
      state.selling[index].buyNum = state.selling[index].buyNum! + buyNum;
    }
    CartStore.updateCart([...state.selling, ...state.sellout]);
  }

  _subtractCart(bool isDelete, String skuCode, int buyNum) {
    int itemIndex = state.selling.indexWhere((item) => item.skuCode == skuCode);
    if (itemIndex != -1) {
      if (isDelete || ((state.selling[itemIndex].buyNum ?? 0) <= buyNum)) {
        CartStore.deleteUserUnSelect(skuCode);
        state.selling.removeAt(itemIndex);
      } else {
        state.selling[itemIndex].buyNum = (state.selling[itemIndex].buyNum ?? 0) - buyNum;
      }
      return;
    }
    itemIndex = state.sellout.indexWhere((item) => item.skuCode == skuCode);
    if (itemIndex != -1) {
      if (isDelete || ((state.sellout[itemIndex].buyNum ?? 0) <= buyNum)) {
        CartStore.deleteUserUnSelect(skuCode);
        state.sellout.removeAt(itemIndex);
      } else {
        state.sellout[itemIndex].buyNum = (state.sellout[itemIndex].buyNum ?? 0) - buyNum;
      }
    }
  }
}
