import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/theme_controller.dart';
import 'mine_logic.dart';

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
                children: [identityButton(context), themeButton(context)],
              ),
            ),
            // Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 24, vertical: 12).w,
            //     child: const UserBaseInfo()),
            // Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 24, vertical: 12).w,
            //     child: const UserAssetPanel()),
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 24, vertical: 12).w,
            //   child: const UserListMenu(),
            // ),
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

  Widget identityButton(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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

  Widget themeButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ThemeController.to.toggleTheme();
      },
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 150),
        firstCurve: Curves.fastOutSlowIn,
        secondCurve: Curves.fastOutSlowIn,
        crossFadeState: Get.isDarkMode
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: 'ico_theme_light'.svg.toSvg
          ..width = 24.w
          ..height = 24.w
          ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
        secondChild: 'ico_theme_dark'.svg.toSvg
          ..width = 24.w
          ..height = 24.w
          ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
      ),
    );
  }
}
