import 'package:cotti_client/widget/custom_page_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BonusRulesPage extends StatelessWidget {

  final String rules;

  BonusRulesPage({Key? key, required this.rules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPageWidget(
      title: '奖励金规则',
      appBarBackgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 14.h,left: 20.w,right: 20.w,),
          child: Text(
            rules,
          ),
        ),
      ),
    );
  }
}
