import 'package:bloc/bloc.dart';
import 'package:cotti_client/pages/product/api/product_api.dart';
import 'package:cotti_client/pages/product/entity/product_spec_entity.dart';
import 'package:cotti_client/sensors/product_sensors_constant.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductState()) {
    on<QueryProductInfoEvent>(_queryProductInfo);
    on<SelectSpecItemEvent>(_selectSpecItem);
    on<ResetSpecEvent>(_resetSpec);
    on<ChangeBuyNumberEvent>(_changeBuyNumber);
    on<InitBuyNumberEvent>(_initBuyNumber);
  }

  _queryProductInfo(QueryProductInfoEvent event, emit) async {
    String defaultSku;
    await Future.wait([
      ProductApi.getProductDetail(
        itemNo: event.itemNo,
        shopMdCode: event.shopMdCode,
        takeFoodMode: event.takeFoodMode,
        businessTypes: event.businessTypes,
        selectSkuCode: event.defaultSkuCode,
      ).then((value) => state.productDetailData = value),
      ProductApi.getProductSpecs(
        itemNo: event.itemNo,
        shopMdCode: event.shopMdCode,
        takeFoodMode: event.takeFoodMode,
        businessTypes: event.businessTypes,
        selectSkuCode: event.defaultSkuCode,
      ).then((value) {
        defaultSku = value.firstSku!.skuNo;
        __initSpecData(state, value, defaultSku);
        // 推荐sku逻辑
        state.recommendType = (value.firstSkuFlag == 1) ? 0 : -1; // 展示推荐时，先赋值为默认，后续逻辑再行校验
        if (value.firstSkuFlag == 1) {
          SensorsAnalyticsFlutterPlugin.track(
              ProductSensorsConstant.productDetailLastsetSkuAutoSelectTipShow, {});
        }
        if (defaultSku != value.firstSku!.skuNo) {
          // 说明是编辑进入，默认选中的sku不是接口返回的firstSku,所以是未选中
          state.recommendType = 2;
        }
        state.productSpecData = value;
      }),
    ]);

    emit(state.copy());
  }

  void __initSpecData(ProductState state, ProductSpecEntity apiData, String defaultSku) {
    // List<String> mapKeyList = [];
    String mapKey;
    List<String> mapKeyList = [];
    apiData.skuCombinList?.forEach((ProductSpecSkuCombinList skuItem) {
      if (skuItem.skuNo == defaultSku) {
        // 存在默认值，则勾选选项
        __initSpecList(state, skuItem.skusSpecs, apiData);
        // 记录当前选中的sku信息，用于底部价格展示
        state.currentSkuData = skuItem;
      }
      mapKeyList = [];
      skuItem.skusSpecs?.forEach((cur) {
        mapKeyList.add("${(cur.specItemNo)}-${(cur.specItemValue)}");
      });

      mapKeyList.sort();
      mapKey = mapKeyList.join('/');

      state.skuMap![mapKey] = skuItem;
      // #不可售逻辑判断#
      if (skuItem.noSale == 1 || skuItem.haltSale == 1) {
        state.noSaleMap![mapKey] = skuItem;
      } else if (skuItem.noSale == 0 && skuItem.saleOut == true) {
        state.saleOutMap![mapKey] = skuItem;
      } else {
        skuItem.skusSpecs?.forEach((specItem) {
          state.sellingList?.add("${specItem.specItemNo}-${specItem.specItemValue}");
        });
      }
    });
    List<String> keyArray = __objectValues(state.currentSelect);
    keyArray.sort();
    // 根据默认选中的情况，进行第一次筛选，获取不可购买的选项
    __findAllOutItem(state, keyArray);
  }

  void __initSpecList(ProductState state, List<ProductSpecSkuCombinListSkusSpecs>? defaultSpec,
      ProductSpecEntity apiData) {
    Map<String, String> map = {};
    defaultSpec?.forEach((i) {
      // 用于初始化当前选中
      state.currentSelect![i.specItemNo] = "${i.specItemNo}-${i.specItemValue}";

      // 建立映射，减少循环
      map[i.specItemNo] = i.specItemValue;
    });

    apiData.specItems?.forEach((item) {
      item.specValueList?.forEach((val) {
        val.selected = (map[item.specItemNo] == val.value);
      });
    });
  }

  List<String> __objectKeys(Map<String, dynamic>? obj) {
    List<String> keyArray = [];
    obj?.forEach((k, v) {
      keyArray.add(k);
    });
    return keyArray;
  }

  List<T> __objectValues<T>(Map<String, T>? obj) {
    List<T> valArray = [];
    obj?.forEach((k, v) {
      valArray.add(v);
    });
    return valArray;
  }

  void __findAllOutItem(ProductState state, List<String> currKeyArray) {
    // 检出售罄元素集合
    List<List<String>> saleOutKeyList = [];
    __objectKeys(state.saleOutMap).forEach((String i) {
      saleOutKeyList.add(i.split('/'));
    });
    state.saleOutList =
        saleOutKeyList.isNotEmpty ? __diffKeyItem(saleOutKeyList, currKeyArray) : [];
    // 检出不可售元素集合
    List<List<String>> noSaleKeyList = [];
    __objectKeys(state.noSaleMap).forEach((String i) {
      noSaleKeyList.add(i.split('/'));
    });
    // const noSaleKeyList = Object.keys(this.noSaleMap).map(i => (i.split('/')));
    state.noSaleList = noSaleKeyList.isNotEmpty ? __diffKeyItem(noSaleKeyList, currKeyArray) : [];
  }

  List<String> __diffKeyItem(List<List<String>> keyList, List<String> current) {
    List<String> res = [];
    List<String> diff = [];
    if (current.isEmpty) {
      return res;
    }
    for (var item in keyList) {
      diff = [];
      item.asMap().forEach((idx, i) {
        if (i != current[idx]) {
          diff.add(i);
        }
      });
      // 只有一个选项有差异，说明切换到该选项会导致不可购买
      if (diff.length == 1) {
        res.add(diff[0]); // = [...res, diff[0]];
      }
      // 完全一致，说明该选项就是不可购买的
      if (diff.isEmpty) {
        res.addAll(current); // = [...res, ...current];
      }
    }
    return res;
  }

  _selectSpecItem(SelectSpecItemEvent event, emit) async {
    int specListIdx = event.specListIdx;
    String specItemVal = event.specItemVal;
    List<ProductSpecSpecItems>? specList = state.productSpecData?.specItems;
    String willSpec = "${(specList![specListIdx].specItemNo)}-$specItemVal";
    // 售罄拦截
    if (!state.sellingList!.contains(willSpec)) {
      ToastUtil.show("该规格已售罄");
      return;
    }
    // 更新规格项选中状态
    specList[specListIdx].specValueList?.forEach((ProductSpecSpecItemsSpecValueList item) {
      if (item.value == specItemVal) {
        // 更新当前选中项目
        state.currentSelect!["${(specList[specListIdx].specItemNo)}"] =
            "${(specList[specListIdx].specItemNo)}-$specItemVal";
        item.selected = true;
      } else {
        item.selected = false;
      }
    });
    List<String> keyArr = __objectValues(state.currentSelect);
    keyArr.sort();
    // 点击改变后，重新筛选不可购买的选项
    __findAllOutItem(state, keyArr);
    // 记录当前选中的sku信息，用于底部价格展示
    state.currentSkuData = state.skuMap![keyArr.join('/')];
    if (state.currentSkuData != null) {
      await ProductApi.getProductSpecsCoupon(
              state.currentSkuData!.skuNo!,
              state.productSpecData?.prodCategoryCode ?? '',
              event.shopMdCode,
              state.productDetailData?.itemNo ?? '',
              event.takeFoodMode,
              event.businessTypes)
          .then((value) {
        state.currentSkuData!.oncePrice = value.oncePrice;
        state.currentSkuData!.oncePriceStr = value.oncePriceStr;
        state.currentSkuData!.oncePriceDetailStr = value.oncePriceDetailStr;
        state.currentSkuData!.displayOncePrice = value.displayOncePrice;
      });
    }
    if (state.productSpecData?.firstSkuFlag == 1 &&
        state.productSpecData!.skuCombinList!.length > 1) {
      // 如果开始命中了推荐sku规则，则进行匹配处理
      state.recommendType =
          (state.currentSkuData?.skuNo == state.productSpecData?.firstSku?.skuNo) ? 1 : 2;
      if (state.currentSkuData?.skuNo == state.productSpecData?.firstSku?.skuNo) {
        SensorsAnalyticsFlutterPlugin.track(
            ProductSensorsConstant.productDetailSelectedLastsetSkuTipShow, {});
      } else {
        SensorsAnalyticsFlutterPlugin.track(
            ProductSensorsConstant.productDetailSelectLastsetSkuTipShow, {});
      }
    }
    emit(state.copy());
  }

  _resetSpec(ResetSpecEvent event, emit) {
    __initSpecData(state, state.productSpecData!, "${state.productSpecData?.firstSku?.skuNo}");
    SensorsAnalyticsFlutterPlugin.track(
        ProductSensorsConstant.productDetailSelectLastsetSkuTipClick, {});
    state.recommendType = 1; // 点击推荐，则选中已推荐
    emit(state.copy());
  }

  _initBuyNumber(InitBuyNumberEvent event, emit) {
    state.buyNum = event.num;
    emit(state.copy());
  }

  _changeBuyNumber(ChangeBuyNumberEvent event, emit) {
    event.isAdd ? state.buyNum++ : state.buyNum--;
    emit(state.copy());
  }
}
