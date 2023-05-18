import 'package:cotti_client/global/icon_font.dart';
import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/tabs/mine/setting/entity/shop_license_entity.dart';
import 'package:cotti_client/routers/mine_router.dart';
import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:cotti_client/widget/custom_smart_footer.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/10/12 10:33 PM
class ShopLicensePage extends StatefulWidget {
  const ShopLicensePage({Key? key}) : super(key: key);

  @override
  State<ShopLicensePage> createState() => _ShopLicensePageState();
}

class _ShopLicensePageState extends State<ShopLicensePage> {
  final RefreshController _controller = RefreshController(initialRefresh: false);
  final List<ShopLicenseEntity> _list = [];
  LoadStatus status = LoadStatus.idle;
  num pageNo = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _onLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      title: '门店资质',
      child: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        controller: _controller,
        footer: CustomSmartFooter(),
        onLoading: () => _onLoading(),
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h, bottom: 0),
          itemBuilder: (context, index) {
            ShopLicenseEntity shopLicense = _list[index];
            return InkWell(
              onTap: () => NavigatorUtils.push(
                context,
                MineRouter.shopLicenseDetailPage,
                arguments: shopLicense.images,
              ),
              child: Container(
                height: 55.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: index == 0 ? Radius.circular(4.r) : Radius.zero,
                    topRight: index == 0 ? Radius.circular(4.r) : Radius.zero,
                    bottomLeft: index == _list.length - 1 ? Radius.circular(4.r) : Radius.zero,
                    bottomRight: index == _list.length - 1 ? Radius.circular(4.r) : Radius.zero,
                  ),
                ),
                padding: EdgeInsets.only(left: 14.w, right: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      shopLicense.shopName ?? '',
                      style: TextStyle(
                        color: CottiColor.textBlack,
                        fontSize: 14.sp,
                      ),
                      strutStyle: const StrutStyle(
                        leading: 0,
                        forceStrutHeight: true,
                        leadingDistribution: TextLeadingDistribution.proportional,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '查看',
                          style: TextStyle(
                            color: CottiColor.textGray,
                            fontSize: 14.sp,
                          ),
                          strutStyle: const StrutStyle(
                            leading: 0,
                            forceStrutHeight: true,
                            leadingDistribution: TextLeadingDistribution.proportional,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/images/mine/ic_right_arrow.svg',
                          height: 20.w,
                          width: 20.w,
                          color: CottiColor.textGray,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 0.5.h,
              color: Colors.white,
              padding: EdgeInsets.only(
                left: 22.w,
                right: 28.w,
              ),
              child: Container(
                color: CottiColor.dividerGray,
              ),
            );
          },
          itemCount: _list.length,
        ),
      ),
    );
  }

  _onLoading() async {
    List<ShopLicenseEntity>? list = await getShopLicence(pageNo + 1);
    if (list?.isNotEmpty ?? false) {
      pageNo++;
      _list.addAll(list!);
      _controller.loadComplete();
    } else if (list?.isEmpty ?? false) {
      _controller.loadNoData();
    } else {
      _controller.loadComplete();
    }
    setState(() {});
  }

  Future<List<ShopLicenseEntity>?> getShopLicence(num pageNo) async {
    try {
      return CottiNetWork().post('/shop/queryShopLicence', data: {
        'pageNo': pageNo,
        'pageSize': 20,
      }).then((value) => ShopLicenseList.fromJson(value).list ?? []);
    } catch (error) {
      return null;
    }
  }
}
