import 'package:cotti_client/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2022/11/7 22:22
class SexDialog extends StatefulWidget {
  final int curSex;
  final Function(int) callBack;

  const SexDialog({Key? key, required this.curSex, required this.callBack}) : super(key: key);

  @override
  State<SexDialog> createState() => _SexDialogState();

  static Future show(BuildContext context, int curSex, Function(int) callBack) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SexDialog(curSex: curSex, callBack: callBack);
      },
    );
  }
}

class _SexDialogState extends State<SexDialog> {
  late int selectIndex;

  @override
  void initState() {
    super.initState();
    selectIndex = widget.curSex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 18.w, right: 18.w, bottom: 44.h),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            _buildItem('男', 1, selectIndex == 1),
            _buildItem('女', 2, selectIndex == 2),
          ],
        ),
      ),
    );
  }

  _buildTitle() {
    return Container(
      height: 52.h,
      alignment: Alignment.center,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 52.h,
              alignment: Alignment.center,
              child: Text(
                "取消",
                style: TextStyle(
                  color: CottiColor.textHint,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              '请选择性别',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CottiColor.textBlack,
                fontSize: 14.sp,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.callBack(selectIndex);
              Navigator.pop(context);
            },
            child: Container(
              height: 52.h,
              alignment: Alignment.center,
              child: Text(
                "确定",
                style: TextStyle(
                  color: CottiColor.primeColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildItem(String name, int index, bool isSelect) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        selectIndex = index;
        setState(() {});
      },
      child: SizedBox(
        height: 52.h,
        child: Row(
          children: [
            Text(
              name,
              style: TextStyle(
                color: CottiColor.textBlack,
                fontSize: 14.sp,
              ),
            ),
            const Expanded(child: SizedBox()),
            SvgPicture.asset(
              isSelect
                  ? 'assets/images/order/order_confirm/icon_coupon_selected.svg'
                  : 'assets/images/order/order_confirm/icon_coupon_unselected.svg',
              width: 18.w,
              height: 18.w,
            ),
          ],
        ),
      ),
    );
  }
}
