import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/entity/order_submit_model_entity.dart';
import 'package:cotti_client/widget/cotti_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// FileName: conform_commodity_dialog
///
/// Description: 确认下单商品dialog
/// Author: zhangxu
/// Date: 2022/11/21

typedef ConformCommodityClickCallback = void Function(dynamic res);

dynamic showConfirmCommodityDialog(
    {required BuildContext context,
    required ConformCommodityClickCallback callback,
    required unavailableOfLessList,
    required unavailableOfSaleOutList}) async {
  var result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setModalBottomSheetState) {
            return SingleChildScrollView(
                child: ConformCommodityDialog(
                    callback: callback,
                    unavailableOfLessList: unavailableOfLessList,
                    unavailableOfSaleOutList: unavailableOfSaleOutList));
          },
        );
      });
  return result;
}

class ConformCommodityDialog extends StatefulWidget {
  List<OrderSubmitModelUnavailableItemList> unavailableOfLessList;
  List<OrderSubmitModelUnavailableItemList> unavailableOfSaleOutList;
  final ConformCommodityClickCallback callback;

  ConformCommodityDialog(
      {Key? key,
      required this.unavailableOfLessList,
      required this.unavailableOfSaleOutList,
      required this.callback})
      : super(key: key);

  @override
  _ConformCommodityDialogState createState() => _ConformCommodityDialogState();
}

class _ConformCommodityDialogState extends State<ConformCommodityDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 16.w, right: 16.w),
      constraints: BoxConstraints(maxHeight: 500.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitleRow(context),
            if (widget.unavailableOfLessList.isNotEmpty) _buildLowStockProduct(),
            if (widget.unavailableOfSaleOutList.isNotEmpty) _buildSaleOutStockProduct(),
            _buildBottom()
          ],
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              widget.callback(0);
            },
            child: Container(
              height: 40.h,
              margin: EdgeInsets.only(top: 12.h),
              decoration:
                  BoxDecoration(border: Border.all(color: CottiColor.primeColor, width: 0.5)),
              child: Center(
                  child: Text(
                '返回购物车',
                style: TextStyle(fontSize: 14.sp, color: CottiColor.primeColor),
              )),
            ),
          ),
        ),
        SizedBox(
          width: 7.w,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              widget.callback(1);
            },
            child: Container(
              height: 40.h,
              color: CottiColor.primeColor,
              margin: EdgeInsets.only(top: 12.h),
              child: Center(
                  child: Text(
                '确认修改',
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLowStockProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "以下餐品库存不足，请修改购买数量",
          style: TextStyle(color: CottiColor.primeColor, fontSize: 12.sp),
        ),
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _buildItemRow(widget.unavailableOfLessList[index]),
            separatorBuilder: (context, index) => Container(),
            itemCount: widget.unavailableOfLessList.length)
      ],
    );
  }

  Widget _buildSaleOutStockProduct() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "以下餐品不可购买，继续下单将自动移除",
          style: TextStyle(color: CottiColor.primeColor, fontSize: 12.sp),
        ),
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                _buildItemRowWithMock(widget.unavailableOfSaleOutList[index]),
            separatorBuilder: (context, index) => SizedBox(
                  height: 16.h,
                ),
            itemCount: widget.unavailableOfSaleOutList.length)
      ],
    );
  }

  Widget _buildItemRowWithMock(OrderSubmitModelUnavailableItemList item) {
    return Container(
      foregroundDecoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
      child: _buildItemRow(item),
    );
  }

  Widget _buildItemRow(OrderSubmitModelUnavailableItemList item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 14.w, top: 14.h),
              child: Stack(
                children: [
                  CottiImageWidget(
                    item.image ?? "",
                    imgH: 70.h,
                    imgW: 70.h,
                    fit: BoxFit.fill,
                  ),
                  quantityOut(item),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            constraints: BoxConstraints(minHeight: 70.h),
            margin: EdgeInsets.only(top: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(item.title ?? '',
                        style: TextStyle(
                            color: CottiColor.textBlack,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500)),
                    Text(item.skuShowName ?? '',
                        style: TextStyle(
                            color: CottiColor.textHint,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'x ${item.buyNum}',
                      style: TextStyle(
                        color: CottiColor.textHint,
                        fontSize: 12.sp,
                      ),
                    ),
                    _buildRemainNumWidget(item),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _getSaleOutHint(OrderSubmitModelUnavailableItemList item) {
    if (item.saleable != null && item.saleable == 0) {
      //不可售
      return '暂不可售';
    } else if (item.saleable != null && item.saleable == 1) {
      //可售
      if (item.quantity != null && item.quantity <= 0) {
        //售罄
        return '今日售罄';
      }
    } else if (item.saleable != null && item.saleable == 2) {
      return '活动结束';
    }
  }

  ///剩余库存件数标签
  Container _buildRemainNumWidget(OrderSubmitModelUnavailableItemList item) {
    int limitType = item.limitType ?? 0;

    String limitTypeName() {
      if (limitType == 1 || limitType == 0) {
        return "仅剩";
      } else if (limitType == 2) {
        return "限购";
      }
      return "";
    }

    return (item.saleable != null &&
            item.saleable == 1 &&
            item.buyNum != null &&
            item.quantity != null &&
            item.buyNum > item.quantity &&
            item.quantity > 0 &&
            [0, 1, 2].contains(limitType))
        ? Container(
            margin: EdgeInsets.only(left: 4.w),
            padding: EdgeInsets.only(top: 0.h, bottom: 0.h, left: 3.w, right: 3.w),
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.all(Radius.circular(9.r)),
            ),
            child: Center(
              child: Text(
                "${limitTypeName()}${item.quantity}件",
                style: TextStyle(color: CottiColor.primeColor, fontSize: 12.sp),
              ),
            ),
          )
        : Container();
  }

  /// 售罄展示
  Widget quantityOut(OrderSubmitModelUnavailableItemList item) {
    return (item.saleable != null && item.saleable == 0) ||
            (item.saleable != null && item.saleable == 1 && (item.quantity <= 0)) ||
            (item.saleable != null && item.saleable == 2) //不可售、售罄 显示浮层
        ? Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: 70.h,
              height: 15.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xff3A3B3C).withOpacity(0.55),
              ),
              child: Center(
                  child: Text(
                _getSaleOutHint(item) ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: Colors.white,
                ),
              )),
            ),
          )
        : Container();
  }

  Row _buildTitleRow(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24.w,
          height: 34.h,
        ),
        Expanded(
            child: Text(
          '请确认下单商品',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: const Color(0xff111111), fontSize: 16.sp, fontWeight: FontWeight.w500),
        )),
        InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              IconFont.icon_close,
              color: CottiColor.textGray,
              size: 24.w,
            )),
      ],
    );
  }
}
