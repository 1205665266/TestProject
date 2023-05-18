import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/my/entity/coupon_bounty_entity.dart';

CouponBountyEntity $CouponBountyEntityFromJson(Map<String, dynamic> json) {
	final CouponBountyEntity couponBountyEntity = CouponBountyEntity();
	final CouponBountyCouponMsg? couponMsg = jsonConvert.convert<CouponBountyCouponMsg>(json['couponMsg']);
	if (couponMsg != null) {
		couponBountyEntity.couponMsg = couponMsg;
	}
	final CouponBountyBountyMsg? bountyMsg = jsonConvert.convert<CouponBountyBountyMsg>(json['bountyMsg']);
	if (bountyMsg != null) {
		couponBountyEntity.bountyMsg = bountyMsg;
	}
	return couponBountyEntity;
}

Map<String, dynamic> $CouponBountyEntityToJson(CouponBountyEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['couponMsg'] = entity.couponMsg?.toJson();
	data['bountyMsg'] = entity.bountyMsg?.toJson();
	return data;
}

CouponBountyCouponMsg $CouponBountyCouponMsgFromJson(Map<String, dynamic> json) {
	final CouponBountyCouponMsg couponBountyCouponMsg = CouponBountyCouponMsg();
	final int? totalCouponAmount = jsonConvert.convert<int>(json['totalCouponAmount']);
	if (totalCouponAmount != null) {
		couponBountyCouponMsg.totalCouponAmount = totalCouponAmount;
	}
	final int? expiringSoonCouponAmount = jsonConvert.convert<int>(json['expiringSoonCouponAmount']);
	if (expiringSoonCouponAmount != null) {
		couponBountyCouponMsg.expiringSoonCouponAmount = expiringSoonCouponAmount;
	}
	final int? ineffectiveCount = jsonConvert.convert<int>(json['ineffectiveCount']);
	if (ineffectiveCount != null) {
		couponBountyCouponMsg.ineffectiveCount = ineffectiveCount;
	}
	final int? availableVoucherCount = jsonConvert.convert<int>(json['availableVoucherCount']);
	if (availableVoucherCount != null) {
		couponBountyCouponMsg.availableVoucherCount = availableVoucherCount;
	}
	final int? closeExpiryVoucherCount = jsonConvert.convert<int>(json['closeExpiryVoucherCount']);
	if (closeExpiryVoucherCount != null) {
		couponBountyCouponMsg.closeExpiryVoucherCount = closeExpiryVoucherCount;
	}
	final bool? showVoucher = jsonConvert.convert<bool>(json['showVoucher']);
	if (showVoucher != null) {
		couponBountyCouponMsg.showVoucher = showVoucher;
	}
	return couponBountyCouponMsg;
}

Map<String, dynamic> $CouponBountyCouponMsgToJson(CouponBountyCouponMsg entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['totalCouponAmount'] = entity.totalCouponAmount;
	data['expiringSoonCouponAmount'] = entity.expiringSoonCouponAmount;
	data['ineffectiveCount'] = entity.ineffectiveCount;
	data['availableVoucherCount'] = entity.availableVoucherCount;
	data['closeExpiryVoucherCount'] = entity.closeExpiryVoucherCount;
	data['showVoucher'] = entity.showVoucher;
	return data;
}

CouponBountyBountyMsg $CouponBountyBountyMsgFromJson(Map<String, dynamic> json) {
	final CouponBountyBountyMsg couponBountyBountyMsg = CouponBountyBountyMsg();
	final int? bounty = jsonConvert.convert<int>(json['bounty']);
	if (bounty != null) {
		couponBountyBountyMsg.bounty = bounty;
	}
	final bool? display = jsonConvert.convert<bool>(json['display']);
	if (display != null) {
		couponBountyBountyMsg.display = display;
	}
	return couponBountyBountyMsg;
}

Map<String, dynamic> $CouponBountyBountyMsgToJson(CouponBountyBountyMsg entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['bounty'] = entity.bounty;
	data['display'] = entity.display;
	return data;
}