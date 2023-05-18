import 'package:cotti_client/global/bloc/config_bloc.dart';
import 'package:cotti_client/pages/shopping_cart/entity/shopping_cart_entity.dart';
import 'package:cotticommon/global/global_blocs.dart';

class ShoppingCartState {
  final int cartMaxCount = GlobalBlocs.get<ConfigBloc>(ConfigBloc.blocName).state.maxCount;
  int? shopMdCode;
  List<int> takeFoodModes = [];
  ShoppingCartEntity cartEntity = ShoppingCartEntity();
  List<GoodsItem> selling = [];
  List<GoodsItem> sellout = [];

  //是否展示清空购物车二次确认按钮
  bool isCleanConfirmation = false;

  //是否展示售罄列表
  bool showSellOutList = false;

  //添加商品时的时间戳，用于判定数量小红点动画
  int addCartTimeStamp = 0;

  //同步服务器购物车的时间戳
  int syncCarTimeStamp = 0;

  bool isLoading = false;

  ShoppingCartState copy({
    int? shopMdCode,
    List<int>? tookFoodModes,
    ShoppingCartEntity? cartDetail,
    bool? isCleanConfirmation,
    bool? showSellOut,
    List<GoodsItem>? selling,
    List<GoodsItem>? sellout,
    int? addCartTimeStamp,
    int? syncCarTimeStamp,
    bool? isLoading,
  }) {
    return ShoppingCartState()
      ..shopMdCode = shopMdCode ?? this.shopMdCode
      ..takeFoodModes = tookFoodModes ?? takeFoodModes
      ..cartEntity = cartDetail ?? cartEntity
      ..selling = selling ?? this.selling
      ..sellout = sellout ?? this.sellout
      ..isLoading = isLoading ?? this.isLoading
      ..syncCarTimeStamp = syncCarTimeStamp ?? this.syncCarTimeStamp
      ..addCartTimeStamp = addCartTimeStamp ?? this.addCartTimeStamp
      ..showSellOutList = showSellOut ?? showSellOutList
      ..isCleanConfirmation = isCleanConfirmation ?? this.isCleanConfirmation;
  }

  ///查询某个商品在购物车中的数量
  int getProductNumByItemNo(String itemNo) {
    int buyNum = 0;
    for (var element in selling) {
      if (element.itemNo == itemNo) {
        buyNum += element.buyNum ?? 0;
      }
    }
    return buyNum;
  }

  ///获取所有已选中商品的总数
  int get getSelectedSellingCount {
    int buyNum = 0;
    for (var element in selling) {
      if (element.selectedStatus == 1) {
        buyNum += element.buyNum ?? 0;
      }
    }
    return buyNum;
  }

  ///获取购物车总商品的总数
  int get getAllCartCount {
    int buyNum = 0;
    for (var element in selling) {
      buyNum += element.buyNum ?? 0;
    }
    for (var element in sellout) {
      buyNum += element.buyNum ?? 0;
    }
    return buyNum;
  }

  ///所有的所选商品
  List<GoodsItem> get getSelectedSelling {
    return selling.where((element) => element.selectedStatus == 1).toList();
  }

  bool get isSelectAll {
    if (selling.isEmpty) {
      return false;
    }
    return !selling.any(
        (element) => element.selectedStatus == 0 && element.saleable == 1 && element.soldOut == 0);
  }

  String get tipShowText {
    couponText(String str) {
      if (cartEntity.couponDiscountTip?.couponType == 20) {
        return "$str折";
      }
      return "￥$str";
    }

    availableText() {
      if (cartEntity.couponDiscountTip?.couponType == 20 &&
          cartEntity.couponDiscountTip?.isUserVoucher == 1) {
        return '可另享';
      } else {
        return '可享';
      }
    }

    String text = '';
    if (cartEntity.couponDiscountTip?.reducedMoney != null) {
      if (cartEntity.couponDiscountTip?.stillOweMoney != null) {
        text = "已享¥${cartEntity.couponDiscountTip?.reducedMoney}优惠，再买¥"
            "${cartEntity.couponDiscountTip?.stillOweMoney}"
            "${availableText()}"
            "${couponText(cartEntity.couponDiscountTip?.canHaveMoney ?? '')} 优惠";
      }
    } else {
      if (cartEntity.couponDiscountTip?.stillOweMoney != null) {
        text =
            "再买￥${cartEntity.couponDiscountTip?.stillOweMoney}可享${couponText(cartEntity.couponDiscountTip?.canHaveMoney ?? '')}优惠";
      }
    }
    return text;
  }
}
