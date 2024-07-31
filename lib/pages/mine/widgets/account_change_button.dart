import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/routes/app_navigator.dart';

class AccountChangeButton extends StatelessWidget {
  const AccountChangeButton({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.startAccountList();
      },
      child: Container(
        height: 24.w,
        padding: const EdgeInsets.only(left: 8, right: 10).w,
        decoration: BoxDecoration(
            color: Styles.c_F3F3F3.adapterDark(Styles.c_222222),
            borderRadius: BorderRadius.circular(30.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            "me_ico_identity".svg.toSvg
              ..width = 16.w
              ..height = 16.w
              ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
            3.gaph,
            "me_id_change".tr.toText
              ..style = Styles.ts_333333_12.adapterDark(Styles.ts_CCCCCC_12),
            3.gaph,
            "arrow_down".svg.toSvg
              ..width = 10.w
              ..fit = BoxFit.cover
              ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
          ],
        ),
      ),
    );
  }
}
