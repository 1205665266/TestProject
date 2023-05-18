/// Description:
/// Author: zhang.xu
/// Date: 2022/12/10 9:39 上午
class OrderSensorsConstant {
  // 确认订单
  static String orderConfirmPageView = "order_confirm_page_view"; // 浏览-确认订单页面

  static String orderComfirmShopConfirmShow = "order_comfirm_shopConfirm_show"; // 浏览-确认订单-普通门店确认弹层
  static String orderConfirmShopConfirmChangeShopClick =
      "order_comfirm_shopConfirm_changeShop_click"; // 门店确认弹窗-修改 点击
  static String orderConfirmShopConfirmPayClick =
      "order_comfirm_shopConfirm_pay_click"; // 门店确认弹窗-确认支付 点击
  static String orderComfirmShopConfirmNotPromotClick =
      "order_comfirm_shopConfirm_notPromot_click"; // 点击-确认订单-普通门店确认弹层-下次不再提醒

  static String orderComfirmShopTooFarConfirmShow =
      "order_comfirm_shopTooFarConfirm_show"; // 浏览-确认订单-超距离门店确认弹层
  static String orderConfirmShopTooFarConfirmChangeClick =
      "order_comfirm_shopTooFarConfirm_change_click"; // 取餐门店距离较远 确认弹窗-修改 点击
  static String orderConfirmShopTooFarConfirmPayClick =
      "order_comfirm_shopTooFarConfirm_pay_click"; // 取餐门店距离较远 确认弹窗-确认支付 点击

  static String orderComfirmAddressTooFarConfirmShow =
      "order_comfirm_addressTooFarConfirm_show"; // 浏览-确认订单-超距离地址确认弹层
  static String orderConfirmAddressTooFarConfirmChangeClick =
      "order_comfirm_addressTooFarConfirm_change_click"; // 当前收货地址距离较远 确认弹窗-修改 点击
  static String orderConfirmAddressTooFarConfirmPayClick =
      "order_comfirm_addressTooFarConfirm_pay_click"; // 当前收货地址距离较远 确认弹窗-确认支付 点击

  static String orderConfirmSwitchServiceType =
      "order_confirm_switchServiceType"; // 点击-切换取餐方式   1： 自提切外卖   2： 外卖切自提

  static String orderConfirmSwitchServiceTypeAutoSelectShopTipShow =
      "order_confirm_switchServiceType_autoSelectShopTip_show"; // 浏览-外卖切自提自动匹配门店提示

  static String orderConfirmChangeShopShopNameClick =
      "order_confirm_changeShop_shopName_click"; // 点击-切换取餐门店-点击门店名称区域
  static String orderConfirmChangeShopDistanceClick =
      "order_confirm_changeShop_distance_click"; // 点击-切换取餐门店-点击右侧距离区域

  static String orderConfirmAddressSwitch =
      "order_confirm_address_switch"; // 点击-收货地址

  static String confirmOrderCouponClick =
      "confirm_order_coupon_click"; // 点击-确认订单-优惠券入口  是否已选中优惠券（是/否）
  static String confirmOrderCouponCountView = "confirm_order_coupon_count_view"; // 浏览-选择优惠券页-可用券tab
  static String confirmOrderCouponNotUseView =
      "confirm_order_coupon_notUse_view"; // 浏览-选择优惠券页-不可用券tab
  static String confirmOrderCouponNotUseClick =
      "confirm_order_coupon_notUse_click"; // 点击-选择优惠券页-不使用优惠券
  static String confirmOrderCouponNotBestClick =
      "confirm_order_coupon_notBest_click"; // 点击-选择优惠券页-选择最优优惠券外的优惠券
  static String confirmOrderCouponDetailClick =
      "confirm_order_coupon_detail_click"; // 点击-选择优惠券页-可用券tab-详细信息
  static String confirmOrderCouponNotUseDetailView =
      "confirm_order_coupon_notUseDetail_view"; // 点击-选择优惠券页-不可用券tab-详细信息
  ///点击-选择优惠券页-可用券tab-替换使用	confirm_order_coupon_replace_click
  static String confirmOrderCouponReplaceClick = "confirm_order_coupon_replace_click";
  /// 点击-选择优惠券页-可用券tab-调整代金券	confirm_order_coupon_adjustVoucher_click
  static String confirmOrderCouponAdjustVoucherClick = "confirm_order_coupon_adjustVoucher_click";


  static String orderConfirmBountyCheckedClickEvent =
      "order_confirm_bounty_checked_click_event"; // 点击-勾选奖励金
  static String orderConfirmBountyUncheckedClickEvent =
      "order_confirm_bounty_unchecked_click_event"; // 点击-取消勾选奖励金
  static String orderConfirmBountyDescBrowseEvent =
      "order_confirm_bounty_desc_browse_event"; // 浏览-奖励金说明

  static String orderConfirmDeliverDescBrowseEvent =
      "order_confirm_deliver_desc_browse_event"; // 浏览-运费说明

  static String confirmOrderRemarkClick = "confirm_order_remark_click"; // 点击-订单备注入口
  static String confirmOrderRemarkDoneClick = "confirm_order_remark_done_click"; // 点击-填写备注页-完成

  static String orderConfirmWaitPayDialogBrowseEvent =
      "order_confirm_wait_pay_dialog_browse_event"; // 浏览-有N笔待支付订单提示
  static String orderConfirmWaitPayDialogGotoClickEvent =
      "order_confirm_wait_pay_dialog_goto_click_event"; // 点击-有N笔待支付订单提示-查看订单
  static String orderConfirmWaitPayDialogCancelClickEvent =
      "order_confirm_wait_pay_dialog_cancel_click_event"; // 点击-有N笔待支付订单提示-取消

  static String orderConfirmDeliveryCloseBrownEvent =
      "order_confirm_delivery_close_brown_event"; // 浏览-外送门店休息中提示

  static String orderConfirmCommodityInvalidToastBrownEvent =
      "order_confirm_commodity_invalid_toast_brown_event"; // 浏览-商品不可下单吐司
  static String orderConfirmCommodityInvalidDialogBrownEvent =
      "order_confirm_commodity_invalid_dialog_brown_event"; // 浏览-确认订单-商品失效弹层
  static String orderConfirmCommodityInvalidDialogCloseEvent =
      'order_confirm_commodity_invalid_dialog_close_event'; // 点击-确认订单-商品失效弹层-关闭弹层
  static String orderConfirmCommodityInvalidDialogPopEvent =
      "order_confirm_commodity_invalid_dialog_pop_event"; // 点击-确认订单-商品失效弹层-返回购物车
  static String orderConfirmCommodityInvalidDialogConfirmEvent =
      "order_confirm_commodity_invalid_dialog_confirm_event"; // 点击-确认订单-商品失效弹层-确认修改

  static String orderConfirmCreateOrderEvent = "order_confirm_create_order_event"; // 确认订单页-创建订单
  static String orderConfirmPaySuccessEvent = "order_confirm_pay_success_event"; // 确认订单页-支付成功查询

  // 订单详情
  static String orderDetailView = "orderDetail_view"; // 浏览-订单详情
  static String productDetailOrderDetailClick = "productDetail_orderDetail_click"; // 点击-订单详情-查看商品
  static String checkCommentOrderDetailClick = "checkComment_orderDetail_click"; // 点击-订单详情-查看评价
  static String copyOrderCodeOrderDetailClick = "copyOrderCode_orderDetail_click"; // 点击-订单详情-复制订单编号
  static String toPayOrderDetailClick = "toPay_orderDetail_click"; // 点击-订单详情-去支付
  static String cancelOrderOrderDetailClick = "cancelOrder_orderDetail_click"; // 点击-订单详情-取消订单
  static String confirmReasonOfCancelOrderDetailClick =
      "confirm_reasonOfCancel_orderDetail_click"; // 点击-订单详情-取消订单原因弹窗-提交
  static String reOrderOrderDetailClick = "reOrder_orderDetail_click"; // 点击-订单详情-再来一单
  static String toCommentOrderDetailClick = "toComment_orderDetail_click"; // 点击-订单详情-去评价
  static String servantOrderDetailClick = "servant_orderDetail_click"; // 点击-订单详情-去评价
  static String phoneServantServantOrderDetailClick =
      "phoneServant_servant_orderDetail_click"; // 点击-客服icon-电话客服
  static String onlineServantServantOrderDetailClick =
      "onlineServant_servant_orderDetail_click"; // 点击-客服icon-在线客服
  static String navigationOrderDetailClick = "navigation_orderDetail_click"; // 点击-订单详情-门店导航
  static String callRiderOrderDetailClick = "callRider_orderDetail_click"; // 点击-订单详情-联系骑手
  static String acceptInfoOrderDetailClick = "acceptInfo_orderDetail_click"; // 点击-订单详情-接受通知

  // 订单列表
  static String orderListPageView = "orderListPage_view"; // 浏览-订单列表-当前订单
  static String obligationOrderListView = "obligation_orderList_view"; // 浏览-订单列表-历史订单
  static String toDrinkOrderListClick = "toDrink_orderList_click"; // 点击-订单列表-去喝一杯
  static String toPayOrderListClick = "toPay_orderList_click"; // 点击-订单列表-立即支付
  static String cancelOrderOrderListClick = "cancelOrder_orderList_click"; // 点击-订单列表-取消订单
  static String reorderOrderListClick = "reorder_orderList_click"; // 点击-订单列表-再来一单
  static String toCommentOrderListClick = "toComment_orderList_click"; // 点击-订单列表-去评价
  static String toDetailPageOrderListClick = "toDetailPage_orderList_click"; // 点击-订单列表-进入详情
  static String confirmReasonOfCancelOrderListClick =
      "confirm_reasonOfCancel_orderList_click"; // 点击-订单详情-取消订单原因弹窗-提交
  static String tabOrderClick = "tab_order_click"; // 点击“首页”tab
  static String orderListLoginClick = "orderList_login_click"; // 点击-订单列表-立即登录

  /// 代金券
  /// 点击-确认订单-代金券入口	confirm_order_voucher_click
  static String confirmOrderVoucherClick = "confirm_order_voucher_click";
  /// 浏览-可用券sku列表	confirm_order_voucherSkuList_view
  static String confirmOrderVoucherSkuListView = "confirm_order_voucherSkuList_view";
  /// 点击-可用券sku	confirm_order_voucherSkuList_click
  static String confirmOrderVoucherSkuListClick = "confirm_order_voucherSkuList_click";
  /// 浏览-选择代金券页-可用券tab	confirm_order_voucher_count_view
  static String confirmOrderVoucherCountView = "confirm_order_voucher_count_view";
  /// 点击-选择代金券页-不使用代金券	confirm_order_voucher_notUse_click
  static String confirmOrderVoucherNotUseClick = "confirm_order_voucher_notUse_click";
  /// 点击-选择代金券页-选择最优代金券外的代金券	confirm_order_voucher_notBest_click
  static String confirmOrderVoucherNotBestClick = "confirm_order_voucher_notBest_click";
  /// 点击-选择代金券页-可用券tab-详细信息	confirm_order_voucher_detail_click
  static String confirmOrderVoucherDetailClick = "confirm_order_voucher_detail_click";
  /// 浏览-选择代金券页-不可用券tab	confirm_order_voucher_notUse_view
  static String confirmOrderVoucherNotUseView = "confirm_order_voucher_notUse_view";
  /// 点击-选择代金券页-不可用券tab-详细信息	confirm_order_voucher_notUseDetail_view
  static String confirmOrderVoucherNotUseDetailView = "confirm_order_voucher_notUseDetail_view";
  /// 点击-选择代金券页-替换使用	confirm_order_voucher_replace_click
  static String confirmOrderVoucherReplaceClick = "confirm_order_voucher_replace_click";


}
