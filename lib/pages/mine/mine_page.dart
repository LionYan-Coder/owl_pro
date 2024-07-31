import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/mine/widgets/account_change_button.dart';
import 'package:owlpro_app/pages/mine/widgets/theme_change_button.dart';
import 'mine_logic.dart';
import 'widgets/account_base_info.dart';
import 'widgets/asset_base_info.dart';
import 'widgets/operation_base_menu.dart';

class MinePage extends StatelessWidget {
  MinePage({super.key});

  final logic = Get.find<MineLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  bottom: 24.w,
                  top: context.mediaQueryPadding.top + 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AccountChangeButton(context: context),
                  ThemeChangeButton(context: context)
                ],
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12).w,
                child: AccountBaseInfo()),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12).w,
                child: AssetBaseInfo()),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12).w,
              child: const OperationBaseMenu(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 36, bottom: 20).w,
              child: Align(
                  alignment: Alignment.center,
                  child: "system_version".tr.toText
                    ..style =
                        Styles.ts_999999_10.adapterDark(Styles.ts_555555_10)),
            )
          ],
        ),
      ),
    );
  }
}
